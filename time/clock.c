#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <libp.h>

clock_t clock(void)
{
	return _ll_ticks();
}