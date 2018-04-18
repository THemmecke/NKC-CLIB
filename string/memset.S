	.text

	.global memset
	
/*
	void *memset(void *str, int c, size_t n)
*/		

memset:
	move.l	(12,%a7),%d1	/* count n	 */
	move.l	(8,%a7),%d2		/* int c	 */
	move.l	(4,%a7),%a0		/* dest	*str */
	move.l	%a0,%d0			/* dest		 */
lp:
	move.b	%d2,(%a0)+
	subq.l	#1,%d1
	bne	lp
	move.l	%d0,%a0
	rts
	