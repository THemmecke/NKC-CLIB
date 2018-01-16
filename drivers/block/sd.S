
#include "../../nkc/nkc.h"
#include "../../nkc/macros.h"

.bss 


#ifdef CONFIG_DEBUG_DRV_SD
buffer:   ds.b 256  
#endif
.data


.text


/* ****************************************************************************
void _spi_cs_assert(unsigned char which, unsigned char ctrlreg)

 input: 
    input	byte to send, ctrlreg
	
 output:
	void
  
 stack-frame:
 			0x0008	11  ctrlreg
			0x0004	 7	which
	sp--->	0x0000	 0	

*******************************************************************************/
_spi_cs_assert: .global _spi_cs_assert
 move.b 11(%sp), %d0
 move.b 7(%sp), %d1                      
 bset.b  %d1,%d0      /*  set CS low (active) */   
 move.b %d0,spictrl.w
 rts

/* ****************************************************************************
void _spi_cs_deassert(unsigned char ctrlreg)

 input: 
    input	ctrlreg
	
 output:
	void
  
 stack-frame:
	sp--->	0x0000	 0	

*******************************************************************************/
_spi_cs_deassert: .global _spi_cs_deassert
 	  
 move.b 7(%sp), %d0	
 move.b %d0,spictrl.w   /* 10000001b : 0x81 SPI enabled, spi-clk=20MHz */
 rts

/* ****************************************************************************
int _spi_send_byte(unsigned char input, unsigned int timeout)

 input: 
    input	byte to send, timeout 
	
 output:
	int 1=success, 0=timeout
  
 stack-frame:
 			0x000C   12  timeouot
			0x0008	 11	input (BYTE 4+3)
			0x0004		saved d2
	sp--->	0x0000	 0	

*******************************************************************************/
_spi_send_byte: .global _spi_send_byte

	                        /*  schreibt ein Byte auf die SD-Card, CSx zur Kartenauswahl wurde bereits gesetzt! */

movem.l %d2,-(%sp)			/* save d2 (only d0/d1 are scratch registers !) */
#ifdef CONFIG_DEBUG_DRV_SD
// 
//   prnt 'S'
//   prnt 'B'
//   prnt ':'	                        
#endif   
 move.b 11(%sp),%d1 
 move.l 12(%sp),%d2 
#ifdef CONFIG_DEBUG_DRV_SD
//   prthex2 %d1
//   writeln buffer
//   prnt ',' 
//   prthex2 %d2
//   writeln buffer
//   crlf 
#endif   
 move %sr, -(%sp)					/* save sr -- Note: sr is only 16bits wide !! */
 ori #0x0700, %sr                        /*  disable interrupts */
_spi_send_byte1:  
 btst.b #0, spictrl.w                  /*  busy? */
 bne _spi_send_byte2					
 dbra %d2,_spi_send_byte1	
 clr.l %d0							/* set timout error */
 bra _spi_send_byte3 
_spi_send_byte2:
 move.b %d1, spidata.w                  /*  send data */
 moveq #1,%d0						/* return success */	  
_spi_send_byte3:  
 move (%sp)+, %sr  					/* restore status register */
 movem.l (%sp)+,%d2					/* restore d2 */
#ifdef CONFIG_DEBUG_DRV_SD
//    prnt '.'
//    crlf 	
#endif     
 rts

/* ****************************************************************************
unsigned char _spi_rcv_byte()

 input: 
    void
	
 output:
	byte received
  
 stack-frame:
	sp--->	0x0000	 0	

*******************************************************************************/ 
_spi_rcv_byte: .global _spi_rcv_byte                        /*  liest ein Byte von der SD-Card, CSx zur Kartenauswahl wurde bereits gesetzt! */
#ifdef CONFIG_DEBUG_DRV_SD
//     prnt 'R'
//     prnt 'B'
//     crlf 	
#endif     
 move %sr, -(%sp)
 ori #0x0700, %sr                        /*  Interrupts aus */
 move.b #0xff, spidata.w                /*  Dummybyte */
_spi_rcv_byte1:  
 btst.b #0, spictrl.w                  /*  OK? */
 beq _spi_rcv_byte1						/* FIXME LOOP ! */
 move.b spidata.w, %d0
 move (%sp)+,%sr
#ifdef CONFIG_DEBUG_DRV_SD
//  prnt '.'
//  crlf 
#endif
 rts


/* ------------------------------------------------------------------------------------------------------------------------------------------- */
