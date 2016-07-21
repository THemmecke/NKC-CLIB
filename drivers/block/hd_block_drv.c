    /****************************************************************************
 * drivers/xx_block_drv.c
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
 * AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
 * ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *
 ****************************************************************************/

/****************************************************************************
 * Included Files
 ****************************************************************************/
#include <debug.h>
#include <errno.h>
#include <gide.h>
#include <drivers.h>
#include <ioctl.h>
#include "hd_block_drv.h"

/****************************************************************************
 * Pre-processor Definitions
 ****************************************************************************/

/****************************************************************************
 * Private Types
 ****************************************************************************/

/*-----------------------------------------------------------------------*/
/* Low level disk I/O module skeleton for Petit FatFs (C)ChaN, 2009      */
/*-----------------------------------------------------------------------*/


#define MAX_DRIVES	10	/* Max number of physical drives to be used */
#define BUFSIZE 512

typedef struct {
	DSTATUS	status;		/* drive status */
	WORD sz_sector;		/* sectorsize */
	DWORD n_sectors;	/* number of sectors over all */
} STAT;




typedef struct {	
	DWORD dwsector;	/* sector that is in the buffer 			 */
	DWORD dwofs;	/* current read/write pointer in the bufffer */ 
} _BUFSTAT;


/*-----------------------------------------------------------------------*/

/****************************************************************************
 * Private Function Prototypes
 ****************************************************************************/

/****************************************************************************
 * Private Data
 ****************************************************************************/
/*-----------------------------------------------------------------------*/
/* Low level disk I/O module skeleton for Petit FatFs (C)ChaN, 2009      */
/*-----------------------------------------------------------------------*/

// LBA = C x usNumHeads x usNumSecs + H x Num_Sec + (S - 1) 
//USHORT usNumHeads;
//USHORT usNumSecs;

static volatile STAT Stat[MAX_DRIVES]; /* first drive is 0, GP starts at 1 ! */
static BYTE Buffer[BUFSIZE];
static volatile _BUFSTAT stat;

/*-----------------------------------------------------------------------*/

static const struct block_operations hd_bops =
{
  hd_open,     /* open     */
  hd_close,    /* close    */
  hd_read,     /* read     */
  hd_write,    /* write    */
  hd_geometry, /* geometry */
  hd_ioctl     /* ioctl    */
};

/****************************************************************************
 * Private Functions
 ****************************************************************************/


DRESULT IDEError2DRESULT(int result)
{
  DRESULT res = RES_OK;
  
  if(!result) {
    drvgide_lldbg(" no error \n");    
  }
  if(result & 1) {     
    /* Indicates that an address mark was not
     * found. What this means I not sure of. I have never seen this happen.
     */ 
    drvgide_lldbg(" [0] AMNF bit \n");
  }
  if(result & 2) {     
    /* When this bit is set the drive was not able to find track 0 of the device. 
     * I think you will have to throw away the disk if this happens.
     */             
    drvgide_lldbg(" [1] TK0NF bit \n");
    res = RES_ERROR;
  }
  if(result & 4) { 
    /* This bit is set when you have given an indecent command to the disk. 
     * Mostly wrong parameters (wrong head number etc..) cause the disk to 
     * respond with error flag in the status bit set and the ABRT bit set. 
     * I have gotten this error a lot when I tried to run the disk with interrupts. 
     * Something MUST have been wrong with my interface program. 
     * I have not (yet) found what.
     */ 
    drvgide_lldbg(" [2] ABRT bit \n");
    res = RES_ERROR;
  }
  if(result & 8) { 
    /* indicated that a media change was requested.
     * What that means I do not know. I've ignored this bit till now.
     */ 
    drvgide_lldbg(" [3] MCR bit \n");
  }
  if(result & 16) { 
    /* Means that a sector ID was not found. 
     * I have never seen this happen, I guess it means that you've
     * requested a sector that is not there.
     */ 
    drvgide_lldbg(" [4] IDNF bit \n");
    res = RES_ERROR;
  }
  if(result & 32) { 
    /* Indicates that the media has been changed. 
     * I ignore this bit.
     */ 
    drvgide_lldbg(" [5] MC bit \n");
  }
  if(result & 64) { 
    /* Indicates that an uncorrectable data error happened. 
     * Some read or write errors could provoke this. 
     * I have never seen it happen.
     */ 
    drvgide_lldbg(" [6] UNC bit \n");
  }
  if(result & 128) { 
    /* reserved */
    drvgide_lldbg(" [7] RESERVED bit \n");
  }
  
  return res;
  
}

/*-----------------------------------------------------------------------*/
/* Initialize Disk Drive                                                 */
/*-----------------------------------------------------------------------*/
static void init_ff(void)
{
	memset(Stat,STA_NOINIT,sizeof(STAT)*MAX_DRIVES); /* set all drives to STA_NOINIT */
	memset(Buffer,0,BUFSIZE);						 /* reset buffer */
}


/*
 Disk Status Bits (DSTATUS) 

 #define STA_OK			0x00
 #define STA_NOINIT		0x01	 Drive not initialized 
 #define STA_NODISK		0x02	 No medium in the drive 
 #define STA_PROTECT		0x04	 Write protected 
 
*/ 

static DSTATUS disk_initialize (BYTE pdrv)				/* Physical drive number (0..) */
{
	DSTATUS stat = STA_OK;
	UINT result;
	struct _deviceinfo di;
	
	drvgide_dbg("disk_initialize (%d)...\n",pdrv);
	
	result = idetifyIDE(pdrv+1, &di);  // call IDE direct

	/* decode result of $EC .... */
	if(!result) {
	  drvgide_lldbg(" no error \n");    
	}
	if(result & 1) {     
	 /* Indicates that an address mark was not
	  * found. What this means I not sure of. I have never seen this happen.
	  */ 
	  drvgide_lldbg(" [0] AMNF bit \n");
	}
	if(result & 2) {     
	 /* When this bit is set the drive was not able to find track 0 of the device. 
	  * I think you will have to throw away the disk if this happens.
	  */             
	  drvgide_lldbg(" [1] TK0NF bit \n");
	  stat = STA_NOINIT;
	}
	if(result & 4) { 
	 /* This bit is set when you have given an indecent command to the disk. 
	  * Mostly wrong parameters (wrong head number etc..) cause the disk to 
	  * respond with error flag in the status bit set and the ABRT bit set. 
	  * I have gotten this error a lot when I tried to run the disk with interrupts. 
	  * Something MUST have been wrong with my interface program. 
	  * I have not (yet) found what.
	  */ 
	  drvgide_lldbg(" [2] ABRT bit \n");
	  stat = STA_NOINIT;
	}
	if(result & 8) { 
	  /* indicated that a media change was requested.
	  * What that means I do not know. I've ignored this bit till now.
	  */ 
	  drvgide_lldbg(" [3] MCR bit \n");
	}
	if(result & 16) { 
	  /* Means that a sector ID was not found. 
	  * I have never seen this happen, I guess it means that you've
	  * requested a sector that is not there.
	  */ 
	  drvgide_lldbg(" [4] IDNF bit \n");
	  stat = STA_NOINIT;
	}
	if(result & 32) { 
	  /* Indicates that the media has been changed. 
	  * I ignore this bit.
	  */ 
	  drvgide_lldbg(" [5] MC bit \n");
	}
	if(result & 64) { 
	  /* Indicates that an uncorrectable data error happened. 
	  * Some read or write errors could provoke this. 
	  * I have never seen it happen.
	  */ 
	  drvgide_lldbg(" [6] UNC bit \n");
	}
	if(result & 128) { 
	  /* reserved */
	  drvgide_lldbg(" [7] RESERVED bit \n");
	}
	
	/* ------- */
	Stat[pdrv].status = stat;	
	Stat[pdrv].sz_sector = 512;
	
	
	Stat[pdrv].n_sectors = di.cylinders * di.heads *di.sptrack; // sectors per card
	
	drvgide_dbg("...\n");
	
	if(!Stat[pdrv].status)
	{
		drvgide_dbg(" Model: %s\n",di.modelnum);
		drvgide_dbg("   Cylinders      : %u\n",di.cylinders);
		drvgide_dbg("   Cylinders (CL) : %u\n",di.ccylinder);
		drvgide_dbg("   Heads          : %u\n",di.heads);
		drvgide_dbg("   Heads (CL)     : %u\n",di.cheads);
		drvgide_dbg("   Sectors/Card   : %lu\n",di.spcard);
		drvgide_dbg("   Sectors (CL)   : %lu\n",di.ccinsect);
		drvgide_dbg("   LBA-Sectors    : %lu\n",di.lbasec);
		drvgide_dbg("   Tracks         : %u\n",di.csptrack);
		drvgide_dbg("   Sec/Track      : %u\n",di.sptrack);
		drvgide_dbg("   Sec/Track (CL) : %u\n",di.csptrack);
		drvgide_dbg("   Bytes/Track    : %u\n",di.bptrack);
		drvgide_dbg("   Bytes/Sector   : %u\n",di.bpsec);
		drvgide_dbg("   Capabilities   : 0x%0X\n",di.cap);

		drvgide_lldbgwait("KEY...\n");	
		
	} else Stat[pdrv].status = STA_NODISK;
	

	return Stat[pdrv].status;
}


/*-----------------------------------------------------------------------*/
/* Miscellaneous Functions                                               */
/*-----------------------------------------------------------------------*/



/****************************************************************************
 * Misc Helpers
 ****************************************************************************/

/****************************************************************************
 * Block Driver Methods (no GP used)
 ****************************************************************************/
/****************************************************************************
 * Name: xx_open
 *
 * Description: Open the block device
 *
 ****************************************************************************/

static DSTATUS hd_open(struct _dev *devp)
{  
  drvgide_lldbg("hd_open\n");
  return disk_initialize(devp->pdrv);    
}

/****************************************************************************
 * Name: xx_close
 *
 * Description: close the block device
 *
 ****************************************************************************/

static DRESULT hd_close(struct _dev *devp)
{
  BYTE disk;
  DRESULT res;
  UINT result;
  
  drvgide_lldbg("hd_close\n");

  if(devp == NULL) return EINVAL;
  disk = devp->pdrv;
	
  return IDEError2DRESULT(result);
}

/****************************************************************************
 * Name: xx_read
 *
 * Description:
 *   Read the specified numer of sectors from the read-ahead buffer or from
 *   the physical device.
 *
 ****************************************************************************/

static DRESULT hd_read(struct _dev *devp, char *buffer, DWORD start_sector, DWORD num_sectors)
{
  DRESULT res;
  UINT result;
  BYTE disk; 
  
  if(devp == NULL) {
    drvgide_lldbgwait("hd_block_drv.c|hd_read: devp == NULL .... (KEY)\n");
    return EINVAL;
  }
  
  disk = devp->pdrv;
  
  drvgide_dbg("hd_block_drv.c|hd_read: disk %d, sector 0x%x , %d sectors --> buffer 0x%x\n",disk,start_sector, num_sectors, buffer);
  
  
  result = _ide(CMD_READ,start_sector,num_sectors,disk+1,buffer);  /* direct PIO mode reading, 1st disk == 1 */
                                                                   /* idedisk routine uses GP and here 1st disk is 0 (Master) and second is 1 (Slave) */
  
  drvgide_dbg(" _ide ->result= %d\n",result);
  
  switch(result){
    /*  0: success
     * -1: RDY timeout 
     * -2: DRQ timeouot
     * -3: BUSY timeout
     * 
     *  -100: unknown command 
     */
    case 0: 
      res = RES_OK;
      break;
    case -1:
    case -2:
    case -3:
      res = RES_NOTRDY;
      break;
    case -100:
      res = RES_PARERR;
      break;
    
    default:
      res = RES_PARERR;
  }
  
  return res;
  
}

/****************************************************************************
 * Name: xx_write
 *
 * Description:
 *   Write the specified number of sectors to the write buffer or to the
 *   physical device.
 *
 ****************************************************************************/

static DRESULT hd_write(struct _dev *devp, char *buffer, DWORD start_sector, DWORD num_sectors)
{
  DRESULT res;
  UINT result;
  BYTE disk;
  
  if(buffer == NULL){
    drvgide_lldbgwait("hd_block_drv.c|hd_write: buffer == NULL .... (KEY)\n");
    return EINVAL;
  }
  
   if(devp == NULL) {
    drvgide_lldbgwait("hd_block_drv.c|hd_write: devp == NULL .... (KEY)\n");
    return EINVAL;
  }
  
  disk = devp->pdrv;
  
  drvgide_dbg("hd_block_drv.c|hd_write: buffer 0x%x --> disk %d, sector 0x%x , %d sectors\n",buffer,disk,start_sector, num_sectors);
  
  result = _ide(CMD_WRITE,start_sector,num_sectors,disk+1,buffer);  /* direct PIO mode writing, 1st disk == 1 */
								   /* idedisk routine uses GP and here 1st disk is 0 (Master) and second is 1 (Slave) */
  
  drvgide_dbg(" _ide ->result= %d\n",result);
  
  switch(result){
    /*  0: success
     * -1: RDY timeout 
     * -2: DRQ timeouot
     * -3: BUSY timeout
     * 
     *  -100: unknown command 
     */
    case 0: 
      res = RES_OK;
      break;
    case -1:
    case -2:
    case -3:
      res = RES_NOTRDY;
      break;
    case -100:
      res = RES_PARERR;
      break;
    
      default:
	    res = RES_PARERR;
  }
  
  return res;
}


/****************************************************************************
 * Name: xx_geometry
 *
 * Description: Return device geometry
 *
 ****************************************************************************/

//struct geometry
//{
//  BOOL   geo_available;    /* true: The device is vailable */
//  BOOL   geo_mediachanged; /* true: The media has changed since last query */
//  BOOL   geo_writeenabled; /* true: It is okay to write to this device */
//  UINT   geo_nsectors;     /* Number of sectors on the device */
//  UINT   geo_sectorsize;   /* Size of one sector */
//};

static DRESULT hd_geometry(struct _dev *devp, struct geometry *geometry)
{
  UINT result;
  struct _deviceinfo di;
  BYTE disk;  
  
  drvgide_lldbg("hd_block_drv.c|hd_geometry ...\n");
   
  if(geometry == NULL) return EINVAL; // return 'Invalid argument'
  
  disk = devp->pdrv+1;
  
  result = idetifyIDE(disk, &di); // direct call, no GP
 
  geometry->geo_available = TRUE;
  geometry->geo_mediachanged = FALSE;
  geometry->geo_writeenabled = TRUE;
  geometry->geo_nsectors = di.cylinders * di.heads *di.sptrack; // sectors per card
  geometry->geo_sectorsize = di.bpsec; // usually 512 Bytes per Sector  
  
  return IDEError2DRESULT(result);
  
}

/****************************************************************************
 * Name: xx_ioctl
 *
 * Description: device ioctl
 *
 ****************************************************************************/


//RESULT disk_ioctl (
//	BYTE pdrv,		/* Physical drive nmuber (0) */
//	BYTE ctrl,		/* Control code */
//	void *buff		/* Buffer to send/receive data block */
//	
static DRESULT hd_ioctl(struct _dev *devp, int cmd, unsigned long arg)
{
  BYTE disk; 
  DSTATUS stat;
  DRESULT res = RES_PARERR;
  UINT result;
  
  drvgide_dbg("hd_block_drv.c|hd_ioctl (cmd=%d)\n",cmd);
  
  if(devp == NULL) {
    drvgide_lldbg(" error: no physical device given\n");
    return RES_PARERR;  
  }
  disk = devp->pdrv;
  
  if (Stat[disk].status & STA_NOINIT) {
    drvgide_lldbg(" error: device not ready\n");
    return RES_NOTRDY;
  }
  
  
  //   struct ioctl_disk_rw {
  //     char *drv;			/* pointer to physical drive name (HDA,HDB,SDA,SDB ....) */
  //     unsigned char *buff;	/* Data buffer to store read data to / retreive data to be writte from */
  //     unsigned int sector;	/* Sector address (LBA) */
  //     unsigned int count;		/* Number of sectors to read (1..128) */
  // };
  
  switch(cmd) {
    
    // handle calls from fs.c
    
    case FS_IOCTL_DISK_READ:
      drvgide_lldbg(" ->FS_IOCTL_DISK_READ\n");
      // static UINT hd_read(struct _dev *devp, char *buffer, UINT start_sector, UINT num_sectors)
      // low level disk read
      // args: struct _dev *devp<=phydrv, int cmd<=FS_IOCTL_DISK_READ, unsigned long arg <=pointer to struct ioctl_disk_rw   
      if(arg == NULL) return RES_PARERR;      
      res = hd_read(devp, ((struct ioctl_disk_rw*)arg)->buff, ((struct ioctl_disk_rw*)arg)->sector, ((struct ioctl_disk_rw*)arg)->count);
      break;
    case FS_IOCTL_DISK_WRITE:
      drvgide_lldbg(" ->FS_IOCTL_DISK_WRITE\n");
      // static UINT hd_write(struct _dev *devp, char *buffer, UINT start_sector, UINT num_sectors)
      // low level disk write
      // args: struct _dev *devp<=phydrv, int cmd<=FS_IOCTL_DISK_WRITE, unsigned long arg <=pointer to struct ioctl_disk_rw
      if(arg == NULL) return RES_PARERR;      
      res = hd_write(devp, ((struct ioctl_disk_rw*)arg)->buff, ((struct ioctl_disk_rw*)arg)->sector, ((struct ioctl_disk_rw*)arg)->count);
      break;
    case FS_IOCTL_MKPTABLE: // is (or should) currently handled in ff.c by f_fdisk(); but clearly it should be handled here because the partition table is independent of the filesystem
      drvgide_lldbg(" ->FS_IOCTL_MKPTABLE\n");
      // write disk partition table
      // args: struct _dev *devp<=phydrv, int cmd<=FS_IOCTL_MKPTABLE, unsigned long arg <=pointer to struct ioctl_mkptable
      res = RES_PARERR;
      break;
    
    // handles calls from FAT FS module .... ( ff.c )
    case CTRL_SYNC:
        drvgide_lldbg(" ->CTRL_SYNC\n"); 
	// no need to call anything....
	res = RES_OK;
	break;

    case FS_IOCTL_DISK_GET_SECTOR_COUNT:
    case GET_SECTOR_COUNT: // return available sectors on the device
        drvgide_lldbg(" ->FS_IOCTL_DISK_GET_SECTOR_COUNT\n");
	*(DWORD*)arg = Stat[devp->pdrv].n_sectors;
	res = RES_OK;
	break;

    case FS_IOCTL_DISK_GET_SECTOR_SIZE:
    case GET_SECTOR_SIZE: // return sector size in bytes
        drvgide_lldbg(" ->FS_IOCTL_DISK_GET_SECTOR_SIZE\n");
	*(WORD*)arg = Stat[devp->pdrv].sz_sector;
	res = RES_OK;
	break;
	
    case GET_BLOCK_SIZE: // return erase block size of flash memory in units of sectors
        drvgide_lldbg(" ->GET_BLOCK_SIZE\n");
	*(DWORD*)arg = 128;
	res = RES_OK;
	break;
	
    case CTRL_ERASE_SECTOR:
        drvgide_lldbg(" ->CTRL_ERASE_SECTOR\n");
	// FIXME
	res = RES_OK;
	break;
	
    case FS_IOCTL_GET_DISK_DRIVE_STATUS:  
      drvgide_lldbg(" ->FS_IOCTL_GET_DISK_DRIVE_STATUS\n");
      // args: struct _dev *devp<=phydrv, int cmd<=FS_IOCTL_GET_DISK_DRIVE_STATUS, unsigned long arg <=pointer to struct _deviceinfo            
  
      result = idetifyIDE(devp->pdrv+1, (struct _deviceinfo *)arg );
      
      switch(result){ // FIXME
      default:
	    res = RES_OK;
      }

      break;
    case GET_DISK_STATUS:
        drvgide_lldbg(" ->GET_DISK_STATUS\n");
	*(DSTATUS*)arg = Stat[devp->pdrv].status;
	res = RES_OK;
	break;
		
    case FS_IOCTL_DISK_INIT: 
      // args: struct _dev *devp<=phydrv, int cmd<=FS_IOCTL_DISK_INIT, unsigned long arg <=NULL
    case CTRL_DISK_INIT:
        drvgide_lldbg(" ->FS_IOCTL_DISK_INIT\n");
	
	switch( disk_initialize (devp->pdrv) ){ // DSTATUS FIXME
	  default:
	     res = RES_OK;
	}
	break;
    
  }
  
  return res;
  
}



/****************************************************************************
 * Initialization/uninitialization/reset
 ****************************************************************************/

DSTATUS hd_initialize()
{
  DSTATUS res;
  
  drvgide_lldbg("hd_initialize\n");
  
  init_ff();      // initialize diskio system
  res = disk_initialize(0); // initialize GIDE, there is only one GIDE drive yet
  
  register_blk_driver("HD",  &hd_bops);
  
  return res;
}
  