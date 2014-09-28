#include <stdio.h>

#ifdef CONFIG_DEBUG_XXPRINTF
#include "../nkc/llnkc.h"
#endif


int vfprintf(FILE *stream, const char *format, void *list)
{
	int rv;
	#ifdef USE_DYNAMIC_VSPRINTF_BUFFER
	char *buffer=NULL;
	
	#else
	char buffer[512];	
	#endif
	
	/*
	        Um die Buffergrösse dynamisch zu machen hier nur einen Zeiger auf den Zeiger (NULL) übergeben.
	        In _printchar (sprintf.c) dann entsprechend Chunks von z.B 128 od 512 Bytes allokieren.
	        Hier den Speicher dann vor dem return wieder freigeben.
	*/
	
	#ifdef USE_DYNAMIC_VSPRINTF_BUFFER
	#ifdef CONFIG_DEBUG_XXPRINTF
	nkc_write(" pbuffer-addr = 0x"); nkc_write_hex8(&buffer); nkc_write("\n");
	nkc_write(" pbuffer      = 0x"); nkc_write_hex8(buffer);  nkc_write("\n");
	nkc_getchar();
	#endif
	rv = vsprintf(&buffer,format,list);
	#else
	rv = vsprintf(buffer,format,list);
	#endif
				
	#ifdef CONFIG_DEBUG_XXPRINTF
	nkc_write("DEBUG: <<"); nkc_write(buffer); nkc_write(">>\n");
	#endif		
		
	if (fputs(buffer,stream) == EOF)
		//return 0;
		rv = 0;
		
	#ifdef CONFIG_DEBUG_XXPRINTF
	nkc_write(" pbuffer-addr = 0x"); nkc_write_hex8(&buffer); nkc_write("\n");
	nkc_write(" pbuffer      = 0x"); nkc_write_hex8(buffer);  nkc_write("\n");
	nkc_getchar();
	#endif
		
	#ifdef USE_DYNAMIC_VSPRINTF_BUFFER
	free(buffer);
	#endif	
	
	return rv;
}
int fprintf(FILE *stream, const char *format, ...)
{
	return vfprintf(stream,format,((char *)&format+sizeof(char *)));
}
