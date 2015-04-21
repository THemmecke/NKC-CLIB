#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <time.h>
#include <ioctl.h>
#include "diskio.h"
#include "../fs.h"
#include "fs_fat.h"
#include "ff.h"

#ifdef CONFIG_DEBUG_FS_FAT
#include "../nkc/llnkc.h"
#endif

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

static FATFS FatFs[_VOLUMES];    /* File system object for logical drive */
static BYTE Buff[262144];      /* Working buffer */

#if _USE_FASTSEEK
static DWORD SeekTbl[16];      /* Link map table for fast seek feature */
#endif

#if _USE_LFN
static char LFName[256];
#endif

static char CurrDirPath[300];

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
   
   #ifdef CONFIG_CONFIG_DEBUG_FS_FAT
   nkc_write("fs_fat.c: [ fatfs_open ....\n");
   #endif

   if(filp == NULL) return ENOFILE;

   /* translate stdio.h mode flag ... */

   mode = 0;
   if(filp->f_oflags && _F_READ) mode |= FA_READ;
   if(filp->f_oflags && _F_WRIT) mode |= FA_WRITE;
   if(filp->f_oflags && _F_CREATE) mode |= FA_CREATE_NEW;

   /* allocate FIL structure */
   pfil = (FIL *)malloc(sizeof(FIL));
   if(pfil == NULL) return ENOFILE;


   res = f_open(pfil, filp->pname, mode);
   if(res != FR_OK) {
    free(pfil);
    return ENOFILE;
   }

   filp->private = (void*)pfil;

   #ifdef CONFIG_CONFIG_DEBUG_FS_FAT
   nkc_write("... fatfs_open ]\n");
   #endif
   
   return EZERO;
}	

static int     fatfs_close(struct _file *filp){
  FIL *pfil;
  FRESULT res;

  #ifdef CONFIG_CONFIG_DEBUG_FS_FAT
   nkc_write("fs_fat.c: [ fatfs_close ....\n");
   #endif
   
  if(filp == NULL) return ENOFILE;

  pfil = (FIL*)filp->private;

  res = f_close(pfil);

  free(pfil);

  if(res != FR_OK) { 
    return ENOFILE;
  }

  #ifdef CONFIG_CONFIG_DEBUG_FS_FAT
  nkc_write("fs_fat.c: ... fatfs_close ]\n");
  #endif
   
  return EZERO;
}

static int     fatfs_read(struct _file *filp, char *buffer, int buflen){
  FIL *pfil;
  FRESULT res;
  UINT s2=0;

  #ifdef CONFIG_DEBUG_FS_FAT
  nkc_write("fs_fat.c: [ fatfs_read ... \n");
  #endif
  
  if(filp == NULL) return ENOFILE;

  pfil = (FIL*)filp->private;

//  FRESULT f_read (
//  FIL* fp,    /* Pointer to the file object */
//  void* buff,   /* Pointer to data buffer */
//  UINT btr,   /* Number of bytes to read */
//  UINT* br    /* Pointer to number of bytes read */

  res = f_read(pfil, buffer, buflen, &s2);

  #ifdef CONFIG_DEBUG_FS_FAT
  nkc_write("fs_fat.c: ... fatfs_read ] \n");
  #endif
    
  return s2;
}

static int     fatfs_write(struct _file *filp, const char *buffer, int buflen){
  FIL *pfil;
  FRESULT res;
  UINT s2=0;

  #ifdef CONFIG_DEBUG_FS_FAT
  nkc_write("fs_fat.c: [ fatfs_write ...\n");
  #endif
  
  if(filp == NULL) return ENOFILE;

  pfil = (FIL*)filp->private;
    
// FRESULT f_write (
//	FIL* fp,			/* Pointer to the file object */
//	const void *buff,	/* Pointer to the data to be written */
//	UINT btw,			/* Number of bytes to write */
//	UINT* bw			/* Pointer to number of bytes written */
//)
    
  res = f_write(pfil, buffer, buflen, &s2);
  
  #ifdef CONFIG_DEBUG_FS_FAT
  nkc_write("fs_fat.c: ... fatfs_write ]\n");
  #endif
  
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
  
  #ifdef CONFIG_DEBUG_FS_FAT
  nkc_write("fs_fat.c: [ fatfs_seek ...\n");
  #endif
  
  if(filp == NULL) return ENOFILE;
  
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
  
  #ifdef CONFIG_DEBUG_FS_FAT
  nkc_write("fs_fat.c: ... fatfs_seek ]\n");
  #endif
  
  return res;
}

static int     fatfs_remove(struct _file *filp){
  FRESULT res;
  #ifdef CONFIG_DEBUG_FS_FAT
  nkc_write("fs_fat.c: [ fatfs_remove ...\n");
  #endif
  
  if(filp == NULL) return ENOFILE;
  
  
  /* FRESULT f_unlink (
	const TCHAR* path  -- Pointer to the file or directory path 
) */
  res = f_unlink(filp->pname);
  
  #ifdef CONFIG_DEBUG_FS_FAT
  nkc_write("fs_fat.c: ... fatfs_remove ]\n");
  #endif
  
  return res;
}

static int     fatfs_getpos(struct _file *filp){  
  #ifdef CONFIG_DEBUG_FS_FAT
  nkc_write("fs_fat.c: [ fatfs_getpos ...\n");
  #endif
  if(filp == NULL) return ENOFILE;
  
  #ifdef CONFIG_DEBUG_FS_FAT
  nkc_write("fs_fat.c: ... fatfs_getpos ]\n");
  #endif
  return filp->f_pos;
 
}

static int     fatfs_rename(struct _file *filp, const char *oldrelpath, const char *newrelpath){
  FIL *pfil;
  FRESULT res;
  #ifdef CONFIG_CONFIG_DEBUG_FS_FAT
  nkc_write("fs_fat.c: [ fatfs_rename ...\n");
  #endif
  if(filp == NULL) return ENOFILE;
  
  pfil = (FIL*)filp->private;
  
  res = f_rename(oldrelpath,newrelpath);
  
  #ifdef CONFIG_CONFIG_DEBUG_FS_FAT
  nkc_write("fs_fat.c: ... fatfs_rename ]\n");
  #endif
  
  return res;
}


static int     fatfs_ioctl(char *name, int cmd, unsigned long arg){
  FIL *pfil;
  FRESULT res;
  
  struct ioctl_chmod *parg_chmod;
  struct ioctl_opendir *parg_opendir;
  struct ioctl_readdir *parg_readdir;
  struct ioctl_getfree *parg_getfree;
  
  #ifdef CONFIG_CONFIG_DEBUG_FS_FAT
  nkc_write("fs_fat.c: [ fatfs_ioctl ...\n");
  #endif
  
/*  
 if(filp == NULL) return ENOFILE;
  
  pfil = (FIL*)filp->private;
  
  #ifdef CONFIG_CONFIG_DEBUG_FS_FAT
  nkc_write("fs_fat.c: fatfs_ioctl not implemented !\n");
  #endif
 */

  switch(cmd){
    
    case FS_IOCTL_CHMOD: // change mod arg = 
    case FS_IOCTL_CD: // change directory
    // low level functions:
    case FS_IOCTL_INIT: // initialize filesystem
    case FS_IOCTL_DRIVE_STATUS: // get drive status
    case FS_IOCTL_FS_STATUS: // get file system status
    case FS_IOCTL_LD_STATUS: // get logical drive status
    case FS_IOCTL_MKFS: // make file system
    case FS_IOCTL_FDISK: // fdisk - write partition table
    case FS_IOCTL_READ: // low level disk read
    case FS_IOCTL_WRITE: // low level disk write
    case FS_IOCTL_MOUNT: // mount file system
    case FS_IOCTL_UMOUNT: // un-mount file system
    case FS_IOCTL_SET_LABEL: // set volume label
      
    case FS_IOCTL_GETCWD: // get current working directory (handled in fs.c)
    default: res = 0;
  }

  #ifdef CONFIG_CONFIG_DEBUG_FS_FAT
  nkc_write("fs_fat.c: ... fatfs_ioctl ]\n");
  #endif
  
  return res;
}

static int     fatfs_mkdir(struct _file *filp, const char *relpath){
  FIL *pfil;
  FRESULT res;
  #ifdef CONFIG_CONFIG_DEBUG_FS_FAT
  nkc_write("fs_fat.c: [ fatfs_mkdir ...\n");
  #endif  
  res = f_mkdir(relpath);
  #ifdef CONFIG_CONFIG_DEBUG_FS_FAT
  nkc_write("fs_fat.c: ... fatfs_mkdir ]\n");
  #endif
  return res;
}

static int     fatfs_rmdir(struct _file *filp, const char *relpath){
  FIL *pfil;
  FRESULT res;
  #ifdef CONFIG_CONFIG_DEBUG_FS_FAT
  nkc_write("fs_fat.c: [ fatfs_rmdir ...\n");
  #endif    
  res = f_unlink(relpath);
  #ifdef CONFIG_CONFIG_DEBUG_FS_FAT
  nkc_write("fs_fat.c: ... fatfs_rmdir ]\n");
  #endif 
  return res;
}


static int     fatfs_opendir(struct _file *filp, const char *relpath, DIR *dir){
  FIL *pfil;
  FRESULT res;
  #ifdef CONFIG_CONFIG_DEBUG_FS_FAT
  nkc_write("fs_fat.c: [ fatfs_opendir ...\n");
  #endif  
  if(dir == NULL) return ENOFILE;
  if(relpath == NULL) return ENOFILE;
  res = f_opendir(dir,relpath);
  #ifdef CONFIG_CONFIG_DEBUG_FS_FAT
  nkc_write("fs_fat.c: ... fatfs_opendir ]\n");
  #endif
  return res;
}


static int     fatfs_closedir(struct _file *filp, DIR *dir){
  FIL *pfil;
  FRESULT res;
  #ifdef CONFIG_CONFIG_DEBUG_FS_FAT
  nkc_write("fs_fat.c: [ fatfs_closedir ...\n");
  #endif    
  if(dir == NULL) return ENOFILE;
  res = f_closedir(dir);
  #ifdef CONFIG_CONFIG_DEBUG_FS_FAT
  nkc_write("fs_fat.c: ... fatfs_closedir ]\n");
  #endif
  return res;
}


static int     fatfs_readdir(struct _file *filp, DIR *dir,FILINFO* finfo){
  FIL *pfil;
  FRESULT res;
  #ifdef CONFIG_CONFIG_DEBUG_FS_FAT
  nkc_write("fs_fat.c: [ fatfs_readdir ...\n");
  #endif
  if(dir == NULL) return ENOFILE;
  if(finfo == NULL) return ENOFILE;
  
  f_readdir(dir,finfo);
  
  #ifdef CONFIG_CONFIG_DEBUG_FS_FAT
  nkc_write("fs_fat.c: ... fatfs_readdir ]\n");
  #endif
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
        printf("\n Multiple partition feature is enabled.\n Each logical drive is tied to the patition as follows:\n");
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

        res = f_mount(&FatFs[0], "0:", 1);
   
        res = f_getcwd(CurrDirPath, 256); /* update current drive,path */

        /* register driver within lib */
	register_driver("hda","FAT",&fat_file_operations); 	// general driver for gide 
        register_driver("hda0","FAT",&fat_file_operations); 	// driver for partition 0
	
}

