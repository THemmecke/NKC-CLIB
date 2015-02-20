	.text
	.global memcpy
	
/*
	void *memcpy(void *dest, const void *src, size_t n)
*/		

memcpy:
	move.l	(12,%a7),%d1	        /* count	*/
	move.l	(8,%a7),%a1		/* src		*/
	move.l	(4,%a7),%a0		/* dest		*/
	move.l	%a0,%d0			/* save dest	*/
lp:
	move.b	(%a1)+,(%a0)+
	subq	#1,%d1
	bne	lp
	move.l	%d0,%a0          /* pointer must be returned in %a0 in gcc */
	rts
