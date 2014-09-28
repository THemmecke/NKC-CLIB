#include <stdio.h>

//#define NKC_DEBUG 

#ifdef NKC_DEBUG
#include "../nkc/llnkc.h"
#endif


char *gets(char *buf)
{
	int i = 0,rv;
	
	#ifdef NKC_DEBUG
	nkc_write("scanf...\n");
	#endif
	
	while (1) {
		rv = fgetc(stdin);
		if (rv == EOF)
			break;
			
		fputc(rv,stdout);  // echo back
			
		buf[i++] = (char)rv;
		if (rv == '\n') 
			break;
	}
	if (!i)
		i = 1;
	buf[i-1] = 0;
	if (rv == EOF)
		return 0;
	else return buf;
}
