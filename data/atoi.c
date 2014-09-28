#include <stdio.h>
#include <ctype.h>

long strtol(const char *s, char **endptr, int radix)
{
	int sign = 0;
	int val = 0;

	while (isspace(*s)) s++;

	if (*s == '-') {
		sign++;
		s++;
	}
	else if (*s == '+') 
		s++;
	if (*s == '0') {
		radix = 8;
		s++;
		if (*s == 'x' || *s == 'X') {
			radix = 16;
			s++;
		}
	}
	while(isalnum(*s)) {
		unsigned temp = toupper(*s++)- '0';
		if (temp >= 10)
			temp -= 7;
		if (temp >=radix) {
			s--;
			break;
		}
		val*= radix;
		val += temp;
	}
	if (sign)
		val = -val;
	if (endptr)
		*endptr = s;
	return val;
}
long atol(const char *s)
{
	return strtol(s,0,10);
}