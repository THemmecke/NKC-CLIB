#ifndef __SD_BLOCK_DRV_H
#define __SD_BLOCK_DRV_H

#include <types.h> 
#include <drivers.h>

int sd_initialize(void);


static DRESULT sd_open(struct _dev *devp);
static DRESULT sd_close(struct _dev *devp);
static DRESULT sd_read(struct _dev *devp, char *buffer, UINT start_sector, UINT num_sectors);
static DRESULT sd_write(struct _dev *devp, char *buffer, UINT start_sector, UINT num_sectors);
static DRESULT sd_geometry(struct _dev *devp, struct geometry *geometry);
static DRESULT sd_ioctl(struct _dev *devp, UINT cmd, unsigned long arg);

#endif