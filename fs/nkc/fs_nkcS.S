#include "../../nkc/nkc.h"
#include "../../nkc/macros.h"

	.text 
	.global _nkc_remove, _nkc_rename, _nkc_get_drive, _nkc_set_drive, _nkc_directory
	
/*****************************************************************************
 * int _nkc_remove(char *name)
  * delete file
 *****************************************************************************/                                       
_nkc_remove:
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
 * int _nkc_rename(char *old , char *new)
 * Rename a file (DOS function 56h,Int21)
 * z.B. rename C:/Mydir/myfile.dat c:/newdir/otherfile.dat
 *****************************************************************************/                                      
_nkc_rename:
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
 * int _nkc_get_drive();
 *
 * Return vaules:
 * 	0 		= ramdisk
 *	1..4 	= disk 1..4
 *  5..30 	= harddisk partition A..Z
 *****************************************************************************/ 
_nkc_get_drive:
	movem.l %d7/%a2/%a6,-(%sp)	/* used by jados frame-pointer */
	clr.l %d0
	moveq #__getdrive,%d7		/* call jados */
	trap #6
	movem.l (%sp)+, %d7/%a2/%a6
	rts
/*****************************************************************************
 * void _nkc_set_drive(int drive);
 *
 * input:
 * 	0 		= ramdisk
 *	1..4 	= disk 1..4
 *  5..30 	= harddisk partition A..Z
 *****************************************************************************/  	
_nkc_set_drive:
	movem.l %d7/%a2/%a6,-(%sp)	/* used by jados frame-pointer */
	move.l 16(%sp),%d0  		/* drive */
	moveq #__setdrive,%d7		/* call jados */
	trap #6
	movem.l (%sp)+, %d7/%a2/%a6
	rts 

/*****************************************************************************
 * BYTE _nkc_directory(void* pbuf, void* ppattern, BYTE attrib, BYTE columns, DWORD size);
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
 *		0x0028   40	size		(DWORD)
 *		0x0024	 36+3	columns 	(BYTE)
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
_nkc_directory:
        movem.l %d7/%a2/%a6,-(%sp)      /* used by jados frame-pointer */
	movem.l %d2/%d3,-(%sp)		/* save used regs (%a0,%a1,%d0,%d1 are scratch regs) */

        movea.l 24(%sp),%a0             /* pbuf */
	movea.l 28(%sp),%a1		/* ppattern */
	move.b  35(%sp),%d2		/* attrib */
	move.b  39(%sp),%d3		/* columns */
	move.l  40(%sp),%d1		/* size */
	
        moveq #__directory,%d7           /* call jados */
        trap #6

	movem.l (%sp)+, %d2/%d3		/* restore used regs */
        movem.l (%sp)+, %d7/%a2/%a6	/* restore jados frame-pointer */
        rts

	
	
.data

buffer:	ds.b 255	
