#include <time.h>

//#define NKC_DEBUG

#ifdef NKC_DEBUG
#include "../nkc/llnkc.h"
void nkc_write(char* msg);
void nkc_write_hex2(unsigned char val);
void nkc_write_hex8(unsigned int val);
void nkc_write_dec_dw(unsigned int val);
char nkc_getchar(void);
#endif

char *ctime(const time_t *timer)
{
	#ifdef NKC_DEBUG
	nkc_write("ctime...\n");
	#endif
	struct tm *t = localtime(timer), t1 = *t;
	
	#ifdef NKC_DEBUG
	nkc_write(" sec :"); nkc_write_dec_dw((unsigned int)t->tm_sec); nkc_write("\n");
	nkc_write(" min :"); nkc_write_dec_dw((unsigned int)t->tm_min); nkc_write("\n");
	nkc_write(" hour:"); nkc_write_dec_dw((unsigned int)t->tm_hour); nkc_write("\n");
	nkc_write(" year:"); nkc_write_dec_dw((unsigned int)t->tm_year); nkc_write("\n");
	nkc_write(" mon :"); nkc_write_dec_dw((unsigned int)t->tm_mon); nkc_write("\n");
	nkc_write(" mday :"); nkc_write_dec_dw((unsigned int)t->tm_mday); nkc_write("\n");
	nkc_write(" wday :"); nkc_write_dec_dw((unsigned int)t->tm_wday); nkc_write("\n");
	#endif
	
	return asctime(&t1);
}
