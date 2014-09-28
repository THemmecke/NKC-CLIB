/*
 * strdup.c
 */

#include <stdlib.h>
#include <string.h>

char *strdup(const char *string)
{
	char *rv = malloc(strlen(string)+1);
	strcpy(rv,string);
  return rv;
}