	.text
	.global strpbrk
	
/*
	char * strpbrk(const char *string1, const char *string2)
*/		

strpbrk:
	lea	(4,%A7),%A0
	move.l	a2,-(%sp)
	move.l	(4,%a0),%a1	/* string2 	*/
	move.l	(%a0),%a2	/* string1	*/
	clr.l	%d0
lp:
	tst.b	(%a2)
	beq.b	out
	move.b	(%a2)+,%d1
	move.l	%a1,%a0
lp1:
	tst.b	(%a0)
	beq.b	lp
	cmp.b	(%a0)+,%d1
	bne.b	lp1
out2:
	move.l	%a0,%d0
out:
	move.l  %d0,%a0
	move.l	(%sp)+,%a2
	rts
	
