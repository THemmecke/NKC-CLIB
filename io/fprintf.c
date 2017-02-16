#include <stdio.h>
#include <debug.h>

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
	
	xxprintf_lldbghex(" pbuffer-addr = 0x",&buffer);
	xxprintf_lldbghex(" pbuffer      = 0x",buffer);
	xxprintf_lldbgwait(" ");
	
	rv = vsprintf(&buffer,format,list); /* buffer allocation is done here (-> sprintf.c: _printchar() ) ... */
	#else
	rv = vsprintf(buffer,format,list);
	#endif
				
	xxprintf_lldbg("DEBUG: <<"); 
	xxprintf_lldbg(buffer); 
	xxprintf_lldbg(">>\n");
			
		
	if (fputs(buffer,stream) == EOF)
		//return 0;
		rv = 0;
	
	fflush(stream); /* flush the buffer before freeing it ... ! */
		
	xxprintf_lldbghex(" pbuffer-addr = 0x",&buffer);
	xxprintf_lldbghex(" pbuffer      = 0x",buffer);
	xxprintf_lldbgwait(" ");
		
	#ifdef USE_DYNAMIC_VSPRINTF_BUFFER
	free(buffer);
	#endif	
	
	return rv;
}
int fprintf(FILE *stream, const char *format, ...)
{
	return vfprintf(stream,format,((char *)&format+sizeof(char *)));
}
