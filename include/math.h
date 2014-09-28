/*  math.h

    Definitions for the math floating point package.

*/

#ifndef  __MATH_H
#define  __MATH_H

// div_t, ldiv_t ...
#include <stdlib.h>

struct complex      /* as used by "_cabs" function */
{
    double  x, y;
};

struct _complexl    /* as used by "_cabsl" function */
{
    double  x, y;
};

#define cabs(z)     (hypot  ((z).x, (z).y))
#define cabsl(z)    (hypotl ((z).x, (z).y))

typedef enum
{
    DOMAIN = 1,    /* argument domain error -- log (-1)        */
    SING,          /* argument singularity  -- pow (0,-2))     */
    OVERFLOW,      /* overflow range error  -- exp (1000)      */
    UNDERFLOW,     /* underflow range error -- exp (-1000)     */
    TLOSS,         /* total loss of significance -- sin(10e70) */
    PLOSS,         /* partial loss of signif. -- not used      */
    STACKFAULT     /* floating point unit stack overflow       */
}   _mexcep;

/* Constants rounded for 21 decimals. */
#define M_E         2.71828182845904523536
#define M_LOG2E     1.44269504088896340736
#define M_LOG10E    0.434294481903251827651
#define M_LN2       0.693147180559945309417
#define M_LN10      2.30258509299404568402
#define M_PI        3.14159265358979323846
#define M_PI_2      1.57079632679489661923
#define M_PI_4      0.785398163397448309616
#define M_1_PI      0.318309886183790671538
#define M_2_PI      0.636619772367581343076
#define M_1_SQRTPI  0.564189583547756286948
#define M_2_SQRTPI  1.12837916709551257390
#define M_SQRT2     1.41421356237309504880
#define M_SQRT_2    0.707106781186547524401

#define EDOM    33      /* Math argument */
#define ERANGE  34      /* Result too large */

struct  exception
{
    int type;
    char *name;
    double  arg1, arg2, retval;
};

struct  _exceptionl
{
    int type;
    char *name;
    double  arg1, arg2, retval;
};

#define HUGE_VAL    _huge_dble
extern double _huge_dble;
#define _LHUGE_VAL   _huge_ldble
extern double _huge_ldble;

double      acos    (double __x); 				//
double      asin    (double __x); 				//
double      tan     (double __x); 				//
double      atan     (double __x); 				//
//double      atan2   (double __y, double __x);
double      ceil    (double __x);				//
double      cos     (double __x);				//
double      cosh    (double __x);				//
double      exp     (double __x);				//
double      fabs    (double __x);				//
double      __fabs__(double __x); /* Intrinsic */
double      floor   (double __x);				//
double      fmod    (double __x, double __y);
double      frexp   (double __x, int *__exponent);
double      ldexp   (double __x, int __exponent);
double      log     (double __x);				//
double      log10   (double __x);				//
double      modf    (double __x, double *__ipart);
double      pow     (double __x, double __y);
double      sin     (double __x); 				//
double      sinh    (double __x);				//
double      sqrt    (double __x);				//
double      tan     (double __x);				//
double      tanh    (double __x);				//

// divmod64.S
#define DWORD unsigned int

#ifndef _LARGE_INTEGER_TYPE
#define _LARGE_INTEGER_TYPE

/*
typedef struct _LARGE_INTEGER {
		    DWORD HighPart;
		    DWORD LowPart;
	} LARGE_INTEGER, *PLARGE_INTEGER;
*/	

typedef unsigned long long LONGLONG;
typedef signed long long SLONGLONG;
typedef unsigned long LONG;	
typedef union _LARGE_INTEGER {
  struct {
    DWORD LowPart;
    LONG  HighPart;
  };
  struct {
    DWORD LowPart;
    LONG  HighPart;
  } u;
  LONGLONG QuadPart;
} LARGE_INTEGER, *PLARGE_INTEGER;
	

#endif

DWORD do_div(PLARGE_INTEGER pli, DWORD base);
DWORD div64(PLARGE_INTEGER pli, DWORD base); 
DWORD div32(DWORD *divident, DWORD base);  	
div_t       div(int __numer, int __denom);
ldiv_t      ldiv(long __numer, long __denom);

/* gibts nicht ...
double acosl  (double __x);					
double asinl  (double __x);	
double atan2l (double __x, double __y);
double atanl  (double __x);
double ceill  (double __x);
double coshl  (double __x);
double cosl   (double __x);
double expl   (double __x);
double fabsl  (double __x);
double floorl (double __x);
double fmodl  (double __x, double __y);
double frexpl (double __x, int *__exponent);
double ldexpl (double __x, int __exponent);
double log10l (double __x);
double logl   (double __x);
double modfl  (double __x, double *__ipart);
double powl   (double __x, double __y);
double sinhl  (double __x);
double sinl   (double __x);
double sqrtl  (double __x);
double tanhl  (double __x);
double tanl   (double __x);
*/

double hypot (double __x, double __y);
int    _matherr (struct exception *__e);
double poly  (double __x, int __degree, double *__coeffs);
double pow10 (int __p);
double hypotl (double __x, double __y);
double polyl  (double __x, int __degree, double *__coeffs);
double pow10l (int __p);

#if !defined(__ABS_DEFINED)
#define __ABS_DEFINED
int         __abs__(int);
int         abs(int __x);
#  define abs(x)   __abs__(x)

#endif /* __ABS_DEFINED */

double     atof  (const char *__s);
long       labs  (long __x);
int        _matherrl (struct _exceptionl *__e);

double     _atold (const char *__s);

#endif  /* __MATH_H */
