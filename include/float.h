/*  float.h

    Defines implementation specific macros for dealing with
    floating point.  We don't currently support long doubles.

*/

#ifndef __FLOAT_H
#define __FLOAT_H


#define FLT_RADIX           2
#define FLT_ROUNDS          1
#define FLT_GUARD           1
#define FLT_NORMALIZE       1

#define DBL_DIG             15
#define FLT_DIG             6
#define LDBL_DIG            18

#define DBL_MANT_DIG        53
#define FLT_MANT_DIG        24
#define LDBL_MANT_DIG       64

#define DBL_EPSILON         2.2204460492503131E-16
#define FLT_EPSILON         1.19209290E-07F
#define LDBL_EPSILON        1.084202172485504434e-019L

/* smallest positive IEEE normal numbers */
#define DBL_MIN             2.2250738585072014E-308
#define FLT_MIN             1.17549435E-38F
#define LDBL_MIN            _tiny_ldble

#define DBL_MAX             _huge_dble
#define FLT_MAX             _huge_flt
#define LDBL_MAX            _huge_ldble

#define DBL_MAX_EXP         +1024
#define FLT_MAX_EXP         +128
#define LDBL_MAX_EXP        +16384

#define DBL_MAX_10_EXP      +308
#define FLT_MAX_10_EXP      +38
#define LDBL_MAX_10_EXP     +4932

#define DBL_MIN_10_EXP      -307
#define FLT_MIN_10_EXP      -37
#define LDBL_MIN_10_EXP     -4931

#define DBL_MIN_EXP         -1021
#define FLT_MIN_EXP         -125
#define LDBL_MIN_EXP        -16381

extern float         _huge_flt;
extern double        _huge_dble;
extern double   _huge_ldble;
extern double   _tiny_ldble;

unsigned int  _clear87(void);
unsigned int  _control87(unsigned int __newcw, unsigned int __mask);
void          _fpreset(void);
unsigned int  _status87(void);

#endif