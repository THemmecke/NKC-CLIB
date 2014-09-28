#include <stdio.h>

void setbuf(FILE *stream, char *buffer)
{
	if (buffer) 
		setvbuf(stream,buffer,_IOFBF,BUFSIZ);
	else
		setvbuf(stream,buffer,_IONBF,BUFSIZ);
}
