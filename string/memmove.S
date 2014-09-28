	.text
	.global memmove

/*
	void *memmove(void *dest, const void *src, size_t n)
*/
	
memmove:
	move.l	(12,%a7),%d1	/* count	*/
	move.l	(8,%a7),%a1	/* src		*/
	move.l	(4,%a7),%a0	/* dest		*/
	move.l	%a0,%d0		/* dest		*/
	cmp.l	%a1,%a0
	bcc	negmove
lp:
	move.b	(%a1)+,(%a0)+
	subq	#1,%d1
	bne	lp
	move.l %d0,%a0
	rts
negmove:
	add.l	%d1,%a1
	add.l	%d1,%a0
lp1:
	move.b	-(%a1),-(%a0)
	subq	#1,%d1
	bne	lp1
	move.l %d0,%a0
	rts
