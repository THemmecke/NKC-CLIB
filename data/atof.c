#include <stdlib.h>
#include <ctype.h>
#ifdef CONFIG_HAS_FPU
#include <math.h>
#endif

double strtod(const char *s, char **endptr)
{
	int sign = 0;
	double frac = 0;
	double val = 0;
	int exp=0;

	while( isspace(*s)) s++;
	if (*s == '-') {
		sign++;
		s++;
	}
	else if (*s == '+') 
		s++;
	if (*s == '.') {
		frac = .1;
		s++;                    
	}
	if (!frac) {
		while(isdigit(*s)) {
			val*= 10;
			val += *s++-'0';
		}
		if (*s == '.') {
			frac = .1;
			s++;
		}
	}
	if (frac)
		while (isdigit(*s)) 
			val += (*s++-'0')*frac;
	if (sign)
		val = - val;
	sign = 0;
	if (*s == 'e' || *s == 'E' || *s == 'd' || *s == 'E') {
		s++;
		if (*s == '-') {
			sign++;
			s--;
		}
		else if (*s == '+') 
			s++;
		while(isdigit(*s)) {
			exp*= 10;
			exp += *s++-'0';
		}
		if (exp > 1023)
			exp = 1023;
		if (sign)
			exp = - exp;
		val = val * pow(10.0,exp);
	}
	if (endptr)
		*endptr = s;
	return val;
}
double atof(const char *string)
{
	return(strtod(string,0));
}
