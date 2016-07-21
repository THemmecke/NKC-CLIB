	.text
	.global strcpy
	
/*
	char strcpy(char *dst, const char *src)
	
	copy string src to string dst - src must be terminated with \0 which is also copied 
*/	

strcpy:
	move.l	(8,%a7),%a1	/* src	*/
	move.l	(4,%A7),%a0	/* dest	*/
	move.l	%a0,%d0		/* dest	*/
lp:
	move.b	(%a1)+,(%a0)+	/* copy all characters including trailing NULL */
	bne.b	lp
	move.l	%d0,%a0		/* return value is pointer to dst in %a0 */
	rts
