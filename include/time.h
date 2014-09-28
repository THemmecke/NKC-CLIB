/*  time.h                               

    Struct and function declarations for dealing with time.

*/

#ifndef __TIME_H
#define __TIME_H

#ifndef _SIZE_T
#define _SIZE_T
typedef unsigned size_t;
#endif

#ifndef  _TIME_T
#define  _TIME_T
typedef long time_t;
#endif

#ifndef  _CLOCK_T
#define  _CLOCK_T
typedef long clock_t;
#endif

#define CLOCKS_PER_SEC 1000.0
#define CLK_TCK        1000.0

#define TZNAME "Eastern Standard Time"
#define GMT_OFFS 7

#define NONRECURSIVE

struct tm
{
  int   tm_sec;
  int   tm_min;
  int   tm_hour;
  int   tm_mday;
  int   tm_mon;
  int   tm_year;
  int   tm_wday;
  int   tm_yday;
  int   tm_isdst;
};

char *   asctime(const struct tm *__tblock);
char *   ctime(const time_t *__time);
double      difftime(time_t __time2, time_t __time1);
struct tm * gmtime(const time_t *__timer);
struct tm * localtime(const time_t *__timer);
time_t      time(time_t *__timer);
time_t        mktime(struct tm *__timeptr);
clock_t     clock(void);
size_t        strftime(char *__s, size_t __maxsize,
                        const char *__fmt, const struct tm *__t);
size_t        _lstrftime(char *__s, size_t __maxsize,
                        const char *__fmt, const struct tm *__t);

int  *        __getDaylight(void);
long *        __getTimezone(void);
char * * __getTzname(void);

#define _daylight (*__getDaylight())
#define _tzname   ( __getTzname())
#define _timezone (*__getTimezone())

int                   stime(time_t *__tp);
void         tzset(void);
char *  _strdate(char *datestr);
char *  _strtime(char *timestr);


#endif  /* __TIME_H */
