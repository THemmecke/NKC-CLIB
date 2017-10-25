#include "../nkc/nkc.h"
#include "../nkc/macros.h"


	.text
	.global _ll_gettime, _ll_settime, _ll_ticks, _ll_getenv, _ll_system, timerinit, timerclose

	
uwait:
 movem.l %d4,-(%sp)
 moveq #5*cpu, %d4               /* Ein bißchen warten, da Baugruppe nicht so */
uwait0:                         /* schnell (Zeit ist CPU-abhängig) */
 dbra %d4, uwait0
 movem.l (%sp)+,%d4
 rts
      
/************************************************************************
 * struct tm *_ll_gettime(struct tm *tm2)
 ************************************************************************/
/*
	 * Only the values that we read from the RTC are set. We leave
	 * tm_wday, tm_yday and tm_isdst untouched. Even though the
	 * RTC has RTC_DAY_OF_WEEK, we ignore it, as it is only updated
	 * by the RTC when initially set to a non-zero value.
	 
		 struct tm
		{
		  int   tm_sec;   int = 32bit 
		  int   tm_min;
		  int   tm_hour;
		  int   tm_mday;
		  int   tm_mon;
		  int   tm_year;
		  int   tm_wday;
		  int   tm_yday;
		  int   tm_isdst;
		};

*/ 


_ll_gettime:
	movem.l %d3/%a2,-(%sp)
	
	move.l 12(%sp),%a2 /* *tm */	

	move %sr, -(%sp)                 /* save status */
 	ori #0x0700, %sr                 /* disable interrupts  */	

_ll_gettime2b:
 	bsr uwait
 	move.b #0x0a, RTC_DS12887_INDEX.w
 	move.b RTC_DS12887_DATA.w, %d3            	/* RTC ready? */
 	bmi.s _ll_gettime2b                 /* no, wait */   	
	
	CMOS_READ #RTC_SECONDS
	BCD_TO_BIN
	move.l %d0,0(%a2)
	bsr uwait
	
	CMOS_READ #RTC_MINUTES
	BCD_TO_BIN
	move.l %d0,4(%a2)
	bsr uwait

	CMOS_READ #RTC_HOURS
	BCD_TO_BIN	
	move.l %d0,8(%a2)
	bsr uwait
	
	CMOS_READ #RTC_DAY_OF_MONTH
	BCD_TO_BIN
	move.l %d0,12(%a2)
	bsr uwait
	
	CMOS_READ #RTC_MONTH
	BCD_TO_BIN	
	/*
	sub.l #1,%d0   why ? 
	*/
	move.l %d0,16(%a2)
	bsr uwait

	CMOS_READ #RTC_YEAR	
	BCD_TO_BIN

/*--	
	move.l %d0,%d1
	bsr uwait
	CMOS_READ #RTC_CENTURY
	BCD_TO_BIN

	mulu.l #100,%d0
	add.l %d1,%d0
	sub.l #1900,%d0
--*/	

	addi.l #100,%d0		/* years since 1900  */
	move.l %d0,20(%a2) 
	bsr uwait
	
	CMOS_READ #RTC_DAY_OF_WEEK	
	BCD_TO_BIN
	move.l %d0,24(%a2)

	move.l %a2,%d0
	
	move (%sp)+, %sr                 /* restore status */
	movem.l (%sp)+,%d3/%a2
	rts


/************************************************************************
 * int _ll_settime(struct tm *tm2)
   set the RTC with the values of tm2
   return 0 if successful, 1 otherwise
 ************************************************************************/
_ll_settime:
	movem.l %d3/%a2,-(%sp)
	
	move.l 12(%sp),%a2 /* *tm */	

	move %sr, -(%sp)                 /* save status */
 	ori #0x0700, %sr                 /* disable interrupts  */

_ll_settime2b:
 	bsr uwait
 	move.b #0x0a, RTC_DS12887_INDEX.w
 	move.b RTC_DS12887_DATA.w, %d3            	/* RTC ready? */
 	bmi.s _ll_settime2b                 /* no, wait */  	

	move.l 0(%a2),%d0
	BIN_TO_BCD
	CMOS_WRITE #RTC_SECONDS,%d0
	bsr uwait                      
	
	move.l 4(%a2),%d0
	BIN_TO_BCD
	CMOS_WRITE #RTC_MINUTES,%d0
	bsr uwait                      

	move.l 8(%a2),%d0
	BIN_TO_BCD
	CMOS_WRITE #RTC_HOURS,%d0	
	bsr uwait                      
	
	move.l 12(%a2),%d0
	BIN_TO_BCD
	CMOS_WRITE #RTC_DAY_OF_MONTH,%d0
	bsr uwait                      
	
	move.l 16(%a2),%d0
	BIN_TO_BCD
	CMOS_WRITE #RTC_MONTH, %d0	
	bsr uwait                      
	
	move.l 20(%a2),%d0 /* years since 1900  */
	subi.l #100,%d0	
	BIN_TO_BCD
	CMOS_WRITE #RTC_YEAR, %d0
	bsr uwait                      

/*--	
	FIXME!
	BIN_TO_BCD
	CMOS_WRITE #RTC_CENTURY, %d0
	bsr uwait                      
	

	move.l 24(%a2),%d0
	BIN_TO_BCD
	CMOS_WRITE #RTC_DAY_OF_WEEK,%d0
	bsr uwait                      
--*/
	clr.l %d0
	move (%sp)+, %sr                 /* restore status */
	movem.l (%sp)+,%d3/%a2
	rts

/************************************************************************
 * int _ll_ticks(void)
 	returns processor time since start of program execution
 	_ll_ticks / CLOCKS_PER_SEC ist time in seconds
 	
 	In MSDOS this function is done in BIOS (1Ah,0) and returns
 	the time in ticks since system start.
 	
 	so we must initialize some variable which in turn needs
 	to be updated using the timer interrupt....
 	--> initialization in startup.S via timerinit
 ************************************************************************/
_ll_ticks:

/*

(long)clock_t clock(void)
{
        return _ll_ticks();
}

*/
#ifdef M68000
	lea ticks,%a0
#else
	lea ticks(%pc),%a0
#endif
	move.l (%a0),%d0
	rts
	
	
/*
 INT 0x74 = Autovector Ebene 5 (IPL0..IPL4 =)
 INT 0x7C = Autovector Ebene 7 (IPL0..IPL4 = / nicht maskierbar !)
 
*/

timerinit:
#ifdef M68000
	lea kqstart, %a0		/* clear Key-Queue Vars */
	clr (%a0)
	lea kqend, %a0
	clr (%a0) 
	lea kqanz, %a0
	clr (%a0)

	lea oldint7c,%a0
        move.l 0x7c, (%a0)       	/* save old int vector */
	lea oldint74,%a0
	move.l 0x74, (%a0)
        lea trap1F,%a0
#else
	lea kqstart(%pc), %a0		/* clear Key-Queue Vars */
	clr (%a0)
	lea kqend(%pc), %a0
	clr (%a0) 
	lea kqanz(%pc), %a0
	clr (%a0)

	lea oldint7c(%pc),%a0
        move.l 0x7c, (%a0)       	/* save old int vector */
	lea oldint74(%pc),%a0
	move.l 0x74, (%a0)
        lea trap1F(%pc),%a0	
#endif
        move.l %a0, 0x7c         	/* install new int vector */
	move.l %a0, 0x74
        
#ifdef M68000
	lea ticks,%a0
#else
	lea ticks(%pc),%a0
#endif
	move.b #0x0,(%a0)
        
	lea TIMER1_CTRL.w,%a0        	/* adresse ctrl-reg in a0 	*/
	lea TIMER1_HI.w,%a1          	/* adresse hi-reg in a1	*/
	lea TIMER1_LO.w,%a2          	/* adresse lo-reg in a2 */

	move.b #4,(%a0)          	/* schreibe preset und timer register */
        				/* timer counts with 1Mhz, CLOCKS_PER_SEC = 1000 => counter=1000=0x03e8 => overflow after 50 days */
	move.b #0x03,(%a1)        	/* hi-byte */
	move.b #0xe8,(%a2)        	/* low-byte */
	move.b #0b10000001,(%a0)  	/* start timer, enable interupt */
	andi #0xf8ff, %sr		/* Interrups freigeben	*/
	rts
	
timerclose:
	lea TIMER1_CTRL.w,%a0        	/* adresse ctrl-reg in a0 */
	move.b #0,(%a0)          	/* stop timer and interrupts */
	ori #0x0700, %sr		/* Interrupts aus	*/
#ifdef M68000
	lea oldint7c,%a0
#else
	lea oldint7c(%pc),%a0
#endif
	move.l (%a0),0x7c       	/* restore old interrupt */
#ifdef M68000
	lea oldint74,%a0
#else
	lea oldint74(%pc),%a0
#endif
	move.l (%a0),0x74       	/* restore old interrupt */
	rts
		
/* TIMER INTERRUPT ROUTINE */	
trap1F:
    movem.l %a0-%a6/%d0-%d7,-(%sp)
    move %sr,-(%sp)
	ori #0x0700, %sr			/* Interrupts aus */
/*
    lea TIMER1_CTRL.w,%a0
    move.b #0b10000001,(%a0)  /* clear ovl bit(6), continue running(0), enable INT(7) */	
*/        
#ifdef M68000
    lea ticks,%a0
#else
    lea ticks(%pc),%a0
#endif
    add.l #1,(%a0)			/* increment tick counter */
	
	/*----- Ctrl-C check -------*/
checkkbd:
	move.b NKC_KEY_DATA.w, %d0
#ifdef M68000	
	bmi tr1Fend				/* kein neues Zeichen -> Ende */
#else
	bmi.s tr1Fend				/* kein neues Zeichen -> Ende */
#endif
	
	
	cmp.b #0x03, %d0			/* check Ctrl-C (incl. Strobe-Flag) */
 	bne.s getkbd	 			/* kein ctrl-c 	*/
 	
    tst.b NKC_KEY_DIP.w			/* Reset Strobe-Flag */
        
#ifdef M68000
    writeln ctrlctxt
#else
	writeln ctrlctxt(%pc)
#endif
        
    /* - SIG senden */
    move.l #21,-(%sp)			/* raise(SIGBREAK); (sollte es raise(SIGINT) sein ?)*/
    /*bsr.l raise Problem mit 68000 (illegal instruction) => dem Compiler überlassen */
    bsr raise

    /* muss hier noch ein bra tr1Fend rein oder kommt man hier nie an? */
    /* im Grunde kommt man hier nie an, weil raise(SIGBREAK) das Programm beendet */
    bra tr1Fend /* so ist es "sauberer" */
        
getkbd:
#ifdef M68000
	lea keyqueue, %a0
	lea kqanz, %a1
	lea kqend, %a2
#else
	lea keyqueue(%pc), %a0
	lea kqanz(%pc), %a1
	lea kqend(%pc), %a2
#endif	
	cmp #256, (%a1)			/* kqanz			*/
	bge.s tr1Fend			/* Queue voll			*/

	addq #1, (%a1)			/* kqanz - ein Zeichen mehr	*/
	move (%a2), %d1			/* kqend			*/
	move.b %d0, 0(%a0, %d1.w)	/* Zeichen speichern		*/
    tst.b NKC_KEY_DIP.w		/* Reset Strobe-Flag		*/
	addq #1, %d1
	and #0xff, %d1			/* auf 0..255			*/
	move %d1, (%a2)			/* kqend			*/

	/*----------------------------*/
	
tr1Fend:
	
	lea TIMER1_CTRL.w,%a0
	move.b #0b10000001,(%a0)  /* clear ovl bit(6), continue running(0), enable INT(7) */	
        
	move (%sp)+,%sr 
	movem.l (%sp)+,%a0-%a6/%d0-%d7

	rte


			
/************************************************************************
 * int _ll_system(char *name)
 	executes the "name" command, then resumes execution
 ************************************************************************/
_ll_system:
#ifdef USE_JADOS
	movem.l %a6,-(%a7)	/* used by jados frame-pointer */
	movea.l 8(%sp),%a0
	moveq #__cmdexec,%d7
	trap #6
	movem.l (%a7)+,%a6
	moveq.l #0,%d0
#endif
	rts
/************************************************************************
 * int _ll_getenv(char *buf, int id)
 	returns number of environment-variables
 	for now we return NULL
 	*buf is a pointer to the env variables
 ************************************************************************/
_ll_getenv:
	move.l #0,%d0
	rts
	
/*
char keyci(void);
*/
keyci:	.global keyci
	movem.l %d1/%d7/%a0-%a2, -(%sp)
#ifdef M68000
	lea keyqueue, %a0
	lea kqanz, %a1
	lea kqstart, %a2
#else
	lea keyqueue(%pc), %a0
	lea kqanz(%pc), %a1
	lea kqstart(%pc), %a2
#endif
	move #_CURSEIN, %d7
	trap #1
keyci01:
	move #_AUTOFLIP, %d7
	trap #1
 	tst (%a1)			// kqanz
	beq.s keyci01			// Warten auf Zeichen

	move (%a2), %d1			// kqstart
	move.b 0(%a0, %d1.w), %d0
	addq #1, %d1			// Queue-Start ein nach hinten
	and #0xff, %d1			// auf 0..255 bringen
	move %d1, (%a2)			// kqstart speichern
	sub #1, (%a1)			// kqanz - Anzahl reduzieren
	
	move #_CURSAUS, %d7
	trap #1
	
	movem.l (%sp)+, %d1/%d7/%a0-%a2
	rts   
		

/*
Ohne GP !

char _keyci(void);
*/
_keyci:	.global _keyci
	movem.l %d1/%d7/%a0-%a2, -(%sp)
#ifdef M68000
	lea keyqueue, %a0
	lea kqanz, %a1
	lea kqstart, %a2
#else
	lea keyqueue(%pc), %a0
	lea kqanz(%pc), %a1
	lea kqstart(%pc), %a2
#endif
/*
	move #_CURSEIN, %d7
	trap #1
*/	
_keyci01:
/*
	move #_AUTOFLIP, %d7
	trap #1
*/
 	tst (%a1)			// kqanz
	beq.s _keyci01			// Warten auf Zeichen

	move (%a2), %d1			// kqstart
	move.b 0(%a0, %d1.w), %d0
	addq #1, %d1			// Queue-Start ein nach hinten
	and #0xff, %d1			// auf 0..255 bringen
	move %d1, (%a2)			// kqstart speichern
	sub #1, (%a1)			// kqanz - Anzahl reduzieren
/*	
	move #_CURSAUS, %d7
	trap #1
*/	
	movem.l (%sp)+, %d1/%d7/%a0-%a2
	rts   

/*
Ohne GP !

char _keypressed(void);
*/
_keypressed:	.global _keypressed	
#ifdef M68000
	lea kqanz, %a1	
#else
	lea kqanz(%pc), %a1
#endif
	move (%a1),%d0
	rts   


.data

oldint74:	ds.l 1	
oldint7c:	ds.l 1	
ticks:		ds.l 1

/* Key Variablen */

keyqueue:	ds.b 256		/* 256B Zeichenpuffer */
kqstart:	ds.w 1
kqend:		ds.w 1
kqanz:		ds.w 1


ctrlctxt: 	.ascii " Ctrl-C"
		.byte 0x0d,0x0a,0x00
dot: 		.ascii "."
		.byte 0x00	

buffer:   ds.b 256        /* 256B debug buffer */			
		
		


