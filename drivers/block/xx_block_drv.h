#ifndef __XX_BLOCK_DRV_H
#define __XX_BLOCK_DRV_H

#include <types.h> 
#include <drivers.h>

int xx_initialize(void);


static UINT xx_open(struct _dev *devp);
static UINT xx_close(struct _dev *devp);
static UINT xx_read(struct _dev *devp, char *buffer, UINT start_sector, UINT num_sectors);
static UINT xx_write(struct _dev *devp, char *buffer, UINT start_sector, UINT num_sectors);
static UINT xx_geometry(struct _dev *devp, struct geometry *geometry);
static UINT xx_ioctl(struct _dev *devp, int cmd, unsigned long arg);

#endif