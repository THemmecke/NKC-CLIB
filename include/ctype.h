/*  ctype.h

    Defines the locale aware ctype macros.

*/


#ifndef __CTYPE_H
#define __CTYPE_H

#ifndef _SIZE_T
#define _SIZE_T
typedef unsigned size_t;
#endif

extern unsigned char _ctype[ 256 ];

int isalnum (int __c);
int isalpha (int __c);
int iscntrl (int __c);
int isdigit (int __c);
int isgraph (int __c);
int islower (int __c);
int isprint (int __c);
int ispunct (int __c);
int isspace (int __c);
int isupper (int __c);
int isxdigit(int __c);
int isascii (int __c);

int isnumber(char* _s);


/* character classes */

#define _IS_SP     1           /* space */
#define _IS_DIG    2           /* digit */
#define _IS_UPP    4           /* upper case */
#define _IS_LOW    8           /* lower case */
#define _IS_HEX   16           /* [0..9] or [A-F] or [a-f] */
#define _IS_CTL   32           /* control */
#define _IS_PUN   64           /* punctuation */
#define _IS_BLK  128           /* blank */

#define _IS_ALPHA    (_IS_UPP | _IS_LOW)
#define _IS_ALNUM    (_IS_DIG | _IS_ALPHA)
#define _IS_GRAPH    (_IS_ALNUM | _IS_HEX | _IS_PUN)

#ifndef __USELOCALES__

#define isalnum(c)   (_ctype[ (c) ] & (_IS_ALNUM))
                     
#define isalpha(c)   (_ctype[ (c) ] & (_IS_ALPHA))
                     
#define iscntrl(c)   (_ctype[ (c) ] & (_IS_CTL))
                     
#define isdigit(c)   (_ctype[ (c) ] & (_IS_DIG))
                     
#define isgraph(c)   (_ctype[ (c) ] & (_IS_GRAPH))
                     
#define islower(c)   (_ctype[ (c) ] & (_IS_LOW))
                     
#define isprint(c)   (_ctype[ (c) ] & (_IS_GRAPH | _IS_BLK))
                     
#define ispunct(c)   (_ctype[ (c) ] & (_IS_PUN))
                     
#define isspace(c)   (_ctype[ (c) ] & (_IS_SP))
                     
#define isupper(c)   (_ctype[ (c) ] & (_IS_UPP))
                     
#define isxdigit(c)  (_ctype[ (c) ] & (_IS_HEX))

#endif

#define isascii(c)  ((unsigned)(c) < 128)
#define toascii(c)  ((c) & 0x7f)

int tolower(int __ch);
int _ltolower(int __ch);
int toupper(int __ch);
int _ltoupper(int __ch);

#define _toupper(c) ((c) + 'A' - 'a')
#define _tolower(c) ((c) + 'a' - 'A')

#if defined(__USELOCALES__)

#define toupper    _ltoupper
#define tolower    _ltolower

#endif

#endif 