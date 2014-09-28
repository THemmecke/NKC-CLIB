#include <time.h>
#include <stdio.h>

//#define NKC_DEBUG

#ifdef NKC_DEBUG
#include "../nkc/llnkc.h"
void nkc_write(char* msg);
void nkc_write_hex2(unsigned char val);
void nkc_write_hex8(unsigned int val);
void nkc_write_dec_dw(unsigned int val);
char nkc_getchar(void);
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
	#ifdef NKC_DEBUG
	nkc_write("asctime...\n");
	#endif
	
	strftime(rv,26,"%a %b %c\n",time);
	
	#ifdef NKC_DEBUG
	nkc_write(" sec :"); nkc_write_dec_dw((unsigned int)time->tm_sec); nkc_write("\n");
	nkc_write(" min :"); nkc_write_dec_dw((unsigned int)time->tm_min); nkc_write("\n");
	nkc_write(" hour:"); nkc_write_dec_dw((unsigned int)time->tm_hour); nkc_write("\n");
	nkc_write(" year:"); nkc_write_dec_dw((unsigned int)time->tm_year); nkc_write("\n");
	nkc_write(" mon :"); nkc_write_dec_dw((unsigned int)time->tm_mon); nkc_write("\n");
	nkc_write(" mday :"); nkc_write_dec_dw((unsigned int)time->tm_mday); nkc_write("\n");
	nkc_write(" wday :"); nkc_write_dec_dw((unsigned int)time->tm_wday); nkc_write("\n");
	nkc_write(rv);
	#endif
	
	return (char*)rv;
}
