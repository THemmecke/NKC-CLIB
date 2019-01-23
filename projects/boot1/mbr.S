/*********************************************
*                                            *
*              MBR  BOOTLOADER               *
*                                            *
*********************************************/
#include "../../nkc/nkc.h"
#include "../../nkc/macros.h"

.text
/*.equ cpu,    4  */ 			/* 68020 (4), 68000 (2), 68008(1) (in nkc.h) */

.org 0x0
		
start:  jmp main(%pc)			/* jump  */
        nop						/* nop denotes loader 		*/
        nop						/* GP recognizes MBR loader */

/* data has to be written by installer */
/* disk:    .byte  1				 0x08: disk type (0=SCSI, 1=IDE, 2=SD) */
/* drive:	 .byte  1                0x09: physical drive numberf (1=1st drive) */
/* part:	 .byte  0xff			 0x0A: partition (0=1st partition, 0xff=no partition table) */
/* ssector: .byte	0,0,0,0			 0x0B: start sector of OS.SYS */
/* nsector: .byte	0,0				 0x0F: size in sectors of OS.SYS */
/* dstadr:	 .byte  0,0,0,0			 0x11: target address for OS.SYS */

disk:    .byte  1				/* 0x08: disk type (0=SCSI, 1=IDE, 2=SD) */
drive:	 .byte  1               /* 0x09: physical drive numberf (1=1st drive) */
part:	 .byte  0		    	/* 0x0A: partition (0=1st partition, 0xff=no partition table) */
dummy:	 .byte  0
ssector: .long	510 			/* 0x0C: start sector of OS.SYS */
nsector: .long	716				/* 0x10: size in sectors of OS.SYS */
dstadr:	 .long  0x1000			/* 0x14: target address for OS.SYS */
osname:	 .ascii  "  TEST      " /* 0x18: name of OS.SYS (max. 12 characters 8.3 notation)*/
         .byte		0x0a,0x0d,0x00

/* messages         */
meldung: .ascii 	"MBR Bootloader (C) 2018 Torsten Hemmecke"
	 	.byte		0x0a,0x0d
	 	.ascii		"loading "
	 	.byte		0x00


        .align cpu
main:									/* loads OS.SYS (or whatever resides at ssector) */
		moveq #20,%d7					/* clear screen (GP) */
 		trap #1
 		

		lea meldung(%pc),%a0			/* fire messages */
m001:
		move.b (%a0)+,%d0       		/* fetch character */
 		beq.s m002            			/* end if zero */
 		moveq #33,%d7        			/* put character out */
 		trap #1							/* call GP */
 		bra.s m001        				/* repeat */
m002:

		writeln osname(%pc)
		crlf

/*		
		lea disk(%pc),%a0
		bsr _PRTHEX8
		lea ssector(%pc),%a0
		bsr _PRTHEX8
		lea nsector(%pc),%a0
		bsr _PRTHEX8
		lea dstadr(%pc),%a0
		bsr _PRTHEX8
mloop:  bra mloop
*/

		/* initialize drive */
		move.b drive(%pc),%d4			/* drive number */
		movea.l dstadr(%pc),%a0				/* space for drive information */

		cmp.b #1,disk(%pc)				/* if disk=1 */
		beq  m003						/* then IDE  */
		cmp.b #2,disk(%pc)				/* if disk=2 */
		beq  m004                       /* then SD   */
										/* else SCSI */

		move.l #142,%d7					/* SCSI call */			
		bra m005
m003:	move.l #154,%d7					/* IDE call */
		bra m005
m004:	move.l #163,%d7					/* SD call */
										
m005:   trap #1
										/* load sectors */
										/* disk type (IDE/SD) is set by GP at boot time */

		clr.l %d5						/* clear block counter */
		move.l nsector(%pc),%d6			/* total number of sectors to read */
		move.b drive(%pc),%d4			/* select physical drive */
		movea.l dstadr(%pc),%a0			/* Target Address */	    
		
		move.l #1,%d1					/* command 'sector read' */
		move.l ssector(%pc),%d2			/* Start Sector */
		
m006:
		cmp.l #0,%d6					/* if all sectors read  */
		beq m013					    /* terminate ... */

		cmp.l #256,%d6					/* we can read up tp 256 sectors per GP call */
		blt m007						/* if less than 256 sectors */
		bge m008						/* if more than or exact 256 sectors */

m007:	move.l %d6,%d3		
		move.l #0,%d6
		bra m009
m008:	move.l #0,%d3					/* 256 sectors */
		subi.l #256,%d6					/* decrement total number of sectors to read */

m009:
		movem.l %a0-%a6/%d1-%d7,-(%a7)  /* save registers */

		/* set start sector */
		lsl.l #8,%d5					/* calculate already read sectors LSL 8 == x256 */
		add.l %d5,%d2					/* add to start sector */

		/* set target address */
		mulu #512,%d5					/* address offset = 512 bytes x sectors read */
		adda.l %d5,%a0					/* add to start address */
							
		cmp.b #1,disk(%pc)
		beq  m010		
		cmp.b #2,disk(%pc)
		beq  m011

		move.l #141,%d7					/* SCSI call */			
		bra m012
m010:	move.l #155,%d7					/* IDE call */
		bra m012
m011:	move.l #164,%d7					/* SD call */
										
m012:
		trap #1							/* call GP */

		movem.l (%a7)+,%a0-%a6/%d1-%d7  /* restore registers */
										/* d0 has error code */
		addq #1,%d5						/* increment block counter */
		bra m006

m013:		

		/*lea dstadr(%pc),%a0	*/
		movea.l dstadr(%pc),%a0




		jmp (%a0)				/* jmp !! */
		
								        
mainend: bra mainend

        rts						/* end of loader, we should never come here... */
		





/*
_PRTHEX8:
	prthex8 %a0
	writeln buffer(%pc)
	crlf
	rts    
      
        .align cpu

buffer:	
*/
.end

        
        
