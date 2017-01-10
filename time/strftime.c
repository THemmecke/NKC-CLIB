#include <time.h> 
#include <stdio.h>
#include <string.h>

#ifdef CONFIG_DEBUG_TIME
#include "../nkc/llnkc.h"
#endif

static char *_days[7] = { "Sun", "Mon","Tue","Wed","Thu","Fri","Sat" };
static char *_months[12] = { "Jan", "Feb", "Mar","Apr","May","Jun",
			"Jul","Aug","Sep","Oct","Nov","Dec" };
static char *_ampm[2] = { "am", "pm" };
static char *_ldays[7] = { "Sunday", "Monday","Tuesday","Wednesday","Thursday",
		"Friday","Saturday" };
static char *_lmonths[12] = { "January", "February", "March","April","May","June",
		"July","August","September","October","November","December" };

static int pstr(char *str,char *astr, int maxsize, int *cursize)
{
	int l;
	if (*cursize > maxsize)
		return 1;
	l = strlen(astr);
	str += *cursize;
	while (*cursize < maxsize-1 && l) {
		*str++ = *astr++;
		(*cursize)++;
		l--;
	}
	*str = 0;
	if (l)
		return 1;
	return 0;
}
static int pchar(char *str,char astr, int maxsize, int *cursize)
{
	if (*cursize > maxsize)
		return 1;
	str += *cursize;
	*str++ = astr;
	(*cursize)++;
	*str = 0;
	return 0;
}
static int pnum(char *str, int num, int fwidth, int maxsize, int *cursize)
{
	char buf[11],*p = &buf[9];
	int i;

	for (i=0; i < 10; i++)
		buf[i] = '0';
	buf[10] = 0;
	while (num) {
		*p-- = (char)(num %10)+'0';
		num = (num / 10);
	}
	return(pstr(str,buf+10-fwidth,maxsize,cursize));
}
size_t strftime(char *str, size_t maxsize, const char *format_string,
				const struct tm *t)
{
	int i,rv = 0;
	
	#ifdef CONFIG_DEBUG_TIME
	gp_write("strftime...\n");
	#endif
	
	for (i=0; i < strlen(format_string); i++) {
		if (format_string[i] == '%') {
			i++;
			switch(format_string[i]) {
				case 'a':
					if (pstr(str,_days[t->tm_wday],maxsize,&rv))
						return 0;
					break;
				case 'A':
					if (pstr(str,_ldays[t->tm_wday],maxsize,&rv))
						return 0;
					break;
				case 'b':
					if (pstr(str,_months[t->tm_mon],maxsize,&rv))
						return 0;
					break;
				case 'B':
					if (pstr(str,_lmonths[t->tm_mon],maxsize,&rv))
						return 0;
					break;
				case 'c':
					if (pnum(str,t->tm_mday,2,maxsize,&rv))
						return 0;
					if (pstr(str," ",maxsize,&rv))
						return 0;
					if (pnum(str,t->tm_hour,2,maxsize,&rv))
						return 0;
					if (pstr(str,":",maxsize,&rv))
						return 0;
					if (pnum(str,t->tm_min,2,maxsize,&rv))
						return 0;
					if (pstr(str,":",maxsize,&rv))
						return 0;
					if (pnum(str,t->tm_sec,2,maxsize,&rv))
						return 0;
					if (pstr(str," ",maxsize,&rv))
						return 0;
					if (pnum(str,t->tm_year+1900,4,maxsize,&rv))
						return 0;
					break;
				case 'd':
					if (pnum(str,t->tm_mday,2,maxsize,&rv))
						return 0;
					break;
				case 'H':
					if (pnum(str,t->tm_hour,2,maxsize,&rv))
						return 0;
					break;
				case 'i':
					if (pnum(str,t->tm_hour%12+1,2,maxsize,&rv))
						return 0;
					break;
				case 'j':
					if (pnum(str,t->tm_yday,3,maxsize,&rv))
						return 0;
					break;
				case 'm':
					if (pnum(str,t->tm_mon,2,maxsize,&rv))
						return 0;
					break;
				case 'M':
					if (pnum(str,t->tm_min,2,maxsize,&rv))
						return 0;
					break;
				case 'P':
					if (pstr(str,_ampm[t->tm_hour/12],maxsize,&rv))
						return 0;
					break;
				case 'S':
					if (pnum(str,t->tm_sec,2,maxsize,&rv))
						return 0;
					break;
				case 'U':
					/* This should start with the first sunday */
					if (pnum(str,(t->tm_yday-1+(7-t->tm_wday))/7,2,maxsize,&rv))
						return 0;
					break;
				case 'w':
					if (pnum(str,t->tm_wday,1,maxsize,&rv))
						return 0;
					break;
				case 'W':
					/* This should start with the first monday */
					if (pnum(str,(t->tm_yday-1+(7-t->tm_wday))/7,2,maxsize,&rv))
						return 0;
					break;
				case 'x':
					if (pnum(str,t->tm_mday,2,maxsize,&rv))
						return 0;
					if (pstr(str," ",maxsize,&rv))
						return 0;
					if (pnum(str,t->tm_year+1900,4,maxsize,&rv))
						return 0;
					break;
				case 'X':
					if (pnum(str,t->tm_hour,2,maxsize,&rv))
						return 0;
					if (pstr(str,":",maxsize,&rv))
						return 0;
					if (pnum(str,t->tm_min,2,maxsize,&rv))
						return 0;
					if (pstr(str,":",maxsize,&rv))
						return 0;
					if (pnum(str,t->tm_sec,2,maxsize,&rv))
						return 0;
					break;
				case 'y':
					if (pnum(str,t->tm_year %100,2,maxsize,&rv))
						return 0;
					break;
				case 'Y':
					if (pnum(str,t->tm_year+1900,4,maxsize,&rv))
						return 0;
					break;
				case 'z':
					if (pstr(str,TZNAME,maxsize,&rv))
						return 0;
					break;
				default:
					if (pchar(str,format_string[i],maxsize,&rv))
						return 0;
					
			}
		}
		else {
			if (pchar(str,format_string[i],maxsize,&rv))
				return 0;
		}
	}
	return(rv);
	
}
