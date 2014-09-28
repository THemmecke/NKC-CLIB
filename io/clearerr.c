#include <stdio.h>

void clearerr(FILE *stream)
{
	if (stream->token == FILTOK)
		stream->flags &= ~(_F_ERR | _F_EOF);
}