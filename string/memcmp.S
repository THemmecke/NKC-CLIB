	.text
	.global memcmp

/*	
	int memcmp(const void *s1, const void *s2, size_t n)
*/
	
memcmp:
	move.l 	(12,%a7),%d0	/* size */
	beq.b	zerout
	move.l  (8,%a7),%a1		/* buf2	*/
	move.l	(4,%A7),%a0		/* buf1 */
lp:
	move.b	(%a1)+,%d1
	cmp.b	(%a0),%d1
	beq.b	lp2
	blo.b	posout
	bhi.b	negout
lp2:
	addq.l	#1,%a0
	subq.l	#1,%d0
	bne	lp
zerout:
   	clr.l	%d0
	rts
posout:
	clr.l	%d0
	addq.l	#1,%d0
	rts
negout:
	clr.l	%d0
	subq.l	#1,%d0
	rts
