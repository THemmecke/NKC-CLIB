/*  stddef.h  

    Definitions for common types, and NULL

*/

#ifndef __STDDEF_H
#define __STDDEF_H

#define NULL 0


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

#endif  /* __STDDEF_H */