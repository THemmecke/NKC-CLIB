	.text
	.global atan
	
/*	double atan(double t)
*
*	Rückgabe: arcus-tangens in %fp0, falls FPU
*
*/

atan:

      	fatan.d	4(%sp),%FP0

	rts		
