.text
.global _ll_malloc,_ll_free,_ll_transfer


#include "macros.h"

/*****************************************************************************
 *                void *_ll_malloc(int size)*/				     *
 *****************************************************************************/
 
/*

*/
_ll_malloc:
				/* Bereichsprüfung... */
	move.l 4(%sp),%d1	/* size     */
	add.l _BREAK,%d1	/* + _BREAK */
	add.l #1024,%d1		/* + 1KB    */
	clr.l %d0
	
	cmp.l %sp,%d1		/* %sp > %d1  ?   eff.  %d1-%sp -> cc Ergebniss muss negativ sein == N-Flag set */
	ble _ll_malloc_end
	

	move.l 4(%sp),%d1  	/* size   */
	addq.l #1,%d1		/* size+1 */
	move.l _BREAK,%d0	/* aktuelle _BREAK Variable nach %d0 */
	move.l %d0,%a0		
	add.l  %d1,%a0		
	move.l %d0,(%a0)+	/* alten _BREAK Wert sichern und %a0 +1 */
	move.l %a0,_BREAK	/* %a0 ist neue _BREAK Variable         */
				/* in %d0 steht der alte _BREAK Wert = Zeiger auf allokierten  Bereich */
_ll_malloc_end:				
	rts


/*****************************************************************************
 *                void _ll_free(void *block)				     *
 *     (nur der oberste Block auf dem HEAP kann freigegeben werden     )     *
 *****************************************************************************/
_ll_free:
	move.l 4(%sp),%d0  	/* *block */
	move.l _BREAK,%a0
	move.l -1(%a0),%d1	/* Zeiger auf letzten Speicherbereich holen */
	cmp.l	%d0,%d1		/* und mit *block vergleichen */
	bne _ll_free_end	/* wenn nicht gleich, dann ENDE */
	
	move.l -1(%a0),_BREAK	/* sonst letzten Block freigeben */
	
_ll_free_end:
	rts
	
/*****************************************************************************
 *                void _ll_transfer(void)				     *
 *****************************************************************************/

_ll_transfer:
	writeln msg00(%pc)
	rts

.data
msg00:	.ascii " _ll_transfer" 	
	.byte 0x0d,0x0a,0x00


buffer:	ds.b 255		

