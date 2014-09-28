/*  locale.h

*/

#ifndef __LOCALE_H
#define __LOCALE_H


#ifndef _SIZE_T
#    define _SIZE_T
typedef unsigned size_t;
#endif


#define LC_ALL      0
#define LC_COLLATE  1
#define LC_CTYPE    2
#define LC_MONETARY 3
#define LC_NUMERIC  4
#define LC_TIME     5
#define LC_MESSAGES 6
#define LC_userdef  7
#define LC_LAST     LC_userdef

struct lconv {

   char *decimal_point;
   char *thousands_sep;
   char *grouping;
   char *int_curr_symbol;
   char *currency_symbol;
   char *mon_decimal_point;
   char *mon_thousands_sep;
   char *mon_grouping;
   char *positive_sign;
   char *negative_sign;
   char int_frac_digits;
   char frac_digits;
   char p_cs_precedes;
   char p_sep_by_space;
   char n_cs_precedes;
   char n_sep_by_space;
   char p_sign_posn;
   char n_sign_posn;
};

char *   setlocale( int __category, const char *__locale );
char *   _lsetlocale( int __category, const char *__locale );
struct lconv *  localeconv( void );
struct lconv *   _llocaleconv( void );

#if defined( __USELOCALES__ )
#define setlocale  _lsetlocale
#define localeconv _llocaleconv
#endif


#endif  /* __LOCALE_H */
