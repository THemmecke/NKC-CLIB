#include "ffconf.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <time.h>
#include <ioctl.h>
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
 
 /*
  * volume 0-3 => gide drive A partition 0-3
  * volume 4-7 => sdcard A partition 0-3
  * (see ffconf.h) 
  * 
  */ 
 
 #if _MULTI_PARTITION  
 /* 
  * Volume - partition resolution table. 
  * Here all possible system volumes are listed, which are the possible FAT partitions supported by the FAT file sub-system.
  * We could make this table dynamic (build by mount/umount), but this would require major changes to the imported FAT fs module from (C)ChaN,
  * making FAT fs module updates cumbersome.
  * 
  * The folowing system has one IDE and one SD interface, each with one physical drive numbered '0'.
  * This must match the FAT module configuration in /fs/fat/ffconf.h -> 'Drive/Volume Configurations'
  * 
  * current definitions in ffconf.h:
  *	#define _VOLUMES	8 
  * 	#define _STR_VOLUME_ID	1
  * 	#define _VOLUME_STRS	"HDA0","HDA1","HDA2","HDA3","SDA0","SDA1","SDA2","SDA3"
  * 	#define	_MULTI_PARTITION	1
  * 	#define _MULTI_DISK		1
  */
 
 PARTITION VolToPart[] = {
  /* Physical disk, partition -> Volume */
  {0, 1}, /* "0:" <== Disk# HDA, 1st partition (HDA0:) -- physical IDE drive 0, logical drive / volume 0 */
  {0, 2}, /* "1:" <== Disk# HDA, 2nd partition (HDA1:) -- physical IDE drive 0, logical drive / volume 1 */
  {0, 3}, /* "2:" <== Disk# HDA, 3rd partition (HDA2:) -- physical IDE drive 0, logical drive / volume 2 */
  {0, 4}, /* "3:" <== Disk# HDA, 4th partition (HDA3:) -- physical IDE drive 0, logical drive / volume 3 */
  {0, 1}, /* "4:" <== Disk# SDA, 1st partition (SDA0:) -- physical SD  drive 0, logical drive / volume 4 */
  {0, 2}, /* "5:" <== Disk# SDA, 2nd partition (SDA1:) -- physical SD  drive 0, logical drive / volume 5 */
  {0, 3}, /* "6:" <== Disk# SDA, 3rd partition (SDA2:) -- physical SD  drive 0, logical drive / volume 6 */
  {0, 4}  /* "7:" <== Disk# SDA, 4th partition (SDA3:) -- physical SD  drive 0, logical drive / volume 7 */
};

char* const drvstr[] = {"HD","HD","HD","HD","SD","SD","SD","SD"}; // volume -> driver mapping
 
#endif  

// Note: dn2vol (DiskName-To-Volume) maps devicename (HDA0...) to a FatFs index 
static FATFS FatFs[_VOLUMES];		/* Pointer to the fat file system objects  -> ff.c */


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
    return ENOMEM;
   }

   //res = f_open(pfil, filp->pname, filp->f_oflags);
   res = f_open(pfil, filp->pname, mode);
   fsfat_dbg(" f_open(pfil, filp->pname, mode) retured %d\n",res);
   
   switch(res){
     case FR_OK: break; // continue
     case FR_NO_FILE: return ENOFILE;
     case FR_NO_PATH: return ENOPATH;
     case FR_INVALID_DRIVE: return ENXIO;
     default:
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

  fsfat_dbg("fs_fat.c: [ fatfs_remove (%s) ...\n",filp->pname);
  
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


static int     fatfs_ioctl(struct _file *filp, int cmd, unsigned long arg){
  FIL *pfil;
  long p1,p2;
  WORD w;
  DWORD dw;
  FRESULT res; 
  int n,result;
  char *pcp;
  char *pcd;
  char tmp[10];
  struct _deviceinfo di;
  struct geometry geo;
  struct _dev dev;

  
  FATFS *pFatFs;
  
  fsfat_dbg("fs_fat.c|fatfs_ioctl: ...\n");  

  SWITCH:
  switch(cmd){

    case FS_IOCTL_GETCWD:
    case FAT_IOCTL_GETCWD:	
			      fsfat_dbg(" - FAT_IOCTL_GETCWD -\n");
			
			      res = f_getcwd(((struct ioctl_get_cwd*)arg)->cpath, 
					     ((struct ioctl_get_cwd*)arg)->size);
			      
			      fsfat_dbg(" fs_fat.c|ioctl: cpath(1) = %s\n", (char*)((struct ioctl_get_cwd*)arg)->cpath);
			      
			      // extract drive information from path ...			      
			      pcp = ((struct ioctl_get_cwd*)arg)->cpath;
			      pcd = ((struct ioctl_get_cwd*)arg)->cdrive;
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
			     
			      fsfat_dbg(" fs_fat.c|ioctl: cpath(2) = %s\n", (char*)((struct ioctl_get_cwd*)arg)->cpath);
			      fsfat_dbg(" fs_fat.c|ioctl: drive    = %s", (char*)((struct ioctl_get_cwd*)arg)->cdrive);
			      fsfat_lldbgwait("   (KEY)...\n");			      
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
			      //res = f_chdir("0:foo");
    			      break;
    // change physical drive
    case  FS_IOCTL_CHDRIVE:
    case FAT_IOCTL_CHDRIVE:   // *filp=NULL, cmd=FS_IOCTL_CHDRIVE, arg = (struct fstabentry*)pfstab 
			      fsfat_dbg(" FAT_IOCTL_CHDRIVE: %s", ((struct fstabentry*)arg)->devname);
			      fsfat_lldbgwait("(KEY)\n");
			      strcpy(tmp,((struct fstabentry*)arg)->devname); strcat(tmp,":");
    			      res = f_chdrive((char*)tmp); // changes volume given in arg ...
			      fsfat_dbg("res = %d\n",res);			      
			      break;
    // FAT change file mode
    case FS_IOCTL_CHMOD:			      
    case FAT_IOCTL_CHMOD:
      // (NULL,FS_IOCTL_CHMOD,arg* = struct ioctl_chmod)
      
      //struct ioctl_chmod {
      //      void* fpath;		/* pointer to file path */
      //      unsigned char value;
      //      unsigned char mask;
      //};
			      res = f_chmod(((struct ioctl_chmod*)arg)->fpath, 
					    ((struct ioctl_chmod*)arg)->value, 
					    ((struct ioctl_chmod*)arg)->mask);
			      break;
    // file level disk read
    case FAT_IOCTL_READ:	
			      res = f_read(((struct ioctl_file_rw*)arg)->fp,
					   ((struct ioctl_file_rw*)arg)->pbuf,
					   ((struct ioctl_file_rw*)arg)->size,
					   ((struct ioctl_file_rw*)arg)->count);
			      break;
    // file level disk write
    case FAT_IOCTL_WRITE:
			      res = f_write(((struct ioctl_file_rw*)arg)->fp,
					    ((struct ioctl_file_rw*)arg)->pbuf,
					    ((struct ioctl_file_rw*)arg)->size,
					    ((struct ioctl_file_rw*)arg)->count);
			      break;

    // mount file system
    case FS_IOCTL_MOUNT:		      
    case FAT_IOCTL_MOUNT:   
			      fsfat_dbg("fs_fat|FS_IOCTL_MOUNT\n");
      // args: NULL,FS_IOCTL_MOUNT,struct fstabentry*  
      
//		       struct fstabentry
//		       {
//			        char* devname;			/* devicename A, B ,HDA0 , HDB1... */   
//			        BYTE pdrv;			/* physical drive number */  
//			        struct fs_driver	*pfsdrv;	/* pointer to file system driver */
//			        struct blk_driver *pblkdrv;	/* pointer to block device driver */
//			        unsigned char options;		/* mount options */
//			        struct fstabentry* next;	/* pointer to next fstab entry */
//		       };
	                      sprintf(tmp, "%s:", ((struct fstabentry*)arg)->devname);
			      
			      fsfat_dbg("try mount logical drive/volume %s/%d:\n", ((struct fstabentry*)arg)->devname, dn2vol(((struct fstabentry*)arg)->devname));			      
			      fsfat_dbg("  phydrv  = %d\n",((struct fstabentry*)arg)->pdrv);
			      fsfat_dbg("  fsdrv   = 0x%x\n",((struct fstabentry*)arg)->pfsdrv);
			      fsfat_dbg("  blkdrv  = 0x%x\n",((struct fstabentry*)arg)->pblkdrv);
			      fsfat_dbg("  options = %d",((struct fstabentry*)arg)->options); 
			      fsfat_lldbgwait("\n");
			      			      
			      pFatFs = &FatFs[dn2vol(((struct fstabentry*)arg)->devname)];
			      pFatFs->pfstab = (struct fstabentry*)arg;				// add corresponding fstabentry to FatFs struct
			      
			      res = f_mount(pFatFs,  tmp, 1); // Mount immediately     
			      
			      fsfat_dbg("fs_fat.c| f_mount retured with code %d",res);
			      fsfat_lldbgwait("\n");
			      
#ifdef CONFIG_DEBUG_FS_FAT
			    
//typedef struct {
//	BYTE	fs_type;		/* FAT sub-type (0:Not mounted) */
//	BYTE	drv;			/* Physical drive number */
//	//char    volume[10];		/* physical drive/volume where the filesystem resides, i.e. FD0,FD1,HDA0,HDB2,SDA17.... */
//	BYTE	csize;			/* Sectors per cluster (1,2,4...128) */
//	BYTE	n_fats;			/* Number of FAT copies (1 or 2) */
//	BYTE	wflag;			/* win[] flag (b0:dirty) */
//	BYTE	fsi_flag;		/* FSINFO flags (b7:disabled, b0:dirty) */
//	WORD	id;				/* File system mount ID */
//	WORD	n_rootdir;		/* Number of root directory entries (FAT12/16) */
//#if _MAX_SS != _MIN_SS
//	WORD	ssize;			/* Bytes per sector (512, 1024, 2048 or 4096) */
//#endif
//#if _FS_REENTRANT
//	_SYNC_t	sobj;			/* Identifier of sync object */
//#endif
//#if !_FS_READONLY
//	DWORD	last_clust;		/* Last allocated cluster */
//	DWORD	free_clust;		/* Number of free clusters */
//#endif
//#if _FS_RPATH
//	DWORD	cdir;			/* Current directory start cluster (0:root) */
//#endif
//	DWORD	n_fatent;		/* Number of FAT entries (= number of clusters + 2) */
//	DWORD	fsize;			/* Sectors per FAT */
//	DWORD	volbase;		/* Volume start sector */
//	DWORD	fatbase;		/* FAT start sector */
//	DWORD	dirbase;		/* Root directory start sector (FAT32:Cluster#) */
//	DWORD	database;		/* Data start sector */
//	DWORD	winsect;		/* Current sector appearing in the win[] */
//	BYTE	win[_MAX_SS];		/* Disk access window for Directory, FAT (and file data at tiny cfg) */
//	//struct  blk_driver *blk_drv; 	/* Pointer to the block device driver */
//} FATFS;

			      for (n=0; n< _VOLUMES; n++){
				printf("fs_fat.c| FatFs[%d]:\n",n);
				printf("     drv:      %d\n",FatFs[n].drv);
				printf("     fatbase:  0x%x\n",FatFs[n].fatbase);
				printf("     database: 0x%x\n",FatFs[n].database);
				fsfat_lldbgwait(" ....(KEY)\n");
			      }
			      
#endif
			      break;
    // un-mount file system
    case FS_IOCTL_UMOUNT:
    case FAT_IOCTL_UMOUNT:  // args: NULL,FS_IOCTL_UMOUNT,arg = char* drivename 
			      fsfat_dbg("fs_fat.c|FAT_IOCTL_UMOUNT (%s)\n",(char*)arg);
			      sprintf(tmp, "%s:", (char*)arg);
			      res = f_mount(NULL, tmp, 0);			      
			      //((struct ioctl_mount_fatfs*)arg)->drv === not used yet, we have only one physical drive 0
			      // same information is in name => hda, hdb....
			      // we implicitly assume there is no other drive than drive 0 => FIX !
			      break;
    // set volume label
    case FAT_IOCTL_SET_VLABEL: 
			      fsfat_dbg(" FAT_IOCTL_SET_VLABEL: arg = %s\n",arg);
			      res = f_setlabel((char*)arg);
			      break;    		
    // get volume label
    case FAT_IOCTL_GET_VLABEL:
			      fsfat_dbg(" FAT_IOCTL_GET_VLABEL:\n");
			      // ((struct ioctl_getlabel)arg)->drv  === not used yet, we have only one physical drive 0
			      res = f_getlabel( ((struct ioctl_getlabel*)arg)->volume,
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
			      fsfat_dbg(" fs_fat.c| _IOCTL_CLOSE_DIR: (%s)\n",(char*)arg);
			      res = f_closedir((DIR*)arg);			      
			      break;
    // make directory
    case FS_IOCTL_MKDIR:
    case FAT_IOCTL_MKDIR:
			      fsfat_dbg(" fs_fat.c| _IOCTL_MKDIR: (%s)\n",(char*)arg);
			      res = f_mkdir((char*)arg);
			      break;
    // unlink/delete a file/dir
    case FS_IOCTL_RMDIR:
    case FS_IOCTL_DEL:
    case FAT_IOCTL_UNLINK:
			      fsfat_dbg(" fs_fat.c| _IOCTL_RMDIR/DEL/UNLINK: (%s)\n",(char*)arg);
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
			      fsfat_dbg(" fs_fat.c| FAT_IOCTL_MKFS - \n");
			      res = f_mkfs(((struct ioctl_mkfs*)arg)->part, 
					   ((struct ioctl_mkfs*)arg)->sfd, 
					   ((struct ioctl_mkfs*)arg)->au);			      
			      break;    
    // get FatFs structure
    case FAT_IOCTL_GET_FATFS: 
			      fsfat_dbg(" fs_fat.c| FAT_IOCTL_GET_FATFS - \n");
			      p1 = ((struct ioctl_getfatfs*)arg)->vol;          
			      if (! FatFs[p1].fs_type) { res = RES_NOTRDY; break; } 
			      *(((struct ioctl_getfatfs*)arg)->ppfs) = (FatFs+p1);
			      res = RES_OK;
			      
			      break;
      
    case FAT_IOCTL_INFO:	
			      printf("FatFs module (%s, CP:%u/%s) version %s , revision %d\n\n",
					_USE_LFN ? "LFN" : "SFN",
					_CODE_PAGE,
					_LFN_UNICODE ? "Unicode" : "ANSI",
					_FAT_FS_VERSION,_FFCONF
				    );
			      
			      #if _MULTI_PARTITION	
			        UINT cnt;
			      printf("Multiple partition feature is enabled.\nEach logical drive is tied to the partition as follows:\n");
			      for (cnt = 0; cnt < sizeof(VolToPart) / sizeof(PARTITION); cnt++) {
				const char *pn[] = {"auto detect", "1st partition", "2nd partition", "3rd partition", "4th partition"};
				printf("\"%u:\" <== %s Disk# %u, %s\n", cnt, drvstr[cnt],VolToPart[cnt].pd, pn[VolToPart[cnt].pt]);
			      }
			      printf("\n"); 
			      #else
			      printf("\nMultiple partition feature is disabled.\nEach logical drive is tied to the same physical drive number.\n\n");
			      #endif
	
			      break;   
			      
    // Low Level FileSystem Services 200+ ==============================  
   
        
    case FS_IOCTL_MKPTABLE:		      // this should be handled in the block driver itself for it is a filesystem independent function ... see hd_block_drv -> ioctl function
    case FAT_IOCTL_MKPTABLE:
      // write disk partition table (this function is FAT FileSystem independent and should be moved...)
      // args: char *name<=NULL, int cmd<=FS_IOCTL_MKPTABLE, unsigned long arg <=pointer to struct ioctl_mkptable
      printf(" Uuups: FS_IOCTL_MKPTABLE should not be called in fs_fat.c but in a lower level driver ... !\n");
      break;
		      res = f_fdisk(dn2pdrv(((struct ioctl_mkptable*)arg)->devicename), /* physical drive number mapped via dn2pdrv(HDA...) */  
					    ((struct ioctl_mkptable*)arg)->szt, 	/* Pointer to the size table for each partition */
					    ((struct ioctl_mkptable*)arg)->work);	/* Pointer to the working buffer */
			      
				 
			              
				break;
    

    default: res = 0;
  }
  

  fsfat_lldbgwait("fs_fat.c: ... fatfs_ioctl ] (KEY)\n");

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
	//struct _dev dev;
	
	//struct blk_driver* pblk_drv;

	/*
        printf("FatFs module (%s, CP:%u/%s)\n\n",
            _USE_LFN ? "LFN" : "SFN",
            _CODE_PAGE,
            _LFN_UNICODE ? "Unicode" : "ANSI");
	*/
        

        #if _USE_LFN
        Finfo.lfname = LFName;
        Finfo.lfsize = sizeof LFName;
        #endif

      
           
        /* register driver within lib */
	fsfat_dbg(" fileoperations at:\n");
	fsfat_dbg("    fatfs_ioctl: 0x%0x\n",fatfs_ioctl);
	
	// register a FAT file system on GIDE drive -> später mit mount in fstab !!
	//pblk_drv = get_blk_driver("HD");
	//if(pblk_drv)
	//{
	  register_driver("FAT",&fat_file_operations); 	// general driver for gide disk a
	  //register_driver("HDA0","FAT",&fat_file_operations, pblk_drv); 	// driver for disk 0 partition 0
	  //register_driver("HDA1","FAT",&fat_file_operations, pblk_drv); 	// driver for disk 0 partition 1
	//} else {
	//   fsfat_dbg(" could not retreive block driver for HD !\n");
	//}
	
	/*
	// register a FAT file system on SD drive
	pblk_drv = get_blk_driver("SD");
	if(pblk_drv)
	{
	  register_driver("SDA","FAT",&fat_file_operations, pblk_drv); 		// general driver for sd disk a
	  register_driver("SDA0","FAT",&fat_file_operations, pblk_drv); 	// driver for sd disk 0 partition 0
	} else {
	   fsfat_dbg(" could not retreive block driver for SD !\n");
	}
	*/
	
	// hat schon in hd_block_drv.c ==> hd_initialize() stattgefunden 
	// init_ff(); /* initialize diskio.h */
	// p1=0;      
        // printf(" disk_initialize(%d) => (rc=%d)\n", (BYTE)p1, disk_initialize((BYTE)p1));    
	
	
        /* mount 1st partition of disk #0 */  
	// rewrite to pblk_drv->ioctl((BYTE)p1, GET_SECTOR_SIZE, &w) ...
	// DEBUG!! res = f_mount(&FatFs[0], "0:", 1);
	
	// rewrite to pblk_drv->ioctl
	#if 0
        dev.pdrv = 1;
        if (pblk_drv->blk_oper->ioctl(&dev, GET_SECTOR_SIZE, &w) == RES_OK)
        printf(" Sector size = %u\n", w);
	if (pblk_drv->blk_oper->ioctl(&dev, GET_SECTOR_COUNT, &dw) == RES_OK)
        printf(" Number of sectors = %u\n", dw);
        #endif
	
}

