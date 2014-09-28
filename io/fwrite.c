#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <string.h>
#include <libp.h>


//#define NKC_DEBUG

#ifdef NKC_DEBUG
#include "../nkc/llnkc.h"
#endif

size_t fwrite(const void *buf, size_t size, size_t count, FILE *stream)
{
	int len = size * count,i,c;
	
	#ifdef NKC_DEBUG
	nkc_write("fwrite...\n");
	#endif


	if (stream->token != FILTOK)
	{
		#ifdef NKC_DEBUG
		nkc_write("...fwrite(1)\n"); nkc_getchar();
		#endif
		return 0;
	}
	if (!(stream->flags & _F_WRIT)) 
	{
		stream->flags |= _F_ERR;	  
		#ifdef NKC_DEBUG
		nkc_write("...fwrite(2)\n"); nkc_getchar();
		#endif	
		return 0;
	   
	}
	for (i=0; i < len; i++)
	{
		c = _baseputc(*((unsigned char *)buf++),stream);
		if (c == EOF)
		{
			#ifdef NKC_DEBUG
			nkc_write("...fwrite(3)\n"); nkc_getchar();
			#endif
			return i / size;
		}
	}
	
	#ifdef NKC_DEBUG
	nkc_write("...fwrite\n"); nkc_getchar();
	#endif
	return count;
}
