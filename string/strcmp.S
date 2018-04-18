	.text
	.global strcmp
	
/*
	int strcmp (const char *s1, const char *s)	
	
	This function starts comparing the first character of each string. 
	If they are equal to each other, it continues with the following pairs 
	until the characters differ or until a terminating null-character is reached.

	This function performs a binary comparison of the characters.	
	
	Returns an integral value indicating the relationship between the strings:
		A zero value indicates that both strings are equal.
		A value greater than zero indicates that the first 
		character that does not match has a greater value in str1 than in str2; 
		And a value less than zero indicates the opposite.
*/	
		

strcmp:
	move.l  (8,%a7),%a1	/* buf2	(s)  */
	move.l	(4,%A7),%a0	/* buf1	(s1) */
lp:
	move.b	(%a1)+,%d1  /* check s[n] 					*/
	beq.b	posout      /* Z-Flag (s ends) -> posout 	*/
	tst.b	(%a0)       /* check s1[n] 					*/
	beq.b	negout		/* Z-Flag (s1 ends) -> negout 	*/
	cmp.b	(%a0)+,%d1  /* compare a character ... 		*/
	beq.b	lp			/* try next if equal       		*/
	bcc.b	negout      /* C-Flag = 0 -> 				*/
	bcs.b	lp1		/* C-Flag = 1 -> 				*/
	bra	lp				/* is never reached ! 			*/
zerout:
   	clr.l	%d0
	rts
posout:
	tst.b	(%a0)		/* check s1[n], if it is zero	*/
	beq	zerout			/* both strings match -> zerout */
lp1:    clr.l	%d0
	addq.l	#1,%d0      /* return 1 */
	rts
negout:
	clr.l	%d0
	subq.l	#1,%d0          /* return -1 */
	rts
