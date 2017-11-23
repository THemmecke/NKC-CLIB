#ifndef _TYPES
#define _TYPES


#ifndef NULL
#define NULL 0
#endif

/* These types must be 16-bit, 32-bit or larger integer */
typedef int		INT;
typedef unsigned int	UINT;

/* These types must be 8-bit integer */
typedef char		CHAR;
typedef unsigned char	UCHAR;
typedef unsigned char	BYTE;

#define u8 UCHAR

/* These types must be 16-bit integer */
typedef short		SHORT;
typedef unsigned short	USHORT;
typedef unsigned short	WORD;
typedef unsigned short	WCHAR;

#define u16 USHORT

/* These types must be 32-bit integer */
typedef long		LONG;
typedef unsigned long	ULONG;
typedef unsigned long	DWORD;

#define u32 ULONG


/* These types must be 64-bit integer */
typedef unsigned long long LONGLONG;

typedef enum {FALSE=0, TRUE=1} BOOL,BOOLEAN;

typedef void *PVOID;

typedef PVOID HANDLE;


#ifndef _LARGE_INTEGER_TYPE
#define _LARGE_INTEGER_TYPE
typedef struct _LARGE_INTEGER {
		    DWORD HighPart;
		    DWORD LowPart;
	} LARGE_INTEGER, *PLARGE_INTEGER;
#endif

#endif
