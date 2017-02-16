#include <time.h>

#ifdef CONFIG_DEBUG_TIME
#include "../nkc/llnkc.h"
#endif

char *ctime(const time_t *timer)
{
	#ifdef CONFIG_DEBUG_TIME
	gp_write("ctime...\n");
	#endif
	struct tm *t = localtime(timer), t1 = *t;
	
	#ifdef CONFIG_DEBUG_TIME
	gp_write(" sec :"); gp_write_dec_dw((unsigned int)t->tm_sec); gp_write("\n");
	gp_write(" min :"); gp_write_dec_dw((unsigned int)t->tm_min); gp_write("\n");
	gp_write(" hour:"); gp_write_dec_dw((unsigned int)t->tm_hour); gp_write("\n");
	gp_write(" year:"); gp_write_dec_dw((unsigned int)t->tm_year); gp_write("\n");
	gp_write(" mon :"); gp_write_dec_dw((unsigned int)t->tm_mon); gp_write("\n");
	gp_write(" mday :"); gp_write_dec_dw((unsigned int)t->tm_mday); gp_write("\n");
	gp_write(" wday :"); gp_write_dec_dw((unsigned int)t->tm_wday); gp_write("\n");
	#endif
	
	return asctime(&t1);
}
