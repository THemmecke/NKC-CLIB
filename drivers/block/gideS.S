
#include "../nkc/nkc.h"
#include "../nkc/macros.h"


/* commands coming from the host */
.equ CMD_READ,		1
.equ CMD_WRITE, 	2

/* ATA command codes */
.equ CMD_SET_MULTIPLE_MODE	,		0xC6
		
.equ CMD_READ_MULTIPLE		, 		0xC4
.equ CMD_READ_SECTORS		,		0x20
.equ CMD_READ_SECTORS_R		,		0x21
.equ CMD_READ_SECTORS_V		,		0x40
.equ CMD_READ_SECTORS_VR	,		0x41

.equ CMD_WRITE_SECTORS		,		0x30
.equ CMD_WRITE_SECTORS_R	,		0x31
.equ CMD_WRITE_SECTORS_V	,		0x3C

.equ CMD_CACHE_FLUSH		, 		0xE7

.equ DELAY_VAL				, 		0XFFFF



	.data
	
#ifdef CONFIG_DEBUG_GIDE_S	
msgKEY:	.ascii "KEY.."
	.byte 0x0d,0x0a,0x00
	
msgREAD:	.ascii "IDEREAD.."
	.byte 0x0d,0x0a,0x00	

msgWRITE:	.ascii "IDEWRITE.."
	.byte 0x0d,0x0a,0x00
	
msgRETRYrd:	.ascii "retry read.."
	.byte 0x0d,0x0a,0x00
	
msgRECOVERrd:	.ascii "recover read.."
	.byte 0x0d,0x0a,0x00		

msgERRORrd:	.ascii "error read.."
	.byte 0x0d,0x0a,0x00
	
msgRETRYwr:	.ascii "retry write.."
	.byte 0x0d,0x0a,0x00
	
msgRECOVERwr:	.ascii "recover write.."
	.byte 0x0d,0x0a,0x00		
	
msgERRORwr:	.ascii "error write.."
	.byte 0x0d,0x0a,0x00
		
msgSUCC:	.ascii "success.."
	.byte 0x0d,0x0a,0x00	
	
msgWAWA:	.ascii "wawa..."
	.byte 0x0d,0x0a,0x00
	
msg01:	.ascii "send command write..."
	.byte 0x0d,0x0a,0x00

msg02:	.ascii "next sector..."
	.byte 0x0d,0x0a,0x00	
	
msg03:	.ascii "send command read..."
	.byte 0x0d,0x0a,0x00	
		
#endif	
		
	.text
	.global idetifyIDE, idedisk, idetest, _ide
	
/*
	https://www.pjrc.com/tech/8051/ide/wesley.html#readwritereg
*/	



/* -------------------------------------------------------------------------

	routines using GP
	
   -------------------------------------------------------------------------*/		
   
   
/*	
	DRESULT idedisk(USHORT cmd,ULONG arg1,ULONG arg2,BYTE disk,void* pdata)	
	d0      idedisk(
					USHORT sp+6 -> d1,
					ULONG  sp+8 -> d2,
					ULONG  sp+12 -> d3,
					BYTE   sp+19 -> d4,
					void*  sp+20 -> a0)	

	Eingaberegister: d1.w = Auswahl des Befehls (0-31)
	d2.l = Je nach Befehl verschieden
	d3.l = Je nach Befehl verschieden
	d4.b = Auswahl der Harddisk (0=Master, 1=	Slave)
	a0.l = Adresse der Daten, wenn welche verlangt werden
	Ausgaberegister: d0.l = Fehlercode
	CARRY = 1, wenn d0.l <> 0	
*/
idedisk:
	movea.l %a7,%a1
	
	movem.l %d1-%d4,-(%sp)
	clr.l %d0
	clr.l %d1
	clr.l %d4
	/*-----*/	
	move.w  (6 ,%A1),%d1		/* cmd -> d1 */
	move.l  (8 ,%A1),%d2		/* arg1 -> d2 */
	move.l  (12,%A1),%d3		/* arg2 -> d3 */
	move.b  (19,%A1),%d4		/* disk -> d4 */
	move.l  (20,%A1),%a0		/* pdata -> a0 */
	/*-----*/
	move.l	#155,%d7
	trap #1
	movem.l (%sp)+,%d1-%d4
	and.l #0x0000FFFF,%d0
	rts				
    		
/*
struct _driveinfo *idetest(BYTE disk)

Kurzbeschreibung: Testet, ob ein IDE-Laufwerk vorhanden ist.
Eingaberegister: d4.b = Auswahl des Laufwerks
Ausgaberegister: d0.l = Fehlercode
CARRY = 1, wenn kein Laufwerk vorhanden ist
a0.l = Adresse der Laufwerksinformationen
*/
idetest:
	move.l %a7,%a0
	movem.l %d0-%d7,-(%sp)
	move.l (4,%A0),%d4		/* disk -> d4 */
	move.l	#154,%d7
	trap #1
	move %d0,%d6
							/* a0 points to a struct _driveinfo, d0 has error code */
	tst.l %d0									
	beq idetest_e
	movea.l #0,%a0			/* in case of an error return NULL */
idetest_e:		
	movem.l (%sp)+,%d0-%d7
	rts							



/* -------------------------------------------------------------------------

	routines talking directly with IDE device
	
   -------------------------------------------------------------------------*/		
   

/*
int idetifyIDE(BYTE disk, struct hd_driveid *p)

return values:
  0 - no error
  ide error register ...
  
  The error register indicates what went wrong when a command execution results in an error. 
  The fact that an error has occurred is indicated in the status register, the explanation is given in the error register. This is a read register.

	bit 0    : AMNF bit. Indicates that an address mark was not
           found. What this means I not sure of. I have never
           seen this happen.
	bit 1    : TK0NF bit. When this bit is set the drive was not able
           to find track 0 of the device. I think you will have
           to throw away the disk if this happens.
	bit 2    : ABRT bit. This bit is set when you have given an
           indecent command to the disk. Mostly wrong parameters
           (wrong head number etc..) cause the disk to respond
           with error flag in the status bit set and the ABRT bit
           set. I have gotten this error a lot when I tried to
           run the disk with interrupts. Something MUST have been
           wrong with my interface program. I have not (yet)
           found what.
	bit 3    : MCR bit. indicated that a media change was requested.
           What that means I do not know. I've ignored this bit
           till now.
	bit 4    : IDNF bit. Means that a sector ID was not found. I have
           never seen this happen, I guess it means that you've
           requested a sector that is not there.
	bit 5    : MC bit. Indicates that the media has been changed. I
           ignore this bit.
	bit 6    : UNC bit. Indicates that an uncorrectable data error
           happened. Some read or write errors could provoke
           this. I have never seen it happen.
	bit 7    : reserved.
*/

idetifyIDE: 
	movea.l %a7,%a1
	movem.l %d1-%d4/%a0-%a1,-(%sp)
		
	bsr waitRDY             	/* wait for IDE to be ready */
	bsr waitNBSY			/* wait for IDE to be not busy */
	move.b  (7,%a1),idesdh.w	/* drivenumber */
	bsr wawa
	bsr waitNBSY
	move.b  #0xEC,idecmd.w    	/* send command 		*/	
	bsr waitDRQ             	/* wait for IDE data		*/
	
	move.b idecmd.w,%d2		/* Status */
	move.b ideerr.w,%d1		/* Error */
	
	andi.b #1,%d2			/* if an error occured, return with error code */
	bne L2				/* if error => Z-Flag = 0 */
	clr.l %d1			/* if status ok, clear error */
	
	move.l  (8,%A1),%a0
	move.l #(512/2)-1,%d0       	/* read data to buffer		*/
	lea idedat.w,%a1
L1:     

	move.b (%a1),1(%a0)		/* store with byte swap */
	move.b (%a1),0(%a0)
	addq #2,%a0
	dbra %d0,L1
	
	bsr flushIDE			/* empty data buffer */	
	
L2:	clr.l %d0
	move.b %d1,%d0			/* return error code */
	movem.l (%sp)+,%d1-%d4/%a0-%a1
	rts


/*	
	DRESULT _ide(USHORT cmd,ULONG arg1,ULONG arg2,BYTE disk,void* pdata)	
	d0      idedisk(
					USHORT sp+6 -> d1,
					ULONG  sp+8 -> d2,
					ULONG  sp+12 -> d3,
					BYTE   sp+19 -> d4,
					void*  sp+20 -> a0)	

	Eingaberegister: d1.w = Auswahl des Befehls (0-31)
	d2.l = Je nach Befehl verschieden
	d3.l = Je nach Befehl verschieden
	d4.b = Auswahl der Harddisk
	a0.l = Adresse der Daten, wenn welche verlangt werden
	Ausgaberegister: d0.l = Fehlercode
	CARRY = 1, wenn d0.l <> 0	
*/
_ide:
	movea.l %a7,%a1	
	movem.l %d1-%d7/%a1-%a6,-(%sp)

	
	clr.l %d0					/* clear registers */
	clr.l %d1
	clr.l %d2
	clr.l %d3
	clr.l %d4
	
	move.w  (6 ,%A1),%d1		/* cmd   -> d1 */
	move.l  (8 ,%A1),%d2		/* arg1  -> d2 */
	move.l  (12,%A1),%d3		/* arg2  -> d3 */
	move.b  (19,%A1),%d4		/* disk  -> d4 */
	move.l  (20,%A1),%a0		/* pdata -> a0 */

	cmp.w	#CMD_READ,%d1
	beq		_iderd
	cmp.w	#CMD_WRITE,%d1
	beq		_idewr
	
	moveq	#-100,%d0              /* error unknown command */

	bra		_ideend
	
	/*******************************************************************************************************************************
		<PIO Mode Reading>
		READ-ARGS:
			d1.w = CMD_READ
			d2.l = sector address (LBA)
			d3.l = number of sectors
			d4.b = disk (1....n)
			a0.l = pointer to buffer
			
			d3.l <= 256 => CMD_READ_SECTORS 
			d3.l > 256  => CMD_SET_MULTIPLE,CMD_READ_MULTIPLE
			
			---
			d0.l = tmp
			d1.l = tmp
			*d2.l = sector address (LBA)
			*d3.l = number of sectors
			*d4.b = disk (1....n)
			d5.l = try counter
			d6.l = byte counter
			d7.l = sector counter
		    *a0.l = pointer to buffer
			a1.l = data register address
			a2.l = saved buffer address to work on
	*/
_iderd:		
	/*dbg msgREAD*/
	move #10-1, %d5         /* try reading 10 times */			
		
_iderd_01:
	
	move.l %d2,%d1			/* load sector number */
	lsr.l  #8,%d1
	lsr.l  #8,%d1
	lsr.l  #8,%d1
	or.b   #0xE0,%d1
	move.b  %d1,idesdh.w	/* 1110b(LBA MASTER) + sectornumber LBA[24..27] => idesdh */	
	
	move.b #0,ideerr.w		/* this write will be ignored by the drive, it just produces some delay .... */
	/*bsr wawa*/
	
	move.b	%d3,idescnt.w	/* number of sectors => idescnt */
	
	move.l %d2,%d1			/* load sector number */
	move.b  %d1,idesnum.w	/* LBA[0..7] 		*/
	lsr.l	#8,%d1
	move.b  %d1,ideclo.w	/* LBA[8..15]		*/
	lsr.l	#8,%d1
	move.b  %d1,idechi.w	/* LBA[16..23] 		*/	
		
		
_iderd_01a:	

    move.l	%a0,%a2			/* load buffer address */
    move.l  %d3,%d7			/* load sector count */	
    tst		%d7				/* number of sectors = 0 ? */
	bne		_iderd_01b
	move	#256,%d7
_iderd_01b:
	subq #1,%d7
	
	lea idedat.w, %a1       /* dataport address in a1 */
	
	bsr waitRDY             /* wait for IDE to be ready */
	bsr waitNBSY			/* wait for IDE to be not busy */	
 	tst %d0					/* drive busy? (%d0 != 0)*/
 	bne _iderd_retry        /* yes %d0 != 0, some error occured */
	
	move %sr, -(%a7)         /* save status reg */
 	ori #0x0700, %sr         /* switch off interrupts */
 	
 	/*dbg msg03*/
 	
	move.b  #CMD_READ_SECTORS,idecmd.w    	/* send command 			*/	
	
_iderd_02:
	move #512-1, %d6                    /* read nth sector */	
	bsr waitNBSY						/* wait for IDE to be not busy */	
 	tst %d0								/* still busy ? */
 	beq _iderd_02a           			/* no (%d0=0), so go ahead */
 	move (%a7)+, %sr               		/* error (%d0!=0) while waiting, restore status */
 	bra.s _iderd_retry                  /* error reading sector */
_iderd_02a:
 	bsr waitDRQ                         /* data ready?   */
	tst %d0
	beq.s _iderd_03                     /* yes (%d0=0), no error */
 	move (%a7)+, %sr               		/* error while waiting, restore status */
 	bra.s _iderd_retry                  /* error reading sector */
	
_iderd_03:
	move.b (%a1), (%a2)+                /* read */
 	dbra 	%d6, _iderd_03              /* next byte */
 	dbra 	%d7, _iderd_02              /* next sector */
 	 	
	move (%a7)+, %sr                 	/* restore status */
 	bsr waitNBSY                        /* drive busy? */
 	tst %d0
 	bne _iderd_retry               		/* yes, some error occured */
 	move.b idecmd.w, %d0
 	move.b %d0,%d1
 	and.b #0b00100001, %d1
 	
 	/*and.b #0b10001001, %d1*/          /* any other errors? 
 											*Bit 0 = ERR ("some error") 
 											Bit 3 = DRQ ??? FEHLER ?
 											*Bit 5 = DF (disk failed)
 											Bit 7 = BSY
 										*/
 										
 	beq  _iderd_success                 /* no, we are ready */
 	bra  _iderd_tryrecover
 	
_iderd_retry:
	dbg msgRETRYrd
	dbra %d5, _iderd_01a	                 /* one more try */ 	
	bra _iderd_error
	
_iderd_tryrecover:
	dbg msgRECOVERrd
	bsr resetIDE						/* try recovering */
	dbra %d5, _iderd_01                 /* one more try */ 	
	
_iderd_error:
	dbg msgERRORrd
/*	moveq #-1, %d0*/					/* error code is set by subroutines... */
	bra _iderd_end
_iderd_success:
/*	dbg msgSUCCrd*/
	clr.l %d0
_iderd_end:	
	
	bra 	_ideend
	
	/***************************************************************************************************************************
		<PIO Mode Writing>
		WRITE-ARGS:
			d1 = CMD_WRITE
			d2 = sector address (LBA)
			d3 = number of sectors
			d4 = disk (1....n)
			a0 = pointer to buffer
			
			---
			d0.l = tmp
			d1.l = tmp
			*d2.l = sector address (LBA)
			*d3.l = number of sectors
			*d4.b = disk (1....n)
			d5.l = try counter
			d6.l = byte counter
			d7.l = sector counter
		    *a0.l = pointer to buffer
			a1.l = data register address
			a2.l = saved buffer address to work on
	*/
_idewr:		
    /*dbg msgWRITE    */
	move #10-1, %d5         /* try reading 10 times */			
	
_idewr_01:
		
	move.l %d2,%d1			/* load sector number */
	lsr.l  #8,%d1
	lsr.l  #8,%d1
	lsr.l  #8,%d1
	or.b	#0xE0,%d1
	move.b  %d1,idesdh.w	/* 1110b(LBA MASTER) + sectornumber LBA[24..27] => idesdh */
		
	move.b #0,ideerr.w		/* this write will be ignored by the drive, it just produces some delay .... */
	/*bsr wawa*/
	
	move.b	%d3,idescnt.w	/* number of sectors => idescnt */
	
	move.l %d2,%d1			/* load sector number */
	move.b  %d1,idesnum.w	/* LBA[0..7] 		*/
	lsr.l	#8,%d1
	move.b  %d1,ideclo.w	/* LBA[8..15]		*/
	lsr.l	#8,%d1
	move.b  %d1,idechi.w		/* LBA[16..23] 		*/	
		
	
_idewr_01a:	
    move.l	%a0,%a2			/* load buffer address */
    move.l  %d3,%d7			/* load sector count */	
    tst		%d7				/* number of sectors = 0 ? */
	bne		_idewr_01b
	move	#256,%d7
_idewr_01b:
	subq #1,%d7
	
	lea idedat.w, %a1       /* dataport address in a1 */		
	
	bsr waitRDY             /* wait for IDE to be ready */
	bsr waitNBSY			/* wait for IDE to be not busy */	
 	tst %d0					/* drive busy? (%d0 != 0)*/
 	bne _idewr_retry   /* yes, some error occured */
	
	move %sr, -(%a7)         /* save status reg */
 	ori #0x0700, %sr         /* switch off interrupts */
 	
 	/*dbg msg01*/
 	
	move.b  #CMD_WRITE_SECTORS,idecmd.w    	/* send command 			*/	


_idewr_02:
	move #512-1, %d6                    /* write 1 sector */	
	bsr waitNBSY						/* wait for IDE to be not busy */	
 	tst %d0								/* still busy ? */
 	beq _idewr_02a           			/* no, so go ahead */
 	move (%a7)+, %sr               		/* error while waiting, restore status */
 	bra.s _idewr_retry                  /* error writing sector */
_idewr_02a:
 	bsr waitDRQ                         /* data ready?   */
	tst %d0
	beq.s _idewr_03                     /* yes (%d0=0), no error */
 	move (%a7)+, %sr               		/* error while waiting, restore status */
 	bra.s _idewr_retry                  /* error writing sector */
	
_idewr_03:
    bra	.+4								/* delay ...*/
/*    
    bra	_idewr_04
_idewr_04:
*/    
	move.b (%a2)+, (%a1)                /* write */
 	dbra 	%d6, _idewr_03              /* next byte */
 	/*dbg msg02*/
 	dbra 	%d7, _idewr_02              /* next sector */
 	
	move (%a7)+, %sr                 	/* restore status */
 	bsr waitNBSY                        /* drive busy? */
 	tst %d0
 	bne _idewr_retry               /* yes, some error occured */
 	move.b idecmd.w, %d0
 	move.b %d0,%d1
 	and.b #0b00100001, %d1
 	
 	/*and.b #0b10001001, %d1*/          /* any other errors? 
 											*Bit 0 = ERR ("some error") 
 											Bit 3 = DRQ ??? FEHLER ?
 											*Bit 5 = DF (disk failed)
 											Bit 7 = BSY
 										*/
 										
 	beq  _idewr_success                 /* no, we are ready */
 	bra  _idewr_tryrecover
 	
_idewr_retry: 	
	dbg msgRETRYwr
	/*dbgwait*/
	dbra %d5, _idewr_01a                 /* one more try */
	bra _idewr_error
	
_idewr_tryrecover:
	dbg msgRECOVERwr
	dbgwait
	bsr resetIDE						/* try recovering */
	dbra %d5, _idewr_01                 /* one more try */ 	
	
_idewr_error:
	dbg msgERRORwr
	dbgwait
/*	moveq #-1, %d0*/					/* error code is set by subroutines... */
	bra _idewr_end
_idewr_success:	
	clr.l %d0
_idewr_end:	
	bsr ideCacheFlush
_ideend:
	
	movem.l (%sp)+,%d1-%d7/%a1-%a6	
	rts




/* -------------------------------------------------------------------------

	helper routines
	
	http://wiki.osdev.org/ATA_PIO_Mode
   -------------------------------------------------------------------------*/		

	
waitRDY:                 /* wait for ide to be ready	*/
 move.l #DELAY_VAL,%d0          /*   tries					*/
waitRDY1:
 /*bsr wawa*/
 subq.l #1,%d0
 beq waitRDYerr            	/* break			*/
 btst.b #6,idecmd.w		  	/* RDY bit == 1 ?		*/
 btst.b #6,idecmd.w		  	
 btst.b #6,idecmd.w		  	
 btst.b #6,idecmd.w		  	
 btst.b #6,idecmd.w		  	
 
 bne waitRDYsucc		  	/* RDY = 1, success */	
 bra waitRDY1		 		/* RDY = 0, keep trying */
waitRDYerr:
 moveq #-1,%d0
 bra waitRDYend
waitRDYsucc:
 clr.l %d0
waitRDYend:
 rts	
 

waitDRQ:                 /* wait for data available	*/
 move.l #DELAY_VAL,%d0           /* Versuche					*/
waitDRQ1:
 /*bsr wawa*/		/* im GP wird hier nicht gewartet....laut Spec muss aber min 400ns gewartet werden, bevor das DRQ abgefragt wird 
 					- wird das DRQ evtl. automatisch zurückgesetzt ? */
 subq.l #1,%d0
 beq waitDRQerr            /* Schleifen-Abbruch			*/
 btst.b #3,idecmd.w		  /* DRQ bit == 1  ?     */    
 
 btst.b #3,idecmd.w		  
 btst.b #3,idecmd.w		  
 btst.b #3,idecmd.w		  
 btst.b #3,idecmd.w		  
 
 bne waitDRQsucc		  /* DRQ = 1, data available ... */
 bra waitDRQ1			  /* DRQ = 0, keep tryig */
waitDRQerr:
 moveq #-2,%d0
 bra waitDRQend
waitDRQsucc:
 clr.l %d0
waitDRQend:
 rts 
	
	
waitNBSY:                 /* wait on ide while BUSY	*/
 move.l #DELAY_VAL,%d0          /*   Versuche					*/
waitNBSY1:
 /*bsr wawa*/
 subq.l #1,%d0
 beq waitNBSYerr            /* Schleifen-Abbruch			*/
 btst.b #7,idecmd.w		    /* check if BUSY bit == 0		*/

 btst.b #7,idecmd.w		    
 btst.b #7,idecmd.w		    
 btst.b #7,idecmd.w		    
 btst.b #7,idecmd.w		    

 beq waitNBSYsucc			/* BSY = 0 */
 bra waitNBSY1			    /* BSY = 1 */
waitNBSYerr:
 /*.writeln err1(%pc)*/
 moveq #-3,%d0
 bra waitNBSYend
waitNBSYsucc:
 clr.l %d0	
waitNBSYend:
 rts	
 
 
 
 	
resetIDE:					/* soft reset IDE (master and slave) */
	bset #1,idesir.w
	bsr wawa
	bclr #1,idesir.w
	bsr waitNBSY
	bsr waitRDY
	rts
	
ideCacheFlush:
	move.b #CMD_CACHE_FLUSH, idecmd.w    	/* send command 			*/	
	bsr waitNBSY
	rts
	
	
	
flushIDE:					/* read any data available and flush data buffer */
	movem.l %a0/%d0,-(%sp)
	
	lea idedat(%pc),%a0
flushIDE1:	
	btst.b #3,idecmd.w
	beq flushIDEe
	move.b	(%a0),%d0
	bra flushIDE1
flushIDEe:	
	movem.l (%sp)+,%a0/%d0
	rts
	

 
	
wawa:                           /* simply wait some time ... */
 movem.l %d0,-(%a7)
 clr.l %d0
 move #0xFFFF,%d0
wawa1:
 dbra %d0,wawa1
 movem.l (%a7)+,%d0
 rts	
	
	
	
	

