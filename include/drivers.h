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
  USHORT type;	       /* device type */
  char*  model;	       /* model name */
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

struct c_operations
{
  UINT     (*open)(char *pdevice);
  UINT     (*close)(void *phandle);
  UINT     (*read)(void *phandle, UINT address, UINT data);
  UINT     (*write)(void *phandle, UINT address);
  UINT     (*ioctl)(void *phandle, int cmd, unsigned long arg);
};


struct blk_driver
{
	char	                       *pdrive;	  /* name of drive, i.e. A, B... ,HD, SD... */
	struct block_operations 		 *blk_oper;	/* block operations */
	struct blk_driver			       *next;		  /* pointer to next driver in driverlist */
};

struct char_driver
{
  char                          *pdrive;  /* name of device, i.e. RTC etc. */
  struct c_operations           *c_oper;  /* char operations */
  struct char_driver            *next;    /* pointer to next driver in driverlist */
};

/*
* Idetify Device Information: (cmd = $EC)
idedata:
genconf:        ds.w 1          * $848a default
cylinders:      ds.w 1          * number of cylinders
res1:           ds.w 1          * reserverd
heads:          ds.w 1          * number of heads
bptrack:        ds.w 1          * number of unformatted bytes per track
bpsec:          ds.w 1          * number of unformatted bytes per sector
sptrack:        ds.w 1          * number of sectors per track
spcard:         ds.w 2          * number of sectors per card (msw,lsw)
res2:           ds.w 1
serial:         ds.b 20         * serial number in ASCII
btype:          ds.w 1          * buffer type (dual port)
bsize:          ds.w 1          * buffer size in 512 byte increments
eccbytes:       ds.w 1          * number of ECC bytes
fwrev:          ds.b 8          * firmware revision in ASCII
modelnum:       ds.b 40         * model number in ASCII
maxsec:         ds.w 1          * max sectors rd/wr on multiple cmd
dwunsup:        ds.w 1          * dword not supported
cap:            ds.w 1          * capabilities: DMA(8), LBA(9)
res3:           ds.w 1
piomode:        ds.w 1          * PIO data transfer cycle timing mode
swdmact:        ds.w 1          * single DMA data trans cycle timing mode
fvalid:         ds.w 1          * field validity
ccylinder:      ds.w 1          * current number of cylinders
cheads:         ds.w 1          * current number of heads
csptrack:       ds.w 1          * current sectors per track
ccinsect:       ds.w 2          * current capacity in sectors (LBAs)
mssvalid:       ds.w 1          * multiple sector setting is valid
lbasec:         ds.w 2          * num of sects in LBA mode
swdma:          ds.w 1          * single word dma transfer
mwdma:          ds.w 1          * multi word dma transfer
advpio:         ds.w 1          * advanced PIO modes supported
mmwdmact:       ds.w 1          * min multi word dma transfer cycle time
rmwdmact:       ds.w 1          * recommended mword dma trans cycle time
minpio:         ds.w 1          * min PIO transfer without flow control
minpiordy:      ds.w 1          * min PIO trans with IORDY flow control
res4:           ds.b 20
ataver1:        ds.w 1          * major ATA version
ataver2:        ds.w 1          * minor ATA version
featsup:        ds.w 3          * features/commands supported
featena:        ds.w 3          * features/commands enabled
udmamode:       ds.w 1          * ultra DMA mode supported and selected
secerat:      ds.w 1          * time for security erase-unit completion
secerate:     ds.w 1          * time for enhanced sec erase
pwrmgmtval:     ds.w 1          * current advanced power mgmt value
res5:           ds.b 72
res6:           ds.b 64
pwrreq:         ds.w 1          * power requirement description
res7:           ds.w 1
keymgmt:        ds.w 1          * key mgmt schemes supported
tidetim:        ds.w 1          * adv. true IDE timing mode cap./setting
pcmciatim:      ds.w 1          * PCMCIA I/O and Mem timing mode capability
res8:           ds.b 22
res9:           ds.b 140
*/

struct _deviceinfo
/* Idetify Device Information: (cmd = $EC) */
{             // WORD 
  USHORT  genconf;        // 0    0x848a default
  USHORT  cylinders;      // 1    number of logical cylinders
  USHORT  res1;           // 2    reserverd
  USHORT  heads;          // 3    number of logical heads
  USHORT  bptrack;        // 4    number of unformatted bytes per track (obsolete)
  USHORT  bpsec;          // 5    number of unformatted bytes per sector (obsolete)
  USHORT  sptrack;        // 6    number of logical sectors per logical track
  ULONG spcard;         // 7-8    number of sectors per card (msw,lsw) (vendor specific)
  USHORT  _spcard;        // 9    (vendor specific)
  char    serial[20];     // 10-19  serial number in 20 ASCII characters
  USHORT  btype;          // 20   buffer type (dual port) (obsolet)
  USHORT  bsize;          // 21   buffer size in 512 byte increments (obsolet)
  USHORT  eccbytes;       // 22   number of ECC bytes
  char    fwrev[8];       // 23-26  firmware revision in ASCII (8 characters)
  char  modelnum[40];   // 27-46  model number in ASCII (40 characters)
  USHORT  maxsec;         // 47     max sectors rd/wr on multiple cmd
  USHORT  dwunsup;        // 48   dword not supported (reserved)
  USHORT  cap;            // 49   capabilities: DMA(8), LBA(9)
  USHORT  res2;     // 50   reserved
  USHORT  piomode;        // 51   PIO data transfer cycle timing mode
  USHORT  swdmact;        // 52   single DMA data trans cycle timing mode
  USHORT  fvalid;         // 53   field validity
  USHORT  ccylinder;      // 54   number of current logical cylinders
  USHORT  cheads;         // 55   number of current logical heads
  USHORT  csptrack;       // 56     number of current logical sectors per track
  ULONG   ccinsect;       // 57-58  current capacity in sectors (LBAs)
  USHORT  mssvalid;       // 59   multiple sector setting is valid
  ULONG   lbasec;         // 60-61  num of sects in LBA mode
  USHORT  swdma;          // 62   single word dma transfer (obsolet)
  USHORT  mwdma;          // 63     multi word dma transfer
  USHORT  advpio;         // 64   advanced PIO modes supported
  USHORT  mmwdmact;       // 65   min multi word dma transfer cycle time
  USHORT  rmwdmact;       // 66   recommended mword dma trans cycle time
  USHORT  minpio;         // 67   min PIO transfer without flow control
  USHORT  minpiordy;      // 68   min PIO trans with IORDY flow control
  USHORT  res3[11];       // 69-79  reserved
  USHORT  ataver1;        // 80   major ATA version
  USHORT  ataver2;        // 81   minor ATA version
  USHORT  featsup1;       // 82   features/commands supported
  USHORT  featsup2;   // 83
  USHORT  res4[44];   // 84-127 reserved
  USHORT  featena1;       // 128    Security status
  USHORT  res5[31];   // 129-159  vendor specific
  USHORT  res6[96];   // 160-255  reserved
  };
//}__attribute__ ((packed));  


struct blk_driver* get_blk_driver(char *name);
struct char_driver* get_char_driver(char *name);

int xx_initialize(void);

int register_blk_driver(char *pdrive, const struct block_operations  *blk_oper);
int un_register_blk_driver(char *pdrive);

int register_char_driver(char *pdrive, const struct c_operations  *c_oper);
int un_register_char_driver(char *pdrive);


#endif