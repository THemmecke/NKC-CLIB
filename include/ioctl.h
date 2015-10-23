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
#define FS_IOCTL_GET_FREE	6
#define FS_IOCTL_RENAME 	7
#define FS_IOCTL_DEL 		8
#define FS_IOCTL_GETDRV		9
#define FS_IOCTL_CHDRIVE	10
#define FS_IOCTL_CHMOD		11

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
// JADOS/NKC related calls 1000+ ===================================
#define NKC_IOCTL
#define NKC_IOCTL_DIR				10001





//static 
int ioctl(char *name, int cmd, unsigned long arg); // do ioctl on device "name"


// structures used to transfer data to ioctl functions using the arg parameter:
// pointers are void, their type depends on the filesystem used and has to be casted 


// FAT ioctl structures
struct ioctl_get_cwd {
  void *cpath;		/* pointer to path string buffer 	*/
  void *cdrv;		/* pointer to drive srtring buffer      */
  unsigned int size; 	/* size of buffer		*/
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

struct ioctl_disk_read {
    unsigned char drv;	/* physical drive number */
    unsigned char *buff;	/* Data buffer to store read data */
    unsigned int sector;	/* Sector address (LBA) */
    unsigned int count;		/* Number of sectors to read (1..128) */
};

struct ioctl_mkfs {
  char* pdrv;			/* Logical drive number */
  unsigned char au;		/* Partitioning rule 0:FDISK, 1:SFD */
  unsigned int sfd;		/* Allocation unit [bytes] */
};

struct ioctl_mkptable {
  unsigned char drv;		/* Physical drive number */
  const unsigned int *szt;	/* Pointer to the size table for each partitions */
  void* work;			/* Pointer to the working buffer */
};

struct ioctl_getfatfs {
  unsigned char drv;		
  long ldrv;
  FATFS **ppfs;
};

struct ioctl_mount_fatfs {
  unsigned char drv;		/* disk number 	*/
  unsigned char ldrv;		/* logical drive/partition number */
  unsigned char opt; 		/* mount option		*/
};

struct ioctl_getlabel {
  unsigned char drv;		/* disk number */
  char* pldrv;			/* piointer logical drive/partition number */
  char* plabel;			/* pointer to label buffer */	
  DWORD* psn; 			/* pointer to volume serial number		*/
};

struct ioctl_read_write {
  FIL* fp;			/* pointer to file object */
  void* pbuf;			/* buffer to store read data/to data to be written */
  UINT size;			/* number of bytes to read/wwrite */	
  UINT* count; 			/* number of bytes read/written		*/
};

struct ioctl_nkc_dir {
  BYTE  attrib;			// IN: bitmapped file attribute: 1=file length; 2=date; 4=r/w attribute
  BYTE  *ppattern;	        // IN: pointer to file pattern (? and * are also allowed)
  BYTE  cols;			// IN: number of colums for output
  UINT  size;			// IN: size of output buffer pbuf (256x14 Bytes max.)
  void* pbuf;			// OUT: output buffer
};


#endif