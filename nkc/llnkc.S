#include "../nkc/nkc.h"
#include "../nkc/macros.h"

	.text

/*

 --------------------------------------------------- Hier folgend GrundProgramm- und JADOS-Aufrufe, die könnten noch in ein eigenes File ---------------------------------------------------

*/ 	


/*    --------- AUFRUFE IN's GRUNDPROGRAMM ----------  */
 	
/*
void nkc_clrscr(void);
*/ 	
nkc_clrscr: .global nkc_clrscr
	clrscr
	rts

/*
unsigned char nkc_kbhit(void);
*/	
nkc_kbhit: .global nkc_kbhit
	moveq #_CSTS,%d7
	trap #1
	rts
/*
 void nkc_write(char* message)
*/
nkc_write: .global nkc_write

	
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
 void nkc_getxy(unsigned char *x, unsigned char *y)
*/
nkc_getxy: .global nkc_getxy

	
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
 void nkc_setxy(unsigned char x, unsigned char y)
*/
nkc_setxy: .global nkc_setxy
	
	movem.l %a0-%a6/%d0-%d7,-(%a7)      
	move.b 67(%sp),%d1	/* x */
        move.b 71(%sp),%d2	/* y */
        moveq #_SETCURXY,%d7
 	trap #1
	movem.l (%a7)+,%a0-%a6/%d0-%d7
	rts 		

	
/*
 void nkc_write_hex2(unsigned char val)
*/	  
nkc_write_hex2: .global nkc_write_hex2
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
 void nkc_write_hex8(unsigned int val)
 
*/	  	  
nkc_write_hex8: .global nkc_write_hex8
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
 void nkc_write_dec_dw(unsigned int val)
*/	  
nkc_write_dec_dw: .global nkc_write_dec_dw
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
char nkc_getchar(void);
*/
nkc_getchar: .global nkc_getchar
	movem.l %a0-%a6/%d1-%d7,-(%a7)
        moveq #_CI,%d7
        trap #1       
        movem.l (%a7)+,%a0-%a6/%d1-%d7
	rts

/*
 void nkc_putchar(char c)
*/
nkc_putchar: .global nkc_putchar

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
 void nkc_curoff(void)
*/
nkc_curoff: .global nkc_curoff
	moveq #_CUROFF,%d7 /* Cursor ausschalten */
	trap #1
	rts

/*
 void nkc_curon(void)
*/
nkc_curon: .global nkc_curon
	moveq #_CURON,%d7 /* Cursor einschalten */
	trap #1
	rts	

/*
 void nkc_setflip(unsigned char flip2pages, unsigned char flip4pages)
*/
nkc_setflip: .global nkc_setflip
	clr.l %d0
	clr.l %d1
    move.b 7(%sp),%d0   /* Blinkrate für 2-Seiten-Umschaltung */
    move.b 11(%sp),%d1  /* Blinkrate für 4-Seiten-Umschaltung */
	moveq #_SETFLIP,%d7 /* Fliprate setzen */
	trap #1
	rts	

/*
 void nkc_setpage(unsigned char writepage, unsigned char viewpage)
*/
nkc_setpage: .global nkc_setpage
	clr.l %d0
	clr.l %d1
    move.b 7(%sp),%d0   /* writepage */
    move.b 11(%sp),%d1  /* viewpage */
	moveq #_NEWPAGE,%d7 /* setzen */
	trap #1
	rts		

	  
/*  -------------------------- JADOS FUNKTIONEN ------------------------------- */ 	
/*
 UCHAR nkc_fillfcb(struct fcb *FCB,char *name)
 returns 0 if successful
*/	
nkc_fillfcb: .global nkc_fillfcb 	
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
 UCHAR nkc_open(struct fcb *FCB)
 returns 0 if successful
*/	
nkc_open: .global nkc_open 	
	movem.l %a6,-(%a7)	/* used by jados frame-pointer */
	movea.l 8(%sp),%a1 	/* *fcb  */
	moveq #__open,%d7
	trap #6
	movem.l (%a7)+,%a6
	rts
	
/*
 UCHAR nkc_create(struct fcb *FCB)
 returns 0 if successful
*/	
nkc_create: .global nkc_create 	
	movem.l %a6,-(%a7)	/* used by jados frame-pointer */
	movea.l 8(%sp),%a1 	/* *fcb  */
	moveq #__create,%d7
	trap #6
	movem.l (%a7)+,%a6
	rts	

/*
 void nkc_close(struct fcb *FCB)
*/	
nkc_close: .global nkc_close 	
	movem.l %a6,-(%a7)	/* used by jados frame-pointer */
	movea.l 8(%sp),%a1 	/* *fcb  */
	moveq #__close,%d7
	trap #6
	movem.l (%a7)+,%a6
	rts
	
/*
 UCHAR nkc_erase(struct fcb *FCB)
 
 result	Bedeutung
		0	Datei gelöscht
		2	Datei nicht vorhanden
		0xff	Fehler beim Zugriff auf den Massenspeicher
		
		Achtung: falls die Datei schon existiert, wird sie lediglich geöffnet !
		
*/	
nkc_erase: .global nkc_erase 	
	movem.l %a6,-(%a7)	/* used by jados frame-pointer */
	movea.l 8(%sp),%a1 	/* *fcb  */
	moveq #__erase,%d7
	trap #6
	movem.l (%a7)+,%a6
	rts			

/*
 UCHAR nkc_readrec(struct fcb *FCB)
 returns 	   0 - if successful
 		   1 - EOF
 		  99 - end of memory
 		0xFF - access error 
*/	
nkc_readrec: .global nkc_readrec
	movem.l %a6,-(%a7)	/* used by jados frame-pointer */
	movea.l 8(%sp),%a1 	/* *fcb  */
	moveq #__readrec,%d7
	trap #6
	movem.l (%a7)+,%a6
	rts		

/*
 UCHAR nkc_writerec(struct fcb *FCB)
 returns 	   0 - if successful
 		   5 - disk full
 		0xFF - access error 
*/	
nkc_writerec: .global nkc_writerec
	movem.l %a6,-(%a7)	/* used by jados frame-pointer */
	movea.l 8(%sp),%a1 	/* *fcb  */
	moveq #__writerec,%d7
	trap #6
	movem.l (%a7)+,%a6
	rts		

/*
 UCHAR nkc_setrec(struct fcb *FCB, int sector)
 returns 	   0 - if successful
 		   1 - EOF
 		0xFF - access error 
*/	
nkc_setrec: .global nkc_setrec	
	movem.l %a6,-(%a7)	/* used by jados frame-pointer */
	movea.l 8(%sp),%a1 	/* *fcb  */
	move.l 12(%sp),%d1 	/* sector  */
	moveq #__setrec,%d7
	trap #6
	movem.l (%a7)+,%a6
	rts		
	
/*
 void nkc_setdta(struct fcb *FCB, void* buffer)
*/	
nkc_setdta: .global nkc_setdta
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