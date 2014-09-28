#ifndef __STDLIB_H
#define __STDLIB_H

#ifndef NULL
#define NULL 0
#endif


#ifndef _PTRDIFF_T
#define _PTRDIFF_T
typedef long    ptrdiff_t;
#endif

#ifndef _SIZE_T
#define _SIZE_T
typedef unsigned size_t;
#endif

#define offsetof( s_name, m_name )  (size_t)&(((s_name _FAR *)0)->m_name)

#ifndef _WCHAR_T
#define _WCHAR_T
typedef unsigned wchar_t;
#endif

#ifndef _DIV_T
#define _DIV_T
typedef struct {
        int     quot;
        int     rem;
} div_t;
#endif

#ifndef _LDIV_T
#define _LDIV_T
typedef struct {
        long    quot;
        long    rem;
} ldiv_t;
#endif

#define MB_CUR_MAX 18

/* Maximum value returned by "rand" function
*/
#define RAND_MAX 0x7FFFU

#define EXIT_SUCCESS 0
#define EXIT_FAILURE 1

typedef void (* atexit_t)(void);


void         abort(void);

#if !defined(__ABS_DEFINED)
#define __ABS_DEFINED

int          __abs__(int);
int         abs(int __x);
#  define abs(x)   __abs__(x)

#endif /* __ABS_DEFINED */

int         atexit(void (*__func)(void));
double      atof(const char *__s);
int         atoi(const char *__s);
long        atol(const char *__s);
void * bsearch(const void *__key, const void *__base,
                           size_t __nelem, size_t __width,
                           int (*fcmp)(const void *,
                           const void *));
void * calloc(size_t __nitems, size_t __size);
div_t       div(int __numer, int __denom);
ldiv_t      ldiv(long __numer, long __denom);
void        exit(int __status);
void        free(void *__block);
char * getenv(const char *__name);
void * malloc(size_t __size);
int          mblen(const char *__s, size_t __n);
size_t       mbstowcs(wchar_t *__pwcs, const char *__s,
                                    size_t __n);
int          mbtowc(wchar_t *__pwc, const char *__s, size_t __n);
void         qsort(void *__base, size_t __nelem, size_t __width,
                       int (* __fcmp)(const void *, const void *));
int         rand(void);
void  *realloc(void *__block, size_t __size);
void        srand(unsigned __seed);
char *      strdup(const char *string);
double      strtod(const char *__s, char **__endptr);
long          strtol(const char *__s, char **__endptr,
                                    int __radix);
double _strtold(const char *__s, char **__endptr);
unsigned long   strtoul(const char *__s, char **__endptr,
                                       int __radix);
int           system(const char *__command);
size_t       wcstombs(char *__s, const wchar_t *__pwcs,
                                    size_t __n);
int          wctomb(char *__s, wchar_t __wc);
int          wctombflush(char *__s);

extern  char          ** _environ;
extern  int              _fmode;
extern  unsigned char    _osmajor;
extern  unsigned char    _osminor;
extern  unsigned int     _version;


#define atoi(s)     ((int) atol(s))

/* Constants for MSC pathname functions */

#define _MAX_PATH       80
#define _MAX_DRIVE      3
#define _MAX_DIR        66
#define _MAX_FNAME      9
#define _MAX_EXT        5

double     _atold(const char *__s);
unsigned char   _crotl(unsigned char __value, int __count);
unsigned char   _crotr(unsigned char __value, int __count);
char     * ecvt(double __value, int __ndig, int *__dec,
                           int *__sign);
void            _exit(int __status);
char     * fcvt(double __value, int __ndig, int *__dec,
                           int *__sign);
char     *  _fullpath( char *__buf,
                                 const char *__path,
                                 size_t __maxlen );
char     * gcvt(double __value, int __ndec, char *__buf);
char     *  itoa(int __value, char *__string, int __radix);
void     *  lfind(const void *__key, const void *__base,
                                 size_t *__num, size_t __width,
                                 int (* __fcmp)(const void *,
                                 const void *));

void     *  lsearch(const void *__key, void *__base,
                                 size_t *__num, size_t __width,
                           int (* __fcmp)(const void *, const void *));
char     *  ltoa(long __value, char *__string, int __radix);
void             _makepath( char *__path,
                                 const char *__drive,
                                 const char *__dir,
                                 const char *__name,
                                 const char *__ext );
int              putenv(const char *__name);

unsigned        __rotl__(unsigned __value, int __count);     /* intrinsic */
unsigned        __rotr__(unsigned __value, int __count);     /* intrinsic */

void            _searchenv(const char *__file,
                                 const char *__varname,
                                 char *__pathname);
void            _searchstr(const char *__file,
                                 const char *__ipath,
                                 char *__pathname);
void             _splitpath( const char *__path,
                                 char *__drive,
                                 char *__dir,
                                 char *__name,
                                 char *__ext );
void             swab(char *__from, char *__to, int __nbytes);
char     *  ultoa(unsigned long __value, char *__string,
                                 int __radix);

#define  _rotl(__value, __count)  __rotl__(__value, __count)
#define  _rotr(__value, __count)  __rotr__(__value, __count)


#define random(num)((rand()*(num))/((RAND_MAX+1))



#define randomize() srand((unsigned)time(NULL))
#define max(a,b)    (((a) > (b)) ? (a) : (b))
#define min(a,b)    (((a) < (b)) ? (a) : (b))

#define _itoa(__value, __string, __radix) itoa(__value, __string, __radix)

#endif  /* __STDLIB_H */