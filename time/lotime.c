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

extern char _monthdays[];
struct tm *localtime(const time_t *time)
{
	struct tm *t = gmtime(time);
	
	#ifdef NKC_DEBUG
	nkc_write("localtime (after gmtime)...\n");
	#endif
	
	#ifdef NKC_DEBUG
	nkc_write(" sec :"); nkc_write_dec_dw((unsigned int)t->tm_sec); nkc_write("\n");
	nkc_write(" min :"); nkc_write_dec_dw((unsigned int)t->tm_min); nkc_write("\n");
	nkc_write(" hour:"); nkc_write_dec_dw((unsigned int)t->tm_hour); nkc_write("\n");
	nkc_write(" year:"); nkc_write_dec_dw((unsigned int)t->tm_year); nkc_write("\n");
	nkc_write(" mon :"); nkc_write_dec_dw((unsigned int)t->tm_mon); nkc_write("\n");
	nkc_write(" mday :"); nkc_write_dec_dw((unsigned int)t->tm_mday); nkc_write("\n");
	nkc_write(" wday :"); nkc_write_dec_dw((unsigned int)t->tm_wday); nkc_write("\n");
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
	#ifdef NKC_DEBUG
	nkc_write("...localtime\n");
	#endif
	return t;
}
