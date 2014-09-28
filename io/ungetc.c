#include <stdio.h>

#undef ungetc
int ungetc(int c, FILE *stream)
{
	if (stream->token != FILTOK)
		return EOF;
	if (stream->buffer) {
		if ((stream->flags & _F_IN) && stream->curp != stream->buffer) {
			stream->level++;
			(*--stream->curp) = (char)c;
		}
		else {
			if (fflush(stream))
				return EOF;
			stream->flags |= _F_IN;
	    stream->level = 1;
			stream->curp = stream->buffer+stream->bsize;
			*--stream->curp = (char)c;
		}
	}
	else {
		if (stream->hold)
			return EOF;
		stream->hold = (char)c;
	}
	return c;
}