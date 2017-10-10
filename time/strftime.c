#include <time.h> 
#include <stdio.h>
#include <string.h>
#include <debug.h>

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


/*

Format time as string
Copies into ptr the content of format, expanding its format specifiers into the 
corresponding values that represent the time described in timeptr, with a limit of maxsize characters.


Parameters

ptr
    Pointer to the destination array where the resulting C string is copied.
maxsize
    Maximum number of characters to be copied to ptr, including the terminating null-character.
format
    C string containing any combination of regular characters and special format specifiers. 
    These format specifiers are replaced by the function to the corresponding values to represent the time specified in timeptr. 
    They all begin with a percentage (%) sign, and are:

    specifier	Replaced by	Example
    %a			Abbreviated weekday name *	Thu
    %A			Full weekday name * 	Thursday
    %b			Abbreviated month name *	Aug
    %B			Full month name *	August
    %c			Date and time representation *	Thu Aug 23 14:55:02 2001
    %C			Year divided by 100 and truncated to integer (00-99)	20
    %d			Day of the month, zero-padded (01-31)	23
    %D			Short MM/DD/YY date, equivalent to %m/%d/%y	08/23/01
    %e			Day of the month, space-padded ( 1-31)	23
    %F			Short YYYY-MM-DD date, equivalent to %Y-%m-%d	2001-08-23
    %g			Week-based year, last two digits (00-99)	01
    %G			Week-based year	2001
    %h			Abbreviated month name * (same as %b)	Aug
    %H			Hour in 24h format (00-23)	14
    %I			Hour in 12h format (01-12)	02
    %j			Day of the year (001-366)	235
    %m			Month as a decimal number (01-12)	08
    %M			Minute (00-59)	55
    %n			New-line character ('\n')	
    %p			AM or PM designation	PM
    %r			12-hour clock time *	02:55:02 pm
    %R			24-hour HH:MM time, equivalent to %H:%M	14:55
    %S			Second (00-61)	02
    %t			Horizontal-tab character ('\t')	
    %T			ISO 8601 time format (HH:MM:SS), equivalent to %H:%M:%S	14:55:02
    %u			ISO 8601 weekday as number with Monday as 1 (1-7)	4
    %U			Week number with the first Sunday as the first day of week one (00-53)	33
    %V			ISO 8601 week number (01-53)	34
    %w			Weekday as a decimal number with Sunday as 0 (0-6)	4
    %W			Week number with the first Monday as the first day of week one (00-53)	34
    %x			Date representation *	08/23/01
    %X			Time representation *	14:55:02
    %y			Year, last two digits (00-99)	01
    %Y			Year	2001
    %z			ISO 8601 offset from UTC in timezone (1 minute=1, 1 hour=100)
    If 			timezone cannot be determined, no characters	+100
    %Z			Timezone name or abbreviation *
    			If timezone cannot be determined, no characters	CDT
    %%			A % sign	%

    * The specifiers marked with an asterisk (*) are locale-dependent.
    Note: Yellow rows indicate specifiers and sub-specifiers introduced by C99. 
    Since C99, two locale-specific modifiers can also be inserted between the percentage sign (%) and the specifier proper 
    to request an alternative format, where applicable:

    Modifier	Meaning	Applies to
    E			Uses the locale's alternative representation	%Ec %EC %Ex %EX %Ey %EY
    O			Uses the locale's alternative numeric symbols	%Od %Oe %OH %OI %Om %OM %OS %Ou %OU %OV %Ow %OW %Oy

timeptr
    Pointer to a tm structure that contains a calendar time broken down into its components (see struct tm).



*/
size_t strftime(char *str, size_t maxsize, const char *format_string,
				const struct tm *t)
{
	int i,rv = 0;
	
	time_lldbg("[strftime...\n");
	
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
	time_lldbg("...strftime]\n");
	return(rv);
	
}
