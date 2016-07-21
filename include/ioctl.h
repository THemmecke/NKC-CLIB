#ifndef __INCLUDE_IOCTL_H
#define __INCLUDE_IOCTL_H

#include <ff.h>
// additional file operations via ioctrl

// general file system functions =============================
#define FS_IOCTL_GETCWD      	1
#define FS_IOCTL_CD		2
#define FS_IOCTL_OPEN_DIR	3
#define FS_IOCTL_READ_DIR	4
#define FS_IOCTL_CLOSE_DIR	5
#define FS_IOCTL_MKDIR		6
#define FS_IOCTL_RMDIR		7
#define FS_IOCTL_GET_FREE	8
#define FS_IOCTL_RENAME 	9
#define FS_IOCTL_DEL 		10
#define FS_IOCTL_GETDRV		11
#define FS_IOCTL_CHDRIVE	12
#define FS_IOCTL_CHMOD		13
#define FS_IOCTL_GETDRVLIST	14
#define FS_IOCTL_MOUNT		15
#define FS_IOCTL_UMOUNT		16
#define FS_IOCTL_GETFSTAB	17
#define FS_IOCTL_GETFSDRIVER	18
#define FS_IOCTL_GETBLKDEV	19

// low level functions 
#define FS_IOCTL_DISK_INIT		20
#define FS_IOCTL_GET_DISK_DRIVE_STATUS  21
#define FS_IOCTL_DISK_READ		22
#define FS_IOCTL_DISK_WRITE		23
#define FS_IOCTL_MKPTABLE		24
#define FS_IOCTL_DISK_GET_SECTOR_COUNT	25
#define FS_IOCTL_DISK_GET_SECTOR_SIZE	26

// FAT filesystem functions 100+ ==================================
#define FAT_IOCTL				100
// change directory
#define FAT_IOCTL_CD 				101
#define FAT_IOCTL_CHMOD 			102
// low level disk read
#define FAT_IOCTL_READ 				103
// low level disk write
#define FAT_IOCTL_WRITE 			104
// mount file system
#define FAT_IOCTL_MOUNT 			105
// un-mount file system
#define FAT_IOCTL_UMOUNT 			106
// set volume label
#define FAT_IOCTL_SET_VLABEL 			107
// get volume label
#define FAT_IOCTL_GET_VLABEL 			108
// open directory
#define FAT_IOCTL_OPEN_DIR 			109
// read directory
#define FAT_IOCTL_READ_DIR 			110
// close directory
#define FAT_IOCTL_CLOSE_DIR 			111
// make directory
#define FAT_IOCTL_MKDIR 			112
// unlink/delete a file/dir
#define FAT_IOCTL_UNLINK 			113
// Get Number of Free Clusters
#define FAT_IOCTL_GET_FREE 			114
// create FAT file system
#define FAT_IOCTL_MKFS 				115
// siehe auch FS_IOCTL_GETCWD.....fix !
#define FAT_IOCTL_GETCWD 			116
// get FatFs structure
#define FAT_IOCTL_GET_FATFS 			117
// rename a file/directory
#define FAT_IOCTL_RENAME			118
// change physical drive
#define FAT_IOCTL_CHDRIVE			119
// print info about FAT file system		
#define FAT_IOCTL_INFO				120
// Low Level FileSystem Services 200+ ==============================
#define FS_LL_IOCTL				200
// initialize disc drive
#define FAT_IOCTL_DISK_INIT 			201
#define FAT_IOCTL_GET_DISK_DRIVE_STATUS 	202
// low level disk read (sector based)
#define FAT_IOCTL_DISK_READ 			203
// create partition table
#define FAT_IOCTL_MKPTABLE 			204
#define FAT_IOCTL_DISK_GET_SECTOR_SIZE 		205
#define FAT_IOCTL_DISK_GET_SECTOR_COUNT 	206

// Low Level diskio commands 300+ ===================================
// inported from 
/* Generic command (used by FatFs) */
#define CTRL_SYNC				300	/* Flush disk cache (for write functions) */
#define GET_SECTOR_COUNT			301	/* Get media size (for only f_mkfs()) */
#define GET_SECTOR_SIZE				302	/* Get sector size (for multiple sector size (_MAX_SS >= 1024)) */
#define GET_BLOCK_SIZE				303	/* Get erase block size (for only f_mkfs()) */
#define CTRL_ERASE_SECTOR			304	/* Force erased a block of sectors (for only _USE_ERASE) */

/* Generic command (not used by FatFs) */
#define CTRL_POWER				305	/* Get/Set power status */
#define CTRL_LOCK				306	/* Lock/Unlock media removal */
#define CTRL_EJECT				307	/* Eject media */
#define CTRL_FORMAT				308	/* Create physical format on the media */

/* MMC/SDC specific ioctl command */
#define MMC_GET_TYPE				310	/* Get card type */
#define MMC_GET_CSD				311	/* Get CSD */
#define MMC_GET_CID				312	/* Get CID */
#define MMC_GET_OCR				313	/* Get OCR */
#define MMC_GET_SDSTAT				314	/* Get SD status */

/* ATA/CF specific ioctl command */
#define ATA_GET_REV				320	/* Get F/W revision */
#define ATA_GET_MODEL				321	/* Get model name */
#define ATA_GET_SN				322	/* Get serial number */

#define GET_DISK_STATUS				323
#define CTRL_DISK_INIT				324
// JADOS/NKC related calls 1000+ ===================================
#define NKC_IOCTL				10000
#define NKC_IOCTL_DIR				10001
#define NKC_IOCTL_READ_REC			10002
#define NKC_IOCTL_WRITE_REC			10003
#define NKC_IOCTL_FILLFCB			10004
#define NKC_IOCTL_ERASE				10005
#define NKC_IOCTL_CREATE			10006
#define NKC_IOCTL_OPEN				10007
#define NKC_IOCTL_CLOSE				10008
#define NKC_IOCTL_SETREC			10009
#define NKC_IOCTL_REMOVE			10010
#define NKC_IOCTL_RENAME			10011





//static 
int ioctl(char *name, int cmd, unsigned long arg); // do ioctl on device "name"


// structures used to transfer data to ioctl functions using the arg parameter:
// pointers are void, their type depends on the filesystem used and has to be casted 


// FAT ioctl structures
struct ioctl_get_cwd {
  void *cpath;		/* pointer to path string buffer 	*/
  void *cdrive;		/* pointer to drive srtring buffer      */
  unsigned int size; 	/* size of path buffer		        */
};

struct ioctl_chmod {
  void* fpath;		/* pointer to file path */
  unsigned char value;
  unsigned char mask;
};

struct ioctl_opendir {
   void* dp;		/* pointer to directory object 	*/
   void* path;		/* pointer to path		*/
};

struct ioctl_readdir {
   void* dp;		/* pointer to directory object		*/
   void* fno;		/* Pointer to file information to return */
};

struct ioctl_getfree {
	char* path;		/* Path name of the logical drive number */
	DWORD* nclst;		/* Pointer to a variable to return number of free clusters */
	FATFS** ppfatfs;	/* Pointer to return pointer to corresponding file system object */
};

struct ioctl_rename {
    void* path_old;
    void* path_new;
};

// high level (filesystem) read/write
struct ioctl_file_rw {
  FIL* fp;			/* pointer to file object */
  void* pbuf;			/* buffer to store read data/to data to be written */
  UINT size;			/* number of bytes to read/wwrite */	
  UINT* count; 			/* number of bytes read/written		*/
};

// low level (device) read/write
struct ioctl_disk_rw {
    char *drv;			/* pointer to physical drive name (HDA,HDB,SDA,SDB ....) */
    unsigned char *buff;	/* Data buffer to store read data to / retreive data to be writte from */
    unsigned int sector;	/* Sector address (LBA) */
    unsigned int count;		/* Number of sectors to read (1..128) */
};

struct ioctl_mkfs {
  char* part;			/* pointer to physical drive and partition name (HDA0,HDB0,SDA1,SDB0 ....) */
  char* fstype;			/* file system type: FAT12,FAT16,FAT32 ... */
  unsigned int sfd;		/* Partitioning rule 0:FDISK, 1:SFD */
  unsigned char au;		/* Allocation unit [bytes] */
};

struct ioctl_mkptable {
  char *devicename;		/* pointer to physical drive name (HDA,HDB,SDA,SDB ....) */
  const unsigned int *szt;	/* Pointer to the size table for each partitions */
  void* work;			/* Pointer to the working buffer */
};

struct ioctl_getfatfs {
  unsigned char vol;
  FATFS **ppfs;
};

struct ioctl_mount_fs {
  char *devicename;   		/* devicename (HDA0, SDB1, A, B, 1, 2, ... */
  char* fsname;			/* file system name (FAT32, JADOS ...)    */
  unsigned char options;        /* mount options (FS_READ, FS_RW, ....)   */  
};

struct ioctl_getlabel {
  char* volume;			/* piointer logical drive/partition number */
  char* plabel;			/* pointer to label buffer */	
  DWORD* psn; 			/* pointer to volume serial number		*/
};


struct ioctl_nkc_dir {
  struct fstabentry *pfstab;    // IN: pointer to fstabentry
  BYTE  attrib;			// IN: bitmapped file attribute: 1=file length; 2=date; 4=r/w attribute
  BYTE  *ppattern;	        // IN: pointer to file pattern (? and * are also allowed)
  BYTE  cols;			// IN: number of colums for output
  UINT  size;			// IN: size of output buffer pbuf (256x14 Bytes max.)
  void* pbuf;			// OUT: output buffer
};

struct ioctl_nkc_blk {
  unsigned long arg1;		// arguments
  unsigned long arg2;	        // 
  unsigned long arg3;
  
};


#endif