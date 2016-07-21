/*-----------------------------------------------------------------------*/
/* Low level disk I/O module skeleton for Petit FatFs (C)ChaN, 2009      */
/*-----------------------------------------------------------------------*/

#include <fs.h>			/* Declarations of file system and block device API */
#include <ff.h>
#include <ioctl.h>		/* include ioctl definitions */
#include <errno.h>
#include <drivers.h>
#include <debug.h>

#include "diskio.h"

// // LBA = C x usNumHeads x usNumSecs + H x Num_Sec + (S - 1) 
// USHORT usNumHeads;
// USHORT usNumSecs;
// 
// #define BUFSIZE 512
// 
// typedef struct {	
// 	DWORD dwsector;	/* sector that is in the buffer 			 */
// 	DWORD dwofs;	/* current read/write pointer in the bufffer */ 
// } _BUFSTAT;
// 
// 
// static
// BYTE Buffer[BUFSIZE];
// 
// static volatile _BUFSTAT stat;
// 


/*--------------------------------------------------------------------------

   Module Private Functions

---------------------------------------------------------------------------*/


// struct fstabentry
// {
//   char* devname;			/* devicename A, B ,HDA0 , HDB1... */   
//   BYTE pdrv;				/* physical drive number */  
//   struct driver	*pfsdrv;	/* pointer to file system driver */
//   struct blk_driver *pblkdrv;	/* pointer to block device driver */
//   unsigned char options;		/* mount options */
//   struct fstabentry* next;		/* pointer to next fstab entry */
// };




/*-----------------------------------------------------------------------*/
/* Initialize Disk Drive                                                 */
/*-----------------------------------------------------------------------*/


DSTATUS disk_initialize (		    
		    //BYTE pdrv				/* Physical drive number (0..) */
		     struct fstabentry *pfstab
	       )		    
{
        struct blk_driver *blk_drv; /* Pointer to block device driver */
	DRESULT res = RES_PARERR;
	struct _dev dev;
	
	
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

	//return STA_OK;
	return disk_status(pfstab);
}


/*-----------------------------------------------------------------------*/
/* Get Disk Status                                                       */
/*-----------------------------------------------------------------------*/


/* Disk Status Bits (DSTATUS) 

#define STA_OK			0x00
#define STA_NOINIT		0x01	 Drive not initialized 
#define STA_NODISK		0x02	 No medium in the drive 
#define STA_PROTECT		0x04	 Write protected 
*/

DSTATUS disk_status (	
	//BYTE pdrv		/* Physical drive nmuber (0..) */
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
	
	//return STA_OK;
	return stat;
}


/*-----------------------------------------------------------------------*/
/* Read Sector(s)                                                        */
/*-----------------------------------------------------------------------*/


DRESULT disk_read (
	//BYTE pdrv,		/* Physical drive nmuber (0..) */
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
	
	ff_dbg("    device = %d\n",pfstab->devname);
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

	//return STA_OK;
	return res;			
}


/*-----------------------------------------------------------------------*/
/* Write Sector(s)                                                       */
/*-----------------------------------------------------------------------*/


DRESULT disk_write (
	//BYTE pdrv,			/* Physical drive nmuber (0..) */
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
	
	//return STA_OK;
	return res;			
}


/*-----------------------------------------------------------------------*/
/* Miscellaneous Functions                                               */
/*-----------------------------------------------------------------------*/


DRESULT disk_ioctl (
	//BYTE pdrv,			/* Physical drive nmuber (0) */
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

	//return STA_OK;
	return res;
}


// unused ...
///*-----------------------------------------------------------------------*/
///* Read Partial Sector                                                   */
///*-----------------------------------------------------------------------*/
//
//DRESULT disk_readp (
//	BYTE* dest,			/* Pointer to the destination object */
//	DWORD sector,		/* Sector number (LBA) */
//	WORD sofs,			/* Offset in the sector 0..511 */
//	WORD count			/* Byte count (bit15:destination) sofs+cound <= 512 ! */
//)
//{
//	DRESULT res;	
//
//	// Put your code here
//	
//	UCHAR *src;
//	
////	nkc_write(" disk_readp: calling idedisk...result = ");
////  d0  = idedisk( d1,       d2, d3,d4,a0)
//	
//	// *** ==> hd_block_erv.c - hd_read(struct _dev *devp, char *buffer, UINT start_sector, UINT num_sectors)
//	res = _ide(CMD_READ,sector,1,1,Buffer);	
////	nkc_write_hex8(res); nkc_write("\n");
//	
////	res = 0;
//	
//	src = Buffer + sofs;
//	
//	if(dest){
////		nkc_write(" copy to destination buffer ...\n");
//		memcpy(dest,src,count);
//	}	
//
//	return res;
//}
//
//
//
///*-----------------------------------------------------------------------*/
///* Write Partial Sector                                                  */
///*-----------------------------------------------------------------------*/
//
//DRESULT disk_writep (
//	const BYTE* buff,		/* Pointer to the data to be written, NULL:Initiate/Finalize write operation */
//	DWORD sc		/* Sector number (LBA) or Number of bytes to send */
//)	
//{
//	DRESULT res;
//
//
//	dio_dbg(" disk_writep:\n");
//	
//	if (!buff) {
//		if (sc) {
//
//			// I) Initiate write process
//			// buff = NULL && sc > 0: initialize a 512 byte write buffer (memset NULL) sa == Sector Number, offset in buffer = 0	
//			dio_lldbgwait(" I) initializing\n");		
//			stat.dwsector = sc;	
//			stat.dwofs = 0;
//			memset(Buffer, 0, sizeof(Buffer));
//			res = RES_OK;
//
//		} else {
//
//			// III) Finalize write process
//			// buff = NULL && sc =	 0: write buffer to disk at Sector given in I
//			dio_lldbgwait(" III) finalizing\n");	
//			
//			
//			// *** ==> hd_block_drv.c - hd_write(struct _dev *devp, char *buffer, UINT start_sector, UINT num_sectors)
//			res = _ide(CMD_WRITE,stat.dwsector,1,1,Buffer);
//			
//			stat.dwsector = 0;
//			res = RES_OK;
//		}
//	} else {
//
//		// II) Send data to the disk(buffer)
//		// i.e. send data to the buffer: sc = number of bytes -> increase buffer offset pointer by sc up to 511		
//		dio_lldbgwait(" II) storing write data in Buffer\n");	
//		if (stat.dwofs + sc > BUFSIZE){
//			 dio_dbg("       Buffer ptr > 512 !\n");
//			 sc = BUFSIZE - stat.dwofs;
//		}
//		memcpy(&Buffer[stat.dwofs], buff, sc);
//		stat.dwofs += sc;
//		res = RES_OK;
//
//	}
//
//	dio_lldbgwait("Key...");
//	return res;
//}
//

