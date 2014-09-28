	.text
	.global	exp

/*	double exp(double t)
*
*	Rückgabe: exp in %fp0, falls FPU
*
*/


exp:
	
      	fetox.d	4(%sp),%FP0
	rts	
