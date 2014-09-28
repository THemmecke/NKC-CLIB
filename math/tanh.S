	.text

	.global tanh

/*	double tanh(double t)
*
*	Rückgabe: tanh in %fp0, falls FPU
*
*/

tanh:
	
      	ftanh.d	4(%sp),%FP0

	rts		
