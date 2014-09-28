/*  memory.h

    Memory manipulation functions

*/

#if !defined(__MEM_H)
#define __MEM_H


#ifndef _SIZE_T
#define _SIZE_T
typedef unsigned size_t;
#endif



void *    memccpy(void *__dest, const void *__src,
                                        int __c, size_t __n);
int            memcmp(const void *__s1, const void *__s2,
                                       size_t __n);
void *    memcpy(void *__dest, const void *__src,
                                       size_t __n);
int            memicmp(const void *__s1, const void *__s2,
                                        size_t __n);
void *   memmove(void *__dest, const void *__src,
                                        size_t __n);
void *   memset(void *__s, int __c, size_t __n);

void *  memchr(const void *__s, int __c, size_t __n);

#endif  /* __MEM_H */