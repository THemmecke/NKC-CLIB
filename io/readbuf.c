#include <stdio.h>
#include <time.h>
#include <libp.h>
#include <debug.h>

int _readbuf(FILE *stream)
{	
	clio_lldbg("_readbuf...\n");

	if (!(stream->flags & _F_IN) || !stream->level)  // stream is NOT incoming or buffer empty
	{
		if (stream->flags & _F_OUT) // file is outgoing
		{			
			if (fflush(stream))
			{
				clio_lldbgwait("..._readbuf(1)\n"); 
				return EOF;
			}
		}
		
		stream->flags &= ~_F_OUT;  	// clear "outgoing" flag
		if (!(stream->flags & _F_IN)) 	// stream is NOT incoming
		{
			stream->level = 0;		// reset buffer fill level
			stream->curp = stream->buffer;	// reset curp to start of buffer
			stream->hold = 0;		// reset ungetchar
		}
		
		stream->flags |= _F_IN;		// set stream to incoming
		if (!stream->level) 		// buffer is empty
		{
			stream->curp = stream->buffer; // reset curp to start of buffer
			if (stream->flags & _F_LBUF)   // if stream is "line-buffered" ...
			{
				while (stream->level < stream->bsize) // ... fill buffer
				{					
					clio_lldbg("#");
					int sz = _ll_read(stream->fd,stream->curp,1);	// -> nkc/llstd.S	
										
															
					if (!sz)		// if no characters could be read, we can break
						break;
						
					stream->level++;	// increment fill level
					
					if ((*stream->curp == '\n') || (*stream->curp == '\r'))
						break;		// break on newline or linefeed
						
					
					if( (*stream->curp == 0) && !(stream->flags & _F_BIN)) // JADOS EOF for ASCII files
					{
					/*
						while (stream->level < stream->bsize) // ... fill rest of buffer with NULL
						{ 
						  *(stream->curp++) = 0;				
						  stream->level++;	// increment fill level
						}
					*/	
						clio_lldbg(" JADOS EOF\n");
						stream->flags |= _F_EOF;
						stream->curp = stream->buffer;	// reset current active pointer to start of buffer
						clio_lldbgwait("..._readbuf(2)\n"); 
						return EOF;
						break;				//break on 0 if ASCII file (JADOS EOF)
					}
					
						
					stream->curp++;				// increment curp
				}
				stream->curp = stream->buffer;	// reset current active pointer to start of buffer
			}						
			else 
			{	// stream is not buffered, so ask OS to fill buffer direct with bsize characters:
				clio_lldbg("before call to _ll_read:\n");
				clio_lldbghex(" fd=0x",stream->fd);
				clio_lldbghex(" buf=0x",(int)stream->buffer);
				clio_lldbghex(" size=0x",stream->bsize);
				
				stream->level = _ll_read(stream->fd,stream->buffer,stream->bsize);  // -> nkc/llstd.S
			}	
		}
	}
	
	if (stream->level == 0) // if fill level is 0 we have reached the end of the file
	{	
		clio_lldbgwait("..._readbuf(EOF)\n");
		stream->flags |= _F_EOF;
		return EOF;
	}
	
	clio_lldbg("..._readbuf\n"); 
	return 0;
}
