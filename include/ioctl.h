#ifndef __INCLUDE_IOCTL_H
#define __INCLUDE_IOCTL_H

#include "../fs/fat/ff.h"
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
#define FS_IOCTL_READ       20
#define FS_IOCTL_WRITE      21

// low level functions 
#define FS_IOCTL_DISK_INIT		22
#define FS_IOCTL_GET_DISK_DRIVE_STATUS  23
#define FS_IOCTL_DISK_READ		24
#define FS_IOCTL_DISK_WRITE		25
#define FS_IOCTL_MKPTABLE		26
#define FS_IOCTL_DISK_GET_SECTOR_COUNT	27
#define FS_IOCTL_DISK_GET_SECTOR_SIZE	28

// should be removed and solved on higher levels using direct access using block drivers
#define FS_IOCTL_SET_VLABEL 29
#define FS_IOCTL_GET_VLABEL 30
#define FS_IOCTL_MKFS 31
#define FS_IOCTL_INFO 32

#define FS_IOCTL_GET_SLIST 33

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
	FS** ppfs;		/* Pointer to return pointer to corresponding file system object */
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


struct slist {  // used with FS_IOCTL_GET_SLIST
  unsigned int s; // sector number on medium (LBA)
  void* next;    // pointer to next slist entry
};

struct ioctl_get_slist{
  struct slist *list;
  char *filename;
};




#endif