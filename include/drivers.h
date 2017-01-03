#ifndef __DRIVERS_H
#define __DRIVERS_H

#include <types.h>

struct _dev
{
  UCHAR	pdrv;		/* physical drive number (blk_driver->n) */ 
};

struct geometry
{
  BOOL   available;    /* true: The device is vailable */
  BOOL   mediachanged; /* true: The media has changed since last query */
  BOOL   writeenabled; /* true: It is okay to write to this device */
  UINT	 cylinders;
  UINT   heads;
  UINT	 sptrack;
  UINT   nsectors;     /* Number of sectors on the device */
  UINT   sectorsize;   /* Size of one sector */
  char*  model;
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


struct blk_driver
{
	char					*pdrive;	/* name of drive, i.e. A, B... ,HD, SD... */
	struct block_operations 		*blk_oper;	/* block operations */
	struct blk_driver			*next;		/* pointer to next driver in driverlist */
};

struct blk_driver* get_blk_driver(char *name);


int xx_initialize(void);

int register_blk_driver(char *pdrive, const struct block_operations  *blk_oper);
int un_register_blk_driver(char *pdrive);


#endif