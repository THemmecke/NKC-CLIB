/*-----------------------------------------------------------------------*/
/* Low level disk I/O module skeleton for Petit FatFs (C)ChaN, 2009      */
/*-----------------------------------------------------------------------*/


#include "diskio.h"
#include "gide.h"
#include "debug.h"



// LBA = C x usNumHeads x usNumSecs + H x Num_Sec + (S - 1) 
USHORT usNumHeads;
USHORT usNumSecs;


//---------

#define MAX_DRIVES	10	/* Max number of physical drives to be used */

typedef struct {
	DSTATUS	status;		/* drive status */
	WORD sz_sector;		/* sectorsize */
	DWORD n_sectors;	/* number of sectors over all */
} STAT;


static volatile STAT Stat[MAX_DRIVES]; /* first drive is 0, GP starts at 1 ! */

//---------

#define BUFSIZE 512

typedef struct {	
	DWORD dwsector;	/* sector that is in the buffer 			 */
	DWORD dwofs;	/* current read/write pointer in the bufffer */ 
} _BUFSTAT;


static
BYTE Buffer[BUFSIZE];

static volatile _BUFSTAT stat;

/*-----------------------------------------------------------------------*/
/* Initialize Disk Drive                                                 */
/*-----------------------------------------------------------------------*/

void init_ff(void)
{
	memset(Stat,STA_NOINIT,sizeof(STAT)*MAX_DRIVES); /* set all drives to STA_NOINIT */
	memset(Buffer,0,BUFSIZE);						 /* reset buffer */
}

DSTATUS disk_initialize (BYTE pdrv)				/* Physical drive number (0..) */
{
	DSTATUS stat; //STA_NODISK
	//struct _driveinfo *pinfo;
	struct _deviceinfo di;
	
	dio_dbg("disk_initialize...\n");
	
	stat = idetifyIDE(pdrv+1, &di);
	//pinfo = idetest(pdrv+1);  /* muss aufgerufen werden um GP Funktionen verwenden zu können ! */
	stat = 0;
		
	Stat[pdrv].status = 0;	
	Stat[pdrv].sz_sector = 512;
	
	
	Stat[pdrv].n_sectors = di.cylinders * di.heads *di.sptrack; // sectors per card
	
	dio_dbg("...\n");
	
	if(!Stat[pdrv].status)
	{
		
		dio_dbg(" Model: %s\n",di.modelnum);
		dio_dbg("   Cylinders      : %u\n",di.cylinders);
		dio_dbg("   Cylinders (CL) : %u\n",di.ccylinder);
		dio_dbg("   Heads          : %u\n",di.heads);
		dio_dbg("   Heads (CL)     : %u\n",di.cheads);
		dio_dbg("   Sectors/Card   : %lu\n",di.spcard);
		dio_dbg("   Sectors (CL)   : %lu\n",di.ccinsect);
		dio_dbg("   LBA-Sectors    : %lu\n",di.lbasec);
		dio_dbg("   Tracks         : %u\n",di.csptrack);
		dio_dbg("   Sec/Track      : %u\n",di.sptrack);
		dio_dbg("   Sec/Track (CL) : %u\n",di.csptrack);
		dio_dbg("   Bytes/Track    : %u\n",di.bptrack);
		dio_dbg("   Bytes/Sector   : %u\n",di.bpsec);
		dio_dbg("   Capabilities   : 0x%0X\n",di.cap);

		dio_lldbgwait("KEY...\n");	
		
	} else Stat[pdrv].status = STA_NODISK;
	
	
//	nkc_write(" ...exit disk_initialize\n");
	return Stat[pdrv].status;
}


/*-----------------------------------------------------------------------*/
/* Get Disk Status                                                       */
/*-----------------------------------------------------------------------*/

DSTATUS disk_status (
	BYTE pdrv		/* Physical drive nmuber (0..) */
)
{
	DSTATUS stat;
/*	
	int result;
	struct _driveinfo *pinfo;

	pinfo = idetest(pdrv); 
	stat = 0;
	return stat;
*/	
	stat = Stat[pdrv].status;

	return stat;
}






/*-----------------------------------------------------------------------*/
/* Read Partial Sector                                                   */
/*-----------------------------------------------------------------------*/

DRESULT disk_readp (
	BYTE* dest,			/* Pointer to the destination object */
	DWORD sector,		/* Sector number (LBA) */
	WORD sofs,			/* Offset in the sector 0..511 */
	WORD count			/* Byte count (bit15:destination) sofs+cound <= 512 ! */
)
{
	DRESULT res;	

	// Put your code here
	
	UCHAR *src;
	
//	nkc_write(" disk_readp: calling idedisk...result = ");
//  d0  = idedisk( d1,       d2, d3,d4,a0)
	res = _ide(CMD_READ,sector,1,1,Buffer);	
//	nkc_write_hex8(res); nkc_write("\n");
	
//	res = 0;
	
	src = Buffer + sofs;
	
	if(dest){
//		nkc_write(" copy to destination buffer ...\n");
		memcpy(dest,src,count);
	}	

	return res;
}



/*-----------------------------------------------------------------------*/
/* Write Partial Sector                                                  */
/*-----------------------------------------------------------------------*/

DRESULT disk_writep (
	const BYTE* buff,		/* Pointer to the data to be written, NULL:Initiate/Finalize write operation */
	DWORD sc		/* Sector number (LBA) or Number of bytes to send */
)	
{
	DRESULT res;


	dio_dbg(" disk_writep:\n");
	
	if (!buff) {
		if (sc) {

			// I) Initiate write process
			// buff = NULL && sc > 0: initialize a 512 byte write buffer (memset NULL) sa == Sector Number, offset in buffer = 0	
			dio_lldbgwait(" I) initializing\n");		
			stat.dwsector = sc;	
			stat.dwofs = 0;
			memset(Buffer, 0, sizeof(Buffer));
			res = RES_OK;

		} else {

			// III) Finalize write process
			// buff = NULL && sc =	 0: write buffer to disk at Sector given in I
			dio_lldbgwait(" III) finalizing\n");	
			
			res = _ide(CMD_WRITE,stat.dwsector,1,1,Buffer);
			
			stat.dwsector = 0;
			res = RES_OK;
		}
	} else {

		// II) Send data to the disk(buffer)
		// i.e. send data to the buffer: sc = number of bytes -> increase buffer offset pointer by sc up to 511		
		dio_lldbgwait(" II) storing write data in Buffer\n");	
		if (stat.dwofs + sc > BUFSIZE){
			 dio_dbg("       Buffer ptr > 512 !\n");
			 sc = BUFSIZE - stat.dwofs;
		}
		memcpy(&Buffer[stat.dwofs], buff, sc);
		stat.dwofs += sc;
		res = RES_OK;

	}

	dio_lldbgwait("Key...");
	return res;
}


/*-----------------------------------------------------------------------*/
/* Read Sector(s)                                                        */
/*-----------------------------------------------------------------------*/

DRESULT disk_read (
	BYTE pdrv,		/* Physical drive nmuber (0..) */
	BYTE *buff,		/* Data buffer to store read data */
	DWORD sector,	/* Sector address (LBA) */
	UINT count		/* Number of sectors to read (1..128) */
)
{
	DRESULT res;
	int result;

	dio_dbg(" disk_read:\n   drive %d, buffer at 0x%08lx, sector %d, count %d\n", pdrv,buff,sector,count);
	    
	dio_lldbgwait("Key...");

	result = _ide(CMD_READ,sector,count,pdrv+1,buff);	
	
	dio_dbg(" (%d)\n", result);
	dio_lldbgwait("Key...");
	
	res = RES_OK;
	
	return result;
	
	//return RES_PARERR;
}



/*-----------------------------------------------------------------------*/
/* Write Sector(s)                                                       */
/*-----------------------------------------------------------------------*/


DRESULT disk_write (
	BYTE pdrv,			/* Physical drive nmuber (0..) */
	const BYTE *buff,	/* Data to be written */
	DWORD sector,		/* Sector address (LBA) */
	UINT count			/* Number of sectors to write (1..128) */
)
{
	DRESULT res;
	int result;


	dio_dbg(" disk_write:\n   drive %d, buffer at 0x%08lx, sector %d, count %d\n", pdrv,buff,sector,count);
	    
	dio_lldbgwait("Key...");
	
	result = _ide(CMD_WRITE,sector,count,pdrv+1,buff);
	
	dio_dbg(" (%d)\n", result);
	dio_lldbgwait("Key...");
	
	res = RES_OK;
	
	return result;
//	return RES_PARERR;
}


/*-----------------------------------------------------------------------*/
/* Miscellaneous Functions                                               */
/*-----------------------------------------------------------------------*/

DRESULT disk_ioctl (
	BYTE pdrv,		/* Physical drive nmuber (0) */
	BYTE ctrl,		/* Control code */
	void *buff		/* Buffer to send/receive data block */
)
{
	DRESULT res = RES_PARERR;


	if (Stat[pdrv].status & STA_NOINIT)
		return RES_NOTRDY;

	switch (ctrl) {
	case CTRL_SYNC:
		res = RES_OK;
		break;

	case GET_SECTOR_COUNT: // return available sectors on the device
		*(DWORD*)buff = Stat[pdrv].n_sectors;
		res = RES_OK;
		break;

	case GET_SECTOR_SIZE: // return sector size in bytes
		*(WORD*)buff = Stat[pdrv].sz_sector;
		res = RES_OK;
		break;

	/* ******************************* */
	
	case GET_BLOCK_SIZE: // return erase block size of flash memory in units of sectors
		*(DWORD*)buff = 128;
		res = RES_OK;
		break;
	
	case CTRL_ERASE_SECTOR:
		res = RES_OK;
		break;	

	}

	return res;
}



