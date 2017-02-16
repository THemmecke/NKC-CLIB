#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>
#include <libp.h>

char **_env_arr;
/*
#pragma startup envset 19
*/

unsigned long _CLIB_BUILD_DATE;
unsigned long _CLIB_BUILD_NUMBER;

extern char   _start;
extern char   __CLIB_BUILD_DATE;
extern char   __CLIB_BUILD_NUMBER;

void envset(void)
{
	int count = _ll_getenv(0,0),i;
	if (count) {
		_env_arr  = malloc(sizeof(char *)*(count+1));
	  for (i=1; i<=count; i++) {
			char buf[1024];
			_ll_getenv(buf,i);		 
		  _env_arr[i-1] = malloc(strlen(buf)+1);
		  strcpy(_env_arr[i-1],buf);
		}
		_env_arr[count] = 0;
	}
	else {		
		_env_arr = malloc(sizeof(char *));
		_env_arr[0] = 0;
	}
	
	/* set build date an number info */
	
	_CLIB_BUILD_DATE = (unsigned long) &__CLIB_BUILD_DATE - (unsigned long) &_start;
	_CLIB_BUILD_NUMBER = (unsigned long) &__CLIB_BUILD_NUMBER - (unsigned long) &_start;
	
}
