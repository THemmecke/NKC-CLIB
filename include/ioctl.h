#ifndef __INCLUDE_IOCTL_H
#define __INCLUDE_IOCTL_H

#include <ff.h>
// additional file operations via ioctrl

// general file system functions =============================
// get current working Directory
#define FS_IOCTL_GETCWD	0
// rename
#define FS_IOCTL_RENAME 1
// delete
#define FS_IOCTL_DEL 2

// FAT filesystem functions ==================================
// change directory
#define FAT_IOCTL_CD 3
#define FAT_IOCTL_CHMOD 4

#define FAT_IOCTL_READ 9
// low level disk write
#define FAT_IOCTL_WRITE 10
// mount file system
#define FAT_IOCTL_MOUNT 11
// un-mount file system
#define FAT_IOCTL_UMOUNT 12
// set volume label
#define FAT_IOCTL_SET_LABEL 13
// open directory
#define FAT_IOCTL_OPEN_DIR 14
// read directory
#define FAT_IOCTL_READ_DIR 15
// close directory
#define FAT_IOCTL_CLOSE_DIR 16
// make directory
#define FAT_IOCTL_MKDIR 17
// unlink/delete a file/dir
#define FAT_IOCTL_UNLINK 18

// Get Number of Free Clusters
#define FAT_IOCTL_GET_FREE 20
// initialize disc drive
#define FAT_IOCTL_DISK_INIT 21
#define FAT_IOCTL_DISK_GET_SECTOR_SIZE 22
#define FAT_IOCTL_DISK_GET_SECTOR_COUNT 23
#define FAT_IOCTL_GET_DISK_DRIVE_STATUS 24
// low level disk read (sector based)
#define FAT_IOCTL_DISK_READ 25
// create partition table
#define FAT_IOCTL_MKPTABLE 26
// get FatFs structure
#define FAT_IOCTL_GET_FATFS 27

static int ioctl(char *name, int cmd, unsigned long arg); // do ioctl on device "name"


// structures used to transfer data to ioctl functions using the arg parameter:
// pointers are void, their type depends on the filesystem used and has to be casted 


// FAT ioctl structures
struct get_cwd {
  void *buffer;		// pointer to string buffer
  unsigned int size; 	// size of buffer
};

struct ioctl_chmod {
  unsigned char value;
  unsigned char mask;
};

struct ioctl_opendir {
   void* dp;		// pointer to directory object 
   void* path;		// pointer to path
};

struct ioctl_readdir {
   void* dp;		// pointer to directory object
   void* fno;		// Pointer to file information to return
};

struct ioctl_getfree {
	void* path;	/* Path name of the logical drive number */
	void* nclst;		/* Pointer to a variable to return number of free clusters */
	void** fatfs;		/* Pointer to return pointer to corresponding file system object */
};

struct ioctl_rename {
    void* path_old;
    void* path_new;
};

struct ioctl_disk_read {
    unsigned char *buff;	/* Data buffer to store read data */
    unsigned int sector;	/* Sector address (LBA) */
    unsigned int count;		/* Number of sectors to read (1..128) */
};

struct ioctl_mkfs {
  char* path;			/* Logical drive number */
  unsigned char au;		/* Partitioning rule 0:FDISK, 1:SFD */
  unsigned int sfd;		/* Allocation unit [bytes] */
};

struct ioctl_mkptable {
  unsigned char pdrv;		/* Physical drive number */
  const unsigned int *szt;	/* Pointer to the size table for each partitions */
  void* work;			/* Pointer to the working buffer */
};

struct ioctl_getfatfs {
  long ld;
  FATFS *pfs;
};


#endif