#include <stdlib.h>
#include <string.h>

void *realloc(void *buf, size_t size)
{
	char *ptr;
	ptr = malloc(size);
	memcpy(ptr,buf,size);
	free(buf);
	return ptr;
}