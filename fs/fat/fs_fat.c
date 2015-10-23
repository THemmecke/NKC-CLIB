#include "ffconf.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <time.h>
#include <ioctl.h>
#include <diskio.h>
#include <fs.h>
#include <ff.h>
#include <debug.h>
#include <gide.h>

#include "fs_fat.h"




const struct file_operations fat_file_operations =
{
  fatfs_open,
  fatfs_close,
  fatfs_read,
  fatfs_write,
  fatfs_seek,
  fatfs_ioctl, 
  fatfs_remove,
  fatfs_getpos,

 /* Directory operations */

  fatfs_opendir,
  fatfs_closedir,
  fatfs_readdir,
   
 /* Path operations */
  fatfs_mkdir,
  fatfs_rmdir,
  fatfs_rename 
};

/*******************************************************************************
 *   private variables   
 *******************************************************************************/

#if _MULTI_PARTITION  /* Volume - partition resolution table (Example) */
PARTITION VolToPart[] = {
  {0, 1}, /* "0:" <== Disk# 0, 1st partition */
  {0, 2}, /* "1:" <== Disk# 0, 2nd partition */
  {0, 3}, /* "2:" <== Disk# 0, 3rd partition */
  {0, 4}  /* "3:" <== Disk# 0, 4th partition */
};
#endif

/* current physical drive is held in FIL.fs (FATFS) structure and given in every file related command */
/* i.e. physical/locical drive information off current drive must be held current by upper layer      */
#if _USE_EXTENSIONS
static FATFS FatFs[_DISKS][_VOLUMES];    /* File system object for logical drive (multi disk support)*/
#else
static FATFS FatFs[_VOLUMES];    /* File system object for logical drive (single disk support)*/
#endif

static BYTE CurrentDisk;	/* Current physical disk */

static BYTE Buff[262144];      /* Working buffer */

#if _USE_FASTSEEK
static DWORD SeekTbl[16];      /* Link map table for fast seek feature */
#endif

#if _USE_LFN
static char LFName[256];
#endif


/*******************************************************************************
 *   private functions   
 *******************************************************************************/

/*---------------------------------------------------------*/
/* User Provided RTC Function for FatFs module             */
/*---------------------------------------------------------*/
/* This is a real time clock service to be called from     */
/* FatFs module. Any valid time must be returned even if   */
/* the system does not support an RTC.                     */
/* This function is not required in read-only cfg.         */

DWORD get_fattime (void)
{
  time_t tnow;
  struct tm *tmnow;

  /* Get local time */
  time(&tnow);
    tmnow = localtime(&tnow);

  /* Pack date and time into a DWORD variable */
  return    ((DWORD)(tmnow->tm_year - 1980) << 25)
      | ((DWORD)tmnow->tm_mon << 21)
      | ((DWORD)tmnow->tm_mday << 16)
      | (WORD)(tmnow->tm_hour << 11)
      | (WORD)(tmnow->tm_min << 5)
      | (WORD)(tmnow->tm_sec >> 1);
}


/*******************************************************************************
 *   public functions   
 *******************************************************************************/
 

static int     fatfs_open(struct _file *filp){

  /* fopen <mode> <file> - Open a file (OK) */
   long mode;
   FIL *pfil;
   FRESULT res;
   
   fsfat_dbg("fs_fat.c: [ fatfs_open ....\n");
 
   fsfat_dbg("    name = %s, mode=0x%x\n",filp->pname,filp->f_oflags);
   
   if(filp == NULL) {
    fsfat_dbg("fs_fat.c: ... fatfs_open ENOFILE (1) ]\n");
    return ENOFILE;
  }

   /* translate stdio.h mode flag ... */

   
   mode = 0;
   if(filp->f_oflags & _F_READ) mode |= FA_READ;
   if(filp->f_oflags & _F_WRIT) mode |= FA_WRITE;
   if(filp->f_oflags & _F_CREATE) mode |= FA_CREATE_NEW;
   
   
   /* allocate FIL structure */
   pfil = (FIL *)malloc(sizeof(FIL));
   if(pfil == NULL) {
    fsfat_dbg("fs_fat.c: ... fatfs_open ENOFILE (2) ]\n");
    return ENOFILE;
   }

   //res = f_open(pfil, filp->pname, filp->f_oflags);
   res = f_open(pfil, filp->pname, mode);
   fsfat_dbg(" f_open(pfil, filp->pname, mode) retured %d\n",res);
   
   if(res != FR_OK) {
    free(pfil);
    return ENOFILE;
   }

   filp->private = (void*)pfil;


   fsfat_dbg("... fatfs_open ]\n");

   
   return EZERO;
}	

static int     fatfs_close(struct _file *filp){
  FIL *pfil;
  FRESULT res;

  fsfat_dbg("fs_fat.c: [ fatfs_close ....\n");
   
  if(filp == NULL) {
    fsfat_dbg("fs_fat.c: ... fatfs_close ENOFILE ]\n");
    return ENOFILE;
  }

  pfil = (FIL*)filp->private;

  res = f_close(pfil);

  free(pfil);

  if(res != FR_OK) { 
    return ENOFILE;
  }

  fsfat_dbg("fs_fat.c: ... fatfs_close ]\n");
   
  return EZERO;
}

static int     fatfs_read(struct _file *filp, char *buffer, int buflen){
  FIL *pfil;
  FRESULT res;
  UINT s2=0;

  fsfat_dbg("fs_fat.c: [ fatfs_read ... \n");
  
  if(filp == NULL) {
    fsfat_dbg("fs_fat.c: ... fatfs_read ENOFILE ]\n");
    return ENOFILE;
  }

  pfil = (FIL*)filp->private;

//  FRESULT f_read (
//  FIL* fp,    /* Pointer to the file object */
//  void* buff,   /* Pointer to data buffer */
//  UINT btr,   /* Number of bytes to read */
//  UINT* br    /* Pointer to number of bytes read */

  res = f_read(pfil, buffer, buflen, &s2);

  fsfat_dbg("fs_fat.c: ... fatfs_read ] \n");
    
  return s2;
}

static int     fatfs_write(struct _file *filp, const char *buffer, int buflen){
  FIL *pfil;
  FRESULT res;
  UINT s2=0;

  fsfat_dbg("fs_fat.c: [ fatfs_write ...\n");
  
  if(filp == NULL) {
    fsfat_dbg("fs_fat.c: ... fatfs_write ENOFILE ]\n");
    return ENOFILE;
  }

  pfil = (FIL*)filp->private;
    
// FRESULT f_write (
//	FIL* fp,			/* Pointer to the file object */
//	const void *buff,	/* Pointer to the data to be written */
//	UINT btw,			/* Number of bytes to write */
//	UINT* bw			/* Pointer to number of bytes written */
//)
    
  res = f_write(pfil, buffer, buflen, &s2);
  
  fsfat_dbg("fs_fat.c: ... fatfs_write ]\n");
  
  return s2;
}

static int     fatfs_seek(struct _file *filp, int offset, int whence){
/*  FRESULT f_lseek (
 *	FIL* fp,	-- Pointer to the file object 
 *	DWORD ofs	-- File pointer from top of file 
 *)
 *  whence/origin:
 *   SEEK_CUR    1 - seek offset from current position
 *   SEEK_END    2 - seek offset from end of file
 *   SEEK_SET    0 - seek offset from start of file
 */ 
  long p1;
  FRESULT res;
  FIL *pfil;
  int n;

  fsfat_dbg("fs_fat.c: [ fatfs_seek ...\n");
  
  if(filp == NULL) {
    fsfat_dbg("fs_fat.c: ... fatfs_seek ENOFILE ]\n");
    return ENOFILE;
  }
  
  pfil = (FIL*)filp->private;
    
  switch(whence)
	{
	  case SEEK_CUR: // seek from current position
			  n = fatfs_getpos(filp) + offset; break;
	  case SEEK_SET: // seek from start of file
			  n = offset; break;
	  case SEEK_END: // seek from end of file
			  n = pfil->fsize + offset; break;
	  default: n = 0;
	}
	
  res = f_lseek(pfil, n);
  
  fsfat_dbg("fs_fat.c: ... fatfs_seek ]\n");
  
  return res;
}

static int     fatfs_remove(struct _file *filp){
  FRESULT res;

  fsfat_dbg("fs_fat.c: [ fatfs_remove ...\n");
  
  if(filp == NULL) return ENOFILE;
  
  
  /* FRESULT f_unlink (
	const TCHAR* path  -- Pointer to the file or directory path 
) */
  res = f_unlink(filp->pname);
  
  fsfat_dbg("fs_fat.c: ... fatfs_remove ]\n");
  
  return res;
}

static int     fatfs_getpos(struct _file *filp){  

  fsfat_dbg("fs_fat.c: [ fatfs_getpos ...\n");

  if(filp == NULL) return ENOFILE;
  
  fsfat_dbg("fs_fat.c: ... fatfs_getpos ]\n");

  return filp->f_pos;
 
}

static int     fatfs_rename(struct _file *filp, const char *oldrelpath, const char *newrelpath){
  FIL *pfil;
  FRESULT res;

  fsfat_dbg("fs_fat.c: [ fatfs_rename ...\n");

  if(filp == NULL) return ENOFILE;
  
  pfil = (FIL*)filp->private;
  
  res = f_rename(oldrelpath,newrelpath);

  fsfat_dbg("fs_fat.c: ... fatfs_rename ]\n");
  
  return res;
}


static int     fatfs_ioctl(char *name, int cmd, unsigned long arg){
  FIL *pfil;
  long p1,p2;
  WORD w;
  DWORD dw;
  FRESULT res; 
  int n;
  char *pcp;
  char *pcd;
  char tmp[10];
  struct _deviceinfo di;
  
  fsfat_dbg("fs_fat.c: [ fatfs_ioctl ...\n");  

  switch(cmd){
    
   
    
    case FS_IOCTL_GETCWD:
    case FAT_IOCTL_GETCWD:	
			      fsfat_dbg(" - FAT_IOCTL_GETCWD -\n");
			      res = f_getcwd(((struct ioctl_get_cwd*)arg)->cpath, 
					     ((struct ioctl_get_cwd*)arg)->size);
			      
			      fsfat_dbg(" cpath(1) = %s\n", (char*)((struct ioctl_get_cwd*)arg)->cpath);
			      
			      // extract drive information from path ...			      
			      pcp = ((struct ioctl_get_cwd*)arg)->cpath;
			      pcd = ((struct ioctl_get_cwd*)arg)->cdrv;
			      n= strchr(pcp,':') - pcp;
			      if(n>0){
				  pcd[0] = 0; // clear drive string
				  strncat(pcd,pcp,n);
				  // terminate string
				  pcd[n] = 0;        
				  pcp+=n+1;
				  // remove drive info from path
				  strncpy(((struct ioctl_get_cwd*)arg)->cpath,pcp,strlen(pcp));
				  ((char*)(((struct ioctl_get_cwd*)arg)->cpath))[strlen(pcp)] = 0;
			      }
			      
			      fsfat_dbg(" cpath(2) = %s\n", (char*)((struct ioctl_get_cwd*)arg)->cpath);
			      fsfat_dbg(" drive    = %s\n", (char*)((struct ioctl_get_cwd*)arg)->cdrv);
			      
			      break;   
    // rename a file/direcctory
    case FS_IOCTL_RENAME:
    case FAT_IOCTL_RENAME:
			      res = f_rename(((struct ioctl_rename*)arg)->path_old,
					     ((struct ioctl_rename*)arg)->path_new); 
			      break;        
    // change directory
    case FS_IOCTL_CD:  
    case FAT_IOCTL_CD:
			      fsfat_dbg(" FAT_IOCTL_CD: %s", (char*)arg);
			      fsfat_lldbgwait("\n");
    			      res = f_chdir((char*)arg);
    			      break;
    // change physical drive
    case  FS_IOCTL_CHDRIVE:
    case FAT_IOCTL_CHDRIVE:
			      fsfat_dbg(" FAT_IOCTL_CHDRIVE: %s", (char*)arg);
			      fsfat_lldbgwait("\n");
			      tmp[0] = 0; strcat(tmp,(char*)arg); strcat(tmp,":");
    			      res = f_chdrive((char*)tmp); // changes volume given in arg ...
			      fsfat_dbg("res = %d\n",res);			      
			      break;
    // FAT change file mode
    case FS_IOCTL_CHMOD:			      
    case FAT_IOCTL_CHMOD:
			      res = f_chmod(((struct ioctl_chmod*)arg)->fpath, 
					    ((struct ioctl_chmod*)arg)->value, 
					    ((struct ioctl_chmod*)arg)->mask);
			      break;
    // low level disk read
    case FAT_IOCTL_READ:	
			      res = f_read(((struct ioctl_read_write*)arg)->fp,
					   ((struct ioctl_read_write*)arg)->pbuf,
					   ((struct ioctl_read_write*)arg)->size,
					   ((struct ioctl_read_write*)arg)->count);
			      break;
    // low level disk write
    case FAT_IOCTL_WRITE:
			      res = f_write(((struct ioctl_read_write*)arg)->fp,
					   ((struct ioctl_read_write*)arg)->pbuf,
					   ((struct ioctl_read_write*)arg)->size,
					   ((struct ioctl_read_write*)arg)->count);
			      break;
    // mount file system
    case FAT_IOCTL_MOUNT:     
	                      sprintf(tmp, "%d:", ((struct ioctl_mount_fatfs*)arg)->ldrv);
			      fsfat_dbg("try mount logical drive %d\n", ((struct ioctl_mount_fatfs*)arg)->ldrv);
			      res = f_mount(&FatFs[((struct ioctl_mount_fatfs*)arg)->ldrv], 
					    tmp, 
					    ((struct ioctl_mount_fatfs*)arg)->opt);			      
			      //((struct ioctl_mount_fatfs*)arg)->disk === not used yet, we have only one physical drive 0
			      // same information is in name => hda, hdb....
			      break;
    // un-mount file system
    case FAT_IOCTL_UMOUNT:
			      sprintf(tmp, "%d:", (BYTE)arg);
			      res = f_mount(NULL, tmp, 0);			      
			      //((struct ioctl_mount_fatfs*)arg)->drv === not used yet, we have only one physical drive 0
			      // same information is in name => hda, hdb....
			      // we implicitly assume there is no other drive than drive 0 => FIX !
			      break;
    // set volume label
    case FAT_IOCTL_SET_VLABEL: // FIX: set label of "current active" logical volume....we have to select disk and lvolume !
			      res = f_setlabel((char*)arg);
			      break;    		
    // get volume label
    case FAT_IOCTL_GET_VLABEL:
      
			      // ((struct ioctl_getlabel)arg)->drv  === not used yet, we have only one physical drive 0
			      res = f_getlabel( ((struct ioctl_getlabel*)arg)->pldrv,
						((struct ioctl_getlabel*)arg)->plabel,
						((struct ioctl_getlabel*)arg)->psn);
			      break;
    // open directory
    case FS_IOCTL_OPEN_DIR:			     
    case FAT_IOCTL_OPEN_DIR:
			      res = f_opendir(((struct ioctl_opendir*)arg)->dp, 
					      ((struct ioctl_opendir*)arg)->path);
			      break;
    // read directory
    case FS_IOCTL_READ_DIR:			      		      
    case FAT_IOCTL_READ_DIR:
			      res = f_readdir(((struct ioctl_readdir*)arg)->dp,   
					      ((struct ioctl_readdir*)arg)->fno);
			      break;
    // close directory
    case FS_IOCTL_CLOSE_DIR:			      		      
    case FAT_IOCTL_CLOSE_DIR:
			      res = f_closedir((DIR*)arg);			      
			      break;
    // make directory
    case FAT_IOCTL_MKDIR:
			      res = f_mkdir((char*)arg);
			      break;
    // unlink/delete a file/dir
    case FS_IOCTL_DEL:
    case FAT_IOCTL_UNLINK:
    			      res = f_unlink((char*)arg);
    			      break;
    // Get Number of Free Clusters
    case FS_IOCTL_GET_FREE:		      
    case FAT_IOCTL_GET_FREE:
			      res = f_getfree(((struct ioctl_getfree*)arg)->path,
					      ((struct ioctl_getfree*)arg)->nclst,
					      ((struct ioctl_getfree*)arg)->ppfatfs);  
			      break;
    // create FAT file system
    case FAT_IOCTL_MKFS:
			      res = f_mkfs(((struct ioctl_mkfs*)arg)->pdrv, 
					   ((struct ioctl_mkfs*)arg)->au, 
					   ((struct ioctl_mkfs*)arg)->sfd);			      
			      break;    
    // get FatFs structure
    case FAT_IOCTL_GET_FATFS: 
			      //((struct ioctl_getfatfs*)arg)->drv === not used yet, we have only one physical drive 0
			      p1 = ((struct ioctl_getfatfs*)arg)->ldrv;
			      if (!FatFs[p1].fs_type) { res = RES_NOTRDY; break; }
			      *(((struct ioctl_getfatfs*)arg)->ppfs) = (FatFs+p1);
			      res = RES_OK;
			      
			      
			      //printf("FAT_IOCTL_GET_FATFS[%d]->[0x%x]->[0x%x]:\n",p1,FatFs,FatFs+p1);
			      /*
			      if (!FatFs[p1].fs_type) { printf("Not mounted.\n"); return 0; }
			      printf("FAT type = %u\nBytes/Cluster = %lu\n"
				    "Root DIR entries = %u\nNumber of clusters = %lu\n"
				    "FAT start (lba) = %lu\nDIR start (lba,clustor) = %lu\nData start (lba) = %lu\n\n",
					  (BYTE)FatFs[p1].fs_type,
					  (DWORD)FatFs[p1].csize * 512,
					  FatFs[p1].n_rootdir, (DWORD)FatFs[p1].n_fatent - 2,
					  FatFs[p1].fatbase, FatFs[p1].dirbase, FatFs[p1].database );
				*/
			      break;
      
      
    // Low Level FileSystem Services 200+ ==============================  (MUST BE MOVED TO LOW LEVEL MODULE !)
    // initialize disc drive
   
      
    case FAT_IOCTL_DISK_INIT:
			      fsfat_lldbgwait("FAT_IOCTL_DISK_INIT\n");
			      // arg contains physical drive number (0,1,... for FAT Drives)
			      // FIX: name contains physical drive name (i.e. 1:,2:,3: for JADOS and HDA0,HDB1,HDC0 for IDE Drives) =>
			      //      move to low level and parse which driver to use ! decide which drive to initialize (HDA->0, HDB->1 ...)
			      res = disk_initialize((BYTE)arg); // take 'arg' drive 
			      
			      break;
    case FAT_IOCTL_GET_DISK_DRIVE_STATUS:
			      fsfat_lldbgwait("FAT_IOCTL_GET_DISK_DRIVE_STATUS\n");
			      // FIX: name contains drive (i.e. 1:,2:,3: for JADOS and HDA,HDB,HDC for IDE Drives) =>
			      //      move to low level and parse which driver to use ! decide which drive to identify (HDA->1, HDB->2 ...)
			      //      arg contains pointer to _deviceinfo 
			      res = idetifyIDE((int)name+1, (struct _deviceinfo*)arg); // take 1st drive (this is the only IDE, the CFCARD)   
			      break;
    // low level disk read (sector based)
    case FAT_IOCTL_DISK_READ:
				// FIX: check if drive exists !? This should be done in ioctl of fs.c
				res = disk_read( ((struct ioctl_disk_read*)arg)->drv, 	// [IN] Physical drive number
						 ((struct ioctl_disk_read*)arg)->buff, 	// [OUT] Pointer to the read data buffer
						 ((struct ioctl_disk_read*)arg)->sector,// [IN] Start sector number
						 ((struct ioctl_disk_read*)arg)->count);// [IN] Number of sectros to read 
				break;
    // create partition table
    case FAT_IOCTL_MKPTABLE:
				res = f_fdisk(((struct ioctl_mkptable*)arg)->drv, 
					      ((struct ioctl_mkptable*)arg)->szt, 
					      ((struct ioctl_mkptable*)arg)->work);
				break;
    
    case FAT_IOCTL_DISK_GET_SECTOR_COUNT:
				// FIX: arg contains drive (i.e. 1:,2:,3: for JADOS and HDA0,HDB1,HDC0 for IDE Drives) =>
			        //      examine arg in fs.c and parse which driver to use !
				p1=0;    // take 1st drive (this is the only IDE, the CFCARD)
				res = disk_ioctl((BYTE)p1, GET_SECTOR_COUNT, (DWORD*)arg);
				break;
    case FAT_IOCTL_DISK_GET_SECTOR_SIZE:
                                // FIX: arg contains drive (i.e. 1:,2:,3: for JADOS and HDA0,HDB1,HDC0 for IDE Drives) =>
			        //      move to low level and parse which driver to use !
				p1=0;    // take 1st drive (this is the only IDE, the CFCARD)
				res = disk_ioctl((BYTE)p1, GET_SECTOR_SIZE, (WORD*)arg);
				break;
    default: res = 0;
  }

  fsfat_dbg("fs_fat.c: ... fatfs_ioctl ]\n");

  return res;
}

static int     fatfs_mkdir(struct _file *filp, const char *relpath){
  FIL *pfil;
  FRESULT res;
  fsfat_dbg("fs_fat.c: [ fatfs_mkdir ...\n");
  res = f_mkdir(relpath);  
  fsfat_dbg("fs_fat.c: ... fatfs_mkdir ]\n");  
  return res;
}

static int     fatfs_rmdir(struct _file *filp, const char *relpath){
  FIL *pfil;
  FRESULT res;
  fsfat_dbg("fs_fat.c: [ fatfs_rmdir ...\n");
  res = f_unlink(relpath);
  fsfat_dbg("fs_fat.c: ... fatfs_rmdir ]\n");
  return res;
}


static int     fatfs_opendir(struct _file *filp, const char *relpath, DIR *dir){
  FIL *pfil;
  FRESULT res;
  fsfat_dbg("fs_fat.c: [ fatfs_opendir ...\n");
  if(dir == NULL) return ENOFILE;
  if(relpath == NULL) return ENOFILE;
  res = f_opendir(dir,relpath);
  fsfat_dbg("fs_fat.c: ... fatfs_opendir ]\n");
  return res;
}


static int     fatfs_closedir(struct _file *filp, DIR *dir){
  FIL *pfil;
  FRESULT res;
  fsfat_dbg("fs_fat.c: [ fatfs_closedir ...\n");
  if(dir == NULL) return ENOFILE;
  res = f_closedir(dir);
  fsfat_dbg("fs_fat.c: ... fatfs_closedir ]\n");
  return res;
}


static int     fatfs_readdir(struct _file *filp, DIR *dir,FILINFO* finfo){
  FIL *pfil;
  FRESULT res;
  fsfat_dbg("fs_fat.c: [ fatfs_readdir ...\n");
  if(dir == NULL) return ENOFILE;
  if(finfo == NULL) return ENOFILE;
  f_readdir(dir,finfo);
  fsfat_dbg("fs_fat.c: ... fatfs_readdir ]\n");
  return res;
  
}


void    fatfs_init_fs(void){

        /* GIDE initialisieren und laufwerk mounten....*/

        FRESULT res;
        WORD w;
        DWORD dw;
        long p1;              

        printf("FatFs module (%s, CP:%u/%s)\n\n",
            _USE_LFN ? "LFN" : "SFN",
            _CODE_PAGE,
            _LFN_UNICODE ? "Unicode" : "ANSI");

        #if _MULTI_PARTITION
        UINT cnt;
        printf("\nMultiple partition feature is enabled.\nEach logical drive is tied to the patition as follows:\n");
        for (cnt = 0; cnt < sizeof VolToPart / sizeof (PARTITION); cnt++) {
          const char *pn[] = {"auto detect", "1st partition", "2nd partition", "3rd partition", "4th partition"};
          printf("\"%u:\" <== Disk# %u, %s\n", cnt, VolToPart[cnt].pd, pn[VolToPart[cnt].pt]);
        }
        printf("\n"); 
        #else
        printf("\nMultiple partition feature is disabled.\nEach logical drive is tied to the same physical drive number.\n\n");
        #endif

        #if _USE_LFN
        Finfo.lfname = LFName;
        Finfo.lfsize = sizeof LFName;
        #endif

        init_ff(); /* initialize diskio.h */

        /* mount 1st partition of disk #0 */  
        p1=0;      
        printf(" disk_initialize(%d) => (rc=%d)\n", (BYTE)p1, disk_initialize((BYTE)p1));       

        #if 1
        if (disk_ioctl((BYTE)p1, GET_SECTOR_SIZE, &w) == RES_OK)
        printf(" Sector size = %u\n", w);
        if (disk_ioctl((BYTE)p1, GET_SECTOR_COUNT, &dw) == RES_OK)
        printf(" Number of sectors = %u\n", dw);
        #endif

        // DEBUG!! res = f_mount(&FatFs[0], "0:", 1);
           
        /* register driver within lib */
	fsfat_dbg(" filoperations at:\n");
	fsfat_dbg("    fatfs_ioctl: 0x%0x\n",fatfs_ioctl);
	register_driver("HDA","FAT",&fat_file_operations); 	// general driver for gide disk a
        register_driver("HDA0","FAT",&fat_file_operations); 	// driver for disk 0 partition 0
	register_driver("HDA1","FAT",&fat_file_operations); 	// driver for disk 0 partition 1
	
}

