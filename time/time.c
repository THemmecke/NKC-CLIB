#include <stdio.h>
#include <time.h>
#include <libp.h>



#ifdef CONFIG_DEBUG_TIME
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
	#ifdef CONFIG_DEBUG_TIME
	gp_write("time...\n");
	#endif
	
	_ll_gettime(&t2);
	
	#ifdef CONFIG_DEBUG_TIME
	gp_write(" sec :"); gp_write_dec_dw((unsigned int)t2.tm_sec); gp_write("\n");
	gp_write(" min :"); gp_write_dec_dw((unsigned int)t2.tm_min); gp_write("\n");
	gp_write(" hour:"); gp_write_dec_dw((unsigned int)t2.tm_hour); gp_write("\n");
	gp_write(" year:"); gp_write_dec_dw((unsigned int)t2.tm_year); gp_write("\n");
	gp_write(" mon :"); gp_write_dec_dw((unsigned int)t2.tm_mon); gp_write("\n");
	gp_write(" mday :"); gp_write_dec_dw((unsigned int)t2.tm_mday); gp_write("\n");
	gp_write(" wday :"); gp_write_dec_dw((unsigned int)t2.tm_wday); gp_write("\n");
	#endif
	
	val = mktime(&t2);
	
	if (tptr)
		*tptr = val;
		
	#ifdef NCONFIG_DEBUG_TIME
	gp_write(" ...time\n");
	#endif	
	return val;
}

