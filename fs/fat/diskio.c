/*-----------------------------------------------------------------------*/
/* Low level disk I/O module skeleton for Petit FatFs (C)ChaN, 2009      */
/*-----------------------------------------------------------------------*/

#include <fs.h>			/* Declarations of file system and block device API */
#include <ioctl.h>		/* include ioctl definitions */
#include <errno.h>
#include <drivers.h>
#include <debug.h>

#include "ff.h"
#include "diskio.h"


/*--------------------------------------------------------------------------

   Module Private Functions

---------------------------------------------------------------------------*/


/*-----------------------------------------------------------------------*/
/* Initialize Disk Drive                                                 */
/*-----------------------------------------------------------------------*/


DSTATUS disk_initialize (		    
		     struct fstabentry *pfstab
	       )		    
{
        struct blk_driver *blk_drv; /* Pointer to block device driver */
	DRESULT res = RES_PARERR;
	struct _dev dev;
	
	ff_dbg("diskio.c: disk_initialize\n");
	
	if(!pfstab) return res;	
	dev.pdrv = pfstab->pdrv;    // physical drive number
	blk_drv = pfstab->pblkdrv;  // block device driver
	
        if(blk_drv) {
	  if(blk_drv->blk_oper) {
	    if(blk_drv->blk_oper->ioctl) {
	        res = blk_drv->blk_oper->open(&dev);
	    }
	  }
	}	

	return disk_status(pfstab);
}


/*-----------------------------------------------------------------------*/
/* Get Disk Status                                                       */
/*-----------------------------------------------------------------------*/


DSTATUS disk_status (	
	 struct fstabentry *pfstab
)
{
	struct blk_driver *blk_drv;	/* Pointer to block device driver */
	DSTATUS stat = STA_OK;
	DRESULT res = RES_PARERR;
	struct _dev dev;
	
	if(!pfstab) return res;	
	dev.pdrv = pfstab->pdrv;    // physical drive number
	blk_drv = pfstab->pblkdrv;  // block device driver
	
	ff_dbg("diskio.c: disk_status\n");
	ff_dbg("    name = %s\n",pfstab->devname);
	ff_dbg("    pdrv = %d\n",pfstab->pdrv);
	
	
        if(blk_drv) {
	  if(blk_drv->blk_oper) {
	    if(blk_drv->blk_oper->ioctl) {
	        res = blk_drv->blk_oper->ioctl(&dev,GET_DISK_STATUS,&stat);
	    }
	  }
	}	

	switch(res) {
	  case RES_OK: 		stat = STA_OK;		break;
	  case RES_ERROR:	stat = STA_NOINIT;      break;
	  case RES_WRPRT:	stat = STA_PROTECT;     break;
	  case RES_NOTRDY:	stat = STA_NODISK;      break;
	  case RES_PARERR:	stat = STA_NOINIT;      break;
	}
	
	return stat;
}


/*-----------------------------------------------------------------------*/
/* Read Sector(s)                                                        */
/*-----------------------------------------------------------------------*/


DRESULT disk_read (
	struct fstabentry *pfstab,
	BYTE *buff,		/* Data buffer to store read data */
	DWORD sector,	/* Sector address (LBA) */
	UINT count		/* Number of sectors to read (1..128) */
)
{
        struct blk_driver *blk_drv;	/* Pointer to block device driver */
	DRESULT res = RES_PARERR;
	struct _dev dev;
	
	ff_dbg("diskio.c: disk_read\n");
	
	if(!pfstab) return res;	
	dev.pdrv = pfstab->pdrv;    // physical drive number
	blk_drv = pfstab->pblkdrv;  // block device driver
	
	ff_dbg("    device = %s\n",pfstab->devname);
	ff_dbg("    pdrv   = %d\n",dev.pdrv);
	ff_dbg("    sect   = 0x%x\n",sector);
	ff_dbg("    cnt    = 0x%x\n",count);
	ff_dbg("    buf    = 0x%x\n",buff);		
	ff_dbg("    blk_drv@ 0x%x\n", blk_drv);
	
        if(blk_drv) {
	  if(blk_drv->blk_oper) {
	    if(blk_drv->blk_oper->read) {
	        res = blk_drv->blk_oper->read(&dev,buff,sector,count);
	    }
	  }
	}	

	return res;			
}


/*-----------------------------------------------------------------------*/
/* Write Sector(s)                                                       */
/*-----------------------------------------------------------------------*/


DRESULT disk_write (
	struct fstabentry *pfstab,
	const BYTE *buff,	/* Data to be written */
	DWORD sector,		/* Sector address (LBA) */
	UINT count			/* Number of sectors to write (1..128) */
)
{
        struct blk_driver *blk_drv;	/* Pointer to block device driver */
	DRESULT res = RES_PARERR;
	struct _dev dev;
		
	ff_dbg("diskio.c: disk_write\n");
	
	if(!pfstab) return res;	
	dev.pdrv = pfstab->pdrv;    // physical drive number
	blk_drv = pfstab->pblkdrv;  // block device driver
	
	ff_dbg("    device = %d\n",pfstab->devname);
	ff_dbg("    pdrv   = %d\n",dev.pdrv);
	ff_dbg("    sect   = 0x%x\n",sector);
	ff_dbg("    cnt    = 0x%x\n",count);
	ff_dbg("    buf    = 0x%x\n",buff);
	ff_dbg("    blk_drv@ 0x%x\n", blk_drv);
	
        if(blk_drv) {
	  if(blk_drv->blk_oper) {
	    if(blk_drv->blk_oper->write) {
	        res = blk_drv->blk_oper->write(&dev,buff,sector,count);
	    }
	  }
	}	

	ff_dbg("diskio.c: done ...\n");
	
	return res;			
}


/*-----------------------------------------------------------------------*/
/* Miscellaneous Functions                                               */
/*-----------------------------------------------------------------------*/


DRESULT disk_ioctl (
	struct fstabentry *pfstab,
	int ctrl,			/* Control code */
	void *buff			/* Buffer to send/receive data block */
)
{        
        struct blk_driver *blk_drv;	/* Pointer to block device driver */
	DRESULT res = RES_PARERR;
	struct _dev dev;
	
	ff_dbg("diskio.c|disk_ioctl:\n");
	
	if(!pfstab) return res;	
	
	dev.pdrv = pfstab->pdrv;    // physical drive number
	blk_drv = pfstab->pblkdrv;  // block device driver
		
	ff_dbg("    pdrv = %d\n",dev.pdrv);
	ff_dbg("    cmd  = %d\n",ctrl);
	ff_dbg("    buf  = 0x%x\n",buff);
	ff_dbg("   blk driver @  0x%x\n",blk_drv);
	
        if(blk_drv) {
	  if(blk_drv->blk_oper) {
	    if(blk_drv->blk_oper->ioctl) {
	        res = blk_drv->blk_oper->ioctl(&dev,ctrl,buff);
	    }
	  }
	}	

	return res;
}

