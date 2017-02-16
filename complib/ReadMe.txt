https://github.com/gcc-mirror/gcc/blob/master/libgcc/libgcc2.c

https://www.mirbsd.org/htman/i386/manINFO/gccint.html#Integer-library-routines
https://www.libsdl.org/extras/amigaos/cross/src/article.html




/* ******************************************************************* */


/* ======================= longlong.h ==================================*/

/* You have to define the following before including this file:

   UWtype -- An unsigned type, default type for operations (typically a "word")
   UHWtype -- An unsigned type, at least half the size of UWtype.
   UDWtype -- An unsigned type, at least twice as large a UWtype
   W_TYPE_SIZE -- size in bits of UWtype

   UQItype -- Unsigned 8 bit type.
   SItype, USItype -- Signed and unsigned 32 bit types.
   DItype, UDItype -- Signed and unsigned 64 bit types.

   On a 32 bit machine UWtype should typically be USItype;
   on a 64 bit machine, UWtype should typically be UDItype.  
*/

/* 32 bit usigned */
#define UWtype          usigned int
/* 16 bit unsigned */
#define UHWtype         unsigned short
/* 64 bit unsigned */
#define UDWtype         unsigned long long
/* 64 bit signed */
#define DItype		signed long long	
/* 64 bit usigned */
#define UDItype		unsigned long long	
/* 32 bit signed */
#define SItype		signed int	
/* 32 bit usigned */
#define USItype		unsigned int	

/*
1) umul_ppmm(high_prod, low_prod, multiplier, multiplicand) multiplies two
   UWtype integers MULTIPLIER and MULTIPLICAND, and generates a two UWtype
   word product in HIGH_PROD and LOW_PROD.
2) __umulsidi3(a,b) multiplies two UWtype integers A and B, and returns a
   UDWtype product.  This is just a variant of umul_ppmm.
*/

#if !defined (__umulsidi3)
#define __umulsidi3(u, v) \
  ({DWunion __w;                                                        \
    umul_ppmm (__w.s.high, __w.s.low, u, v);                            \
    __w.ll; })
#endif

/* The '020, '030, '040, '060 and CPU32 have 32x32->64 and 64/32->32q-32r.  */
#if (defined (__mc68020__) && !defined (__mc68060__))
#define umul_ppmm(w1, w0, u, v) \
  __asm__ ("mulu%.l %3,%1:%0"                                           \
           : "=d" ((USItype) (w0)),                                     \
             "=d" ((USItype) (w1))                                      \
           : "%0" ((USItype) (u)),                                      \
             "dmi" ((USItype) (v)))
#define UMUL_TIME 45
#define udiv_qrnnd(q, r, n1, n0, d) \
  __asm__ ("divu%.l %4,%1:%0"                                           \
           : "=d" ((USItype) (q)),                                      \
             "=d" ((USItype) (r))                                       \
           : "0" ((USItype) (n0)),                                      \
             "1" ((USItype) (n1)),                                      \
             "dmi" ((USItype) (d)))
#define UDIV_TIME 90
#define sdiv_qrnnd(q, r, n1, n0, d) \
  __asm__ ("divs%.l %4,%1:%0"                                           \
           : "=d" ((USItype) (q)),                                      \
             "=d" ((USItype) (r))                                       \
           : "0" ((USItype) (n0)),                                      \
             "1" ((USItype) (n1)),                                      \
             "dmi" ((USItype) (d)))

#else /* not mc68020 */
/* %/ inserts REGISTER_PREFIX, %# inserts IMMEDIATE_PREFIX.  */
#define umul_ppmm(xh, xl, a, b) \
  __asm__ ("| Inlined umul_ppmm\n"                                      \
           "    move%.l %2,%/d0\n"                                      \
           "    move%.l %3,%/d1\n"                                      \
           "    move%.l %/d0,%/d2\n"                                    \
           "    swap    %/d0\n"                                         \
           "    move%.l %/d1,%/d3\n"                                    \
           "    swap    %/d1\n"                                         \
           "    move%.w %/d2,%/d4\n"                                    \
           "    mulu    %/d3,%/d4\n"                                    \
           "    mulu    %/d1,%/d2\n"                                    \
           "    mulu    %/d0,%/d3\n"                                    \
           "    mulu    %/d0,%/d1\n"                                    \
           "    move%.l %/d4,%/d0\n"                                    \
           "    eor%.w  %/d0,%/d0\n"                                    \
           "    swap    %/d0\n"                                         \
           "    add%.l  %/d0,%/d2\n"                                    \
           "    add%.l  %/d3,%/d2\n"                                    \
           "    jcc     1f\n"                                           \
           "    add%.l  %#65536,%/d1\n"                                 \
           "1:  swap    %/d2\n"                                         \
           "    moveq   %#0,%/d0\n"                                     \
           "    move%.w %/d2,%/d0\n"                                    \
           "    move%.w %/d4,%/d2\n"                                    \
           "    move%.l %/d2,%1\n"                                      \
           "    add%.l  %/d1,%/d0\n"                                    \
           "    move%.l %/d0,%0"                                        \
           : "=g" ((USItype) (xh)),                                     \
             "=g" ((USItype) (xl))                                      \
           : "g" ((USItype) (a)),                                       \
             "g" ((USItype) (b))                                        \
           : "d0", "d1", "d2", "d3", "d4")
#define UMUL_TIME 100
#define UDIV_TIME 400

#endif /* not mc68020 */

/* ====================== libgcc2.h ===================================== */
#define LIBGCC2_UNITS_PER_WORD = 4
#define BITS_PER_UNIT = 8
#define W_TYPE_SIZE (4 * BITS_PER_UNIT)
#define Wtype   SItype		signed int
#define UWtype  USItype		unsigned int
#define HWtype  SItype		signed int
#define UHWtype USItype		unsigned int
#define DWtype  DItype		signed long long
#define UDWtype UDItype		unsigned long long
#define __NW(a,b)       __ ## a ## si ## b
#define __NDW(a,b)      __ ## a ## di ## b


/* BIG ENDIAN ! */
struct DWstruct {Wtype high, low;};

typedef union
{
  struct DWstruct s;
  DWtype ll;
} DWunion;


/* ======================== libgcc2.c ==================================== */
#ifdef L_muldi3

__muldi3 (DWtype u, DWtype v)
{
  const DWunion uu = {.ll = u};
  const DWunion vv = {.ll = v};
  DWunion w = {.ll = __umulsidi3 (uu.s.low, vv.s.low)};

  w.s.high += ((UWtype) uu.s.low * (UWtype) vv.s.high
               + (UWtype) uu.s.high * (UWtype) vv.s.low);

  return w.ll;
}
#endif
gcc/longlong.h:
