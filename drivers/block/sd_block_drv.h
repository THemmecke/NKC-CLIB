#ifndef __SD_BLOCK_DRV_H
#define __SD_BLOCK_DRV_H

#include <types.h> 
#include <drivers.h>

int sd_initialize(void);


static UINT sd_open(struct _dev *devp);
static UINT sd_close(struct _dev *devp);
static UINT sd_read(struct _dev *devp, char *buffer, UINT start_sector, UINT num_sectors);
static UINT sd_write(struct _dev *devp, char *buffer, UINT start_sector, UINT num_sectors);
static UINT sd_geometry(struct _dev *devp, struct geometry *geometry);
static UINT sd_ioctl(struct _dev *devp, UINT cmd, unsigned long arg);

#endif