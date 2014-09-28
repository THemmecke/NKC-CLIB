#include "../nkc/macros.h"

	.text
	.global exit
exit:
	move.l	(4,%A7),%d0
	/*move.l	(__rexit,%pc),(%a7)*/
	lea __rexit(%pc),%a0
	move.l %a0,(%a7)
	rts
	
buffer:	ds.b 255	
