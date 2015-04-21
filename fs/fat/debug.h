#ifndef __DEBUG_H
#define __DEBUG_H


#ifdef CONFIG_DEBUG_FS_FAT

#include "../../nkc/llnkc.h"

#define dbg(format,arg...) \
	printf(format,##arg); \
	
#define lldbg(format) \
	nkc_write(format);
	
#define lldbgwait(format) \
	nkc_write(format); \
	nkc_getchar();

#define lldbgdec(format,value) \
	nkc_write(format); \
	nkc_write_dec_dw(value); \
	nkc_write("\n");
		
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




#ifdef CONFIG_DEBUG_DISKIO
# define dio_dbg(format,arg...)    dbg(format,##arg)
# define dio_lldbgwait(format)	   lldbgwait(format) 
#else
# define dio_dbg(x...)
# define dio_lldbgwait(x...)	
#endif

#ifdef CONFIG_DEBUG_GIDE_C
# define gidec_dbg(format,arg...)    dbg(format,##arg)
#else
# define gidec_dbg(x...)    
#endif

#ifdef CONFIG_DEBUG_GIDE_S
# define gides_dbg(format,arg...)    dbg(format,##arg)
#else
# define gides_dbg(x...)
#endif

#ifdef CONFIG_DEBUG_FF
# define ff_dbg(format,arg...)    dbg(format,##arg)
# define ff_lldbgwait(format)	   lldbgwait(format) 
#else
# define ff_dbg(x...)
# define ff_lldbgwait(x...)
#endif


#endif
