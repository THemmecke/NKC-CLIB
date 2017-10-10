#include <time.h>
#include <debug.h>

char *ctime(const time_t *timer)
{
	time_lldbg("[ctime...\n");
	struct tm *t = localtime(timer), t1 = *t;
	
	time_lldbgdec(" sec :",(unsigned int)t->tm_sec);
	time_lldbgdec(" min :",(unsigned int)t->tm_min);
	time_lldbgdec(" hour:",(unsigned int)t->tm_hour);
	time_lldbgdec(" year:",(unsigned int)t->tm_year);
	time_lldbgdec(" mon :",(unsigned int)t->tm_mon);
	time_lldbgdec(" mday:",(unsigned int)t->tm_mday);
	time_lldbgdec(" wday:",(unsigned int)t->tm_wday);

	time_lldbg("...ctime]\n");
	return asctime(&t1);
}
