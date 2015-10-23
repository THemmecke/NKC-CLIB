#ifndef __DEBUG_H
#define __DEBUG_H


//#ifdef CONFIG_DEBUG_FS_FAT
#ifdef CONFIG_DEBUG

static char debugbuf[255];

#include "../nkc/llnkc.h"

#define dbg(format,arg...) \
        sprintf(debugbuf,format,##arg); \
	nkc_write(debugbuf);
	
	
#define lldbg(format) \
	nkc_write(format); 
	
#define lldbgwait(format) \
	nkc_write(format); \
	nkc_getchar(); 

#define lldbgdec(format,value) \
	nkc_write(format); \
	nkc_write_dec_dw(value); 
		
#define lldbghex(format,value) \
	nkc_write(format); \
	nkc_write_write_hex8(value); \
	nkc_write("\n");		
	
#else
#define dbg(x...)
#define lldbg(x...)
#define lldbgwait(x...)
#define lldbgdec(x...)
#define lldbghex(x...)
#endif

#ifdef CONFIG_DEBUG_CLIB_IO
# define clio_dbg(format,arg...)    dbg(format,##arg)
# define clio_lldbg(format)	   lldbg(format) 
# define clio_lldbgwait(format)	   lldbgwait(format) 
#else
# define clio_dbg(x...)
# define clio_lldbg(x...)
# define clio_lldbgwait(x...)	
#endif

#ifdef CONFIG_DEBUG_DISKIO
# define dio_dbg(format,arg...)    dbg(format,##arg)
# define dio_lldbg(format)	   lldbg(format) 
# define dio_lldbgwait(format)	   lldbgwait(format) 
#else
# define dio_dbg(x...)
# define dio_lldbg(x...)
# define dio_lldbgwait(x...)	
#endif

#ifdef CONFIG_DEBUG_GIDE_C
# define gidec_dbg(format,arg...)    dbg(format,##arg)
# define gidec_lldbg(format)	     lldbg(format) 
#else
# define gidec_dbg(x...) 
# define gidec_lldbg(x...)
#endif

#ifdef CONFIG_DEBUG_GIDE_S
# define gides_dbg(format,arg...)    dbg(format,##arg)
# define gides_lldbg(format)	     lldbg(format) 
#else
# define gides_dbg(x...)
# define gides_lldbg(x...)
#endif


#ifdef CONFIG_DEBUG_FS
# define fs_dbg(format,arg...)    dbg(format,##arg)
# define fs_lldbgwait(format)	   lldbgwait(format) 
# define fs_lldbg(format)	     lldbg(format)
#else
# define fs_dbg(x...)
# define fs_lldbgwait(x...)
# define fs_lldbg(x...)
#endif

#ifdef CONFIG_DEBUG_FS_FAT
# define fsfat_dbg(format,arg...)    dbg(format,##arg)
# define fsfat_lldbgwait(format)	   lldbgwait(format) 
#else
# define fsfat_dbg(x...)
# define fsfat_lldbgwait(x...)
#endif

#ifdef CONFIG_DEBUG_FS_NKC
# define fsnkc_dbg(format,arg...)    dbg(format,##arg)
# define fsnkc_lldbgwait(format)	   lldbgwait(format) 
# define fsnkc_lldbg(format)	     lldbg(format)
#else
# define fsnkc_dbg(x...)
# define fsnkc_lldbgwait(x...)
# define fsnkc_lldbg(x...)
#endif

#ifdef CONFIG_DEBUG_FF
# define ff_dbg(format,arg...)    dbg(format,##arg)
# define ff_lldbgwait(format)	   lldbgwait(format) 
#else
# define ff_dbg(x...)
# define ff_lldbgwait(x...)
#endif



#endif
