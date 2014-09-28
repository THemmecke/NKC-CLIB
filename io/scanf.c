#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <string.h>
#include <libp.h>


//#define NKC_DEBUG 
#ifdef NKC_DEBUG
#include "../nkc/llnkc.h"
#endif


int scanf(const char *format, ...)
{
	char buf[512];
	
	#ifdef NKC_DEBUG
	nkc_write("scanf...\n");
	#endif


	if (!gets(buf))
		return 0;
	return _scanf(buf,format,((char *)&format+sizeof(char *)));
}
