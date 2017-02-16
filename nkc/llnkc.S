#include "../nkc/nkc.h"
#include "../nkc/macros.h"

	.text

/*

 --------------------------------------------------- Hier folgend GrundProgramm- und JADOS-Aufrufe, die könnten noch in ein eigenes File ---------------------------------------------------

 Note:
 
 native calls are prefixed nkc_
 gp calls are prefixed gp_
 jados calls are prefixed jd_
 
*/ 


/* ------------- native calls, no GP no JADOS ----------------- */


/*
void nkc_init_ser1(unsigned char control, unsigned char command);
*/

nkc_init_ser1: .global nkc_init_ser1 
	clr.l %d0
	clr.l %d1
	move.b 7(%sp),%d0	/* control */
        move.b 11(%sp),%d1	/* command */
        move.b %d0,NKC_SER1_CTRL
        move.b %d1,NKC_SER1_CMD                       
	rts 
/*
char nkc_ser1_getchar(void);	

  wait for user input on serial line 
  returns input with echo on serial line

*/

nkc_ser1_getchar: .global nkc_ser1_getchar
	btst.b #3,NKC_SER1_STAT
	beq nkc_ser1_getchar
	move.b	NKC_SER1_RX,%d0
	bsr nkc_wait_ser1_tx_empty
	move.b %d0,NKC_SER1_TX
	rts

	
/*
void nkc_se1r_putchar(char c);
*/

nkc_ser1_putchar: .global nkc_ser1_putchar			
	clr.l %d0
	move.b 7(%sp),%d0	
	cmp.b #0x0a,%d0				/* insert CR before LF */
	bne.s nkc_ser1_putchar_1
	bsr nkc_wait_ser1_tx_empty
	move.b #0x0d,NKC_SER1_TX
	move.b 7(%sp),%d0
nkc_ser1_putchar_1:	
        bsr nkc_wait_ser1_tx_empty
	move.b %d0,NKC_SER1_TX
	rts
	
/*
void nkc_ser1_write(char *str);
*/

nkc_ser1_write: .global nkc_ser1_write	
	movea.l 4(%sp),%a0
	bsr nkc_wait_ser1_tx_empty
nkc_ser1_write_1:	
	move.b (%a0)+,%d0
	cmp.b #0x0a,%d0		/* ist it a LF ? */
	bne.s nkc_ser1_write_2
	move.l %d0,-(%sp)       /* yes, let putchar handle this */
	bsr nkc_ser1_putchar
	add.l #4,%sp
	bsr nkc_wait_ser1_tx_empty
	bra nkc_ser1_write_1
nkc_ser1_write_2:        
	move.b %d0,NKC_SER1_TX
	beq.s nkc_ser1_write_end
	bsr nkc_wait_ser1_tx_empty
	bra nkc_ser1_write_1
nkc_ser1_write_end:	
	rts


nkc_wait_ser1_tx_empty:	
	btst.b #4,NKC_SER1_STAT
	beq nkc_wait_ser1_tx_empty
	rts
	
/*    --------- calls to GP (trap #1) ----------  */

/*
void gp_ser1_write_dec_dw(unsigned int val); 
*/

gp_ser1_write_dec_dw: .global gp_ser1_write_dec_dw
	move.l 4(%sp),%d0
#ifdef M68000
	LEA32A0 buffer
#else
	lea buffer(%pc),%a0
#endif
        moveq #_PRINT8D,%d7
        trap #1
#ifdef M68000
	LEA32A0 buffer        
#else
	lea buffer(%pc),%a0
#endif
	move.l %a0,-(%sp)
	bsr nkc_ser1_write
	add.l #4,%sp		/* Stack aufräumen */
	rts	

/*
 void gp_ser1_write_hex8(unsigned int val)
 
*/	  	  
gp_ser1_write_hex8: .global gp_ser1_write_hex8
	move.l 4(%sp),%d0
#ifdef M68000
	LEA32A0 buffer
#else
	lea buffer(%pc),%a0
#endif
        moveq #_PRINT8X,%d7
        trap #1
#ifdef M68000
	LEA32A0 buffer        
#else
	lea buffer(%pc),%a0
#endif
	move.l %a0,-(%sp)
	bsr nkc_ser1_write
	add.l #4,%sp		/* Stack aufräumen */
	rts	
	

 	
/*
void gp_clrscr(void);
*/ 	
gp_clrscr: .global gp_clrscr
	clrscr
	rts

/*
unsigned char gp_kbhit(void);
*/	
gp_kbhit: .global gp_kbhit
	moveq #_CSTS,%d7
	trap #1
	rts
/*
 void gp_write(char* message)
*/
gp_write: .global gp_write

	
	movem.l %a0-%a6/%d0-%d7,-(%a7)      
	movea.l 64(%sp),%a0	

1:
        move.b (%a0)+,%d0
        beq 3f
	cmp.b #0x0A,%d0
	bne 2f
	move.l #0x0D,%d0
	moveq #_CO2,%d7
        trap #1
        move.l #0x0A,%d0  
              	
2:      moveq #_CO2,%d7
        trap #1
        bra 1b
3:	  
	movem.l (%a7)+,%a0-%a6/%d0-%d7
	rts 	

/*
 void gp_read(unsigned char x, unsigned char y, char* buffer)
*/
gp_read: .global gp_read

	
	movem.l %a0-%a6/%d0-%d7,-(%a7) 
	moveq #0x11,%d0		/* Schriftgrösse */
	moveq #25,%d3		/* max. Anzahl Zeichen */
	move.l 67(%sp),%d1	/* *x */
        move.l 71(%sp),%d2	/* *y */
        movea.l 72(%sp),%a0	/* buffer */
        moveq #_READ,%d7
 	trap #1
	movem.l (%a7)+,%a0-%a6/%d0-%d7
	rts 
	
/*
MOVEQ #$22,D0 * Schriftgröße
MOVEQ #10,D1 * X = 10
MOVEQ #100,D2 * Y = 100
MOVEQ #12,D3 * Maximal 12 Zeichen
LEA BUFFER(PC),A0 * Adresse des Buffers
MOVEQ #!READ,D7 * Text einlesen
TRAP #1
RTS
*/
/*
 void gp_getxy(unsigned char *x, unsigned char *y)
*/
gp_getxy: .global gp_getxy

	
	movem.l %a0-%a6/%d0-%d7,-(%a7)      
	movea.l 64(%sp),%a0	/* *x */
        movea.l 68(%sp),%a1	/* *y */
        moveq #_GETCURXY,%d7
 	trap #1
 	move.b %d1,(%a0)           /* d1=X (0..79)*/
 	move.b %d2,(%a1)           /* d2=Y (0..23)*/
	movem.l (%a7)+,%a0-%a6/%d0-%d7
	rts 
	
/*
 void gp_setxy(unsigned char x, unsigned char y)
*/
gp_setxy: .global gp_setxy
	
	movem.l %a0-%a6/%d0-%d7,-(%a7)      
	move.b 67(%sp),%d1	/* x */
        move.b 71(%sp),%d2	/* y */
        moveq #_SETCURXY,%d7
 	trap #1
	movem.l (%a7)+,%a0-%a6/%d0-%d7
	rts 		

	
/*
 void gp_write_hex2(unsigned char val)
*/	  
gp_write_hex2: .global gp_write_hex2
	move.b 7(%sp),%d0
#ifdef M68000
	LEA32A0 buffer
#else
	lea buffer(%pc),%a0
#endif
        moveq #_PRINT2X,%d7
        trap #1
#ifdef M68000
	writeln buffer
#else
        writeln buffer(%pc)
#endif
	rts	
/*
 void gp_write_hex8(unsigned int val)
 
*/	  	  
gp_write_hex8: .global gp_write_hex8
	move.l 4(%sp),%d0
#ifdef M68000
	LEA32A0 buffer
#else
	lea buffer(%pc),%a0
#endif
        moveq #_PRINT8X,%d7
        trap #1
#ifdef M68000
	writeln buffer
#else
        writeln buffer(%pc)
#endif
	rts	
	
/*
 void gp_write_dec_dw(unsigned int val)
*/	  
gp_write_dec_dw: .global gp_write_dec_dw
	move.l 4(%sp),%d0
#ifdef M68000
	LEA32A0 buffer
#else
	lea buffer(%pc),%a0
#endif
        moveq #_PRINT8D,%d7
        trap #1
#ifdef M68000
	writeln buffer
#else
        writeln buffer(%pc)
#endif
	rts	
			  
/*
char gp_getchar(void);
*/
gp_getchar: .global gp_getchar
	movem.l %a0-%a6/%d1-%d7,-(%a7)
        moveq #_CI,%d7
        trap #1       
        movem.l (%a7)+,%a0-%a6/%d1-%d7
	rts

/*
 void gp_putchar(char c)
*/
gp_putchar: .global gp_putchar

	move.b 7(%sp),%d0	  

        beq 3f
	cmp.b #0x0A,%d0
	bne 2f
	move.l #0x0D,%d0
	moveq #_CO2,%d7
        trap #1
        move.l #0x0A,%d0  
              	
2:      moveq #_CO2,%d7
        trap #1
        //bra 1b
3:	  
	
	  rts 	

/*
 void gp_curoff(void)
*/
gp_curoff: .global gp_curoff
	moveq #_CUROFF,%d7 /* Cursor ausschalten */
	trap #1
	rts

/*
 void gp_curon(void)
*/
gp_curon: .global gp_curon
	moveq #_CURON,%d7 /* Cursor einschalten */
	trap #1
	rts	

/*
 void gp_setflip(unsigned char flip2pages, unsigned char flip4pages)
*/
gp_setflip: .global gp_setflip
	clr.l %d0
	clr.l %d1
    move.b 7(%sp),%d0   /* Blinkrate für 2-Seiten-Umschaltung */
    move.b 11(%sp),%d1  /* Blinkrate für 4-Seiten-Umschaltung */
	moveq #_SETFLIP,%d7 /* Fliprate setzen */
	trap #1
	rts	

/*
 void gp_setpage(unsigned char writepage, unsigned char viewpage)
*/
gp_setpage: .global gp_setpage
	clr.l %d0
	clr.l %d1
    move.b 7(%sp),%d0   /* writepage */
    move.b 11(%sp),%d1  /* viewpage */
	moveq #_NEWPAGE,%d7 /* setzen */
	trap #1
	rts		

	  
#ifdef USE_JADOS
/*  -------------------------- calls to JADOS (trap #6) ------------------------------- */ 	
/*
 UCHAR jd_fillfcb(struct fcb *FCB,char *name)
 returns 0 if successful
*/	
jd_fillfcb: .global jd_fillfcb 	
	movem.l %a6,-(%a7)	/* used by jados frame-pointer */
	movea.l 12(%sp),%a0  	/* *name */
	moveq #__uppercas, %d7	/* Dateinamen immer in Großbuchstaben */
	trap #6
	movea.l 8(%sp),%a1   	/* *fcb  */
	movea.l 12(%sp),%a0  	/* *name */
	moveq #__fillfcb,%d7
	trap #6
	movem.l (%a7)+,%a6
	rts

/*
 UCHAR jd_open(struct fcb *FCB)
 returns 0 if successful
*/	
jd_open: .global jd_open 	
	movem.l %a6,-(%a7)	/* used by jados frame-pointer */
	movea.l 8(%sp),%a1 	/* *fcb  */
	moveq #__open,%d7
	trap #6
	movem.l (%a7)+,%a6
	rts
	
/*
 UCHAR jd_create(struct fcb *FCB)
 returns 0 if successful
*/	
jd_create: .global jd_create 	
	movem.l %a6,-(%a7)	/* used by jados frame-pointer */
	movea.l 8(%sp),%a1 	/* *fcb  */
	moveq #__create,%d7
	trap #6
	movem.l (%a7)+,%a6
	rts	

/*
 void jd_close(struct fcb *FCB)
*/	
jd_close: .global jd_close 	
	movem.l %a6,-(%a7)	/* used by jados frame-pointer */
	movea.l 8(%sp),%a1 	/* *fcb  */
	moveq #__close,%d7
	trap #6
	movem.l (%a7)+,%a6
	rts
	
/*
 UCHAR jd_erase(struct fcb *FCB)
 
 result	Bedeutung
		0	Datei gelöscht
		2	Datei nicht vorhanden
		0xff	Fehler beim Zugriff auf den Massenspeicher
		
		Achtung: falls die Datei schon existiert, wird sie lediglich geöffnet !
		
*/	
jd_erase: .global jd_erase 	
	movem.l %a6,-(%a7)	/* used by jados frame-pointer */
	movea.l 8(%sp),%a1 	/* *fcb  */
	moveq #__erase,%d7
	trap #6
	movem.l (%a7)+,%a6
	rts			

/*
 UCHAR jd_readrec(struct fcb *FCB)
 returns 	   0 - if successful
 		   1 - EOF
 		  99 - end of memory
 		0xFF - access error 
*/	
jd_readrec: .global jd_readrec
	movem.l %a6,-(%a7)	/* used by jados frame-pointer */
	movea.l 8(%sp),%a1 	/* *fcb  */
	moveq #__readrec,%d7
	trap #6
	movem.l (%a7)+,%a6
	rts		

/*
 UCHAR jd_writerec(struct fcb *FCB)
 returns 	   0 - if successful
 		   5 - disk full
 		0xFF - access error 
*/	
jd_writerec: .global jd_writerec
	movem.l %a6,-(%a7)	/* used by jados frame-pointer */
	movea.l 8(%sp),%a1 	/* *fcb  */
	moveq #__writerec,%d7
	trap #6
	movem.l (%a7)+,%a6
	rts		

/*
 UCHAR jd_setrec(struct fcb *FCB, int sector)
 returns 	   0 - if successful
 		   1 - EOF
 		0xFF - access error 
*/	
jd_setrec: .global jd_setrec	
	movem.l %a6,-(%a7)	/* used by jados frame-pointer */
	movea.l 8(%sp),%a1 	/* *fcb  */
	move.l 12(%sp),%d1 	/* sector  */
	moveq #__setrec,%d7
	trap #6
	movem.l (%a7)+,%a6
	rts		
	
/*
 void jd_setdta(struct fcb *FCB, void* buffer)
*/	
jd_setdta: .global jd_setdta
	movem.l %a6,-(%a7)	/* used by jados frame-pointer */
	movea.l 8(%sp),%a1 	/* *fcb  */
	movea.l 12(%sp),%a0 	/* buffer  */	
	/*
	moveq #__setdta,%d7
	trap #6
	*/	
	move.l %a0,44(%a1)	 
	
	movem.l (%a7)+,%a6
	rts	

/*****************************************************************************
 * int jd_remove(char *name)
  * delete file
 *****************************************************************************/                                       
jd_remove: .global jd_remove
	movem.l %d7/%a6,-(%sp)	/* used by jados frame-pointer */
	movea.l 12(%sp),%a0  	/* *name */
	moveq #__uppercas, %d7	/* Dateinamen immer in Großbuchstaben */
	trap #6
#ifdef M68000
	lea buffer,%a1   	/* *fcb  <<-- !!*/
#else
	lea buffer(%pc),%a1   	/* *fcb  <<-- !!*/
#endif
	movea.l 12(%sp),%a0  	/* *name */
	moveq #__fillfcb,%d7
	trap #6
#ifdef M68000
	lea buffer,%a1 	/* *fcb  <<-- !!*/
#else
	lea buffer(%pc),%a1 	/* *fcb  <<-- !!*/
#endif
	moveq #__erase,%d7
	trap #6
	movem.l (%sp)+,%d7/%a6
	rts
	
	
/*****************************************************************************
 * int jd_rename(char *old , char *new)
 * Rename a file (DOS function 56h,Int21)
 * z.B. rename C:/Mydir/myfile.dat c:/newdir/otherfile.dat
 *****************************************************************************/                                      
jd_rename: .global jd_rename
	movem.l %d7/%a2/%a6,-(%sp)	/* used by jados frame-pointer */
	movea.l 20(%sp),%a0  	/* *newname */
	moveq #__uppercas, %d7	/* Dateinamen immer in Großbuchstaben */
	trap #6
#ifdef M68000
	lea buffer,%a1   	/* *fcb  */
#else
	lea buffer(%pc),%a1   	/* *fcb  */
#endif
	movea.l 20(%sp),%a0  	/* *newname <<--! */
	moveq #__fillfcb,%d7
	trap #6
	movea.l %a1, %a2
	movea.l 16(%sp),%a0  	/* *oldname */
	moveq #__uppercas, %d7	/* Dateinamen immer in Großbuchstaben */
	trap #6
#ifdef M68000
	lea buffer,%a1     /* <<--- !! */
#else
	lea buffer(%pc),%a1     /* <<--- !! */
#endif
	adda.l #64, %a1   	/* *fcb  */
	movea.l 16(%sp),%a0  	/* *oldname */
	moveq #__fillfcb,%d7
	trap #6
	moveq #__rename, %d7
	trap #6
	movem.l (%sp)+, %d7/%a2/%a6
	rts

/*****************************************************************************
 * int jd_get_drive();
 *
 * Return vaules:
 * 	0 		= ramdisk
 *	1..4 	= disk 1..4
 *  5..30 	= harddisk partition A..Z
 *****************************************************************************/ 
jd_get_drive: .global jd_get_drive
	movem.l %d7/%a2/%a6,-(%sp)	/* used by jados frame-pointer */
	clr.l %d0
	moveq #__getdrive,%d7		/* call jados */
	trap #6
	movem.l (%sp)+, %d7/%a2/%a6
	rts
/*****************************************************************************
 * void jd_set_drive(int drive);
 *
 * input:
 * 	0 		= ramdisk
 *	1..4 	= disk 1..4
 *  5..30 	= harddisk partition A..Z
 *****************************************************************************/  	
jd_set_drive: .global jd_set_drive
	movem.l %d7/%a2/%a6,-(%sp)	/* used by jados frame-pointer */
	move.l 16(%sp),%d0  		/* drive */
	moveq #__setdrive,%d7		/* call jados */
	trap #6
	movem.l (%sp)+, %d7/%a2/%a6
	rts 

/*****************************************************************************
 * BYTE jd_directory(void* pbuf, void* ppattern, BYTE attrib, WORD columns, WORD size);
 *
 * input:
 *      pbuf		pointer output buffer
 *	ppattern	pointer to file pattern
 *	attrib		bitmapped file attribute: 1=file length; 2=date; 4=r/w attribute
 *	columns		number of colums for output
 *	size		size of output buffer pbuf (256x14 Bytes max.)
 *	
 * output:
 *    	buffer filled with directory entries
 *	return code: 0x00 = Success, 0xFF = Values unvalid
 *  
 * stack-frame:
 *		0x0028   40+2	size		(WORD)
 *		0x0024	 36+2	columns 	(WORD)
 *		0x0020	 32+3	attrib 		(BYTE)
 *		0x001C	 28	ppattern	(DOWRD)
 *              0x0018	 24	pbuf		(DWORD)
 *		0x0014	 20	return address
 *		0x0010	 16	saved jados frame
 *		0x000C	 12	---"---	
 *		0x0008	 8	---"---
 *		0x0004	 4	saved registers
 *	sp--->	0x0000	 0	---"---
 *****************************************************************************/
jd_directory: .global jd_directory
        movem.l %d7/%a2/%a6,-(%sp)      /* used by jados frame-pointer */
	movem.l %d2/%d3,-(%sp)		/* save used regs (%a0,%a1,%d0,%d1 are scratch regs) */

        movea.l 24(%sp),%a0             /* pbuf */
	movea.l 28(%sp),%a1		/* ppattern */
	move.b  35(%sp),%d2		/* attrib */
	move.w  38(%sp),%d3		/* columns */
	move.w  42(%sp),%d1		/* size */
	
        moveq #__directory,%d7           /* call jados */
        trap #6

	movem.l (%sp)+, %d2/%d3		/* restore used regs */
        movem.l (%sp)+, %d7/%a2/%a6	/* restore jados frame-pointer */
        rts

 jd_directory_test: .global jd_directory_test
        movem.l %d7/%a2/%a6,-(%sp)      /* used by jados frame-pointer */
	movem.l %d2/%d3,-(%sp)		/* save used regs (%a0,%a1,%d0,%d1 are scratch regs) */
	
	clr.l %d1
	clr.l %d2
	clr.l %d3
	
        movea.l 24(%sp),%a0             /* pbuf */
	movea.l 28(%sp),%a1		/* ppattern */
	move.b  35(%sp),%d2		/* attrib */
	move.w  38(%sp),%d3		/* columns */
	move.w  42(%sp),%d1		/* size */
	
	writeln msg001(%pc)
	/*
        prthex8 %a0
        crlf
        prthex8 %a1
        crlf
        */
        prthex8 %d1
        writeln buffer(%pc)
        crlf
        prthex8 %d2
        writeln buffer(%pc)
        crlf
        prthex8 %d3
        writeln buffer(%pc)
        crlf

	movem.l (%sp)+, %d2/%d3		/* restore used regs */
        movem.l (%sp)+, %d7/%a2/%a6	/* restore jados frame-pointer */
        rts
/*****************************************************************************
 * void* jd_get_ramtop(void);
 *
 * get end of user space from JAODS 
 *
 *****************************************************************************/  	
jd_get_ramtop: .global jd_get_ramtop
	movem.l %d7/%a2/%a6,-(%sp)	/* used by jados frame-pointer */	
	moveq #__ramtop,%d7		/* call jados */
	trap #6
	movem.l (%sp)+, %d7/%a2/%a6
	rts 
	
/*****************************************************************************
 * void* jd_get_gp(void);
 *
 * get start address of GP from JADOS 
 *
 *****************************************************************************/  	
jd_get_gp: .global jd_get_gp
	movem.l %d7/%a2/%a6,-(%sp)	/* used by jados frame-pointer */	
	moveq #__getgrund,%d7		/* call jados */
	trap #6
	movem.l (%sp)+, %d7/%a2/%a6
	rts 	
	
/*****************************************************************************
 * void* jd_get_laddr(void);
 *
 * get start address of user space from JADOS 
 *
 *****************************************************************************/  	
jd_get_laddr: .global jd_get_laddr
	movem.l %d7/%a2/%a6,-(%sp)	/* used by jados frame-pointer */	
	moveq #__getladdr,%d7		/* call jados */
	trap #6
	movem.l (%sp)+, %d7/%a2/%a6
	rts 		
	
#endif /* USE_JADOS */


/*
void nkc_showsp()
*/
nkc_showsp: .global nkc_showsp	
	prthex8 %a7
#ifdef M68000
	writeln buffer
#else
        writeln buffer(%pc)
#endif      
        crlf
        rts

/*  -------------------------- VERSCH. HILFS FUNKTIONEN ------------------------------- */ 	

cli:  .global cli
      lea TIMER1_CTRL.w,%a0     /* adresse ctrl-reg in a0 */
      move.b #0,(%a0)          	/* stop timer and interrupts */
      ori #0x0700, %sr		/* Interrupts aus	*/
      rts
      
sti:  .global sti
      lea TIMER1_CTRL.w,%a0     /* adresse ctrl-reg in a0 	*/
      move.b #0b10000001,(%a0)  /* start timer, enable interupt */
      andi #0xf8ff, %sr		/* Interrups freigeben	*/
      rts
      
      
      
/*
 unsigned char nkc_bcd2bin(unsigned char val)
*/	  
nkc_bcd2bin: .global nkc_bcd2bin
	clr.l %d0
	move.b 7(%sp),%d0
	BCD_TO_BIN
	rts	

/*
 unsigned char nkc_bin2bcd(unsigned char val)
*/	  
nkc_bin2bcd: .global nkc_bin2bcd
	clr.l %d0
	move.b 7(%sp),%d0	
	BIN_TO_BCD 
	rts		

/*
 unsigned char nkc_cmos_read(unsigned char index)
*/	  

nkc_cmos_read: .global nkc_cmos_read
	move.b 7(%sp),%d1
	CMOS_READ %d1
	rts
	
	

.data

buffer:		ds.b 255 	
msg001:	.ascii "jd_directory_test:" 	
	.byte 0x0d,0x0a,0x00	