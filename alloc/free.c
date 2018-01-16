#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>
#include <libp.h>

extern void *_allocbloc;
extern int _allocflag;


void free(void *buf)
{
	
	_ll_free(buf);
}
