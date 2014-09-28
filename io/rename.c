#include <stdio.h>
#include <time.h>
#include <libp.h>

int rename(const char *name,const char *newname)
{
	return(_ll_rename(name,newname));
}