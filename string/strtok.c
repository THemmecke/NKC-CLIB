#include <string.h>

/* note this is non-reentrant! */

static char *pos=0;
char *strtok(char *string, const char *string2)
{
	if (string == 0) {
		string = pos;
		if (string == 0)
			return 0;
	}
	if (!string || *string == 0)
		return 0;
	pos = strpbrk(string,string2);
	if (!*pos)
		return 0;
	*pos++ = 0;
	return string;
}