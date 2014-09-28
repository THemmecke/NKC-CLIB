#include <stdio.h>
#include <time.h>
#include <libp.h>

void nkc_write(char* msg);

int fgetc(FILE *stream)
{
	int rv;
	
	//nkc_write("fgetc...\n");
	if (stream->token != FILTOK)
		return EOF;
	if (!(stream->flags & _F_READ)) {
		stream->flags |= _F_ERR;
		return EOF;
	}
	rv = _basegetc(stream);
	//nkc_write("fgetc..end\n");
	return rv;
}
#undef getc
#undef getchar
int getc(FILE *stream)
{
	//nkc_write("getc...\n");
	return fgetc(stream);
}
int getchar(void)
{
	//nkc_write("getchar...\n");
	return fgetc(stdin);
}
		





