#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <libp.h>

int system(const char *string)
{
	return _ll_system(string);
}