#include <time.h>
#include <stdio.h>
#include <debug.h>

#ifdef NONRECURSIVE
/* only visible within asctime.c */
static char rv[26];
#endif

/*
Convert tm structure to string
Interprets the contents of the tm structure pointed by timeptr as a calendar time and converts it to a C-string containing a human-readable version of the corresponding date and time.

The returned string has the following format:

Www Mmm dd hh:mm:ss yyyy


Where Www is the weekday, Mmm the month (in letters), dd the day of the month, hh:mm:ss the time, and yyyy the year.

The string is followed by a new-line character ('\n') and terminated with a null-character.
*/

char *asctime(const struct tm *time)
{
#ifndef NONRECURSIVE
	char buf[STACKPAD];
	char rv[26];
#endif
	time_lldbg("asctime...\n");
	
	strftime(rv,26,"%a %b %c\n",time);
	
	time_lldbgdec(" sec :",(unsigned int)time->tm_sec);
	time_lldbgdec(" min :",(unsigned int)time->tm_min);
	time_lldbgdec(" hour:",(unsigned int)time->tm_hour);
	time_lldbgdec(" year:",(unsigned int)time->tm_year);
	time_lldbgdec(" mon :",(unsigned int)time->tm_mon);
	time_lldbgdec(" mday:",(unsigned int)time->tm_mday);
	time_lldbgdec(" wday:",(unsigned int)time->tm_wday);
	time_lldbg(rv);

	return (char*)rv;
}
