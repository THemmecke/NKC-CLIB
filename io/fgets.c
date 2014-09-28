#include <stdio.h>


//#define NKC_DEBUG

#ifdef NKC_DEBUG
#include "../nkc/llnkc.h"
#endif

char *fgets(char *buf, int num, FILE *stream)
{
	int i = 0,rv;
	while (1) {
		rv = fgetc(stream);
		if (rv == EOF)
			break;
		
		buf[i++] = (char)rv;
			
		if (--num) {
			//buf[i++] = (char)rv;
			if (rv == '\n') 
				break;
		}
		else
			break;
	}
	buf[i] = 0;
	if (rv == EOF)
		return 0;
	else return buf;
}
