#ifndef __STDARG_H
#define __STDARG_H

typedef void *va_list;

#define __sizeof__(x) ((sizeof(x)+sizeof(int)-1) & ~(sizeof(int)-1))

#define va_start(ap, parmN) ap = (va_list)((char *)(&parmN)+sizeof(parmN))
#define va_arg(ap, type) (*(type *)(((*(char **)&(ap))+=__sizeof__(type))-(__sizeof__(type))))
#define va_end(ap)

#define _va_ptr             (...)

#endif  /* __STDARG_H */