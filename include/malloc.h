/*  malloc.h

    memory management functions and variables.

*/

#ifndef __MALLOC_H
#define __MALLOC_H

#define NULL 0

#define _HEAPEMPTY      1
#define _HEAPOK         2
#define _FREEENTRY      3
#define _USEDENTRY      4
#define _HEAPEND        5
#define _HEAPCORRUPT    -1
#define _BADNODE        -2
#define _BADVALUE       -3

#ifndef _STDDEF
#define _STDDEF
#ifndef _PTRDIFF_T
#define _PTRDIFF_T
  typedef int ptrdiff_t;
#endif
#ifndef _SIZE_T
  #define _SIZE_T
  typedef unsigned size_t;
#endif
#endif

struct heapinfo
  {
  void *ptr;
  unsigned int size;
  int in_use;
  };

void  *calloc(size_t __nitems, size_t __size);
void        free(void *__block);
void  *malloc(size_t __size);
void  *realloc(void *__block, size_t __size);

unsigned      coreleft(void);

int           heapcheck(void);

int         brk(void *__addr);
void       *sbrk(int __incr);

int         heapfillfree(unsigned int __fillvalue);
int         heapcheckfree(unsigned int __fillvalue);

int         heapchecknode(void *__node);
int         heapwalk(struct heapinfo *__hi);



typedef struct _heapinfo
{
    int     *_pentry;
    size_t  _size;
    int     _useflag;
} _HEAPINFO;


int         _heapwalk   (_HEAPINFO *__entry);

void *       alloca     (size_t __size);
void *       __alloca__ (size_t __size);

size_t       stackavail (void);


#endif  /* __MALLOC_H */