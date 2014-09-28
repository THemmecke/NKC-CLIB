#include <stdio.h>
#include <time.h>
#include <libp.h>

#include "../nkc/llnkc.h"

int _baseputc(int c, FILE *stream);

int fputc(int c, FILE *stream)
{		
	
	if (stream->token != FILTOK)
	{		
		return EOF;
	}
	
	if (!(stream->flags & _F_WRIT)) {		
		stream->flags |= _F_ERR;
		return EOF;
	}
	return _baseputc(c,stream);
}
#undef putc
#undef putchar
int putc(int c, FILE *stream)
{
	return fputc(c,stream);
}
int putchar(int c)
{
	return fputc(c,stdout);
}
