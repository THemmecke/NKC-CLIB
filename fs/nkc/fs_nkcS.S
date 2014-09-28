#include "../../nkc/nkc.h"
#include "../../nkc/macros.h"

	.text 
	.global _nkc_remove, _nkc_rename, _nkc_get_drive, _nkc_set_drive
	
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
	
	
.data

buffer:	ds.b 255	
