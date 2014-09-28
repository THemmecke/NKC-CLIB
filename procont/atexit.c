#include <stdlib.h>

#define MAX_ATEXIT 32

extern int _abterm;

static int atexitval = 0;
static void (*funclist[MAX_ATEXIT])(void);

/*
#pragma rundown procexit 128
*/

//static void procexit(void)
// should be globaly visible
void procexit(void)
{
	int i;
	if (!_abterm)
		for (i=atexitval; i >0; i--)
			(*funclist[i-1])();
}




int atexit(void (*func)(void))
{
	if (atexitval < MAX_ATEXIT) {
		funclist[atexitval++] = func;
	  return 0;
	}
  return -1;
}
		
