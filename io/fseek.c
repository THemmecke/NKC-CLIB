#include <stdio.h>
#include <time.h>
#include <libp.h>

int fseek (FILE *stream, long offset, int origin)
{
	if (stream->token != FILTOK)
		return EOF;
	switch (origin) {
		case SEEK_SET:
		case SEEK_END:
		case SEEK_CUR:
			if (fflush(stream)) {
				stream->flags |= _F_ERR;
				return EOF;
			}
			if (_ll_seek(stream->fd,offset,origin)) {
				stream->flags |= _F_ERR;
				return EOF;
			}
			break;
		default:
			return EOF;
	}
	return 0;
}