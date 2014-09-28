	.text

	.global sqrt

/*	double sqrt(double t)
*
*	Rückgabe: sqrt in %fp0, falls FPU
*
*/

sqrt:

      	fsqrt.d	4(%sp),%FP0

	rts	
	
