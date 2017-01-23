#ifndef __DEBUG_H
#define __DEBUG_H


/* -------------- enable debugging output ---------------- */
#ifdef CONFIG_DEBUG


static char debugbuf[255];

/* -------------- output to serial port ---------------- */

#ifdef CONFIG_DEBUG_SIO_OUT

#define dbg(format,arg...) \
        sprintf(debugbuf,format,##arg); \
	nkc_ser1_write(debugbuf);
	
#define lldbg(format) \
	nkc_ser1_write(format); 
	
#define lldbgwait(format) \
	nkc_ser1_write(format);// \
	//nkc_ser1_getchar(); 

#define lldbgdec(format,value) \
	nkc_ser1_write(format); \
	gp_ser1_write_dec_dw(value); \
	nkc_ser1_write("\n");	 
		
#define lldbghex(format,value) \
	nkc_ser1_write(format); \
	gp_ser1_write_hex8(value); \
	nkc_ser1_write("\n");		
	
/* -------------- output inline ---------------- */
	
#else

#define dbg(format,arg...) \
        sprintf(debugbuf,format,##arg); \
	nkc_write(debugbuf);

#define lldbg(format) \
	nkc_write(format); 
	
#define lldbgwait(format) \
	nkc_write(format); \
	gp_getchar(); 

#define lldbgdec(format,value) \
	nkc_write(format); \
	nkc_write_dec_dw(value); 
		
#define lldbghex(format,value) \
	nkc_write(format); \
	nkc_write_write_hex8(value); \
	nkc_write("\n");		
#endif

/* -------------- disable debugging output ---------------- */

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
# define clio_lldbgdec(format,value)	lldbgdec(format,value)
# define clio_lldbghex(format,value) lldbghex(format,value)
#else
# define clio_dbg(x...)
# define clio_lldbg(x...)
# define clio_lldbgwait(x...)	
# define clio_lldbgdec(format,value)
# define clio_lldbghex(format,value)
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
# define ff_lldbg(format)	     lldbg(format)
#else
# define ff_dbg(x...)
# define ff_lldbgwait(x...)
# define ff_lldbg(x...)	     lldbg(format)
#endif

#ifdef CONFIG_DEBUG_DRV
# define drv_dbg(format,arg...)    dbg(format,##arg)
# define drv_lldbg(format)	   lldbg(format) 
# define drv_lldbgwait(format)	   lldbgwait(format) 
#else
# define drv_dbg(x...)
# define drv_lldbg(x...)
# define drv_lldbgwait(x...)
#endif

#ifdef CONFIG_DEBUG_DRV_GIDE
# define drvgide_dbg(format,arg...)    dbg(format,##arg)
# define drvgide_lldbg(format)	   lldbg(format) 
# define drvgide_lldbgwait(format)	   lldbgwait(format) 
#else
# define drvgide_dbg(x...)
# define drvgide_lldbg(x...)
# define drvgide_lldbgwait(x...)
#endif

#ifdef CONFIG_DEBUG_DRV_SD
# define drvsd_dbg(format,arg...)    dbg(format,##arg)
# define drvsd_lldbg(format)	   lldbg(format) 
# define drvsd_lldbgwait(format)	   lldbgwait(format)
#else
# define drvsd_dbg(x...)
# define drvsd_lldbg(x...)
# define drvsd_lldbgwait(x...)
#endif

#ifdef CONFIG_DEBUG_DRV_JD
# define drvjd_dbg(format,arg...)    dbg(format,##arg)
# define drvjd_lldbg(format)	   lldbg(format) 
# define drvjd_lldbgwait(format)	   lldbgwait(format)
#else
# define drvjd_dbg(x...)
# define drvjd_lldbg(x...)
# define drvjd_lldbgwait(x...)
#endif

#ifdef CONFIG_DEBUG_MM
# define mm_dbg(format,arg...)    dbg(format,##arg)
# define mm_lldbg(format)	   lldbg(format) 
# define mm_lldbgwait(format)	   lldbgwait(format)
# define mm_lldbgdec(format,value)	lldbgdec(format,value)
# define mm_lldbghex(format,value) lldbghex(format,value)
#else
# define mm_dbg(x...)
# define mm_lldbg(x...)
# define mm_lldbgwait(x...)
# define mm_lldbgdec(format,value)
# define mm_lldbghex(format,value)
#endif

#ifdef CONFIG_DEBUG_XXPRINTF
# define xxprintf_lldbg(format)	   lldbg(format) 
# define xxprintf_lldbgwait(format)	   lldbgwait(format)
# define xxprintf_lldbgdec(format,value)	lldbgdec(format,value)
# define xxprintf_lldbghex(format,value) lldbghex(format,value)
#else
# define xxprintf_lldbg(x...)
# define xxprintf_lldbgwait(x...)
# define xxprintf_lldbgdec(format,value)
# define xxprintf_lldbghex(format,value)
#endif

#endif
