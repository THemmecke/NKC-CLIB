#include <time.h>
#include <stdio.h>

#ifdef CONFIG_DEBUG_TIME
#include "../nkc/llnkc.h"
#endif

extern char _monthdays[];
struct tm *localtime(const time_t *time)
{
	struct tm *t = gmtime(time);
	
	#ifdef CONFIG_DEBUG_TIME
	gp_write("localtime (after gmtime)...\n");
	#endif
	
	#ifdef CONFIG_DEBUG_TIME
	gp_write(" sec :"); gp_write_dec_dw((unsigned int)t->tm_sec); gp_write("\n");
	gp_write(" min :"); gp_write_dec_dw((unsigned int)t->tm_min); gp_write("\n");
	gp_write(" hour:"); gp_write_dec_dw((unsigned int)t->tm_hour); gp_write("\n");
	gp_write(" year:"); gp_write_dec_dw((unsigned int)t->tm_year); gp_write("\n");
	gp_write(" mon :"); gp_write_dec_dw((unsigned int)t->tm_mon); gp_write("\n");
	gp_write(" mday :"); gp_write_dec_dw((unsigned int)t->tm_mday); gp_write("\n");
	gp_write(" wday :"); gp_write_dec_dw((unsigned int)t->tm_wday); gp_write("\n");
	#endif
	
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
	#ifdef CONFIG_DEBUG_TIME
	gp_write("...localtime\n");
	#endif
	return t;
}
