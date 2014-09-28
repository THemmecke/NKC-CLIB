	.text

	.global tan

/*	double tan(double t)
*
*	Rückgabe: tangens in %fp0, falls FPU
*
*
*
*/


tan:

      	ftan.d	4(%sp),%FP0

	rts	
