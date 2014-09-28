	.text
	.global acos

/*	double acos(double t)
*
*	Rückgabe: arcus-cosinus in %fp0, falls FPU
*
*/

acos:
	
      	facos.d	(4,%sp),%FP0

	rts	


