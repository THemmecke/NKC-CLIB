#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>
#include <libp.h>

char **_env_arr;
/*
#pragma startup envset 19
*/


void nkc_write(char* msg);

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
}
