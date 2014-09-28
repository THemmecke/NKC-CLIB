	.text
	.global cos

/*	double cos(double t)
*
*	Rückgabe: cosinus in %fp0, falls FPU
*
*/
cos:


      	//fcos.d	-8(%fp),%FP0   // uses local variable,i.e. link
	fcos.d 4(%sp),%fp0 // ohne link !
	rts		
