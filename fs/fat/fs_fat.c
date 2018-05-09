#include "ffconf.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <time.h>
#include <ioctl.h>
#include <fs.h>
#include <debug.h>

#include "ff.h"
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
  return    ((DWORD)(tmnow->tm_year - 1980 - 20) << 25)         // with -20 
      | ((DWORD)(tmnow->tm_mon +1) << 21)			// +1 month correction
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

   filp->private = (void*)pfil;


   fsfat_dbg("... fatfs_open ]\n");
   
   if(res < FRESULT_OFFSET && res != FR_OK)
    return res + FRESULT_OFFSET;
   else return res;
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

  fsfat_dbg("fs_fat.c: ... fatfs_close ]\n");
   
  if(res < FRESULT_OFFSET && res != FR_OK)
    return res + FRESULT_OFFSET;
   else return res;
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
  
  if(res < FRESULT_OFFSET && res != FR_OK)
    return res + FRESULT_OFFSET;
   else return res;
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
  
  if(res < FRESULT_OFFSET && res != FR_OK)
    return res + FRESULT_OFFSET;
   else return res;
}

static int     fatfs_getpos(struct _file *filp){  

  fsfat_dbg("fs_fat.c: [ fatfs_getpos ...\n");

  if(filp == NULL) return NULL;
  
  fsfat_dbg("fs_fat.c: ... fatfs_getpos ]\n");

  return filp->f_pos;
 
}

static int     fatfs_rename(struct _file *filp, const char *oldrelpath, const char *newrelpath){
  FIL *pfil;
  FRESULT res;

  fsfat_dbg("fs_fat.c: [ fatfs_rename ...\n");

  if(filp == NULL) return NULL;
  
  pfil = (FIL*)filp->private;
  
  res = f_rename(oldrelpath,newrelpath);

  fsfat_dbg("fs_fat.c: ... fatfs_rename ]\n");
  
  if(res < FRESULT_OFFSET && res != FR_OK)
    return res + FRESULT_OFFSET;
   else return res;
}


//static int     fatfs_ioctl(struct _file *filp, int cmd, unsigned long arg){
static int     fatfs_ioctl(struct fstabentry* pfstab, int cmd, unsigned long arg){
  FIL *pfil;
  long p1,p2;
  WORD w;
  DWORD dw;
  FRESULT res; 
  int n,result;
  char *pcp;
  char *pcd;
  char tmp[10];
  struct _driveinfo di;
  struct geometry geo;
  struct _dev dev;

  
  FATFS *pFatFs;
  
  fsfat_dbg("fs_fat.c|fatfs_ioctl: ...\n");  

  SWITCH:
  switch(cmd){

    case FS_IOCTL_GETCWD:
			      fsfat_dbg(" - FS_IOCTL_GETCWD -\n");
			
			      res = f_getcwd(((struct ioctl_get_cwd*)arg)->cpath, 
					     ((struct ioctl_get_cwd*)arg)->size);
			      
			      fsfat_dbg(" fs_fat.c|ioctl: cpath(1) = %s\n", (char*)((struct ioctl_get_cwd*)arg)->cpath);
			      
			      // extract drive information from path ...			      
			      pcp = ((struct ioctl_get_cwd*)arg)->cpath; // cpath/pcp points to drive:path string
			      pcd = ((struct ioctl_get_cwd*)arg)->cdrive;
			      n= strchr(pcp,':') - pcp;
			      if( n>0 ){
    				  pcd[0] = 0; // clear drive string
    				  strncat(pcd,pcp,n); // copy drive string    				  
    				  pcd[n] = 0;         // terminate string
    				  pcp+=n+1;           // advance path pointer to point to path information    				  
    				  strcpy(((struct ioctl_get_cwd*)arg)->cpath,pcp);	// copy path information    				  
			      }
			     
            pcp = ((struct ioctl_get_cwd*)arg)->cpath;
            if(pcp[strlen(pcp)-1] != '/'){                       /* termitate path with '/' */
              pcp[strlen(pcp)+1] = 0;
              pcp[strlen(pcp)] = '/';
            }

			      fsfat_dbg(" fs_fat.c|ioctl: cpath(2) = %s\n", (char*)((struct ioctl_get_cwd*)arg)->cpath);
			      fsfat_dbg(" fs_fat.c|ioctl: drive    = %s", (char*)((struct ioctl_get_cwd*)arg)->cdrive);
			      fsfat_lldbgwait("   (KEY)...\n");			      
			      break;   
    // rename a file/direcctory
    case FS_IOCTL_RENAME:
			      res = f_rename(((struct ioctl_rename*)arg)->path_old,
					     ((struct ioctl_rename*)arg)->path_new); 
			      break;        
    // change directory
    case FS_IOCTL_CD:  
			      fsfat_dbg(" FS_IOCTL_CD: %s", (char*)arg);
			      fsfat_lldbgwait("\n");
    			      res = f_chdir((char*)arg);
			      //res = f_chdir("0:foo");
    			      break;
    // change physical drive
    case  FS_IOCTL_CHDRIVE: // *filp=NULL, cmd=FS_IOCTL_CHDRIVE, arg = (struct fstabentry*)pfstab 
			      fsfat_dbg(" FS_IOCTL_CHDRIVE: %s", ((struct fstabentry*)arg)->devname);
			      fsfat_lldbgwait("(KEY)\n");
			      strcpy(tmp,((struct fstabentry*)arg)->devname); strcat(tmp,":");
    			      res = f_chdrive((char*)tmp); // changes volume given in arg ...
			      fsfat_dbg("res(f_chdrive) = %d\n",res);			      
			      break;
    // FAT change file mode
    case FS_IOCTL_CHMOD:			
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
    case FS_IOCTL_READ:	
			      res = f_read(((struct ioctl_file_rw*)arg)->fp,
					   ((struct ioctl_file_rw*)arg)->pbuf,
					   ((struct ioctl_file_rw*)arg)->size,
					   ((struct ioctl_file_rw*)arg)->count);
			      break;
    // file level disk write
    case FS_IOCTL_WRITE:
			      res = f_write(((struct ioctl_file_rw*)arg)->fp,
					    ((struct ioctl_file_rw*)arg)->pbuf,
					    ((struct ioctl_file_rw*)arg)->size,
					    ((struct ioctl_file_rw*)arg)->count);
			      break;

    // mount file system
    case FS_IOCTL_MOUNT:		  
			      fsfat_dbg("fs_fat|FS_IOCTL_MOUNT\n");
      // args: NULL,FS_IOCTL_MOUNT,struct fstabentry*  

	          sprintf(tmp, "%s:", ((struct fstabentry*)arg)->devname);
			      
			      fsfat_dbg("try mount logical drive %s:\n", ((struct fstabentry*)arg)->devname);			      
		      
			      fsfat_dbg("  phydrv  = %d\n",((struct fstabentry*)arg)->pdrv);
			      fsfat_dbg("  fsdrv   = 0x%x\n",((struct fstabentry*)arg)->pfsdrv);
			      fsfat_dbg("  blkdrv  = 0x%x\n",((struct fstabentry*)arg)->pblkdrv);
			      fsfat_dbg("  part    = %d\n",((struct fstabentry*)arg)->partition);
			      fsfat_dbg("  pFATFS  = 0x%x\n",((struct fstabentry*)arg)->pfs);
	  			      
			      fsfat_dbg("  options = %d (0/1=delayed/immediate)",((struct fstabentry*)arg)->options); 
			      fsfat_lldbgwait("\n");
			      
			      // allocate memory for FATFS structure and store pointer in fstab
			      pFatFs = (FATFS*)malloc(sizeof(FATFS));
			      if(!pFatFs) { // errorhandling
				      fsfat_dbg("error: no memory for pFatFs\n");
				      return FR_NOT_ENOUGH_CORE;
				    }
				
			      memset(pFatFs,0,sizeof(FATFS)); // reset all values....	
				    
			      ((struct fstabentry*)arg)->pfs = pFatFs;	
			      
			      fsfat_dbg("  memory for FATFS object alocated (0x%x)",pFatFs);
			      fsfat_lldbgwait("  (KEY)\n");

			      
			      pFatFs->pfstab = (struct fstabentry*)arg;				// add corresponding fstabentry to FatFs struct
			      pFatFs->fs_id = FS_TYPE_FAT;					/* idetify this filesystem (id's defined in fs.h) */
			      			         
            res = f_mount(pFatFs,  tmp, ((struct fstabentry*)arg)->options); 
			      
			      fsfat_dbg("fs_fat.c| f_mount retured with code %d",res);
			      fsfat_lldbgwait("\n");
			      
			      break;
    // un-mount file system
    case FS_IOCTL_UMOUNT: // args: NULL,FS_IOCTL_UMOUNT,arg = char* drivename 
			      			     			      
			      pFatFs = ((struct fstabentry*)arg)->pfs;
			      
			      if(pFatFs) {
				fsfat_dbg("fs_fat.c|FS_IOCTL_UMOUNT (%s)\n",((struct fstabentry*)arg)->devname);
				sprintf(tmp, "%s:", ((struct fstabentry*)arg)->devname);
				res = f_mount(NULL, tmp, 0);
				free(pFatFs);
				((struct fstabentry*)arg)->pfs = NULL;
			      } else {
				fsfat_dbg("fs_fat.c|FS_IOCTL_UMOUNT pFatFS = NULL !! \n");
			      }		      
			      //((struct ioctl_mount_fatfs*)arg)->drv === not used yet, we have only one physical drive 0
			      // same information is in name => hda, hdb....
			      // we implicitly assume there is no other drive than drive 0 => FIX !
			      break;
    // set volume label
    case FS_IOCTL_SET_VLABEL: 
			      fsfat_dbg(" FS_IOCTL_SET_VLABEL: arg = %s\n",arg);
			      res = f_setlabel((char*)arg);
			      break;    		
    // get volume label
    case FS_IOCTL_GET_VLABEL:
			      fsfat_dbg(" FS_IOCTL_GET_VLABEL:\n");
			      // ((struct ioctl_getlabel)arg)->drv  === not used yet, we have only one physical drive 0
			      res = f_getlabel( ((struct ioctl_getlabel*)arg)->volume,
						((struct ioctl_getlabel*)arg)->plabel,
						((struct ioctl_getlabel*)arg)->psn);
			      break;
    // open directory
    case FS_IOCTL_OPEN_DIR:			
			      fsfat_dbg(" FS_IOCTL_OPEN_DIR(1):   path = 0x%0x\n",((struct ioctl_opendir*)arg)->path);
			      res = f_opendir(((struct ioctl_opendir*)arg)->dp, 
					      ((struct ioctl_opendir*)arg)->path);
			      fsfat_dbg(" FS_IOCTL_OPEN_DIR(2):   path = 0x%0x\n",((struct ioctl_opendir*)arg)->path);
			      break;
    // read directory
    case FS_IOCTL_READ_DIR:			
			      fsfat_dbg(" fs_fat.c| FS_IOCTL_READ_DIR: (%s)\n",(char*)arg);
			      res = f_readdir(((struct ioctl_readdir*)arg)->dp,   
					      ((struct ioctl_readdir*)arg)->fno);
			      break;
    // close directory
    case FS_IOCTL_CLOSE_DIR:		
			      fsfat_dbg(" fs_fat.c| FS_IOCTL_CLOSE_DIR: (%s)\n",(char*)arg);
			      res = f_closedir((DIR*)arg);			      
			      break;
    // make directory
    case FS_IOCTL_MKDIR:
			      fsfat_dbg(" fs_fat.c| FS_IOCTL_MKDIR: (%s)\n",(char*)arg);
			      res = f_mkdir((char*)arg);
			      break;
    // unlink/delete a file/dir
    case FS_IOCTL_RMDIR:
    case FS_IOCTL_DEL:
			      fsfat_dbg(" fs_fat.c| FS_IOCTL_RMDIR/DEL/UNLINK: (%s)\n",(char*)arg);
    			      res = f_unlink((char*)arg);
    			      break;
    // Get Number of Free Clusters
    case FS_IOCTL_GET_FREE:		 
			      fsfat_dbg(" FS_IOCTL_GET_FREE (1): path = %s\n", ((struct ioctl_getfree*)arg)->path);
			      res = f_getfree(((struct ioctl_getfree*)arg)->path,
					      ((struct ioctl_getfree*)arg)->nclst,
					      (FATFS**)((struct ioctl_getfree*)arg)->ppfs);  			      
			      fsfat_dbg(" FS_IOCTL_GET_FREE (2): path = %s\n", ((struct ioctl_getfree*)arg)->path);
			      break;
    // create FAT file system
    case FS_IOCTL_MKFS:     
			      fsfat_dbg(" fs_fat.c| FS_IOCTL_MKFS - \n");
			      res = f_mkfs(((struct ioctl_mkfs*)arg)->part, 
					   ((struct ioctl_mkfs*)arg)->sfd, 
					   ((struct ioctl_mkfs*)arg)->au);			      
			      break;    
    case FS_IOCTL_INFO:   	
			      printf("FatFs module (%s, CP:%u/%s) version %s , revision %d\n\n",
					_USE_LFN ? "LFN" : "SFN",
					_CODE_PAGE,
					_LFN_UNICODE ? "Unicode" : "ANSI",
					_FAT_FS_VERSION,_FFCONF
				    );

			      break;   
			      
    // Low Level FileSystem Services 200+ ==============================  
   
        
    case FS_IOCTL_MKPTABLE:		      // this should be handled in the block driver itself for it is a filesystem independent function ... see hd_block_drv -> ioctl function
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

  if(res < FRESULT_OFFSET && res != FR_OK)
    return res + FRESULT_OFFSET;
   else return res;
}

static int     fatfs_mkdir(struct _file *filp, const char *relpath){
  FIL *pfil;
  FRESULT res;
  fsfat_dbg("fs_fat.c: [ fatfs_mkdir ...\n");
  res = f_mkdir(relpath);  
  fsfat_dbg("fs_fat.c: ... fatfs_mkdir ]\n");  
  if(res < FRESULT_OFFSET && res != FR_OK)
    return res + FRESULT_OFFSET;
   else return res;
}

static int     fatfs_rmdir(struct _file *filp, const char *relpath){
  FIL *pfil;
  FRESULT res;
  fsfat_dbg("fs_fat.c: [ fatfs_rmdir ...\n");
  res = f_unlink(relpath);
  fsfat_dbg("fs_fat.c: ... fatfs_rmdir ]\n");
  if(res < FRESULT_OFFSET && res != FR_OK)
    return res + FRESULT_OFFSET;
   else return res;
}


static int     fatfs_opendir(struct _file *filp, const char *relpath, DIR *dir){
  FIL *pfil;
  FRESULT res;
  fsfat_dbg("fs_fat.c: [ fatfs_opendir ...\n");
  if(dir == NULL) return ENOFILE;
  if(relpath == NULL) return ENOFILE;
  res = f_opendir(dir,relpath);
  fsfat_dbg("fs_fat.c: ... fatfs_opendir ]\n");
  if(res < FRESULT_OFFSET && res != FR_OK)
    return res + FRESULT_OFFSET;
   else return res;
}


static int     fatfs_closedir(struct _file *filp, DIR *dir){
  FIL *pfil;
  FRESULT res;
  fsfat_dbg("fs_fat.c: [ fatfs_closedir ...\n");
  if(dir == NULL) return ENOFILE;
  res = f_closedir(dir);
  fsfat_dbg("fs_fat.c: ... fatfs_closedir ]\n");
  if(res < FRESULT_OFFSET && res != FR_OK)
    return res + FRESULT_OFFSET;
   else return res;
}


static int     fatfs_readdir(struct _file *filp, DIR *dir,FILINFO* finfo){
  FIL *pfil;
  FRESULT res = 0;
  fsfat_dbg("fs_fat.c: [ fatfs_readdir ...\n");
  if(dir == NULL) return ENOFILE;
  if(finfo == NULL) return ENOFILE;
  res = f_readdir(dir,finfo);
  fsfat_dbg("fs_fat.c: ... fatfs_readdir ]\n");
  if(res < FRESULT_OFFSET && res != FR_OK)
    return res + FRESULT_OFFSET;
   else return res;
  
}


void    fatfs_init_fs(void){
     
        FRESULT res;
        WORD w;
        DWORD dw;
        long p1; 	

        #if _USE_LFN
        Finfo.lfname = LFName;
        Finfo.lfsize = sizeof LFName;
        #endif
  
        /* register driver within lib */
	fsfat_dbg(" fileoperations at:\n");
	fsfat_dbg("    fatfs_ioctl: 0x%0x\n",fatfs_ioctl);

	register_driver("FAT",&fat_file_operations); 	// general driver for gide disk a

}

