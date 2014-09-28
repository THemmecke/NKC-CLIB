#include <stdio.h>

int fsetpos(FILE *stream, const fpos_t *currentpos)
{
	if (stream->token == FILTOK)
		stream->flags &= ~_F_EOF;
	return fseek(stream,*currentpos,SEEK_SET);
}