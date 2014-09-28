	.text
	.global cosh

/*	double cosh(double t)
*
*	Rückgabe: cosh in %fp0, falls FPU
*
*/

cosh:
      	fcosh.d	4(%sp),%FP0
	rts	
