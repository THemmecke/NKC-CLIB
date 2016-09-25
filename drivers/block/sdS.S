
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
	
#ifdef CONFIG_DEBUG_SD_S	
msgKEY:	.ascii "KEY.."
	.byte 0x0d,0x0a,0x00
	
msgREAD:	.ascii "SDREAD.."
	.byte 0x0d,0x0a,0x00	

msgWRITE:	.ascii "SDWRITE.."
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
//	.global idetifySD, sddisk, sdtest, _sd
	.global sddisk, sdtest



/* -------------------------------------------------------------------------

	routines using GP
	
   -------------------------------------------------------------------------*/		
   
   
/*	
	DRESULT sddisk(USHORT cmd,ULONG arg1,ULONG arg2,BYTE disk,void* pdata)	
	d0      sddisk(
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
sddisk:
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
	move.l	#_SDDISK,%d7    /* _SDDISK */
	trap #1
	movem.l (%sp)+,%d1-%d4
	and.l #0x0000FFFF,%d0
	rts				
    		
/*
struct _sddriveinfo *sdtest(BYTE disk)

Kurzbeschreibung: Testet, ob ein SD-Laufwerk vorhanden ist.
Eingaberegister: d4.b = Auswahl des Laufwerks
Ausgaberegister: d0.l = Fehlercode
CARRY = 1, wenn kein Laufwerk vorhanden ist
a0.l = Adresse der Laufwerksinformationen
*/
sdtest:
	move.l %a7,%a0
	movem.l %d0-%d7,-(%sp)
	clr.l %d4
	move.b (7,%A0),%d4		/* disk -> d4 */
	move.l	#_SDTEST,%d7		/* _SDTEST */
	trap #1
	move %d0,%d6
                                     /* a0 points to a struct _sddriveinfo, d0 has error code */
	tst.l %d0                    /* d0 = 0, if no error */
	beq sdtest_e
	movea.l #0,%a0			/* in case of an error return NULL */
sdtest_e:		
	movem.l (%sp)+,%d0-%d7
	rts							

	
// /*
// DRESULT sdtest(BYTE disk,struct _driveinfo** di)
// 
// Kurzbeschreibung: Testet, ob ein SD-Laufwerk vorhanden ist.
// Eingaberegister: d4.b = Auswahl des Laufwerks
// Ausgaberegister: d0.l = Fehlercode
// CARRY = 1, wenn kein Laufwerk vorhanden ist
// a0.l = Adresse der Laufwerksinformationen
// */
// sdtest:
// 	move.l %a7,%a0
// 	movem.l %d0-%d7,-(%sp)
// 	clr.l %d4
// 	move.b (7,%A0),%d4		/* disk -> d4                */
// 	move.l (8,%a0),%a1		/* struct _driveinfo** -> a1 */
// 	move.l	#_SDTEST,%d7		/* _SDTEST */
// 	trap #1
// 	move %d0,%d6
//                                      /* a0 points to a struct _driveinfo, d0 has error code */
// 	tst.l %d0                    /* d0 = 0, if no error */
// 	beq sdtest_e
// 	movea.l #0,%a0			/* in case of an error return NULL */
// sdtest_e:		
// 	move.l %a0,(%a1)		/* store pointer to driveinfo */
// 	movem.l (%sp)+,%d0-%d7
// 	rts		


///* -------------------------------------------------------------------------
//
//	routines talking directly with SD device
//	
//   -------------------------------------------------------------------------*/		
//   
//
///*
//DRESULT idetifySD(BYTE disk, struct _deviceinfo *p)
//*/
//
//idetifySD: 
//	movea.l %a7,%a1
//	movem.l %d1-%d4/%a0-%a1,-(%sp)
//		
//	bsr waitRDY             	/* wait for SD to be ready */
//	bsr waitNBSY			/* wait for SD to be not busy */
//	move.b  (7,%a1),sdsdh.w		/* drivenumber */
//	bsr wawa
//	bsr waitNBSY
//	move.b  #0xEC,sdcmd.w    	/* send command 		*/	
//	bsr waitDRQ             	/* wait for SD data		*/
//	
//	move.b sdcmd.w,%d0		/* Status */
//	move.b sderr.w,%d1		/* Error */
//	
//	move.l  (8,%A1),%a0
//	move.l #(512/2)-1,%d0       	/* read data to buffer		*/
//	lea sddat.w,%a1
//L1:     
//
//	move.b (%a1),1(%a0)		/* store with byte swap */
//	move.b (%a1),0(%a0)
//	addq #2,%a0
//	dbra %d0,L1
//	
//	bsr flushSD			/* empty data buffer */	
//	
//L2:	clr.l %d0
//	move.b %d1,%d0			/* return error code */
//	movem.l (%sp)+,%d1-%d4/%a0-%a1
//	rts
//
//
///*	
//	DRESULT _sd(USHORT cmd,ULONG arg1,ULONG arg2,BYTE disk,void* pdata)	
//	d0      sddisk(
//					USHORT sp+6 -> d1,
//					ULONG  sp+8 -> d2,
//					ULONG  sp+12 -> d3,
//					BYTE   sp+19 -> d4,
//					void*  sp+20 -> a0)	
//
//	Eingaberegister: d1.w = Auswahl des Befehls (0-31)
//	d2.l = Je nach Befehl verschieden
//	d3.l = Je nach Befehl verschieden
//	d4.b = Auswahl der Harddisk
//	a0.l = Adresse der Daten, wenn welche verlangt werden
//	Ausgaberegister: d0.l = Fehlercode
//	CARRY = 1, wenn d0.l <> 0	
//*/
//_sd:
//	movea.l %a7,%a1	
//	movem.l %d1-%d7/%a1-%a6,-(%sp)
//
//	
//	clr.l %d0					/* clear registers */
//	clr.l %d1
//	clr.l %d2
//	clr.l %d3
//	clr.l %d4
//	
//	move.w  (6 ,%A1),%d1		/* cmd   -> d1 */
//	move.l  (8 ,%A1),%d2		/* arg1  -> d2 */
//	move.l  (12,%A1),%d3		/* arg2  -> d3 */
//	move.b  (19,%A1),%d4		/* disk  -> d4 */
//	move.l  (20,%A1),%a0		/* pdata -> a0 */
//
//	cmp.w	#CMD_READ,%d1
//	beq		_sdrd
//	cmp.w	#CMD_WRITE,%d1
//	beq		_sdwr
//	
//	moveq	#-100,%d0
//	bra		_sdend
//	
//	/*******************************************************************************************************************************
//		<PIO Mode Reading>
//		READ-ARGS:
//			d1.w = CMD_READ
//			d2.l = sector address (LBA)
//			d3.l = number of sectors
//			d4.b = disk (1....n)
//			a0.l = pointer to buffer
//			
//			d3.l <= 256 => CMD_READ_SECTORS 
//			d3.l > 256  => CMD_SET_MULTIPLE,CMD_READ_MULTIPLE
//			
//			---
//			d0.l = tmp
//			d1.l = tmp
//			*d2.l = sector address (LBA)
//			*d3.l = number of sectors
//			*d4.b = disk (1....n)
//			d5.l = try counter
//			d6.l = byte counter
//			d7.l = sector counter
//		    *a0.l = pointer to buffer
//			a1.l = data register address
//			a2.l = saved buffer address to work on
//	*/
//_sdrd:		
//	/*dbg msgREAD*/
//	move #10-1, %d5         /* try reading 10 times */			
//		
//_sdrd_01:
//	
//	move.l %d2,%d1			/* load sector number */
//	lsr.l  #8,%d1
//	lsr.l  #8,%d1
//	lsr.l  #8,%d1
//	or.b   #0xE0,%d1
//	move.b  %d1,sdsdh.w	/* 1110b(LBA MASTER) + sectornumber LBA[24..27] => sdsdh */	
//	
//	move.b #0,sderr.w		/* this write will be ignored by the drive, it just produces some delay .... */
//	/*bsr wawa*/
//	
//	move.b	%d3,sdscnt.w	/* number of sectors => sdscnt */
//	
//	move.l %d2,%d1			/* load sector number */
//	move.b  %d1,sdsnum.w	/* LBA[0..7] 		*/
//	lsr.l	#8,%d1
//	move.b  %d1,sdclo.w	/* LBA[8..15]		*/
//	lsr.l	#8,%d1
//	move.b  %d1,sdchi.w	/* LBA[16..23] 		*/	
//		
//		
//_sdrd_01a:	
//
//    move.l	%a0,%a2			/* load buffer address */
//    move.l  %d3,%d7			/* load sector count */	
//    tst		%d7				/* number of sectors = 0 ? */
//	bne		_sdrd_01b
//	move	#256,%d7
//_sdrd_01b:
//	subq #1,%d7
//	
//	lea sddat.w, %a1       /* dataport address in a1 */
//	
//	bsr waitRDY             /* wait for SD to be ready */
//	bsr waitNBSY			/* wait for SD to be not busy */	
// 	tst %d0					/* drive busy? (%d0 != 0)*/
// 	bne _sdrd_retry        /* yes %d0 != 0, some error occured */
//	
//	move %sr, -(%a7)         /* save status reg */
// 	ori #0x0700, %sr         /* switch off interrupts */
// 	
// 	/*dbg msg03*/
// 	
//	move.b  #CMD_READ_SECTORS,sdcmd.w    	/* send command 			*/	
//	
//_sdrd_02:
//	move #512-1, %d6                    /* read nth sector */	
//	bsr waitNBSY						/* wait for SD to be not busy */	
// 	tst %d0								/* still busy ? */
// 	beq _sdrd_02a           			/* no (%d0=0), so go ahead */
// 	move (%a7)+, %sr               		/* error (%d0!=0) while waiting, restore status */
// 	bra.s _sdrd_retry                  /* error reading sector */
//_sdrd_02a:
// 	bsr waitDRQ                         /* data ready?   */
//	tst %d0
//	beq.s _sdrd_03                     /* yes (%d0=0), no error */
// 	move (%a7)+, %sr               		/* error while waiting, restore status */
// 	bra.s _sdrd_retry                  /* error reading sector */
//	
//_sdrd_03:
//	move.b (%a1), (%a2)+                /* read */
// 	dbra 	%d6, _sdrd_03              /* next byte */
// 	dbra 	%d7, _sdrd_02              /* next sector */
// 	 	
//	move (%a7)+, %sr                 	/* restore status */
// 	bsr waitNBSY                        /* drive busy? */
// 	tst %d0
// 	bne _sdrd_retry               		/* yes, some error occured */
// 	move.b sdcmd.w, %d0
// 	move.b %d0,%d1
// 	and.b #0b00100001, %d1
// 	
// 	/*and.b #0b10001001, %d1*/          /* any other errors? 
// 											*Bit 0 = ERR ("some error") 
// 											Bit 3 = DRQ ??? FEHLER ?
// 											*Bit 5 = DF (disk failed)
// 											Bit 7 = BSY
// 										*/
// 										
// 	beq  _sdrd_success                 /* no, we are ready */
// 	bra  _sdrd_tryrecover
// 	
//_sdrd_retry:
//	dbg msgRETRYrd
//	dbra %d5, _sdrd_01a	                 /* one more try */ 	
//	bra _sdrd_error
//	
//_sdrd_tryrecover:
//	dbg msgRECOVERrd
//	bsr resetSD						/* try recovering */
//	dbra %d5, _sdrd_01                 /* one more try */ 	
//	
//_sdrd_error:
//	dbg msgERRORrd
///*	moveq #-1, %d0*/					/* error code is set by subroutines... */
//	bra _sdrd_end
//_sdrd_success:
///*	dbg msgSUCCrd*/
//	clr.l %d0
//_sdrd_end:	
//	
//	bra 	_sdend
//	
//	/***************************************************************************************************************************
//		<PIO Mode Writing>
//		WRITE-ARGS:
//			d1 = CMD_WRITE
//			d2 = sector address (LBA)
//			d3 = number of sectors
//			d4 = disk (1....n)
//			a0 = pointer to buffer
//			
//			---
//			d0.l = tmp
//			d1.l = tmp
//			*d2.l = sector address (LBA)
//			*d3.l = number of sectors
//			*d4.b = disk (1....n)
//			d5.l = try counter
//			d6.l = byte counter
//			d7.l = sector counter
//		    *a0.l = pointer to buffer
//			a1.l = data register address
//			a2.l = saved buffer address to work on
//	*/
//_sdwr:		
//    /*dbg msgWRITE    */
//	move #10-1, %d5         /* try reading 10 times */			
//	
//_sdwr_01:
//		
//	move.l %d2,%d1			/* load sector number */
//	lsr.l  #8,%d1
//	lsr.l  #8,%d1
//	lsr.l  #8,%d1
//	or.b	#0xE0,%d1
//	move.b  %d1,sdsdh.w	/* 1110b(LBA MASTER) + sectornumber LBA[24..27] => sdsdh */
//		
//	move.b #0,sderr.w		/* this write will be ignored by the drive, it just produces some delay .... */
//	/*bsr wawa*/
//	
//	move.b	%d3,sdscnt.w	/* number of sectors => sdscnt */
//	
//	move.l %d2,%d1			/* load sector number */
//	move.b  %d1,sdsnum.w	/* LBA[0..7] 		*/
//	lsr.l	#8,%d1
//	move.b  %d1,sdclo.w	/* LBA[8..15]		*/
//	lsr.l	#8,%d1
//	move.b  %d1,sdchi.w		/* LBA[16..23] 		*/	
//		
//	
//_sdwr_01a:	
//    move.l	%a0,%a2			/* load buffer address */
//    move.l  %d3,%d7			/* load sector count */	
//    tst		%d7				/* number of sectors = 0 ? */
//	bne		_sdwr_01b
//	move	#256,%d7
//_sdwr_01b:
//	subq #1,%d7
//	
//	lea sddat.w, %a1       /* dataport address in a1 */		
//	
//	bsr waitRDY             /* wait for SD to be ready */
//	bsr waitNBSY			/* wait for SD to be not busy */	
// 	tst %d0					/* drive busy? (%d0 != 0)*/
// 	bne _sdwr_retry   /* yes, some error occured */
//	
//	move %sr, -(%a7)         /* save status reg */
// 	ori #0x0700, %sr         /* switch off interrupts */
// 	
// 	/*dbg msg01*/
// 	
//	move.b  #CMD_WRITE_SECTORS,sdcmd.w    	/* send command 			*/	
//
//
//_sdwr_02:
//	move #512-1, %d6                    /* read 1 sector */	
//	bsr waitNBSY						/* wait for SD to be not busy */	
// 	tst %d0								/* still busy ? */
// 	beq _sdwr_02a           			/* no, so go ahead */
// 	move (%a7)+, %sr               		/* error while waiting, restore status */
// 	bra.s _sdwr_retry                  /* error reading sector */
//_sdwr_02a:
// 	bsr waitDRQ                         /* data ready?   */
//	tst %d0
//	beq.s _sdwr_03                     /* yes (%d0=0), no error */
// 	move (%a7)+, %sr               		/* error while waiting, restore status */
// 	bra.s _sdwr_retry                  /* error reading sector */
//	
//_sdwr_03:
//    bra	.+4								/* delay ...*/
///*    
//    bra	_sdwr_04
//_sdwr_04:
//*/    
//	move.b (%a2)+, (%a1)                /* write */
// 	dbra 	%d6, _sdwr_03              /* next byte */
// 	/*dbg msg02*/
// 	dbra 	%d7, _sdwr_02              /* next sector */
// 	
//	move (%a7)+, %sr                 	/* restore status */
// 	bsr waitNBSY                        /* drive busy? */
// 	tst %d0
// 	bne _sdwr_retry               /* yes, some error occured */
// 	move.b sdcmd.w, %d0
// 	move.b %d0,%d1
// 	and.b #0b00100001, %d1
// 	
// 	/*and.b #0b10001001, %d1*/          /* any other errors? 
// 											*Bit 0 = ERR ("some error") 
// 											Bit 3 = DRQ ??? FEHLER ?
// 											*Bit 5 = DF (disk failed)
// 											Bit 7 = BSY
// 										*/
// 										
// 	beq  _sdwr_success                 /* no, we are ready */
// 	bra  _sdwr_tryrecover
// 	
//_sdwr_retry: 	
//	dbg msgRETRYwr
//	/*dbgwait*/
//	dbra %d5, _sdwr_01a                 /* one more try */
//	bra _sdwr_error
//	
//_sdwr_tryrecover:
//	dbg msgRECOVERwr
//	dbgwait
//	bsr resetSD						/* try recovering */
//	dbra %d5, _sdwr_01                 /* one more try */ 	
//	
//_sdwr_error:
//	dbg msgERRORwr
//	dbgwait
///*	moveq #-1, %d0*/					/* error code is set by subroutines... */
//	bra _sdwr_end
//_sdwr_success:	
//	clr.l %d0
//_sdwr_end:	
//	bsr sdCacheFlush
//_sdend:
//	
//	movem.l (%sp)+,%d1-%d7/%a1-%a6	
//	rts
//
//
//
//
///* -------------------------------------------------------------------------
//
//	helper routines
//	
//	http://wiki.osdev.org/ATA_PIO_Mode
//   -------------------------------------------------------------------------*/		
//
//	
//waitRDY:                 /* wait for sd to be ready	*/
// move.l #DELAY_VAL,%d0          /*   tries					*/
//waitRDY1:
// /*bsr wawa*/
// subq.l #1,%d0
// beq waitRDYerr            	/* break			*/
// btst.b #6,sdcmd.w		  	/* RDY bit == 1 ?		*/
// btst.b #6,sdcmd.w		  	
// btst.b #6,sdcmd.w		  	
// btst.b #6,sdcmd.w		  	
// btst.b #6,sdcmd.w		  	
// 
// bne waitRDYsucc		  	/* RDY = 1, success */	
// bra waitRDY1		 		/* RDY = 0, keep trying */
//waitRDYerr:
// moveq #-1,%d0
// bra waitRDYend
//waitRDYsucc:
// clr.l %d0
//waitRDYend:
// rts	
// 
//
//waitDRQ:                 /* wait for data available	*/
// move.l #DELAY_VAL,%d0           /* Versuche					*/
//waitDRQ1:
// /*bsr wawa*/		/* im GP wird hier nicht gewartet....laut Spec muss aber min 400ns gewartet werden, bevor das DRQ abgefragt wird 
// 					- wird das DRQ evtl. automatisch zurückgesetzt ? */
// subq.l #1,%d0
// beq waitDRQerr            /* Schleifen-Abbruch			*/
// btst.b #3,sdcmd.w		  /* DRQ bit == 1  ?     */    
// 
// btst.b #3,sdcmd.w		  
// btst.b #3,sdcmd.w		  
// btst.b #3,sdcmd.w		  
// btst.b #3,sdcmd.w		  
// 
// bne waitDRQsucc		  /* DRQ = 1, data available ... */
// bra waitDRQ1			  /* DRQ = 0, keep tryig */
//waitDRQerr:
// moveq #-2,%d0
// bra waitDRQend
//waitDRQsucc:
// clr.l %d0
//waitDRQend:
// rts 
//	
//	
//waitNBSY:                 /* wait on sd while BUSY	*/
// move.l #DELAY_VAL,%d0          /*   Versuche					*/
//waitNBSY1:
// /*bsr wawa*/
// subq.l #1,%d0
// beq waitNBSYerr            /* Schleifen-Abbruch			*/
// btst.b #7,sdcmd.w		    /* check if BUSY bit == 0		*/
//
// btst.b #7,sdcmd.w		    
// btst.b #7,sdcmd.w		    
// btst.b #7,sdcmd.w		    
// btst.b #7,sdcmd.w		    
//
// beq waitNBSYsucc			/* BSY = 0 */
// bra waitNBSY1			    /* BSY = 1 */
//waitNBSYerr:
// /*.writeln err1(%pc)*/
// moveq #-3,%d0
// bra waitNBSYend
//waitNBSYsucc:
// clr.l %d0	
//waitNBSYend:
// rts	
// 
// 
// 
// 	
//resetSD:					/* soft reset SD (master and slave) */
//	bset #1,sdsir.w
//	bsr wawa
//	bclr #1,sdsir.w
//	bsr waitNBSY
//	bsr waitRDY
//	rts
//	
//sdCacheFlush:
//	move.b #CMD_CACHE_FLUSH, sdcmd.w    	/* send command 			*/	
//	bsr waitNBSY
//	rts
//	
//	
//	
//flushSD:					/* read any data available and flush data buffer */
//	movem.l %a0/%d0,-(%sp)
//	
//	lea sddat(%pc),%a0
//flushSD1:	
//	btst.b #3,sdcmd.w
//	beq flushSDe
//	move.b	(%a0),%d0
//	bra flushSD1
//flushSDe:	
//	movem.l (%sp)+,%a0/%d0
//	rts
//	
//
// 
//	
//wawa:                           /* simply wait some time ... */
// movem.l %d0,-(%a7)
// clr.l %d0
// move #0xFFFF,%d0
//wawa1:
// dbra %d0,wawa1
// movem.l (%a7)+,%d0
// rts	
	
	
	
	

