#ifndef __DRIVERS_H
#define __DRIVERS_H

#include <types.h>


/*
  https://superuser.com/questions/974581/chs-to-lba-mapping-disk-storage
*/

struct _dev
{
  UCHAR	pdrv;		/* physical drive number (blk_driver->n) */ 
};

struct geometry
{
  BOOL   available;    /* true: The device is vailable */
  BOOL   mediachanged; /* true: The media has changed since last query */
  BOOL   writeenabled; /* true: It is okay to write to this device */
  UINT	 cylinders;    /* number of cylinders (non LMB) */
  UINT   heads;        /* number of heads (non LMB) */
  UINT	 sptrack;      /* sectors per track */
  UINT   nsectors;     /* Number of sectors on the device */
  UINT   lba_sectors;  /* Number of lba sectors on the device - on IDE devices this differes from nsectors */
  UINT   sectorsize;   /* Size of one sector, usualy 512 bytes */ 
  UINT   raw_sectorsize; /* raw/unfomatted sector size */
  USHORT type;	       /* device type */
  char*  model;	       /* model name */
};


struct block_operations
{
 
  UINT     (*open)(struct _dev *devp);
  UINT     (*close)(struct _dev *devp);
  UINT     (*read)(struct _dev *devp, char *buffer, DWORD start_sector, DWORD num_sectors);
  UINT     (*write)(struct _dev *devp, const char *buffer, DWORD start_sector, DWORD num_sectors);
  UINT     (*geometry)(struct _dev *devp, struct geometry *geometry);
  UINT     (*ioctl)(struct _dev *devp, int cmd, unsigned long arg);

};

struct c_operations
{
  UINT     (*open)(char *pdevice);
  UINT     (*close)(void *phandle);
  UINT     (*read)(void *phandle, UINT address, UINT data);
  UINT     (*write)(void *phandle, UINT address);
  UINT     (*ioctl)(void *phandle, int cmd, unsigned long arg);
};


struct blk_driver
{
	char	                       *pdrive;	  /* name of drive, i.e. A, B... ,HD, SD... */
	struct block_operations 		 *blk_oper;	/* block operations */
	struct blk_driver			       *next;		  /* pointer to next driver in driverlist */
};

struct char_driver
{
  char                          *pdrive;  /* name of device, i.e. RTC etc. */
  struct c_operations           *c_oper;  /* char operations */
  struct char_driver            *next;    /* pointer to next driver in driverlist */
};

/* The following struct emerged from the original GP and is there used both for IDE and SDCARD type devices.
   That's why we define it here...
*/
struct _driveinfo     //    (32)
{
  USHORT  numcyl;     // +0   (2)
  BYTE  numhead;    // +2 (1)
  BYTE  numsec;     // +3 (1)
  ULONG nkcmode;    // +4 (4)
  char    idename[24];  // +8 (24)
  };
//}__attribute__ ((packed));

struct blk_driver* get_blk_driver(char *name);
struct char_driver* get_char_driver(char *name);

int xx_initialize(void);

int register_blk_driver(char *pdrive, const struct block_operations  *blk_oper);
int un_register_blk_driver(char *pdrive);

int register_char_driver(char *pdrive, const struct c_operations  *c_oper);
int un_register_char_driver(char *pdrive);


#endif