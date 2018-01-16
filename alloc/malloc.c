#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>
#include <libp.h>


void *_allocbloc = 0;
int _allocflag = 0;


void *malloc(size_t size)
{
	return _ll_malloc(size); 
}
