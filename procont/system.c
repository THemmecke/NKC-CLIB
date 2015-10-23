#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <libp.h>

// invokes the command processor to execute a command
int system(const char *string)
{
	return _ll_system(string);
}
