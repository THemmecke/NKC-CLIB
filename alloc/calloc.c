#include <stdlib.h>
#include <string.h>

void *calloc(size_t numelms, size_t elmsize)
{
	unsigned size = numelms * elmsize;
	void *pos;
	pos = malloc(size);
	if (pos)
		memset(pos,0,size);
	return pos;
}