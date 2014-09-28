#include <time.h>
#include <stdio.h>

char _monthdays[12] = { 31,28,31,30,31,30,31,31,30,31,30,31 };

#ifdef NONRECURSIVE
static struct tm rv;
#endif

struct tm *gmtime(const time_t *time)
{
#ifndef NONRECURSIVE
	char buf[STACKPAD];
	struct tm rv;
#endif
	time_t t = *time;
	int temp1,x=0;
	rv.tm_sec = t %60;
	t/=60;
	rv.tm_min = t %60;
	t /=60;
	rv.tm_hour = t %24;
	t /=24;
	rv.tm_yday = t;
	rv.tm_wday = (t + 4 ) % 7;
	rv.tm_year = 70+(rv.tm_yday /365);
	rv.tm_yday = rv.tm_yday % 365;
	rv.tm_yday -= (rv.tm_year - 69)/4;
	if (rv.tm_yday <0) {
		rv.tm_yday = 364;
		rv.tm_year--;
		if (!((rv.tm_year-72)%4))
			rv.tm_yday++;
	}
	if (rv.tm_yday > 31+28+1 && ((rv.tm_year-72) %4 == 0) && (rv.tm_year != 30)) {
		_monthdays[1] = 29;
	}
	else
		_monthdays[1] = 28;
	temp1 = rv.tm_yday;
	rv.tm_mon = -1;
	while (temp1 >=0) 
		temp1-=_monthdays[++rv.tm_mon];
	rv.tm_mday = temp1 + _monthdays[rv.tm_mon]+1;
	rv.tm_isdst = 0;
	return &rv;
}
	
