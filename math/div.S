	.text
/*	.global div,ldiv  */


/*
	div_t       div(int __numer, int __denom);
	ldiv_t      ldiv(long __numer, long __denom);
	
	(__numer / __denom = div_t)
	
	typedef struct {
        	int     quot;
        	int     rem;
	} div_t;

	typedef struct {
        	long    quot;
        	long    rem;
	} ldiv_t;


	Aufruf für ldiv und div:

	link.w %fp,#-24
  	move.l -8(%fp),-(%sp)		// larg2 __denom
  	move.l -4(%fp),-(%sp)		// larg1 __numer
  	jsr ldiv
  	addq.l #8,%sp
  	move.l %d0,-24(%fp)		// ldiv.quot
  	move.l %d1,-20(%fp)		// ldiv.rem
  	unlk %fp

*/



ldiv:	
div:
	lea.l	(4,%A7),%A0	/* get pointer to parameters */
	
#ifdef M68000	
					/* 68000... */
	move.l	(4,%a0),-(%A7)	/* arg 2 __denom */
	move.l	(%a0),-(%A7)   	/* arg1 __numer */
	bsr	__divs		/* Use the software div in case 68000 */	
	add.l #8,%sp		/* Stack aufräumen */
	
#endif		

#ifdef M68020
				/* 68020+ */
	move.l	(4,%a0),%d1  	/* __denom */
	move.l	(%a0),%d0    	/* __numer */
			
	divsl.l %d1,%d1:%d0     /* %d0 / %d1 ==>  %d1 (rest): %d0 (quotient) */				
#endif
	move.l	(%a0),%a0
	move.l	%d0,(%a0)
	move.l	%d1,(4,%a0)	
	rts
	
	
	

	
