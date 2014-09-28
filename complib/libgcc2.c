
#include <math.h>

#define NULL 0


LONGLONG __udivmoddi4	(	
		LONGLONG 	num,
		LONGLONG 	den,
		LONGLONG * 	rem_p 
	)	
{
  LONGLONG quot = 0, qbit = 1;

  if ( den == 0 ) {
    return 1/((unsigned)den); /* Intentional divide by zero, without
                                 triggering a compiler warning which
                                 would abort the build */
  }

  /* Left-justify denominator and count shift */
  while ( (SLONGLONG)den >= 0 ) {
    den <<= 1;
    qbit <<= 1;
  }

  while ( qbit ) {
    if ( den <= num ) {
      num -= den;
      quot += qbit;
    }
    den >>= 1;
    qbit >>= 1;
  }

  if ( rem_p )
    *rem_p = num;

  return quot;
}


/*
 * __umoddi3.c
 */


LONGLONG __umoddi3(LONGLONG num, LONGLONG den)
{
  LONGLONG v;

  (void) __udivmoddi4(num, den, &v);
  return v;
}


/*
 * __divdi3.c
 */


LONGLONG __udivdi3(LONGLONG num, LONGLONG den)
{
  return __udivmoddi4(num, den, NULL);
}
