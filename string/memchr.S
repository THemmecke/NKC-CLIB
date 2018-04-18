	.text
	.global _memchr
	
/*
	void *memchr(const void *s, int c, size_t n)
*/		

_memchr:
	move.l	(12,%a7),%d2	/* downward count */
	move.l	(8,%a7),%d1		/* char		*/
	move.l  (4,%A7),%a0		/* buffer */
lp:
	cmp.b	(%a0),%d1
	beq.b	out
	tst.b	(%a0)
	beq.b	badout
	addq.l	#1,%a0
	subq.l	#1,%d2
	bne	lp
badout:
	clr.l	%d0
out:
	//move.l	%a0,%d0
	rts
	
