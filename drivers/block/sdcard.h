#ifndef __SDCARD_H
#define __SDCARD_H

#include <types.h>
#include <drivers.h>  // struct _deviceinfo

#ifdef M68000
#define		spibase	(*(volatile u8 *)  0xfffffff00) 
#define		spictrl (*(volatile u8 *)  0xfffffff00) 
#define		spidata (*(volatile u8 *)  0xfffffff01) 
#endif

#ifdef M68020 
#define		spibase	(*(volatile u8 *)  0xffffffc00) 
#define   spictrl (*(volatile u8 *)  0xffffffc00) 
#define		spidata (*(volatile u8 *)  0xffffffc04) 
#endif

/*  CS der ersten Hardware SD (Bit 5 im spictrl register) */
#define		SPIH0_CS 5
/*  CS der zweiten Hardware SD (Bit 6 im spictrl register) */
#define		SPIH1_CS 6  


//extern unsigned char spi_ctrl_reg;

/* Assert the CS signal, active low (CS=0) SPIH0_CS or SPIH1_CS */

#define spi_cs_assert(which) \
	spi_ctrl_reg |= ((which+1) << SPIH0_CS); \
  spictrl = spi_ctrl_reg;
	
/* Deassert the CS signal (CS=1)  */
#define spi_cs_deassert() \
	spi_ctrl_reg &= 0x9F; \
  spictrl = spi_ctrl_reg;
	
  
 /* Send a single byte over the SPI port */
#define spi_send_byte(input,timeout) \
  _spi_send_byte(input,timeout);

 /* Receive a byte. Output an 0xFF (the bus idles high) to receive the byte */
#define spi_rcv_byte() \
  _spi_rcv_byte()

/* Disable the SPI module. */
#define spi_disable() \
	spi_ctrl_reg &= 0x7F; \
	spictrl = spi_ctrl_reg;

#define spi_enable() \
	spi_ctrl_reg |= 0x80; \
	spictrl = spi_ctrl_reg;




struct _sddriveinfo			//		  (24) (structure in GP)
{
	ULONG	  size;			    // +0  (4)  size in sectors LBAs
	USHORT	bpb;			    // +4	 (2)  bytes per block/sector (512/1024)
	USHORT	type;			    // +6	 (2)  0=SD, 1=SDHC, 2=MMC	
	char    sdname[17];	  // +8	(17) 16 chars zero terminated ('SD-CARD', 'MMC-Card' or 'SDHC-Card')
  //----- extensions to GP
  // adds from struct geometry:
  BOOL   available;    /* true: The device is vailable */
  BOOL   mediachanged; /* true: The media has changed since last query */
  BOOL   writeenabled; /* true: It is okay to write to this device */
  UINT   cylinders;
  UINT   heads;
  UINT   sptrack;
  //UINT   nsectors;     /* Number of sectors on the device -> size */
  //UINT   sectorsize;   /* Size of one sector -> bpb */
  //USHORT type;         /* device type -> type */
  char  model[8];        /* model name -> cid_reg::OID + cid_reg::PNM*/
  // misc information ...
  DWORD serial;     //  -> cid_reg::PSN
};
//}__attribute__ ((packed));



/*
	SD-Card Register Definitions
	
	CSD - Card Specific Data
	CID - Card IDentification Register
	OCR - The 32-bit operation conditions register stores the VDD voltage profile of the card.
	RCA - 
	DSR - 

*/
struct csd_reg_v1_0
{
  BYTE   CSD_STRUCTURE:2; 	/* 0 = CSD Version 1.0: Version 1.01-1.10/Version 2.00/Standard Capacity 	*/
							/* 1 = CSD Version 2.0: Version 2.00-High Capacity							*/
							/* 2-3 reserved */
  BYTE   RESERVED1:6;    
  BYTE   TAAC;        /* Defines the asynchronous part of the data access time:
                         TAAC bit position    code
                          2:0                 time unit
                                              0=1ns, 1=10ns, 2=100ns, 3=1μs, 4=10μs,
                                              5=100μs, 6=1ms, 7=10ms
                          6:3                 time value
                                              0=reserved, 1=1.0, 2=1.2, 3=1.3, 4=1.5,
                                              5=2.0,
                                              6=2.5, 7=3.0, 8=3.5, 9=4.0, A=4.5, B=5.0,
                                              C=5.5, D=6.0, E=7.0, F=8.0
                          7                   reserved */
  BYTE   NSAC;        /* Defines the worst case for the clock-dependant factor of the data access time. The unit for NSAC is 100
                         clock cycles. Therefore, the maximal value for the clock-dependent part of the data access time is 25.5 k clock cycles.
                         The total access time NAC is the sum of TAAC and NSAC. It should be computed by the host for the
                         actual clock rate. The read access time should be interpreted as a typical delay for the first data bit of a
                         data block or stream. */
  BYTE	 TRAN_SPEED;   /* max. transfer speed peer one line: 
                          TRAN_SPEED bit        code
                          2:0                   transfer rate unit
                                                0=100kbit/s, 1=1Mbit/s, 2=10Mbit/s,
                                                3=100Mbit/s, 4... 7=reserved
                          6:3                   time value
                                                0=reserved, 1=1.0, 2=1.2, 3=1.3, 4=1.5,
                                                5=2.0, 6=2.5, 7=3.0, 8=3.5, 9=4.0, A=4.5,
                                                B=5.0, C=5.5, D=6.0, E=7.0, F=8.0
                            7                   reserved
                          Note that for current SD Memorz Cards, this field shall be alwazs 0?0110?010b )032h= which is equal to
                          25 MHy  the mandatorz maximum operating frequencz of SD Memorz Card.
                          In HighSpeed mode, this field shall be alwazs 0?1011?010b )05Ah= which is equal to 50 MHy, and
                          when the timing mode returns to the default bz CMD6 or CMD0 command, its value will be 032h. */  
  UINT   CCC:12;        /* card command class register == supported command classes */
  BYTE 	 READ_BL_LEN:4;				/* -> C_SIZE BlockLength = 2^READ_BL_LEN = BPB = max. read block length (512...2048 bytes) */
  BYTE   READ_BL_PARTIAL:1;   /* block length for partial block read operations, =1 for SD-Cards */
  BYTE   WRITE_BLK_MISALIGN:1; /* 0 signals that crossing physical block boundaries is invalid */
  BYTE   READ_BLK_MISALIGN:1; /* 0 signals that crossing physical block boundaries is invalid */
  BYTE   DSR_IMP:1;   /* 1=driver stage register (DSR) is implemented (chapter 5.5.) */
  BYTE 	 RESERVED2:2;
  UINT   C_SIZE:12;					/* used to compute the user’s data card capacity:				*/
  									       /* memory capacity = BLOCKNR * BLOCK_LEN						*/
  									       /*		BLOCKNR   = (C_SIZE+1) * MULT 							*/
  									       /*		MULT      = 2^(C_SIZE_MULT+2) {C_SIZE_MULT < 8}			*/
  									       /*		BLOCK_LEN = 2^(READ_BL_LEN)   {READ_BL_LEN < 12}		*/
                                    /* To indicate 2 GByte card, BLOCK_LEN shall be 1024 bytes.     */
                                    /* Therefore, the maximal capacity that can be coded is 4096*512*1024 = 2 G bytes. */
  								 	/* Example A 32 Mbyte card with BLOCK_LEN  512 can be coded by C_SIZE_MULT = 3 and C_SIZE = 2000. */  								 
  BYTE   VDD_R_CURR_MIN:3;    /* max. values for read currents at the minimal power supply VDD */
  BYTE   VDD_R_CURR_MAX:3;    /* max. values for read currents at the maximal power supply VDD */
  BYTE   VDD_W_CURR_MIN:3;    /* max. values for write currents at the minimal power supply VDD */
  BYTE   VDD_W_CURR_MAX:3;    /* max. values for write currents at the maximal power supply VDD */
  BYTE   C_SIZE_MULT:3;				/* -> C_SIZE: MULT = 2^(C_SIZE_MULT+2) */
  BYTE   ERASE_BLK_EN:1;      /* The ERASE_BLK_EN defines the granularity of the unit size of the data to be erased. The erase
                                 operation can erase either one or multiple units of 512 bytes or one or multiple units (or sectors) of
                                 SECTOR_SIZE */
  BYTE   SECTOR_SIZE:7;				/* The size of an erasable sector. The content of this register is a 7-bit binary coded value, defining the
                                 number of write blocks (see WRITE_BL_LEN). The actual size is computed by increasing this number
                                 by one. A value of zero means one write block, 127 means 128 write blocks. */
  BYTE   WP_GRP_SIZE:7;       /* The size of a write protected group. The content of this register is a 7-bit binary coded value, defining
                                the number of erase sectors (see SECTOR_SIZE). The actual size is computed by increasing this
                                number by one. A value of zero means one erase sector, 127 means 128 erase sectors */
  BYTE   WP_GRP_ENABLE:1;     /* 0 means no group write protection possible. */
  BYTE   RESERVED3:2;
  BYTE   R2W_FACTOR:3;        /* Defines the typical block program time as a multiple of the read access time. 
                                 The following table defines the field format:
                                   R2W_FACTOR   Multiples of read access time
                                   0             1
                                   1             2 (write half as fast as read)
                                   2             4
                                   3             8
                                   4            16
                                   5            32
                                   6,7          reserved
                               */    
  BYTE   WRITE_BL_LEN:4;      /* max. write block length = 2^WRITE_BL_LEN ==> 512 to 2048 bytes (512 bytes is always supported) 
                                 Note that in the SD Memory Card, the WRITE_BL_LEN is always equal to READ_BL_LEN */   
  BYTE   WRITE_BL_PARTIAL:1;  /* Defines whether partial block sizes can be used in block write commands.
                                 WRITE_BL_PARTIAL=0 means that only the WRITE_BL_LEN block size and its partial derivatives, in
                                 resolution of units of 512 bytes, can be used for block oriented data write.
                                 WRITE_BL_PARTIAL=1 means that smaller blocks can be used as well. The minimum block size is one byte. */
  BYTE   RESERVED4:5;
  BYTE   FILE_FORMAT_GRP:1;  /* 0= see FILE_FORMAT, 1=reserved */
  BYTE   COPY:1;             /* Defines if the contents is original (=0) or has been copied (=1). The COPY bit for OTP and MTP
                                devices, sold to end consumers, is set to 1, which identifies the card contents as a copy. The COPY bit
                                is a one time programmable bit. */
  BYTE   PERM_WRITE_PROTECT:1; /* Permanently protects the entire card content against overwriting or erasing (default=0) */
  BYTE   TEMP_WRITE_PROTECT:1; /* Temporarily protects the entire card content from being overwritten or erased. (default=0) */
  BYTE   FILE_FORMAT:2;     /*  0 = hard disk file system with partition table 
                                1 = DOS FAT (floppy like) with boot sector only (no partition table)
                                2 = Universal File Format
                                3 = Others unknown
                             */   
  BYTE   RESERVED5:2;
  BYTE   CRC:7;         /* The CRC field carries the check sum for the CSD contents. It is computed according to Chapter 4.5. 
                           The checksum has to be recalculated by the host for any CSD modification. The default corresponds to the initial CSD contents. */
  BYTE   RESERVED6:1;  	       
};

struct csd_reg_v2_0
{
  BYTE   CSD_STRUCTURE:2;		    /* 0 = SD-Card  : CSD Version 1.0: Version 1.01-1.10/Version 2.00/Standard Capacity 	*/
								                /* 1 = SDHC-Card: CSD Version 2.0: Version 2.00-High Capacity							*/
								                /* 2 = MMC-Card : ? */
								                /* 2-3 reserved */
  BYTE   RESERVED1:6;    
  BYTE   TAAC; 
  BYTE   NSAC; 
  BYTE	 TRAN_SPEED;
  UINT   CCC:12;
  BYTE 	 READ_BL_LEN:4;			    /* fixed: 9 ==> 512 bytes 	*/
  BYTE   READ_BL_PARTIAL:1;		  /* fixed: 0 ==> block read is inhibited and only unit of block access is allowed 	*/
  BYTE   WRITE_BLK_MISALIGN:1;	/* fixed: 0 ==> write access crossing physical block boundaries is always disabled in High Capacity SD Memory Card				*/
  BYTE   READ_BLK_MISALIGN:1;	  /* fixed: 0 ==> read access crossing physical block boundaries is always disabled in High Capacity SD Memory Card 				*/
  BYTE   DSR_IMP:1;
  BYTE 	 RESERVED2:6;
  DWORD  C_SIZE:22;				      /* This field is expanded to 22 bits and can indicate up to 2 TBytes						             */
  								              /* This parameter is used to calculate the user data area capacity in the SD memory Card  	 */
  								              /* memory capacity = (C_SIZE+1) * 512KByte												                           */
  								              /* As the maximum capacity of the Physical Layer Specification Version 2.00 is 32 GB, 		   */
  								              /* the upper 6 bits of this field shall be set to 0.										                     */
  BYTE 	 RESERVED3:1;
  BYTE   ERASE_BLK_EN:1;        /* fixed:   1 ==> the host can erase one or multiple units of 512 bytes */
  BYTE   SECTOR_SIZE:7;         /* fixed: 7Fh ==> 64 KBytes. This value does not relate to erase operation. */
                                /* Version 2.00 cards indicates memory boundary by AU size and this field should not be used. */
  BYTE   WP_GRP_SIZE:7;         /* fixed: 0, not used */
  BYTE   WP_GRP_ENABLE:1;       /* fixed: 0, not used */
  BYTE   RESERVED4:2;
  BYTE   R2W_FACTOR:3;          /* fixed : 2h ==> 4 multiples. Write timeout can be calculated by multiplying the read access time */
                                /* and R2W_FACTOR. However, the host should not use this factor and should use 250 ms for write timeout */
  BYTE   WRITE_BL_LEN:4;		    /* fixed: 9 ==> 512 bytes 	*/
  BYTE   WRITE_BL_PARTIAL:1;    /* fixed: 0 ==> partial block read is inhibited and only unit of block access is allowed */
  BYTE   RESERVED5:5;
  BYTE   FILE_FORMAT_GRP:1;     /* fixed: 0, not used */
  BYTE   COPY:1;
  BYTE   PERM_WRITE_PROTECT:1;
  BYTE   TEMP_WRITE_PROTECT:1;
  BYTE   FILE_FORMAT:2;         /* fixed: 0, not used */
  BYTE   RESERVED6:2;
  BYTE   CRC:7;
  BYTE   RESERVED7:1;  	       
};

union csd_reg {
	struct csd_reg_v1_0 v10;
	struct csd_reg_v2_0 v20;
};


struct cid_reg {
	BYTE	MID; 		/* Manufacturer ID 		8-bit binary number			*/
	CHAR	OID[2]; 	/* OEM/Application ID 	2-character ASCII string	*/
	CHAR 	PNM[5];		/* Product name			5-character ASCII string	*/
	BYTE	PRV;		/* “n.m” revision number (BCD)						*/
	DWORD	PSN;		/* Product serial number 							*/
	BYTE	RES1:4;
	WORD	MDT:12;		/* manufacturing date y.m “m” field [11:8] is the month code. 1 = January, “y” field [19:12] is the year code. 0 = 2000 */
	BYTE	CRC:7;		/* CRC7 checksum (7 bits). */
	BYTE	RES2:1;		/* not used, always 1 */
};

struct ocr_reg {
  BYTE PWR_STATUS:1;  // 1=READY, 0=PowerUp not finished
  BYTE CCS:1;         // valid if READY: 1=High Capacity SD Card, 0=Standard Capacity SD Card
  BYTE RES1:7;
  BYTE V35_36:1;
  BYTE V34_35:1;
  BYTE V33_34:1;
  BYTE V32_33:1;
  BYTE V31_32:1;
  BYTE V30_31:1;
  BYTE V29_30:1;
  BYTE V28_29:1;
  BYTE V27_28:1;
  BYTE RES2:7;
  BYTE RES_LOW:1;
  BYTE RES3:7;
};

struct r1_response {
   BYTE  START_BIT:1;           // bit 7
   BYTE  PARAMETER_ERROR:1;     // bit 6
   BYTE  ADDRESS_ERROR:1;       // bit 5
   BYTE  ERASE_SEQUENCE_ERROR:1;// bit 4
   BYTE  COM_CRC_ERROR:1;       // bit 3
   BYTE  ILLEGAL_COMMAND:1;     // bit 2
   BYTE  ERASE_RESET:1;         // bit 1
   BYTE  IDLE_STATE:1;          // bit 0
};

struct r3_ocr_response {
  union {                         // r1 response
    BYTE R1VAL;
    struct {
      BYTE  START_BIT:1;            // bit 7
      BYTE  PARAMETER_ERROR:1;      // bit 6
      BYTE  ADDRESS_ERROR:1;        // bit 5
      BYTE  ERASE_SEQUENCE_ERROR:1; // bit 4
      BYTE  COM_CRC_ERROR:1;        // bit 3
      BYTE  ILLEGAL_COMMAND:1;      // bit 2
      BYTE  ERASE_RESET:1;          // bit 1
      BYTE  IDLE_STATE:1;           // bit 0
    }__attribute__ ((packed));
  }__attribute__ ((packed));
  union{                        // OCR register
    DWORD OCR_REG;     //
    struct {
      BYTE PWR_STATUS:1;  // 1=READY, 0=PowerUp not finished
      BYTE CCS:1;         // valid if READY: 1=High Capacity SD Card, 0=Standard Capacity SD Card
      BYTE RES1:6;
      BYTE V35_36:1;
      BYTE V34_35:1;
      BYTE V33_34:1;
      BYTE V32_33:1;
      BYTE V31_32:1;
      BYTE V30_31:1;
      BYTE V29_30:1;
      BYTE V28_29:1;
      BYTE V27_28:1;
      BYTE RES2:7;
      BYTE RES_LOW:1;
      BYTE RES3:7;
    }__attribute__ ((packed)); 
  }__attribute__ ((packed));
  BYTE  RES2:7;      // 0b1111111 = 0x127
  BYTE  END_BIT:1;   // 1
}__attribute__ ((packed));

struct r6_rca_response {
  BYTE  START_BIT:1; // bit 7 // 0
  BYTE  TRANS_BIT:1; // bit 6 // 0
  BYTE  CMD_INDEX:6; // bit 5 // b000011 = 0x03
  WORD  NEW_RCA:16;  // bit 4 // new published RCA [31:16] of the card
  WORD  CARD_STAT:16;// bit 3 // card status bits: 23,22,19,12:0
  BYTE  CHECK_ECHO;  // bit 2 // echo back of check pattern
  BYTE  CRC:7;       // bit 1 // crc checksum
  BYTE  END_BIT:1;   // bit 0 // 1
};

struct r7_cic_response{    
  union {                           // r1 response
    BYTE R1VAL;
    struct {
      BYTE  START_BIT:1;            // bit 7
      BYTE  PARAMETER_ERROR:1;      // bit 6
      BYTE  ADDRESS_ERROR:1;        // bit 5
      BYTE  ERASE_SEQUENCE_ERROR:1; // bit 4
      BYTE  COM_CRC_ERROR:1;        // bit 3
      BYTE  ILLEGAL_COMMAND:1;      // bit 2
      BYTE  ERASE_RESET:1;          // bit 1
      BYTE  IDLE_STATE:1;           // bit 0
    };
  };                                // cic fields ...
  BYTE  CMD_VERSION:4;              
  WORD  RES1:16;
  BYTE  VOLTAGE_ACCEPTED:4;
  BYTE  ECHO_BACK;
}__attribute__ ((packed));

union crc_16 {
  union{
    WORD v;
    BYTE b[2];
  }__attribute__ ((packed));
}__attribute__ ((packed));



/* #################### */

#define SD_BLOCKSIZE 512
#define SD_BLOCKSIZE_NBITS 9



#define R1 1
#define R1B 2
#define R2 3
#define R3 5
#define R7 6
#define R_MAX 6
#define MSK_IDLE 0x01
#define MSK_ERASE_RST 0x02
#define MSK_ILL_CMD 0x04
#define MSK_CRC_ERR 0x08
#define MSK_ERASE_SEQ_ERR 0x10
#define MSK_ADDR_ERR 0x20
#define MSK_PARAM_ERR 0x40
#define MSK_DATA_RES 0x1F
#define DATA_RES_ACCEPTED 0x05
#define SD_TOK_READ_STARTBLOCK 0xFE
#define SD_TOK_WRITE_STARTBLOCK 0xFE
#define SD_TOK_READ_STARTBLOCK_M 0xFE
#define SD_TOK_WRITE_STARTBLOCK_M 0xFC
#define SD_TOK_STOP_MULTI 0xFD
/* Error token is 111XXXXX */
#define MSK_TOK_DATAERROR 0xE0
/* Bit fields */
#define MSK_TOK_ERROR 0x01
#define MSK_TOK_CC_ERROR 0x02
#define MSK_TOK_ECC_FAILED

#define MSK_TOK_CC_OUTOFRANGE 0x08
#define MSK_TOK_CC_LOCKED 0x10
/* Mask off the bits in the OCR corresponding to voltage range 3.2V to
* 3.4V, OCR bits 20 and 21 */
#define MSK_OCR_33 0xC0
/* Number of times to retry the probe cycle during initialization */
#define SD_INIT_TRY 50
/* Number of tries to wait for the card to go idle during initialization */
#define SD_IDLE_WAIT_MAX 100
/* Hardcoded timeout for commands. 8 words, or 64 clocks. Do 10
* words instead */
#define SD_CMD_TIMEOUT 100000
/******************************** Basic command set **************************/
/* Reset cards to idle state */
#define CMD0 0
#define CMD0_R R1

/* Read the OCR (MMC mode, do not use for SD cards) 
 Argument:
  [31]Reserved bit
  [30]HCS (0= host does not support HighCapacity Cards)
  [29:0]Reserved bits
*/
#define CMD1 1
#define CMD1_R R1

/* Sends SD Card interface condition that includes host supply voltage information and asks the
   accessed card whether card can operate in supplied voltage range. Reserved bits shall be set to '0'.
   Argument:
    [31:20]Reserved bits
    [19:16]supply voltage(VHS)
    [15:8]check pattern 
    [7:1] crc
    [0] end bit
*/
#define CMD8 8
#define CMD8_R R7

/* Card sends the CSD */
#define CMD9 9
#define CMD9_R R1
/* Card sends CID */
#define CMD10 10
#define CMD10_R R1
/* Stop a multiple block (stream) read/write operation */
#define CMD12 12
#define CMD12_R R1B
/* Get the addressed card's status register */
#define CMD13 13
#define CMD13_R R2
/***************************** Block read commands **************************/
/* Set the block length */
#define CMD16 16
#define CMD16_R R1
/* Read a single block (blocksize set by CMD16) */
#define CMD17 17
#define CMD17_R R1
/* Read multiple blocks until a CMD12 */
#define CMD18 18
#define CMD18_R R1
/***************************** Block write commands *************************/
/* Write a block of the size selected with CMD16 */
#define CMD24 24
#define CMD24_R R1
/* Multiple block write until a CMD12 */
#define CMD25 25
#define CMD25_R R1
/* Program the programmable bits of the CSD */
#define CMD27 27
#define CMD27_R R1
/***************************** Write protection *****************************/
/* Set the write protection bit of the addressed group */
#define CMD28 28
#define CMD28_R R1B
/* Clear the write protection bit of the addressed group */
#define CMD29 29
#define CMD29_R R1B
/* Ask the card for the status of the write protection bits */
#define CMD30 30
#define CMD30_R R1
/***************************** Erase commands *******************************/
/* Set the address of the first write block to be erased */
#define CMD32 32
#define CMD32_R R1
/* Set the address of the last write block to be erased */
#define CMD33 33
#define CMD33_R R1
/* Erase the selected write blocks */
#define CMD38 38
#define CMD38_R R1B
/***************************** Lock Card commands ***************************/
/* Commands from 42 to 54, not defined here */
/***************************** Application-specific commands ****************/
/* Flag that the next command is application-specific */
#define CMD55 55
#define CMD55_R R1
/* General purpose I/O for application-specific commands */
#define CMD56 56
#define CMD56_R R1
/* Read the OCR (SPI mode only) */
#define CMD58 58
#define CMD58_R R3
/* Turn CRC on or off */
#define CMD59 59
#define CMD59_R R1
/***************************** Application-specific commands ***************/
/* Get the SD card's status */
#define ACMD13 13
#define ACMD13_R R2
/* Get the number of written write blocks (Minus errors ) */
#define ACMD22 22
#define ACMD22_R R1
/* Set the number of write blocks to be pre-erased before writing */
#define ACMD23 23
#define ACMD23_R R1
/* Get the card's OCR (SD mode) */
#define ACMD41 41
#define ACMD41_R R1
/* Connect or disconnect the 50kOhm internal pull-up on CD/DAT[3] */
#define ACMD42 42
#define ACMD42_R R1
/* Get the SD configuration register */
#define ACMD51 42
#define ACMD51_R R1



DRESULT __idetifySD(BYTE disk, struct _deviceinfo *p);
DRESULT __sd(USHORT cmd,ULONG arg1,ULONG arg2,BYTE disk,void* pdata);

BOOL sd_wait_notbusy (BYTE disk, unsigned int timeout);
DRESULT sd_write_stop(BYTE disk);
DRESULT sd_read_stop(BYTE disk);

/* C routines (-> sdcard.c) */
struct _sddriveinfo *sd_init(BYTE disk);
DRESULT sd_info(BYTE disk, struct _sddriveinfo *pdi); 

/* User functions */
DSTATUS sd_card_present();
DSTATUS sd_init0(BYTE disk);
DSTATUS sd_read_block (BYTE disk, DWORD blockaddr, unsigned char *data);
DSTATUS sd_read_nblock (BYTE disk, DWORD blockaddr, DWORD numblocks, unsigned char *data);
DSTATUS sd_write_block (BYTE disk, DWORD blockaddr, unsigned char *data);
DSTATUS sd_write_nblock (BYTE disk, DWORD blockaddr, DWORD numblocks, unsigned char *data);
DSTATUS sd_write_mblock (BYTE disk, DWORD blockaddr, DWORD numblocks, unsigned char *data);

DSTATUS sd_rd_csd(BYTE disk, union csd_reg *pcsd);
DSTATUS sd_rd_cid(BYTE disk, struct cid_reg *pcid);
/* Internal functions, used for SD card communications. */
DSTATUS sd_set_blocklen (BYTE disk, DWORD length);
DSTATUS sd_send_command(BYTE disk, unsigned char cmd, unsigned char response_type, unsigned char *response, DWORD argument);
void sd_delay(char number);
/* asm functions */
DRESULT _sd_rdblk(BYTE disk, char *pcmd, unsigned int size, void* buffer);  
DRESULT _sd_init(BYTE disk);
DRESULT _sd_info(BYTE disk, struct _sddriveinfo *pdi);
/* SPI interface functions */

/* asm routines (-> sd.S) */
DRESULT _spi_cs_assert(unsigned char which, unsigned char ctrlreg);
DRESULT _spi_cs_deassert(unsigned char ctrlreg);
int _spi_send_byte(unsigned char input, unsigned int timeout);



#endif