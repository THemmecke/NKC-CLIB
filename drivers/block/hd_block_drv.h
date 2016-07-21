#ifndef __HD_BLOCK_DRV_H
#define __HD_BLOCK_DRV_H

#include <types.h> 
#include <drivers.h>


/*---------------------------------------*/
/* Prototypes for disk control functions */


DSTATUS hd_initialize(void);


static DSTATUS hd_open(struct _dev *devp);
static DRESULT hd_close(struct _dev *devp);
static DRESULT hd_read(struct _dev *devp, char *buffer, DWORD start_sector, DWORD num_sectors);
static DRESULT hd_write(struct _dev *devp, char *buffer, DWORD start_sector, DWORD num_sectors);
static DRESULT hd_geometry(struct _dev *devp, struct geometry *geometry);
static DRESULT hd_ioctl(struct _dev *devp, int cmd, unsigned long arg);


#ifndef _DISKIO
#define _DISKIO

#define _USE_WRITE	1	/* 1: Enable disk_write function */
#define _USE_IOCTL	1	/* 1: Enable disk_ioctl fucntion */


/* Card type flags (CardType) */
#define CT_MMC				0x01	/* MMC ver 3 */
#define CT_SD1				0x02	/* SD ver 1 */
#define CT_SD2				0x04	/* SD ver 2 */
#define CT_SDC				(CT_SD1|CT_SD2)	/* SD */
#define CT_BLOCK			0x08	/* Block addressing */


#endif


#endif