	.text
	.global strstr


/*
	char * strstr(const char *s1, const char *s2);
		checks, if s2 ist contained in s1 and returns pointer to first character or NULL
*/
strstr:
	move.l	(8,%a7),%a1		/* *s2 */
	move.l	(4,%a7),%a0 	/* *s1 */
	clr.l	%d1
	move.l	%a1,-(%A7)		/* *s2 -> stack */
	
lp1:						/* length of s2 -> %d1 */
	addq	#1,%d1
	tst.b   (%a1)+
	bne.b	lp1
	subq	#1,%d1
	beq.b	badexit			/* if length == 0 -> s2 not found */
	move.l	(%a7)+,%a1		/* restore *s2 -> %a1 */
lp:							/* search s1 for s2 */
	move.b	(%a0)+,%d0		/* take next character from s1 */
	beq.b	badexit		    /* s1 ends -> s2 not found */
	cmp.b	(%a1),%d0       /* compare it with current character from s2 */
	bne.b	lp				/* not equal ? -> loop */
	subq	#1,%a0			/* if equal stay on that character and test the next character  */
	movem	%D1/%A0/%A1,-(%A7) /* save search state */
lp2:
	move.b	(%a0)+,%d0		/* compare next character */
	cmp.b 	(%a1)+,%d0
	bne.b	badcmp			/* if not equal return to first character of s2 */
	subq	#1,%d1			/* if equal, compare next character */
	bne	lp2					/* if one is left over */
	movem	(%a7)+,%D1/%A0/%A1 /* at this point we found s2 in s1, so restore address of starting character */
							/* and return it to the caller */
	rts
badcmp:
	movem	(%a7)+,%D1/%A0/%A1 /* restore state */
	addq	#1,%a0
	bra	lp					/* and continue searching at lp */
badexit:			
	movea.l #0,%a0		/* return NULL, s2 not found */
	rts
