#include <stdio.h>
#include <time.h>
#include <libp.h>


int fgetc(FILE *stream)
{
	int rv;
	
	if (stream->token != FILTOK)
		return EOF;
	if (!(stream->flags & _F_READ)) {
		stream->flags |= _F_ERR;
		return EOF;
	}
	rv = _basegetc(stream);
	return rv;
}
#undef getc
#undef getchar
int getc(FILE *stream)
{
	return fgetc(stream);
}
int getchar(void)
{
	return fgetc(stdin);
}
		





