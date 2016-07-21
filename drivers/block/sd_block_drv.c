 /****************************************************************************
 * drivers/sd_block_drv.c
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
// 
// Gruppe14: Harddisk
// TRAP Nr. Befehlsname Eingabe-Register Ausgabe-Register Zerstörte Reg.
// 141 HARDDISK d1.b/d4.b/(d2/d3/a0.l)d0.l/Carry KEINE
// 142 HARDTEST d4.b d0.l/Carry KEINE
// 152 SETS2I d0.b d0 KEINE
// 153 GETS2I KEINE d0.b KEINE
// 154 IDETEST d4.b d0.l/a0.l/Carry KEINE
// 155 IDEDISK d1.b/d4.b/(d2/d3/a0.l) d0.l/Carry KEINE
 
 
/****************************************************************************
 * Included Files
 ****************************************************************************/
#include <debug.h>
#include <errno.h>
#include <drivers.h>
#include <ioctl.h>
#include <sd.h>
#include "sd_block_drv.h"
#include "sdS.h"

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


/****************************************************************************
 * Private Function Prototypes
 ****************************************************************************/

/****************************************************************************
 * Private Data
 ****************************************************************************/
/*-----------------------------------------------------------------------*/
/* Low level disk I/O module skeleton for Petit FatFs (C)ChaN, 2009      */
/*-----------------------------------------------------------------------*/


static volatile STAT Stat[MAX_DRIVES]; /* first drive is 0, GP starts at 1 ! */
static BYTE Buffer[BUFSIZE];
static volatile _BUFSTAT stat;

/*-----------------------------------------------------------------------*/

static const struct block_operations sd_bops =
{
  sd_open,     /* open     */
  sd_close,    /* close    */
  sd_read,     /* read     */
  sd_write,    /* write    */
  sd_geometry, /* geometry */
  sd_ioctl     /* ioctl    */
};

/****************************************************************************
 * Private Functions
 ****************************************************************************/



/*-----------------------------------------------------------------------*/
/* Initialize Disk Drive                                                 */
/*-----------------------------------------------------------------------*/
static void init_ff(void)
{
	memset(Stat,STA_NOINIT,sizeof(STAT)*MAX_DRIVES); /* set all drives to STA_NOINIT */
	memset(Buffer,0,BUFSIZE);						 /* reset buffer */
}

static DSTATUS disk_initialize (BYTE pdrv)				/* Physical drive number (0..) */
{
	DSTATUS stat;
	UINT result = RES_OK;
	struct _deviceinfo di;
	struct _driveinfo *pdi;
	
	drvsd_dbg("sd disk_initialize (%d)...\n",pdrv);
	
	
	//result = idetifySD(pdrv+1, &di);	// direct
	pdi = sdtest(pdrv+1); 			// call GP
	//result = sdtest(pdrv+1,&pdi);			// Variant 2: result is 0 or -1, so variant 1 suffices

	switch(result){ 
	  default:
	    if(pdi){ // if pointer to _driveinfo is valid -> stat = OK
	      stat = STA_OK;
	    }
	}
		
	Stat[pdrv].status = stat;	
	Stat[pdrv].sz_sector = 512;
	
	if(pdi == NULL) {
	  drvsd_lldbgwait("error: no device ...\n");
	  return STA_NODISK;
	}
	
	//Stat[pdrv].n_sectors = di.cylinders * di.heads *di.sptrack; // sectors per card
	Stat[pdrv].n_sectors = pdi->numsec;
	
	drvgide_dbg("...\n");
	
//	if(!Stat[pdrv].status)
//	{
//		drvsd_dbg(" Model: %s\n",di.modelnum);
//		drvsd_dbg("   Cylinders      : %u\n",di.cylinders);
//		drvsd_dbg("   Cylinders (CL) : %u\n",di.ccylinder);
//		drvsd_dbg("   Heads          : %u\n",di.heads);
//		drvsd_dbg("   Heads (CL)     : %u\n",di.cheads);
//		drvsd_dbg("   Sectors/Card   : %lu\n",di.spcard);
//		drvsd_dbg("   Sectors (CL)   : %lu\n",di.ccinsect);
//		drvsd_dbg("   LBA-Sectors    : %lu\n",di.lbasec);
//		drvsd_dbg("   Tracks         : %u\n",di.csptrack);
//		drvsd_dbg("   Sec/Track      : %u\n",di.sptrack);
//		drvsd_dbg("   Sec/Track (CL) : %u\n",di.csptrack);
//		drvsd_dbg("   Bytes/Track    : %u\n",di.bptrack);
//		drvsd_dbg("   Bytes/Sector   : %u\n",di.bpsec);
//		drvsd_dbg("   Capabilities   : 0x%0X\n",di.cap);
//
//		drvsd_lldbgwait("KEY...\n");	
//		
//	} else Stat[pdrv].status = STA_NODISK;
	
	
	drvsd_dbg(" Model: %s\n",pdi->idename);
	drvsd_dbg("   Cylinders      : %u\n",pdi->numcyl);
	drvsd_dbg("   Heads          : %u\n",pdi->numhead);
	drvsd_dbg("   Sectors/Card   : %lu\n",pdi->numsec);
	drvsd_dbg("   NKC-Mode       : 0x%0X\n",pdi->nkcmode);
	
        drvsd_lldbgwait("KEY...\n");	

	return Stat[pdrv].status;
}


/****************************************************************************
 * Misc Helpers
 ****************************************************************************/

/****************************************************************************
 * Block Driver Methods
 ****************************************************************************/
/****************************************************************************
 * Name: sd_open
 *
 * Description: Open the block device
 *
 ****************************************************************************/

//struct _driveinfo			//		(32)
//{
//	USHORT	numcyl;			// +0  	(2)
//	BYTE	numhead;		// +2	(1)
//	BYTE	numsec;			// +3	(1)
//	ULONG	nkcmode;		// +4	(4)
//	char    idename[24];	// +8	(24)
//	};
////}__attribute__ ((packed));

static UINT sd_open(struct _dev *devp)
{
  struct _driveinfo* pdi;
  BYTE disk;  
  DSTATUS stat = STA_OK;
  
  drvsd_lldbg("sd_open\n");
   
  if(devp == NULL) return EINVAL;    
  disk = devp->pdrv+1;
  //disk = 1; // currently there is only one disk
    
  //struct _driveinfo *sdtest(BYTE disk)
  
  pdi = sdtest(disk);
  
  if(pdi == NULL) return ENODEV;
  
  Stat[devp->pdrv].status = stat;	
  Stat[devp->pdrv].sz_sector = 512;
  Stat[devp->pdrv].n_sectors = pdi->numsec;
    
  drvsd_dbg(" Model: %s\n",pdi->idename);
  drvsd_dbg("   Cylinders      : %u\n",pdi->numcyl);
  drvsd_dbg("   Heads          : %u\n",pdi->numhead);
  drvsd_dbg("   Sectors/Card   : %lu\n",pdi->numsec);
  drvsd_dbg("   NKC-Mode       : 0x%0X\n",pdi->nkcmode);

  drvsd_lldbgwait("KEY...\n");	
  
  
}

/****************************************************************************
 * Name: sd_close
 *
 * Description: close the block device
 *
 ****************************************************************************/

static UINT sd_close(struct _dev *devp)
{
  drvsd_lldbg("sd_close\n");
}

/****************************************************************************
 * Name: sd_read
 *
 * Description:
 *   Read the specified numer of sectors from the read-ahead buffer or from
 *   the physical device.
 *
 ****************************************************************************/

static UINT sd_read(struct _dev *devp, char *buffer, UINT start_sector, UINT num_sectors)
{

  DRESULT res;
  BYTE disk; 
  
  drvsd_lldbg("sd_read\n");
  
  if(devp == NULL) return EINVAL;
  disk = devp->pdrv+1;
  //disk = 1; // currently there is only one disk
     
  res = sddisk(CMD_READ,start_sector,num_sectors,disk,buffer);	
  
  return res;
  
}

/****************************************************************************
 * Name: sd_write
 *
 * Description:
 *   Write the specified number of sectors to the write buffer or to the
 *   physical device.
 *
 ****************************************************************************/

static UINT sd_write(struct _dev *devp, char *buffer, UINT start_sector, UINT num_sectors)
{
  DRESULT res;
  BYTE disk;
  
  if(devp == NULL) return EINVAL;
  if(buffer == NULL) return EINVAL;
  
  disk = devp->pdrv+1;
  //disk = 1; // currently there is only one disk
  
  drvsd_lldbg("sd_write\n");
  
  res = sddisk(CMD_WRITE,start_sector,num_sectors,disk,buffer);	
  
  return res;
}


/****************************************************************************
 * Name: sd_geometry
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

//struct _driveinfo			//		(32)
//{
//	USHORT	numcyl;			// +0  	(2)
//	BYTE	numhead;		// +2	(1)
//	BYTE	numsec;			// +3	(1)
//	ULONG	nkcmode;		// +4	(4)
//	char    idename[24];	// +8	(24)
//	};
////}__attribute__ ((packed));
	
static UINT sd_geometry(struct _dev *devp, struct geometry *geometry)
{
  unsigned int stat; //STA_NODISK
  struct _driveinfo* pdi;
  BYTE disk;  
  
  drvsd_lldbg("sd_geometry\n");
   
  //if(devp == NULL) return EINVAL;
  if(geometry == NULL) return EINVAL; // return 'Invalid argument'
  
  //disk = devp->drv;
  disk = 1; // currently there is only one disk
    
  //struct _driveinfo *sdtest(BYTE disk)
  
  pdi = sdtest(disk);
  
  if(pdi == NULL) return ENODEV;
 
  geometry->geo_available = TRUE;
  geometry->geo_mediachanged = FALSE;
  geometry->geo_writeenabled = TRUE;
  geometry->geo_nsectors = pdi->numcyl * pdi->numhead *pdi->numsec; // sectors per card
  geometry->geo_sectorsize = 512; // usually 512 Bytes per Sector
}

/****************************************************************************
 * Name: sd_ioctl
 *
 * Description: Return device geometry
 *
 ****************************************************************************/

static UINT sd_ioctl(struct _dev *devp, UINT cmd, unsigned long arg)
{
  BYTE disk; 
  DSTATUS stat;
  DRESULT res = RES_PARERR;
  UINT result;
  
  drvsd_dbg("sd_block_drv.c|hd_ioctl (cmd=%d)\n",cmd);
  
  if(devp == NULL) {
    drvsd_lldbg(" error: no physical device given\n");
    return RES_PARERR;  
  }
  disk = devp->pdrv;
  
  if (cmd != FS_IOCTL_DISK_INIT && Stat[disk].status & STA_NOINIT) {
    drvsd_lldbg(" error: device not ready\n");
    return RES_NOTRDY;
  }
  
   switch(cmd) {
    
    // handle calls from fs.c
    
    case FS_IOCTL_DISK_READ:
      drvsd_lldbg(" ->FS_IOCTL_DISK_READ\n");
      // static UINT sd_read(struct _dev *devp, char *buffer, UINT start_sector, UINT num_sectors)
      // low level disk read
      // args: struct _dev *devp<=phydrv, int cmd<=FS_IOCTL_DISK_READ, unsigned long arg <=pointer to struct ioctl_disk_rw   
      if(arg == NULL) return RES_PARERR;      
      res = sd_read(devp, ((struct ioctl_disk_rw*)arg)->buff, ((struct ioctl_disk_rw*)arg)->sector, ((struct ioctl_disk_rw*)arg)->count);
      break;
    case FS_IOCTL_DISK_WRITE:
      drvsd_lldbg(" ->FS_IOCTL_DISK_WRITE\n");
      // static UINT sd_write(struct _dev *devp, char *buffer, UINT start_sector, UINT num_sectors)
      // low level disk write
      // args: struct _dev *devp<=phydrv, int cmd<=FS_IOCTL_DISK_WRITE, unsigned long arg <=pointer to struct ioctl_disk_rw
      if(arg == NULL) return RES_PARERR;      
      res = sd_write(devp, ((struct ioctl_disk_rw*)arg)->buff, ((struct ioctl_disk_rw*)arg)->sector, ((struct ioctl_disk_rw*)arg)->count);
      break;
    case FS_IOCTL_MKPTABLE: // is (or should) currently handled in ff.c by f_fdisk(); but clearly it should be handled here because the partition table is independent of the filesystem
      drvsd_lldbg(" ->FS_IOCTL_MKPTABLE\n");
      // write disk partition table
      // args: struct _dev *devp<=phydrv, int cmd<=FS_IOCTL_MKPTABLE, unsigned long arg <=pointer to struct ioctl_mkptable
      res = RES_PARERR;
      break;
    
    // handles calls from FAT FS module .... ( ff.c )
    case CTRL_SYNC:
        drvsd_lldbg(" ->CTRL_SYNC\n"); 
	// no need to call anything....
	res = RES_OK;
	break;

    case FS_IOCTL_DISK_GET_SECTOR_COUNT:
    case GET_SECTOR_COUNT: // return available sectors on the device
        drvsd_lldbg(" ->FS_IOCTL_DISK_GET_SECTOR_COUNT\n");
	*(DWORD*)arg = Stat[devp->pdrv].n_sectors;
	res = RES_OK;
	break;

    case FS_IOCTL_DISK_GET_SECTOR_SIZE:
    case GET_SECTOR_SIZE: // return sector size in bytes
        drvsd_lldbg(" ->FS_IOCTL_DISK_GET_SECTOR_SIZE\n");
	*(WORD*)arg = Stat[devp->pdrv].sz_sector;
	res = RES_OK;
	break;
	
    case GET_BLOCK_SIZE: // return erase block size of flash memory in units of sectors
        drvsd_lldbg(" ->GET_BLOCK_SIZE\n");
	*(DWORD*)arg = 128;
	res = RES_OK;
	break;
	
    case CTRL_ERASE_SECTOR:
        drvsd_lldbg(" ->CTRL_ERASE_SECTOR\n");
	// FIXME
	res = RES_OK;
	break;
	
    case FS_IOCTL_GET_DISK_DRIVE_STATUS:  
      drvsd_lldbg(" ->FS_IOCTL_GET_DISK_DRIVE_STATUS\n");
      // args: struct _dev *devp<=phydrv, int cmd<=FS_IOCTL_GET_DISK_DRIVE_STATUS, unsigned long arg <=pointer to struct _deviceinfo            
  
      //result = idetifySD(devp->pdrv+1, (struct _deviceinfo *)arg );      
      result = Stat[devp->pdrv+1].status;
      
      switch(result){ 
          case STA_NODISK:
	    res = RES_NOTRDY;
	    break;
	  case STA_OK:
	    res = RES_OK;
	    break;
	  default:
	     res = RES_OK;
      }

      break;
    case GET_DISK_STATUS:
        drvsd_lldbg(" ->GET_DISK_STATUS\n");
	*(DSTATUS*)arg = Stat[devp->pdrv].status;
	res = RES_OK;
	break;
		
    case FS_IOCTL_DISK_INIT: 
      // args: struct _dev *devp<=phydrv, int cmd<=FS_IOCTL_DISK_INIT, unsigned long arg <=NULL
    case CTRL_DISK_INIT:
        drvsd_lldbg(" sd_block_drv: ->FS_IOCTL_DISK_INIT\n");
	
	switch( disk_initialize (devp->pdrv) ){ 
	  case STA_NODISK:
	    res = RES_NOTRDY;
	    break;
	  case STA_OK:
	    res = RES_OK;
	    break;
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

int sd_initialize()
{
  drvsd_lldbg("sd_initialize\n");
  
  init_ff();
  
  disk_initialize (0);
  
  register_blk_driver("SD",  &sd_bops);
}
  