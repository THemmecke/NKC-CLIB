#include <stdio.h>
#include <time.h>
#include <libp.h>
#include <debug.h>

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


/*
Get current time
Get the current calendar time as a value of type time_t.

The function returns this value, and if the argument is not a null pointer, it also sets this value to the object pointed by timer.

The value returned generally represents the number of seconds since 00:00 hours, Jan 1, 1970 UTC (i.e., the current unix timestamp). 
Although libraries may use a different representation of time: Portable programs should not use the value returned by this function directly, 
but always rely on calls to other elements of the standard library to translate them to portable types (such as localtime, gmtime or difftime).
*/

time_t time(time_t *tptr)
{
	long val;	
	struct tm t2;
	
	time_lldbg("[time...\n");
	
	_ll_gettime(&t2);
	t2.tm_mon--;
	
	time_lldbgdec(" sec :",(unsigned int)t2.tm_sec);
	time_lldbgdec(" min :",(unsigned int)t2.tm_min);
	time_lldbgdec(" hour:",(unsigned int)t2.tm_hour);
	time_lldbgdec(" year:",(unsigned int)t2.tm_year);
	time_lldbgdec(" mon :",(unsigned int)t2.tm_mon);
	time_lldbgdec(" mday:",(unsigned int)t2.tm_mday);
	time_lldbgdec(" wday:",(unsigned int)t2.tm_wday);
	
	

	val = mktime(&t2);
	
	if (tptr)
		*tptr = val;
		
	time_lldbg("...time]\n");	
	return val;
}

