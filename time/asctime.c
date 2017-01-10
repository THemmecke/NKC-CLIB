#include <time.h>
#include <stdio.h>

#ifdef CONFIG_DEBUG_TIME
#include "../nkc/llnkc.h"
#endif

#ifdef NONRECURSIVE
/* only visible within asctime.c */
static char rv[26];
#endif


char *asctime(const struct tm *time)
{
#ifndef NONRECURSIVE
	char buf[STACKPAD];
	char rv[26];
#endif
	#ifdef CONFIG_DEBUG_TIME
	gp_write("asctime...\n");
	#endif
	
	strftime(rv,26,"%a %b %c\n",time);
	
	#ifdef CONFIG_DEBUG_TIME
	gp_write(" sec :"); gp_write_dec_dw((unsigned int)time->tm_sec); gp_write("\n");
	gp_write(" min :"); gp_write_dec_dw((unsigned int)time->tm_min); gp_write("\n");
	gp_write(" hour:"); gp_write_dec_dw((unsigned int)time->tm_hour); gp_write("\n");
	gp_write(" year:"); gp_write_dec_dw((unsigned int)time->tm_year); gp_write("\n");
	gp_write(" mon :"); gp_write_dec_dw((unsigned int)time->tm_mon); gp_write("\n");
	gp_write(" mday :"); gp_write_dec_dw((unsigned int)time->tm_mday); gp_write("\n");
	gp_write(" wday :"); gp_write_dec_dw((unsigned int)time->tm_wday); gp_write("\n");
	gp_write(rv);
	#endif
	
	return (char*)rv;
}
