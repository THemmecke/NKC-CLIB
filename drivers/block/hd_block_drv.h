#ifndef __HD_BLOCK_DRV_H
#define __HD_BLOCK_DRV_H

#include <types.h> 
#include <drivers.h>


/*---------------------------------------*/
/* Prototypes for disk control functions */

extern int idetifyIDE(BYTE disk, struct hd_driveid *p);

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


/* GIDE commands (_IDEDISK) */

#define _IDEDISK_CMD_READ	1
#define _IDEDISK_CMD_WRITE 	2
#define _IDEDISK_CMD_TEST_UNIT_READY 8
#define _IDEDISK_CMD_READ_CAPACITY 22
#define _IDEDISK_CMD_INQUIRY 24



/* Idetify Device Information: (cmd = $EC) (256 bytes) */
struct hd_driveid {
        unsigned short  config;         /* 0: lots of obsolete bit flags */
        unsigned short  cyls;           /* 1: "physical" cyls */
        unsigned short  reserved2;      /* 2: reserved (word 2) */
        unsigned short  heads;          /* 3: "physical" heads */
        unsigned short  track_bytes;    /* 4: unformatted bytes per track */
        unsigned short  sector_bytes;   /* 5: unformatted bytes per sector */
        unsigned short  sectors;        /* 6: "physical" sectors per track */
        unsigned short  vendor0;        /* 7-8: vendor unique (numbers of sectors per card, word 7 = MSW, word 8 = LSW) */
        unsigned short  vendor1;        /* vendor unique */
        unsigned short  vendor2;        /* 9: vendor unique */
        unsigned char   serial_no[20];  /* 10-19: 0 = not_specified */
        unsigned short  buf_type;       /* 20: buffer type: */
        unsigned short  buf_size;       /* 21: 512 byte increments; 0 = not_specified */
        unsigned short  ecc_bytes;      /* 22: for r/w long cmds; 0 = not_specified */
        unsigned char   fw_rev[8];      /* 23-26: 0 = not_specified, firmware revision in ASCII. Big edndian byte order. */
        unsigned char   model[40];      /* 27-46: 0 = not_specified, model number in ASCII - left justified - big endian  */
        unsigned short   max_multsect;   /* 47: 0=not_implemented. max number of sectors in Read/Write multiple command */
        unsigned char   vendor3;        /*  vendor unique */
        unsigned char   dword_io;       /* 48: 0=not_implemented; 1=implemented */
        unsigned char   vendor4;        /* vendor unique */
        unsigned char   capability;     /* 49: bits 0:DMA 1:LBA 2:IORDYsw 3:IORDYsup*/
        unsigned short  reserved50;     /* 50: reserved (word 50) */
        unsigned char   vendor5;        /* vendor unique */
        unsigned char   tPIO;           /* 51: 0=slow, 1=medium, 2=fast */
        unsigned char   vendor6;        /* vendor unique */
        unsigned char   tDMA;           /* 52: 0=slow, 1=medium, 2=fast */
        unsigned short  field_valid;    /* 53: bits 0:cur_ok 1:eide_ok */
        unsigned short  cur_cyls;       /* 54: logical cylinders */
        unsigned short  cur_heads;      /* 55: logical heads */
        unsigned short  cur_sectors;    /* 56: logical sectors per track */
        unsigned short  cur_capacity0;  /* 57-58: logical total sectors on drive */
        unsigned short  cur_capacity1;  /*  (2 words, misaligned int)     */
        unsigned char   multsect;       /* 59: current multiple sector count */
        unsigned char   multsect_valid; /* when (bit0==1) multsect is ok */
        unsigned int    lba_capacity;   /* 60-61: total number of sectors */
        unsigned short  dma_1word;      /* 62: single-word dma info */
        unsigned short  dma_mword;      /* 63: multiple-word dma info */
        unsigned short  eide_pio_modes; /* 64: bits 0:mode3 1:mode4 */
        unsigned short  eide_dma_min;   /* 65: min mword dma cycle time (ns) */
        unsigned short  eide_dma_time;  /* 66: recommended mword dma cycle time (ns) */
        unsigned short  eide_pio;       /* 67: min cycle time (ns), no IORDY  */
        unsigned short  eide_pio_iordy; /* 68: min cycle time (ns), with IORDY */
        unsigned short  word69;
        unsigned short  word70;
        /* HDIO_GET_IDENTITY currently returns only words 0 through 70 */
        unsigned short  word71;
        unsigned short  word72;
        unsigned short  word73;
        unsigned short  word74;
        unsigned short  word75;
        unsigned short  word76;
        unsigned short  word77;
        unsigned short  word78;
        unsigned short  word79;
        unsigned short  word80;
        unsigned short  word81;
        unsigned short  command_sets;   /* bits 0:Smart 1:Security 2:Removable 3:PM */
        unsigned short  word83;         /* bits 14:Smart Enabled 13:0 zero */
        unsigned short  word84;
        unsigned short  word85;
        unsigned short  word86;
        unsigned short  word87;
        unsigned short  dma_ultra;
        unsigned short  word89;         /* reserved (word 89) */
        unsigned short  word90;         /* reserved (word 90) */
        unsigned short  word91;         /* reserved (word 91) */
        unsigned short  word92;         /* reserved (word 92) */
        unsigned short  word93;         /* reserved (word 93) */
        unsigned short  word94;         /* reserved (word 94) */
        unsigned short  word95;         /* reserved (word 95) */
        unsigned short  word96;         /* reserved (word 96) */
        unsigned short  word97;         /* reserved (word 97) */
        unsigned short  word98;         /* reserved (word 98) */
        unsigned short  word99;         /* reserved (word 99) */
        unsigned short  word100;        /* reserved (word 100) */
        unsigned short  word101;        /* reserved (word 101) */
        unsigned short  word102;        /* reserved (word 102) */
        unsigned short  word103;        /* reserved (word 103) */
        unsigned short  word104;        /* reserved (word 104) */
        unsigned short  word105;        /* reserved (word 105) */
        unsigned short  word106;        /* reserved (word 106) */
        unsigned short  word107;        /* reserved (word 107) */
        unsigned short  word108;        /* reserved (word 108) */
        unsigned short  word109;        /* reserved (word 109) */
        unsigned short  word110;        /* reserved (word 110) */
        unsigned short  word111;        /* reserved (word 111) */
        unsigned short  word112;        /* reserved (word 112) */
        unsigned short  word113;        /* reserved (word 113) */
        unsigned short  word114;        /* reserved (word 114) */
        unsigned short  word115;        /* reserved (word 115) */
        unsigned short  word116;        /* reserved (word 116) */
        unsigned short  word117;        /* reserved (word 117) */
        unsigned short  word118;        /* reserved (word 118) */
        unsigned short  word119;        /* reserved (word 119) */
        unsigned short  word120;        /* reserved (word 120) */
        unsigned short  word121;        /* reserved (word 121) */
        unsigned short  word122;        /* reserved (word 122) */
        unsigned short  word123;        /* reserved (word 123) */
        unsigned short  word124;        /* reserved (word 124) */
        unsigned short  word125;        /* reserved (word 125) */
        unsigned short  word126;        /* reserved (word 126) */
        unsigned short  word127;        /* reserved (word 127) */
        unsigned short  security;       /* bits 0:suuport 1:enabled 2:locked 3:frozen */
        unsigned short  reserved[127];
};
//}__attribute__ ((packed)); 


                                                                                                 

#endif