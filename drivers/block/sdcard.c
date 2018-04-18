#include <debug.h>
#include <types.h>
#include <errno.h>

static unsigned char spi_ctrl_reg;

#include "sdcard.h"
#include "crc.h"

static unsigned char response[R_MAX];
static struct _sddriveinfo drive[2];


/* ############################### spi interface functions ############################### */

// --> sdcard-h

/* insline assembler constraints
https://gcc.gnu.org/onlinedocs/gcc/Constraints.html#Constraints

Motorola 680x0—config/m68k/constraints.md

    a 		Address register
    d 		Data register
    f 		68881 floating-point register, if available
	I 		Integer in the range 1 to 8
    J 		16-bit signed number
    K 		Signed number whose magnitude is greater than 0x80
    L 		Integer in the range -8 to -1
    M 		Signed number whose magnitude is greater than 0x100
    N 		Range 24 to 31, rotatert:SI 8 to 1 expressed as rotate
    O 		16 (for rotate using swap)
    P 		Range 8 to 15, rotatert:HI 8 to 1 expressed as rotate
    R 		Numbers that mov3q can handle
    G 		Floating point constant that is not a 68881 constant
    S 		Operands that satisfy ’m’ when -mpcrel is in effect
    T 		Operands that satisfy ’s’ when -mpcrel is not in effect
    Q 		Address register indirect addressing mode
    U 		Register offset addressing
    W 		const_call_operand
    Cs 		symbol_ref or const
    Ci 		const_int
    C0 		const_int 0
    Cj		Range of signed numbers that don’t fit in 16 bits
	Cmvq	Integers valid for mvq
    Capsw	Integers valid for a moveq followed by a swap
    Cmvz	Integers valid for mvz
    Cmvs  	Integers valid for mvs
    Ap  	push_operand
    Ac      Non-register operands allowed in clr

    p,g ->  use as address register

*/

//int __spi_send_byte(BYTE input, unisgned int timeout){
//
// __asm__  volatile(
//    "move.b %0,%%d1"     		/* input -> d1 	*/      							"\n\t"  \
//    "move   %%sr,-(%%sp)"     	/* save sr -- Note: sr is only 16bits wide !! */    "\n\t"  \
//    "ori   #0x700,%%sr"     	/* disable interrupts */      						"\n\t"  \
//"m1: btst.b #0,%1"     			/* spi ready ? */      								"\n\t"  \
//    "beq m1"     				/* FIXME: possible infinite loop */      			"\n\t"  \
//    "move.b %%d1,%2"     		/* data out */ 										"\n\t"  \
//    "move (%%sp)+,%%sr"        /* restore status register */     					"\n\t"  \
//    :                /* outputs */    \
//    : "g"(input),"n"(spictrl),"g"(spidata) /* inputs */    \
//    : "%d1"    /* clobbered regs */ \
//    );
//}

/* ############################### sd card functions ############################### */

/* This function synchronously waits until any pending block transfers
are finished. 
*/
BOOL sd_wait_notbusy (BYTE disk, unsigned int timeout)
{
	unsigned int i;
	BYTE response;

	drvsd_dbg("  sd_wait_notbusy:");

	i=0;
	do
	{
		response = spi_rcv_byte();
		drvsd_dbg(" %02X",response);
		i++;
	}	
	while ((response != 0xFF) && i < timeout);

	if(i == timeout){ 
		drvsd_dbg("\n  sd_wait_notbusy timeout ...\n");
		return FALSE;
	}

	drvsd_dbg("\n  sd_wait_notbusy i=%d (timeout = %d)...\n",i,timeout);
	return TRUE;
}


/* terminate write operation */
DRESULT sd_write_stop(BYTE disk) {
  if(!sd_wait_notbusy(disk,SD_CMD_TIMEOUT) ){
		drvsd_dbg("  sd_write_stop: wait not busy timeout(1)\n");
		spi_cs_deassert();
  		spi_send_byte(0xFF,SD_CMD_TIMEOUT);
		return STA_TIMEOUT;
  }
  spi_send_byte(SD_TOK_STOP_MULTI,SD_CMD_TIMEOUT);
  spi_cs_deassert();
  spi_send_byte(0xFF,SD_CMD_TIMEOUT);
  return STA_OK;
}

/* terminate read operation */
DRESULT sd_read_stop(BYTE disk) {
  if (sd_send_command(disk, CMD12, CMD12_R, response, 0x00) != STA_OK) {
		drvsd_dbg("  sd_read_stop: CMD12 error\n");
		spi_cs_deassert();
		spi_send_byte(0xFF,SD_CMD_TIMEOUT);
		return STA_COM_ERROR;
  }	
  spi_cs_deassert();
  spi_send_byte(0xFF,SD_CMD_TIMEOUT);
  return STA_OK;
}


DSTATUS sd_card_present()
{
	return STA_OK; // not used, assume card is present
}

/* This function initializes the SD card. It returns 1 if
initialization was successful, 0 otherwise.
*/
DSTATUS sd_init0(BYTE disk)
{
	char i, j;
	union csd_reg csd;
    struct cid_reg cid;
	char *pstr;	

	/* SPI SD initialization sequence:
	
	* simplified physical layer specification 7.2.1 (page 94/105) "Simplified_Physical_Layer_Spec.pdf"

	Short Init Sequence:
	-> use only with low capacity cards !!
	CMD0->CMD0+->CMD1  (not recommended, see Spec 2.0)

	Complete Init Sequence:
	(CMD8 is mandatory to initialize High Capacity Cards)

	CMD0->CMD0+->CMD8->CMD58->CMD55/ACMD41(HCS=0/1)->"card ready"->CMD58->"CSS=1"->"ver2.x high capacity sd memory card"
	                                                                    ->"CSS=0"->"ver2.x standard capacity sd memory card"
	                        ->"not supported voltage range"-> "do no use card"
	                 ->"illegal command"->CMD58->CMD55/ACMD41(arg=0)->"card ready"->"ver1.x standard capacity sd memory card"
	                                                                ->"illegal command"->" do not use card"
	                 						   ->"not supported voltage range"-> "do no use card"
	   	                                       ->"illegal command"->" do not use card"
	                 
    *
	*
	*/

	drvsd_dbg("  sd_init0: %d\n", disk);

	/* Delay for at least 74 clock cycles. This means to actually
	* *clock* out at least 74 clock cycles with no data present on
	* the clock. In SPI mode, send at least 10 idle bytes (0xFF). */
	spi_cs_deassert();
	sd_delay(16);

	/* CMD0+ Put the card in the SPI mode */
	if (sd_send_command(disk, CMD0, CMD0_R, response, 0x00000000 ) != STA_OK){
		spi_cs_deassert();
		drvsd_dbg("  sd_init0: CMD0 error\n");
		return STA_COM_ERROR;
	}
	/* from now on the sd card is in SPI mode ... */

	drive[disk].type = 0;
	drive[disk].sdname[0] = 0;

	/* FIXME: use CMD1 for MMC discovery .... */
//	if (sd_send_command(disk, CMD1, CMD1_R, response, 0x40000000 ) == STA_OK){		
//		drvsd_dbg("  MMC Card detected\n");
//		strcat(drive[disk].sdname,"MMC-Card ");
//		drive[disk].type = 2;	
//		//goto LABEL01;	
//	}

#if CONFIG_DRV_SD_CRC
 	if (sd_send_command(disk, CMD59, CMD59_R, response, 0x00000001 ) != STA_OK) // not with MMC !
	{ 
		spi_cs_deassert();
		drvsd_dbg("  sd_init0: CMD59 error\n");
		return STA_COM_ERROR;
	}
#endif 

	if (sd_send_command(disk, CMD8, CMD8_R, response, 0x000001AA ) == STA_OK)
	{ 
		// check R1/R7 response:
		spi_cs_deassert();
		drvsd_dbg("  sd_init0: CMD8 result:\n");
		drvsd_dbg("    command version  = 0x%02x\n",((struct r7_cic_response*)response)->CMD_VERSION);

		#ifdef CONFIG_DEBUG_DRV_SD
		if(response[0] & MSK_IDLE) 			{drvsd_dbg("  R1(0): IDLE\n");}
		if(response[0] & MSK_ERASE_RST) 	{drvsd_dbg("  R1(1): MSK_ERASE_RST\n");}
		if(response[0] & MSK_ILL_CMD) 		{drvsd_dbg("  R1(2): MSK_ILL_CMD\n");}
		if(response[0] & MSK_CRC_ERR) 		{drvsd_dbg("  R1(3): MSK_CRC_ERR\n");}
		if(response[0] & MSK_ERASE_SEQ_ERR){ drvsd_dbg("  R1(4): MSK_ERASE_SEQ_ERR\n");}
		if(response[0] & MSK_ADDR_ERR) 		{drvsd_dbg("  R1(5): MSK_ADDR_ERR\n");}
		if(response[0] & MSK_PARAM_ERR) 	{drvsd_dbg("  R1(6): MSK_PARAM_ERR\n");}
		#endif


		if( ((struct r7_cic_response*)response)->ILLEGAL_COMMAND ){
			// v1.x card			
			if (sd_send_command(disk, CMD58, CMD58_R, response, 0x00000000 ) == STA_OK) {// read OCR
				spi_cs_deassert();
				drvsd_dbg("  sd_init0: CMD58 result:\n");
				drvsd_dbg("    res = 0x%02x:0x%02x:0x%02x:0x%02x:0x%02x:0x%02x\n",response[0],response[1],response[2],response[3],response[4],response[5]);
				drvsd_dbg("    R1               = 0x%08x\n",((struct r3_ocr_response*)response)->R1VAL);
				drvsd_dbg("    OCR              = 0x%08x\n",((struct r3_ocr_response*)response)->OCR_REG);
				drvsd_dbg("    Power Status     = 0x%02x\n",((struct r3_ocr_response*)response)->PWR_STATUS);
				drvsd_dbg("    CCS              = 0x%02x\n",((struct r3_ocr_response*)response)->CCS);
				drvsd_dbg("    3.5-3.6V         = 0x%02x\n",((struct r3_ocr_response*)response)->V35_36);
				drvsd_dbg("    3.4-3.5V         = 0x%02x\n",((struct r3_ocr_response*)response)->V34_35);
				drvsd_dbg("    3.3-3.4V         = 0x%02x\n",((struct r3_ocr_response*)response)->V33_34);
				drvsd_dbg("    3.2-3.3V         = 0x%02x\n",((struct r3_ocr_response*)response)->V32_33);
				drvsd_dbg("    3.1-3.2V         = 0x%02x\n",((struct r3_ocr_response*)response)->V31_32);
				drvsd_dbg("    3.0-3.1V         = 0x%02x\n",((struct r3_ocr_response*)response)->V30_31);
				drvsd_dbg("    2.9-3.0V         = 0x%02x\n",((struct r3_ocr_response*)response)->V29_30);
				drvsd_dbg("    2.8-2.9V         = 0x%02x\n",((struct r3_ocr_response*)response)->V28_29);
				drvsd_dbg("    2.7-2.8V         = 0x%02x\n",((struct r3_ocr_response*)response)->V27_28);

				/* Now wait until the card goes idle. Retry at most SD_IDLE_WAIT_MAX times */
				j = 0;
				do
				{
					j++;
					/* Flag the next command as an application-specific command */
					if (sd_send_command(disk, CMD55, CMD55_R, response, 0x00000000 ) == STA_OK)
					{
						/* Tell the card to send its OCR */
						sd_send_command(disk, ACMD41, ACMD41_R, response, 0x00000000 );
					}
					else
					{
						/* No response, bail early */
						drvsd_dbg("  sd_init0: No response on CMD55, giving up\n");
						j = SD_IDLE_WAIT_MAX;
					}
				}
				while ((response[0] & MSK_IDLE) == MSK_IDLE && j < SD_IDLE_WAIT_MAX);

				spi_cs_deassert();
				if (j >= SD_IDLE_WAIT_MAX){
					drvsd_dbg("  sd_init0: SD_IDLE_WAIT_MAX\n");
					return STA_TIMEOUT;
				}
				drvsd_dbg("  sd_init0:  v1.x SD Card detected....\n");
				strcat(drive[disk].sdname,"v1.0 SD Card ");
				/* Set the block length (CMD16) to 512 Bytes 
				Sets a block length (in bytes) for all following block commands (read and write) of a Standard Capacity Card.
                Block length of the read and write commands are fixed to 512 bytes in a High Capacity Card. The length of
                LOCK_UNLOCK command is set by this command in both capacity cards. */
				if (sd_set_blocklen (disk, SD_BLOCKSIZE) != STA_OK){
					drvsd_dbg("  sd_init0: error in sd_set_blocklen\n");
					return STA_COM_ERROR;
				}
				drvsd_dbg("  sd_init0:  blocksize set to SD_BLOCKSIZE (%d)....\n", SD_BLOCKSIZE);
			}
		}else {
			// v2.x card

			if (sd_send_command(disk, CMD58, CMD58_R, response, 0x00000000 ) == STA_OK) {// read OCR
				spi_cs_deassert();
				drvsd_dbg("  sd_init0: CMD58 result:\n"); 
				drvsd_dbg("    res = 0x%02x:0x%02x:0x%02x:0x%02x:0x%02x:0x%02x\n",response[0],response[1],response[2],response[3],response[4],response[5]);
				drvsd_dbg("    R1               = 0x%08x\n",((struct r3_ocr_response*)response)->R1VAL);
				drvsd_dbg("    OCR              = 0x%08x\n",((struct r3_ocr_response*)response)->OCR_REG);
				drvsd_dbg("    Power Status     = 0x%02x\n",((struct r3_ocr_response*)response)->PWR_STATUS);
				drvsd_dbg("    CCS              = 0x%02x\n",((struct r3_ocr_response*)response)->CCS);
				drvsd_dbg("    3.5-3.6V         = 0x%02x\n",((struct r3_ocr_response*)response)->V35_36);
				drvsd_dbg("    3.4-3.5V         = 0x%02x\n",((struct r3_ocr_response*)response)->V34_35);
				drvsd_dbg("    3.3-3.4V         = 0x%02x\n",((struct r3_ocr_response*)response)->V33_34);
				drvsd_dbg("    3.2-3.3V         = 0x%02x\n",((struct r3_ocr_response*)response)->V32_33);
				drvsd_dbg("    3.1-3.2V         = 0x%02x\n",((struct r3_ocr_response*)response)->V31_32);
				drvsd_dbg("    3.0-3.1V         = 0x%02x\n",((struct r3_ocr_response*)response)->V30_31);
				drvsd_dbg("    2.9-3.0V         = 0x%02x\n",((struct r3_ocr_response*)response)->V29_30);
				drvsd_dbg("    2.8-2.9V         = 0x%02x\n",((struct r3_ocr_response*)response)->V28_29);
				drvsd_dbg("    2.7-2.8V         = 0x%02x\n",((struct r3_ocr_response*)response)->V27_28);	

				/* Now wait until the card goes idle. Retry at most SD_IDLE_WAIT_MAX times */
				j = 0;
				do
				{
					j++;
					/* Flag the next command as an application-specific command */
					if (sd_send_command(disk, CMD55, CMD55_R, response, 0x00000000 ) == STA_OK)
					{
						/* Tell the card to send its OCR */
						sd_send_command(disk, ACMD41, ACMD41_R, response, 0x40000000 );						
					}
					else
					{
						/* No response, bail early */
						drvsd_dbg("  sd_init0: No response on CMD55, giving up\n");
						j = SD_IDLE_WAIT_MAX;
					}
				}
				while ((response[0] & MSK_IDLE) == MSK_IDLE && j < SD_IDLE_WAIT_MAX);

				spi_cs_deassert();

				if (j >= SD_IDLE_WAIT_MAX){
					drvsd_dbg("  sd_init0: SD_IDLE_WAIT_MAX\n");
					return STA_TIMEOUT;
				}
				drvsd_dbg("  sd_init0: card is ready\n"); 

				if (sd_send_command(disk, CMD58, CMD58_R, response, 0x00000000 ) == STA_OK) {// read OCR
					spi_cs_deassert();
					drvsd_dbg("  sd_init0: CMD58 result:\n"); 
					drvsd_dbg("    res = 0x%02x:0x%02x:0x%02x:0x%02x:0x%02x:0x%02x\n",response[0],response[1],response[2],response[3],response[4],response[5]);
					drvsd_dbg("    R1               = 0x%08x\n",((struct r3_ocr_response*)response)->R1VAL);
					drvsd_dbg("    OCR              = 0x%08x\n",((struct r3_ocr_response*)response)->OCR_REG);
					drvsd_dbg("    Power Status     = 0x%02x\n",((struct r3_ocr_response*)response)->PWR_STATUS);
					drvsd_dbg("    CCS              = 0x%02x\n",((struct r3_ocr_response*)response)->CCS);
					drvsd_dbg("    3.5-3.6V         = 0x%02x\n",((struct r3_ocr_response*)response)->V35_36);
					drvsd_dbg("    3.4-3.5V         = 0x%02x\n",((struct r3_ocr_response*)response)->V34_35);
					drvsd_dbg("    3.3-3.4V         = 0x%02x\n",((struct r3_ocr_response*)response)->V33_34);
					drvsd_dbg("    3.2-3.3V         = 0x%02x\n",((struct r3_ocr_response*)response)->V32_33);
					drvsd_dbg("    3.1-3.2V         = 0x%02x\n",((struct r3_ocr_response*)response)->V31_32);
					drvsd_dbg("    3.0-3.1V         = 0x%02x\n",((struct r3_ocr_response*)response)->V30_31);
					drvsd_dbg("    2.9-3.0V         = 0x%02x\n",((struct r3_ocr_response*)response)->V29_30);
					drvsd_dbg("    2.8-2.9V         = 0x%02x\n",((struct r3_ocr_response*)response)->V28_29);
					drvsd_dbg("    2.7-2.8V         = 0x%02x\n",((struct r3_ocr_response*)response)->V27_28);	
				}else{
					drvsd_dbg("  sd_init0: No response on CMD58, giving up\n");
					return STA_TIMEOUT;
				}

				if( ((struct r3_ocr_response*)response)->OCR_REG ) {
					drvsd_dbg("  sd_init0: >= v2.00 SDHC/XC Card detected....\n");					
					strcat(drive[disk].sdname,"v2.0 SDHC/XC Card ");
				} else {
					drvsd_dbg("  sd_init0: >= v2.00 SD Card detected....\n");
					strcat(drive[disk].sdname,"v2.0 SD Card ");
				}				
			}
		}
	}
	

LABEL01:

	spi_cs_deassert();

	// get/store drive info
	if(sd_rd_csd(disk, &csd) != STA_OK){
		drvsd_dbg("  sd_init0: error reading csd register....\n");
		return STA_COM_ERROR;
	}
	
	if(sd_rd_cid(disk, &cid) != STA_OK){
		drvsd_dbg("  sd_init0: error reading cid register....\n");
		return STA_COM_ERROR;
	}

	if(drive[disk].type != 2) // already MMC detected ?
		drive[disk].type = csd.v10.CSD_STRUCTURE;

	drvsd_dbg("  csd.v10.CSD_STRUCTURE = %d\n", csd.v10.CSD_STRUCTURE);

	switch(drive[disk].type){
		case 0: // CSD Version 1.0: Version 1.01-1.10/Version 2.00/Standard Capacity 
		case 2: // MMC ?
			drive[disk].bpb = 2 << (csd.v10.READ_BL_LEN -1);
			drive[disk].size = (2 << (csd.v10.C_SIZE_MULT+1)) * (csd.v10.C_SIZE +1) * (2 << (csd.v10.READ_BL_LEN -1)); /* size in bytes */
			pstr = malloc(20);
			sprintf(pstr,"%u MB",drive[disk].size/(1024*1024));
			drive[disk].size = drive[disk].size >> SD_BLOCKSIZE_NBITS; /* size in sectors/blocks */			
			strcat(drive[disk].sdname,pstr);		
			free(pstr);	
			break;
		case 1: // SDHC-Card: CSD Version 2.0: Version 2.00-High Capacity
			drive[disk].bpb = 2 << (csd.v20.READ_BL_LEN -1);
			drive[disk].size = ((csd.v20.C_SIZE + 1) << (SD_BLOCKSIZE_NBITS+1)); /* size in sectors/blocks */ 
			drvsd_dbg(" csd.v20.C_SIZE = %u ==> size = %u blocks\n", csd.v20.C_SIZE, drive[disk].size);
			pstr = malloc(20);			
			sprintf(pstr,"%.2f GB",(drive[disk].size >> 1)/(1024.0*1024.0) );		/* size in GB */
			strcat(drive[disk].sdname,pstr);		
			free(pstr);	
			break;		
		default:	
			drvsd_dbg("  sd_init0: error, CSD > 1 ....\n");
			return STA_COM_ERROR;

	}  // Disk /dev/sdc: 7.4 GiB, 7948206080 bytes, 15523840 sectors

	drvsd_dbg(" SD-NAME = %s\n", drive[disk].sdname);
	drvsd_dbg(" SD-Type = %d\n", drive[disk].type);
	drvsd_dbg(" BPB     = %d\n", drive[disk].bpb);
	drvsd_dbg(" Size (sectors/bytes)  = %u/%u\n", drive[disk].size, drive[disk].size << SD_BLOCKSIZE_NBITS);


return STA_OK;
}

/* This function reads 1 block (512 Bytes) from blockaddr
*/
DSTATUS sd_read_block (BYTE disk, DWORD blockaddr, unsigned char *data)
{
	unsigned long int i = 0;
	unsigned char tmp;
	unsigned char blank = 0xFF;
	union crc_16 crc;
	DWORD block;

	drvsd_dbg("  sd_read_block: disk %d, block %d, lastblock %d, buf 0x%08x (type: %d)\n", disk, blockaddr, drive[disk].size-1, data,drive[disk].type);
	
	if(blockaddr > (drive[disk].size-1)){
		drvsd_dbg("  sd_read_block: blockaddr out of range\n");
		return STA_PAR_ERROR;
	}	

	/* Wait until any old transfers are finished (if using DMA or returning from a write without waiting for flash program ok (CMD13)) */	
	

	if(drive[disk].type) {  
		drvsd_dbg("  sd_read_block: SDHC -> block addressing\n");
		block = blockaddr; /* SDHC uses block addressing */
	}
	else{
		drvsd_dbg("  sd_read_block: SD -> byte addressing\n");
		block = blockaddr << SD_BLOCKSIZE_NBITS; /* SD/MMC use byte addressing (x512 == << SD_BLOCKSIZE_NBITS(9)) */
	}

	if (sd_send_command(disk, CMD17, CMD17_R, response, block) != STA_OK) {// Block (512 bytes) Read (READ_BL_LEN set)
		drvsd_dbg("  sd_read_block: CMD17 error\n");
		spi_cs_deassert();
		spi_send_byte(0xFF,SD_CMD_TIMEOUT);
		return STA_COM_ERROR;
	}
	/* Check for an error, like a misaligned read */
	if (response[0] != 0) {
		drvsd_dbg("  sd_read_block: CMD17 returned error = 0x%02X\n",response[0]);
		spi_cs_deassert();
		spi_send_byte(0xFF,SD_CMD_TIMEOUT);
		return STA_COM_ERROR;
	}
	
	/* Wait for the token */
	i=0;
	do
	{
		tmp = spi_rcv_byte();
		i++;
	}
	while ((tmp == 0xFF) && (i < SD_CMD_TIMEOUT) );

	if (tmp != SD_TOK_READ_STARTBLOCK)
	{
		tmp = spi_rcv_byte(); // get data error token from card (FIXME: check error cause)
		/* Clock out a byte before returning */
		spi_send_byte(0xFF,SD_CMD_TIMEOUT);
		/* FIXME: send an command abort and check status ! */
		/* The card returned an error response. Bail and return 0 */
		drvsd_dbg("  sd_read_block: data error = 0x%02X (%d)\n",tmp,i);
		spi_cs_deassert();
		spi_send_byte(0xFF,SD_CMD_TIMEOUT);
		return STA_TIMEOUT;
	}

	/* start DMA transfer here, or ... */

	for (i=0; i < SD_BLOCKSIZE; i++){ // read out 512 bytes
		data[i] = spi_rcv_byte();
	}

	crc.b[0] = spi_rcv_byte(); // read crc 1st byte
	crc.b[1] = spi_rcv_byte(); // read crc 2nd byte


	drvsd_dbg("  sd_read_block: crc = 0x%04X(0x%04X)\n",crc.v,CRC_CCITT(data, SD_BLOCKSIZE));

#if CONFIG_DRV_SD_CRC
  	if ( CRC_CCITT(data, SD_BLOCKSIZE) != crc.v ){
  		drvsd_dbg("  sd_read_block: crc error\n");
  		spi_cs_deassert();
		spi_send_byte(0xFF,SD_CMD_TIMEOUT);
  		return STA_CRC_ERROR;
  	}
#endif 


    spi_cs_deassert();
	return STA_OK;
}

DSTATUS sd_read_nblock (BYTE disk, DWORD blockaddr, DWORD numblocks, unsigned char *data)
{
  size_t i;

  for (i = 0; i < numblocks; i++) {
    if (sd_read_block(disk, blockaddr + i, data + i*SD_BLOCKSIZE) != STA_OK) {
      return STA_COM_ERROR;
    }
  }
  return STA_OK;
}

/* This function writes a single block to the SD card at block
blockaddr. Returns 1 if the command was successful, zero
otherwise.
*/
DSTATUS sd_write_block (BYTE disk, DWORD blockaddr, unsigned char *data)

{
	unsigned long int i = 0;
	unsigned char tmp;
	unsigned char blank = 0xFF;
	union crc_16 crc;
	DWORD block;

	drvsd_dbg("  sd_write_block: disk %d, block %d, lastblock %d, buf 0x%08x (type: %d) (data = 0x%02x 0x%02x ...)\n", 
		disk, blockaddr, drive[disk].size-1, data,drive[disk].type, data[0], data[1]);

	if(blockaddr > (drive[disk].size-1)){
		drvsd_dbg("  sd_write_block: blockaddr out of range\n");
		return STA_PAR_ERROR;
	}
	
	/* Wait until any old transfers are finished (if using DMA or returning from a write without waiting for flash program ok (CMD13))  */

	if(drive[disk].type) {
		drvsd_dbg("  sd_write_block: SDHC -> block addressing\n");
		block = blockaddr; /* SDHC uses block addressing */
	}
	else{
		drvsd_dbg("  sd_write_block: SD -> byte addressing\n");
		block = blockaddr << SD_BLOCKSIZE_NBITS; /* SD/MMC use byte addressing  (x512 == << SD_BLOCKSIZE_NBITS(9)*/
	}


	if (sd_send_command(disk, CMD24, CMD24_R, response, block) != STA_OK){
		drvsd_dbg("  sd_write_block: CMD24 send error \n");
		spi_cs_deassert();
		spi_send_byte(0xFF,SD_CMD_TIMEOUT);
		return STA_COM_ERROR;
	}
	/* Check for an error, like a misaligned write */
	if (response[0] != 0){
		drvsd_dbg("  sd_write_block: CMD24 error 0x%02X\n",response[0]);
		spi_cs_deassert();
		return STA_COM_ERROR;
	}
	
	/* The write command needs an additional 8 clock cycles before
	* the block write is started. */
	spi_rcv_byte();

	spi_send_byte(SD_TOK_WRITE_STARTBLOCK,SD_CMD_TIMEOUT); // send start token

	/* start DMA transfer here, or .... */

	for (i=0; i < SD_BLOCKSIZE; i++){ // write out 512 bytes
		spi_send_byte(data[i],SD_CMD_TIMEOUT);
	}
	

#if CONFIG_DRV_SD_CRC
  	crc.v = CRC_CCITT(data, SD_BLOCKSIZE);
#else  
  crc.v = 0XFFFF;
#endif 
	
	drvsd_dbg("  sd_write_block: crc = 0x%04X\n",crc.v);

	spi_send_byte(crc.b[0],SD_CMD_TIMEOUT); // write crc 1st byte
	spi_send_byte(crc.b[1],SD_CMD_TIMEOUT); // write crc 2nd byte


	// receive/check data response token
	response[0]= spi_rcv_byte();
	if ((response[0] & MSK_DATA_RES) != DATA_RES_ACCEPTED) {
	    drvsd_dbg("  sd_write_block: data not accepted (response = 0x%02X)\n", response[0]);
	    /* FIXME: send an command abort and check status ! */
		spi_cs_deassert();
		spi_send_byte(0xFF,SD_CMD_TIMEOUT);
		return STA_CRC_ERROR;
	}

	drvsd_dbg("  sd_write_block: data accepted\n");
	// wait for flash programming to complete ...
	// FIXME: system stalls here, could be done using DMA and returning after transmission ...
	if(!sd_wait_notbusy(disk,SD_CMD_TIMEOUT) ){
		drvsd_dbg("  sd_write_block: wait not busy timeout(2)\n");
		/* FIXME: send an command abort and check status ! */
		spi_cs_deassert();
		spi_send_byte(0xFF,SD_CMD_TIMEOUT);
		return STA_TIMEOUT;
	}
		  
	// check programming (use CMD13)
	// ....
#define CHECK_PROGRAMMING 0	
#if CHECK_PROGRAMMING
  // response is r2 so get and check two bytes for nonzero
  if (cardCommand(CMD13, 0) || spiReceive()) {
    error(SD_CARD_ERROR_CMD13);
    goto fail;
  }
#endif  // CHECK_PROGRAMMING


	spi_cs_deassert();

	return STA_OK;
}

DSTATUS sd_write_nblock (BYTE disk, DWORD blockaddr, DWORD numblocks, unsigned char *data)
{
  size_t i;

  for (i = 0; i < numblocks; i++) {
    if (sd_write_block(disk, blockaddr + i, data + i*SD_BLOCKSIZE) != STA_OK) {
      return STA_COM_ERROR;
    }
  }
  return STA_OK;
}

DSTATUS sd_write_mblock (BYTE disk, DWORD blockaddr, DWORD numblocks, unsigned char *data)
{
    unsigned long int i = 0;
	unsigned char tmp;
	unsigned char blank = 0xFF;
	union crc_16 crc;
	DWORD block;

	drvsd_dbg("  sd_write_mblock: disk %d, strt-block %d, num %d, lastblock %d, buf 0x%08x (type: %d)\n", disk, blockaddr, numblocks, drive[disk].size-1, data,drive[disk].type);

	if(blockaddr > (drive[disk].size-1)){
		drvsd_dbg("  sd_write_mblock: blockaddr out of range\n");
		return STA_PAR_ERROR;
	}
	
	/* Wait until any old transfers are finished (if using DMA or returning from a write without waiting for flash program ok (CMD13))  */
	

	if(drive[disk].type) {
		drvsd_dbg("  sd_write_mblock: SDHC -> block addressing\n");
		block = blockaddr; /* SDHC uses block addressing */
	}
	else{
		drvsd_dbg("  sd_write_mblock: SD -> byte addressing\n");
		block = blockaddr << SD_BLOCKSIZE_NBITS; /* SD/MMC use byte addressing  (x512 == << SD_BLOCKSIZE_NBITS(9)*/
	}

	/* send pre-erase count */
	/* Flag the next command as an application-specific command */
	if (sd_send_command(disk, CMD55, CMD55_R, response, 0x00000000 ) != STA_OK)
	{
		drvsd_dbg("  sd_write_mblock: CMD55 send error \n");
		spi_cs_deassert();
		spi_send_byte(0xFF,SD_CMD_TIMEOUT);
		return STA_COM_ERROR;	
	}

	if (sd_send_command(disk, ACMD23, ACMD23_R, response, numblocks ) != STA_OK)
	{
		drvsd_dbg("  sd_write_mblock: ACMD23 send error \n");
		spi_cs_deassert();
		spi_send_byte(0xFF,SD_CMD_TIMEOUT);
		return STA_COM_ERROR;	
	}

	/* send write multiple blocks command */
    if (sd_send_command(disk, CMD25, CMD25_R, response, block) != STA_OK){
		drvsd_dbg("  sd_write_mblock: CMD25 send error \n");
		spi_cs_deassert();
		spi_send_byte(0xFF,SD_CMD_TIMEOUT);
		return STA_COM_ERROR;
	}

	/* Check for an error, like a misaligned write */
	if (response[0] != 0){
		drvsd_dbg("  sd_write_mblock: CMD25 error 0x%02X\n",response[0]);
		spi_cs_deassert();
		spi_send_byte(0xFF,SD_CMD_TIMEOUT);
		return STA_COM_ERROR;
	}
	

	for(i=0; i<numblocks; i++){
		/* The write command needs an additional 8 clock cycles before
		* the block write is started. */
		spi_rcv_byte();

		spi_send_byte(SD_TOK_WRITE_STARTBLOCK_M,SD_CMD_TIMEOUT); // send start token

		/* start DMA transfer here, or .... */

		for (i=0; i < SD_BLOCKSIZE; i++){ // write out 512 bytes
			spi_send_byte(data[i],SD_CMD_TIMEOUT);
		}
		

	#if CONFIG_DRV_SD_CRC
	  	crc.v = CRC_CCITT(data, SD_BLOCKSIZE);
	#else  
	  crc.v = 0XFFFF;
	#endif 
		
		drvsd_dbg("  sd_write_mblock: crc = 0x%04X\n",crc.v);

		spi_send_byte(crc.b[0],SD_CMD_TIMEOUT); // write crc 1st byte
		spi_send_byte(crc.b[1],SD_CMD_TIMEOUT); // write crc 2nd byte


		// receive/check data response token
		response[0]= spi_rcv_byte();
		if ((response[0] & MSK_DATA_RES) != DATA_RES_ACCEPTED) {
		    drvsd_dbg("  sd_write_mblock: data not accepted (response = 0x%02X)\n", response[0]);
		    /* FIXME: send an command abort and check status ! */
			spi_cs_deassert();
			spi_send_byte(0xFF,SD_CMD_TIMEOUT);
			return STA_CRC_ERROR;
		}

		drvsd_dbg("  sd_write_mblock: data accepted\n");
		// wait for flash programming to complete ...
		// FIXME: system stalls here, could be done using DMA and returning after transmission ...
		if(!sd_wait_notbusy(disk,SD_CMD_TIMEOUT) ){
			drvsd_dbg("  sd_write_mblock: wait not busy timeout(2)\n");
			/* FIXME: send an command abort and check status ! */
			spi_cs_deassert();
			spi_send_byte(0xFF,SD_CMD_TIMEOUT);
			return STA_TIMEOUT;
		}
		  
	}
	
	spi_send_byte(SD_TOK_STOP_MULTI,SD_CMD_TIMEOUT);

	if(!sd_wait_notbusy(disk,SD_CMD_TIMEOUT) ){
			drvsd_dbg("  sd_write_mblock: wait not busy timeout(2)\n");
			/* FIXME: send an command abort and check status ! */
			spi_cs_deassert();
			spi_send_byte(0xFF,SD_CMD_TIMEOUT);
			return STA_TIMEOUT;
	}

	// check programming (use ACMD23)
	// ....


	spi_cs_deassert();

	return STA_OK;
}

DSTATUS sd_send_command(BYTE disk,
	unsigned char cmd, unsigned char response_type,
	unsigned char *response, DWORD argument)
{
	int i;
	char response_length;
	BYTE tmp;
	uint8_t buf[6];

	// form message
	buf[0] = (BYTE)((cmd & 0x3F) | 0x40);
	buf[1] = (BYTE)(argument >> 24);
	buf[2] = (BYTE)(argument >> 16);
	buf[3] = (BYTE)(argument >> 8);
	buf[4] = (BYTE)argument;	
  	// add CRC
#ifdef CONFIG_DRV_SD_CRC  	
  	buf[5] = CRC7(buf, 5);
#else
  	// send CRC - correct for CMD0 with arg zero or CMD8 with arg 0X1AA
    buf[5] = (cmd == CMD0 ? 0X95 : 0X87);
#endif

	drvsd_dbg("  sd_send_command: disk %d, cmd=%d (->0x%02X), rtype=%d\n", disk , cmd , buf[0], response_type);
	
	/* CS high */
	spi_cs_deassert();
	
	/* send dummy byte */
	spi_send_byte(0xff,SD_CMD_TIMEOUT);

	/* CS low */
    spi_cs_assert(disk);
    
	/* All data is sent MSB first, and MSb first */
	/* Send the header/command */
	/* Format:
	cmd[7:6] : 01
	cmd[5:0] : command */
	for (i=0; i<=5; i++)
	{
		spi_send_byte(buf[i],SD_CMD_TIMEOUT);
	}


	// skip stuff byte for stop read
  	if (cmd == CMD12) {
    	spi_rcv_byte();
  	}

	response_length = 0;
	switch (response_type)
	{
		case R1:		
		case R1B:
			response_length = 1;
			break;
		case R2:
			response_length = 2;
			break;
		case R3:
			response_length = 5;
			break;
		case R7:
			response_length = 6;
		default:
			break;
	}
	drvsd_dbg("  sd_send_command: response_length = %d\n", response_length);
	
	/* Wait for a response. A response can be recognized by the
	start bit (a zero) */
	i=0;
	do
	{
		response[0] = spi_rcv_byte();
		i++;
	}
	while ((response[0] & 0x80) && i < SD_CMD_TIMEOUT); /* wait for bit7 = 0 */
	//while ((response[0] == 0xFF) && i < SD_CMD_TIMEOUT);

	drvsd_dbg("  sd_send_command: response = %d, i=%d\n", response[0], i);

#ifdef CONFIG_DEBUG_DRV_SD
		if(response[0] & MSK_IDLE) 			{drvsd_dbg("  R1(0): IDLE\n");}
		if(response[0] & MSK_ERASE_RST) 	{drvsd_dbg("  R1(1): MSK_ERASE_RST\n");}
		if(response[0] & MSK_ILL_CMD) 		{drvsd_dbg("  R1(2): MSK_ILL_CMD\n");}
		if(response[0] & MSK_CRC_ERR) 		{drvsd_dbg("  R1(3): MSK_CRC_ERR\n");}
		if(response[0] & MSK_ERASE_SEQ_ERR){ drvsd_dbg("  R1(4): MSK_ERASE_SEQ_ERR\n");}
		if(response[0] & MSK_ADDR_ERR) 		{drvsd_dbg("  R1(5): MSK_ADDR_ERR\n");}
		if(response[0] & MSK_PARAM_ERR) 	{drvsd_dbg("  R1(6): MSK_PARAM_ERR\n");}
#endif
	drvsd_dbg("  ---------\n");	

	/* Just bail if we never got a response */
	if (i >= SD_CMD_TIMEOUT)
	{
		spi_cs_deassert();
		spi_send_byte(0xFF,SD_CMD_TIMEOUT);
		drvsd_dbg("  sd_send_command: TIMEOUT\n");
		return STA_TIMEOUT;
	}

	for (i=1; i<response_length; i++)
	{
		drvsd_dbg("  sd_send_command: get response\n");
		/* This handles the trailing-byte requirement. */
		response[i] = spi_rcv_byte();
	}
	/* If the response is a "busy" type (R1B), then there's some
	* special handling that needs to be done. The card will
	* output a continuous stream of zeros, so the end of the BUSY
	* state is signaled by any nonzero response. The bus idles
	* high.
	*/
	i=0;
	if (response_type == R1B)
	{
		drvsd_dbg("  sd_send_command: response_type == R1B\n");
		do
		{
			i++;
			tmp = spi_rcv_byte();
		}
		/* This should never time out, unless SDI is grounded (or deasserted !)
		* Don't bother forcing a timeout condition here. */
		while (tmp != 0xFF);

		spi_send_byte(0xFF,SD_CMD_TIMEOUT);
	}

	//spi_cs_deassert(); // we should not deassert the card here, because subsequent reads would be broken !
	drvsd_dbg("  sd_send_command: SUCCESS\n");
	return STA_OK;
}

void sd_delay(char number)
{
	char i;
	/* Null for now */
	for (i=0; i<number; i++)
	{
		/* Clock out an idle byte (0xFF) */
		spi_send_byte(0xFF,SD_CMD_TIMEOUT);
	}
}

/* Set the block length for all future block transactions */
/* Returns 1 if the function was successful */
DSTATUS sd_set_blocklen (BYTE disk, DWORD length)
{
	int res;
	
	if(sd_send_command(disk, CMD16, CMD16_R, response, length) != STA_OK)
	{
		drvsd_dbg("  sd_set_blocklen: error CMD16\n");
  		return STA_COM_ERROR;
	}

	spi_cs_deassert();
	if(response[0]) {
		drvsd_dbg("  sd_set_blocklen: response error CMD16\n");
	
		return STA_COM_ERROR;
	}
	
	return STA_OK;
}

DSTATUS sd_rd_csd(BYTE disk, union csd_reg *pcsd){
  BYTE i,tmp;
  BYTE *p;
  union crc_16 crc;

  if (sd_send_command(disk, CMD9, CMD9_R, response, 0x00000000 ) != STA_OK)
  {
  	drvsd_dbg("  sd_rd_csd: error CMD9\n");
  	spi_cs_deassert();
	spi_send_byte(0xFF,SD_CMD_TIMEOUT);
  	return STA_COM_ERROR;
  }

  if(response[0] != 0){
  	spi_cs_deassert();
	spi_send_byte(0xFF,SD_CMD_TIMEOUT);
  	return STA_COM_ERROR;
  }

  /* wait for start token */
  i=0;
  do
  {
  	tmp = _spi_rcv_byte();
  	i++;
    drvsd_dbg("  0x%02X",tmp);
    
  }
  while ((tmp != SD_TOK_READ_STARTBLOCK) && i < SD_CMD_TIMEOUT);
 
  /* Just bail if we never got a response */
  if (i >= SD_CMD_TIMEOUT)
  {
    spi_cs_deassert();
	spi_send_byte(0xFF,SD_CMD_TIMEOUT);
  	drvsd_dbg("  sd_rd_csd: TIMEOUT\n");
  	return STA_TIMEOUT;
  }

  p = (BYTE*)pcsd;
  for(i=0; i<16; i++)
  	*p++ = spi_rcv_byte();

  /* read the 16 bit CRC */
  crc.b[0] = spi_rcv_byte(); // read crc 1st byte
  crc.b[1] = spi_rcv_byte(); // read crc 2nd byte


#if CONFIG_DRV_SD_CRC
  	if ( CRC_CCITT(pcsd, 16) != crc.v ){
  		drvsd_dbg("  sd_rd_csd: crc error\n");
  		spi_cs_deassert();
		spi_send_byte(0xFF,SD_CMD_TIMEOUT);
  		return STA_CRC_ERROR;
  	}
#endif

   /* command ends, deassert card */
  spi_cs_deassert();
  drvsd_dbg("  sd_rd_csd: SUCCESS\n");
  return STA_OK;
}


DSTATUS sd_rd_cid(BYTE disk, struct cid_reg *pcid){
  BYTE i,tmp;
  BYTE *p;
  union crc_16 crc;

  if (sd_send_command(disk, CMD10, CMD10_R, response, 0x00000000 ) != STA_OK)
  {
  	drvsd_dbg("  sd_rd_cid: error CMD10\n");
  	spi_cs_deassert();
	spi_send_byte(0xFF,SD_CMD_TIMEOUT);
  	return STA_COM_ERROR;
  }

  if(response[0] != 0){
  	spi_cs_deassert();
	spi_send_byte(0xFF,SD_CMD_TIMEOUT);
  	return STA_COM_ERROR;
  }

  /* wait for start block (= 0xfe) */
  i=0;
  do
  {
  	tmp = spi_rcv_byte();
  	i++;
    drvsd_dbg("  0x%02X",tmp);
    
  }
  while ((tmp != SD_TOK_READ_STARTBLOCK) && i < SD_CMD_TIMEOUT);
  
  /* Just bail if we never got a response */
  if (i >= SD_CMD_TIMEOUT)
  {
    spi_cs_deassert();
	spi_send_byte(0xFF,SD_CMD_TIMEOUT);
  	drvsd_dbg("  sd_rd_cid: TIMEOUT\n");
  	return STA_TIMEOUT;
  }

  p = (BYTE*)pcid;
  for(i=0; i<16; i++)
  	*p++ = spi_rcv_byte();

  /* read the 16 bit CRC */
  crc.b[0] = spi_rcv_byte(); // read crc 1st byte
  crc.b[1] = spi_rcv_byte(); // read crc 2nd byte

#if CONFIG_DRV_SD_CRC
  	if ( CRC_CCITT(pcid, 16) != crc.v ){
  		drvsd_dbg("  sd_rd_cid: crc error\n");
  		spi_cs_deassert();
		spi_send_byte(0xFF,SD_CMD_TIMEOUT);
  		return STA_CRC_ERROR;
  	}
#endif

   /* command ends, deassert card */
  spi_cs_deassert();

  drvsd_dbg("  sd_rd_cid: SUCCESS\n");

  return STA_OK;
}


/* public functions */
struct _sddriveinfo *sd_init(BYTE disk)
{

	drvsd_dbg("  sd_init: %d\n", disk);

	/* Initialize the SPI controller and set spiclk at min (divisor = 16, 40MHz/16 ~2,5MHz) */
	spi_ctrl_reg = 0x83; 			
	spictrl = spi_ctrl_reg;

	/* Initialization OK? */
	if (sd_init0(disk) != STA_OK){
		drvsd_dbg("  sd_init: ERROR\n");
		return 0;
	}
	/* Set the maximum SPI clock rate possible 20MHz */
	spi_ctrl_reg = 0x81;
	spictrl = spi_ctrl_reg;


	drvsd_dbg("  sd_init: SUCCESS\n");
	return &drive[disk];
}




