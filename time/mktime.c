#include <stdio.h>
#include <time.h>

static char _monthdays[12] = { 31,28,31,30,31,30,31,31,30,31,30,31 };

#ifdef NONRECURSIVE
static time_t days;
#endif
time_t mktime(struct tm *timeptr)
{
#ifndef NONRECURSIVE
	char buf[STACKPAD];
	time_t days;
#endif
	int i = 0;
	struct tm t = *timeptr;
/*	t.tm_year += 1900;*/
	t.tm_year += 2000;		
/*	t.tm_hour-=GMT_OFFS; */
	if (t.tm_hour<0) {
		t.tm_hour = 23;
		t.tm_mday--;
		if (t.tm_mday < 1) {
			t.tm_mon--;
			if (t.tm_mon <0) {
				t.tm_mon = 11;
				t.tm_year--;
			}
			t.tm_mday = _monthdays[t.tm_mon];
		}
	}
	if (t.tm_year < 1970 || t.tm_year > 2038)
		return -1;
	if (!((t.tm_year - 1972)%4) && t.tm_year != 2000)
		_monthdays[1] = 29;
	else
		_monthdays[1] = 28;
	days = (t.tm_year - 1970)*365;
	days += (t.tm_year -1969)/4;
	for (i=0; i < t.tm_mon; i++)
		days += _monthdays[i];
	days += t.tm_mday-1;
	days *=24;
	days += t.tm_hour;
	days *=60;
	days += t.tm_min;
	days *=60;
	days += t.tm_sec;
	return days;
}
