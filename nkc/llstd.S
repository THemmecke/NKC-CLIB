#include "../nkc/nkc.h"
#include "../nkc/macros.h"

/*
#define _F_READ	= 1
#define _F_WRIT = 2
#define _F_LBUF = 8
#define FILTOK = 0x444c  
#define _N_FILE = 100
*/
.equ	_F_READ,1
.equ	_F_WRIT,2
.equ	_F_LBUF,8
.equ	FILTOK,0x444c
.equ	NOFILTOK,0x5555
.equ	_N_FILE,100

	.data 
	.global stdin, stdout, stderr
	.global output_file, error_file

inbuf:	.space	512,0
outbuf:	.space	512,0
errbuf:	.space	512,0

output_file:
	dc.l 0					/* level 	+0  */
	dc.l (_F_WRIT | _F_READ | _F_LBUF)	/* flags 	+4  */
	dc.b 1					/* fd    	+8  */
	dc.b 0					/* hold  	+9  */
	dc.l 1					/* bsize 	+10 */
	dc.l inbuf				/* bufp  	+14 */
	dc.l outbuf				/* curp  	+18 */
	dc.l 0					/* istemp	+22 */
	dc.w FILTOK				/* token 	+26 */
	
error_file:
	dc.l 0					/* level */
	dc.l (_F_WRIT |  _F_LBUF)		/* flags */
	dc.b 2					/* fd    */
	dc.b 0					/* hold  */
	dc.l 1					/* bsize */
	dc.l errbuf				/* bufp  */
	dc.l errbuf				/* curp  */
	dc.l 0					/* istemp*/
	dc.w FILTOK				/* token */
	
stdin:	dc.l	output_file
stdout:	dc.l	output_file
stderr:	dc.l	error_file

	.text
	.global   _ll_read, _ll_write


/*****************************************************************************
 * int _ll_write(int fd, void *buf, int size)
 *****************************************************************************/ 
_ll_write:
	movem.l %a2-%a6/%d2-%d7,-(%a7)  /* save registers */

	//writeln msg05(%pc)
	
 	move.l 52(%sp),%d0		/* *buf */
	move.l 56(%sp),%d1		/* size */
	move.l 48(%sp),%d2		/* fd   */	
	
	
	cmp.l #1,%d2			/* stdout ? */	
	beq _ll_write_L0		/* ja -> Ausgabe auf Bldschirm */
	cmp.l #2,%d2			/* stderr ? */	
	beq _ll_write_L0		/* ja -> Ausgabe auf Bldschirm */
	
	bra _ll_write_file		/* nein -> Ausgabe in Datei */
	
_ll_write_L0:	
	move.l %d0,%a0	  		/* Buffer ausgeben */
	sub.l #1,%d1			/* Schleifenzähler */
_ll_write_L1:
        move.b (%a0)+,%d0
        moveq #_CO2,%d7
        trap #1        
        dbra %d1, _ll_write_L1
        
_ll_write_L2:	  
	move.l 56(%sp),%d0		/* wir geben jetzt einfach mal size zurück */
	bra _ll_write_end
	
	
_ll_write_file:				/* Ausgabe in Datei (Handle in %d2) */							
	move.l %d1,-(%sp)
	move.l %d0,-(%sp)
	move.l %d2,-(%sp)
	//jsr jfwrite(%pc)
	jsr __ll_write(%pc)
	add.l #12,%sp
	
	bra _ll_write_end	
	
_ll_write_err:
	clr.l %d0			/* return NULL */
					/* return value nach d0 */
_ll_write_end:					
	movem.l (%a7)+,%a2-%a6/%d2-%d7	/* restore registers */
	rts
/*****************************************************************************
 * int _ll_read(int fd, void *buf, int size)
   returns number of read characters
 *****************************************************************************/ 
_ll_read:
	movem.l %a2-%a6/%d2-%d7,-(%a7)  /* save registers: -> 11x4(saved registers) + 1x4(saved pc) = 48(sp-offset) */

	//writeln msg01(%pc)
	
 	move.l 52(%sp),%d0		/* *buf */
	move.l 56(%sp),%d1		/* size */
	move.l 48(%sp),%d2		/* fd   */	
	
	
	cmp.l #1,%d2			/* stdin ? */	
	beq _ll_read_L0			/* ja -> Tastatur abfragen */
	bra _ll_read_file		/* nein -> Aus Datei lesen */	
	
_ll_read_L0:	
	move.l %d0,%a0	  		/* Buffer laden */
	sub.l #1,%d1			/* Schleifenzähler */
_ll_read_L1:        

	/*bsr.l keyci Problem mit 68000 (illegal instruction) => dem Compiler überlassen */
#ifdef M68000
	jsr keyci				/* -> llmisc.S */
#else
	bsr keyci
#endif

_ll_read_L2:         
        move.b %d0,(%a0)+
        dbra %d1, _ll_read_L1	

_ll_read_L3:	  
	move.l 56(%sp),%d0		/* wir geben jetzt einfach mal size zurück */
	bra _ll_read_end
	
	
_ll_read_file:				/* Lesen aus Datei Datei (Handle in %d2) */							
	move.l %d1,-(%sp)		/* size */
	move.l %d0,-(%sp)		/* *buf */
	move.l %d2,-(%sp)		/* fd */
	//jsr jfread(%pc)
	jsr __ll_read(%pc)		/* -> fs.c __ll_read */
	add.l #12,%sp
	bra _ll_read_end	
	
_ll_read_err:
	clr.l %d0			/* return NULL */
					/* return value nach d0 */
_ll_read_end:						
	movem.l (%a7)+,%a2-%a6/%d2-%d7	/* restore registers */
	rts
	
	

// the lea instruction can only load (d16,pc) addresses on 68000 (on 68020 (d32,pc) is possible)
// separation of data leads to "relocation truncated to fit: R_68K_PC16 against `.data'"


.data


buffer:		ds.b 256 

msg01:	.ascii "_ll_read_"
	.byte	0xd,0xa,0
	
	
msg02:	.asciz " buffer = 0x"
msg03:	.asciz " size   = 0x"
msg04:	.asciz " fd     = 0x"

msg05:	.ascii "_ll_write_"
	.byte	0xd,0xa,0
	
crlf:    .byte 0xd,0xa,0
	

	
