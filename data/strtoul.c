#include <stdlib.h>
#include <ctype.h>
unsigned long strtoul(const char *s, char **endptr, int radix)
{
	int val = 0;

	while (isspace(*s)) s++;

	if (*s == '0') {
		radix = 8;
		s++;
		if (*s == 'x' || *s == 'X') {
			radix = 16;
			s++;
		}
	}
	while(isalnum(*s)) {
		unsigned temp = toupper(*s++)-'0';
		if (temp >= 10)
			temp -= 7;
		if (temp >= radix) {
			s--;
			break;
		}
		val*= radix;
		val += temp;
	}
	if (endptr)
		*endptr = s;
	return val;
}