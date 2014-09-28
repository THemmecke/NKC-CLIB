	.text
	.global fabs

/*	double fabs(double t)
*
*	Rückgabe: |t| in %fp0, falls FPU
*
*/


fabs:

      	fabs.d	4(%sp),%FP0

	rts		
