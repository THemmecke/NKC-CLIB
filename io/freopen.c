#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <string.h>
#include <libp.h>

extern FILE *_pstreams[_NFILE_];
extern char *_filenames[_NFILE_];
extern int maxfiles ;

FILE *freopen(const char *name, const char *mode, FILE *stream)
{
	if (_basefclose(stream,0))
		return 0;
	if (!_basefopen(name,mode,stream))
		return 0;
	return stream;
}