	.text
	.global asin

/*	double asin(double t)
*
*	Rückgabe: arcus-sinus in %fp0, falls FPU
*
*/

asin:

      	fasin.d	(4,%sp),%FP0
	rts	

