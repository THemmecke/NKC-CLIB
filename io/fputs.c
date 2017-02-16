#include <stdio.h>
#include <string.h>


int fputs(const char *string, FILE *stream)
{
	int l = strlen(string),i;
		
		
	for (i=0; i < l; i++) 
		if (fputc(string[i],stream) == EOF)
			return EOF;
	return 1;
}
