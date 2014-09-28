#include <stdio.h>
#include <time.h>
#include <libp.h>


//#define NKC_DEBUG


#ifdef NKC_DEBUG
#include "../nkc/llnkc.h"
#endif

/*
 struct tm
		{ //int = 32bit
		  int   tm_sec;    	// seconds after the minute	0-61*
		  int   tm_min;		// minutes after the hour	0-59
		  int   tm_hour;	// hours since midnight		0-23
		  int   tm_mday;	// day of the month		1-31
		  int   tm_mon;		// months since January		0-11
		  int   tm_year;	// years since 1900
		  int   tm_wday;	// days since Sunday		0-6
		  int   tm_yday;	// days since January 1		0-365
		  int   tm_isdst;	// Daylight Saving Time flag
		};
*/

time_t time(time_t *tptr)
{
	long val;	
	struct tm t2;
	#ifdef NKC_DEBUG
	nkc_write("time...\n");
	#endif
	
	_ll_gettime(&t2);
	
	#ifdef NKC_DEBUG
	nkc_write(" sec :"); nkc_write_dec_dw((unsigned int)t2.tm_sec); nkc_write("\n");
	nkc_write(" min :"); nkc_write_dec_dw((unsigned int)t2.tm_min); nkc_write("\n");
	nkc_write(" hour:"); nkc_write_dec_dw((unsigned int)t2.tm_hour); nkc_write("\n");
	nkc_write(" year:"); nkc_write_dec_dw((unsigned int)t2.tm_year); nkc_write("\n");
	nkc_write(" mon :"); nkc_write_dec_dw((unsigned int)t2.tm_mon); nkc_write("\n");
	nkc_write(" mday :"); nkc_write_dec_dw((unsigned int)t2.tm_mday); nkc_write("\n");
	nkc_write(" wday :"); nkc_write_dec_dw((unsigned int)t2.tm_wday); nkc_write("\n");
	#endif
	
	val = mktime(&t2);
	
	if (tptr)
		*tptr = val;
		
	#ifdef NKC_DEBUG
	nkc_write(" ...time\n");
	#endif	
	return val;
}

