#include <time.h>
#include <stdio.h>
#include <debug.h>

extern char _monthdays[];
struct tm *localtime(const time_t *time)
{
	struct tm *t = gmtime(time);
	
	time_lldbg("[localtime (after gmtime)...\n");
		
	time_lldbgdec(" sec :",(unsigned int)t->tm_sec);
	time_lldbgdec(" min :",(unsigned int)t->tm_min);
	time_lldbgdec(" hour:",(unsigned int)t->tm_hour);
	time_lldbgdec(" year:",(unsigned int)t->tm_year);
	time_lldbgdec(" mon :",(unsigned int)t->tm_mon);
	time_lldbgdec(" mday:",(unsigned int)t->tm_mday);
	time_lldbgdec(" wday:",(unsigned int)t->tm_wday);
	
/*	t->tm_hour += GMT_OFFS; */
	if (t->tm_hour > 23) {
		t->tm_hour -= 24;
		t->tm_mday++;
		if (_monthdays[t->tm_mon] < t->tm_mday) {
			t->tm_mon++;
			t->tm_mday = 1;
			if (t->tm_mon > 12) {
				t->tm_mon = 1;
				t->tm_year++;
			}
		}
	}
	time_lldbg("...localtime]\n");
	return t;
}
