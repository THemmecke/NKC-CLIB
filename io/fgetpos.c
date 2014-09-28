#include <stdio.h>
#include <time.h>
#include <libp.h>

int fgetpos(FILE *stream, fpos_t *curpos)
{
	if (stream->token == FILTOK) {
		*curpos = _ll_getpos(stream->fd);
		if (*curpos < 0) {
			stream->flags |= _F_ERR;
			return EOF;
		}
		if (stream->flags & _F_IN)
			*curpos -= stream->level;
		else			
			if (stream->flags & _F_OUT)
				*curpos += stream->level;
		return 0;
	}
	return EOF;
}