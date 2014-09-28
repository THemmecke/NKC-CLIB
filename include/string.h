/*  string.h

    Definitions for memory and string functions.

*/

#ifndef __STRING_H
#define __STRING_H

#if !defined(NULL)
#define NULL 0
#endif

#ifndef _SIZE_T
#define _SIZE_T
typedef unsigned size_t;
#endif


int          memcmp(const void *__s1,
                                       const void *__s2, size_t __n);
void *  memcpy(void *__dest, const void *__src,
                                       size_t __n);
void *  memmove(void *__dest, const void *__src,
                                        size_t __n);
void *  memset(void *__s, int __c, size_t __n);
char *  strcat(char *__dest, const char *__src);
int          strcmp(const char *__s1, const char *__s2);
char *  strcpy(char *__dest, const char *__src);
size_t       strcspn(const char *__s1, const char *__s2);
char *  strerror(int __errnum);
size_t       strlen(const char *__s);
char *  strncat(char *__dest, const char *__src,
                                        size_t __maxlen);
int          strncmp(const char *__s1, const char *__s2,
                                        size_t __maxlen);
char *  strncpy(char *__dest, const char *__src,
                                        size_t __maxlen);
size_t       strspn(const char *__s1, const char *__s2);
char *  strtok(char *__s1, const char *__s2);
char *  _strerror(const char *__s);


          void *   memchr(const void *__s, int __c, size_t __n);
          char *    strchr(const char * __s, int __c);
          char *    strrchr(const char *__s, int __c);
          char *    strpbrk(const char *__s1, const char *__s2);
          char *    strstr(const char *__s1, const char *__s2);

/* Intrinsic functions */
#if !defined(__MEM_H)
void *  __memchr__(const void *__s, int __c, size_t __n);
int          __memcmp__(const void *__s1,
                                             const void *__s2, size_t __n);
void *  __memcpy__(void *__dest, const void *__src,
                                             size_t __n);
void *  __memset__(void *__s, int __c, size_t __n);
#endif

char *             __stpcpy__(char *__dest, const char *__src);
char *  __strcat__(char *__dest, const char *__src);
char *  __strchr__(const char *__s, int __c);
int          __strcmp__(const char *__s1, const char *__s2);
char *  __strcpy__(char *__dest, const char *__src);
size_t       __strlen__(const char *__s);
char *  __strncat__(char *__dest, const char *__src,
                                              size_t __maxlen);
int          __strncmp__(const char *__s1, const char *__s2,
                                              size_t __maxlen);
char *  __strncpy__(char *__dest, const char *__src,
                                              size_t __maxlen);
char *  __strnset__(char *__s, int __ch, size_t __n);
char *  __strrchr__(const char *__s, int __c);
char *  __strset__(char *__s, int __ch);

int            _lstrcoll(const char *__s1, const char *__s2);
size_t         _lstrxfrm(char *__s1, const char *__s2,
                                            size_t __n );
int                     strcoll(const char *__s1, const char *__s2);
size_t                  strxfrm(char *__s1, const char *__s2,
                                          size_t __n );

#if defined(__USELOCALES__)
#define  strupr   _lstrupr
#define  strlwr   _lstrlwr
#define  strcoll  _lstrcoll
#define  strxfrm  _lstrxfrm
#endif  /* __USELOCALES__ */


#endif  /* __STRING_H */