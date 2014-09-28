#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>
#include <libp.h>

//#define NKC_DEBUG
#include "../nkc/llnkc.h"

extern void *_allocbloc;
extern int _allocflag;


void free(void *buf)
{
	
	_ll_free(buf);
}
