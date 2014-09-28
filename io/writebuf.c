#include <stdio.h>



int _writebuf(FILE *stream)
{
	
	
	if ((stream->flags & _F_IN) || (( stream->flags & _F_OUT) && stream->curp >=stream->bsize + stream->buffer)) {
		
		if (fflush(stream))
			return EOF;
		
		goto join;
	}
	else {
		
		if (!(stream->flags & _F_OUT)) {
join:
			stream->flags &= ~(_F_IN | _F_OUT);
			stream->level = 0;
			stream->curp = stream->buffer;
			
		}
	}
	return 0;
}
