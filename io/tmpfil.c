#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <string.h>

#ifdef NONRECURSIVE
static char ibuf[256];
#endif
char *tmpnam(char *buf)
{
#ifndef NONRECURSIVE
	char pbuf[STACKPAD];
	char ibuf[256];
#endif
	time_t time1;
	struct tm *ltime;
	int i,q=0;
	clock_t t;
	FILE *fil;
	time(&time1);
	ltime = localtime(&time1);
	t = clock();
	while (1) {
		ibuf[0] = (char)(ltime->tm_year%26);
		ibuf[1] = (char)ltime->tm_hour;
		ibuf[2] = (char)(ltime->tm_min/36);	// nur A+B !?
		ibuf[3] = (char)(ltime->tm_min%36);
		ibuf[4] = (char)(ltime->tm_sec/36);	// nur A+B !?
		ibuf[5] = (char)(ltime->tm_sec%36);
		ibuf[6] = (char)(t/36);
		ibuf[7] = (char)(t%36);
		ibuf[8] = '.';
		ibuf[9] = 'T';
		ibuf[10] = 'M';
		ibuf[11] = 'P';
		ibuf[12] = 0;
		for (i=0; i < 8; i++) {
			ibuf[i] += 'A';
			if (ibuf[i] > 'Z')
				ibuf[i]+= '0' - 'A';
		}
		fil = fopen(ibuf,"rb");
		if (!fil)
		  break;
		fclose(fil);
/*		if (q % 26 == 0) {
			ltime->tm_mon++;
			if (ltime->tm_mon > 11)
				ltime->tm_mon = 0;
		}
		q++;
		ltime->tm_year++;*/
	}
	if (buf) {
		strcpy(buf,ibuf);
		return buf;
	}
	else
		return &ibuf;
}
FILE *tmpfile(void)
{
	char buf[20];
	FILE *stream = fopen(tmpnam(buf),"wb+");
	if (stream)
		stream->istemp = 1;
	return stream;
}
