#include <stdlib.h>
#include <phitext.h>

static PHITEXT phidefaults = { 4,0,0x0f,0,0,0,0x7f,1 };
static  PHITEXT curparms;
/*
#pragma startup wcinit 120
*/
//static void wcinit(void)
void wcinit(void)
{
	curparms = phidefaults;
}
static int flush(char *buf, int i)
{
	if (phidefaults.size != curparms.size)
		buf[i++] = 0xf0 + phidefaults.size;
	if (phidefaults.style != curparms.style)
		buf[i++] = 0xe0 + phidefaults.style;
	if (phidefaults.bgc != curparms.bgc)
		buf[i++] = 0xd0 + phidefaults.bgc;
	if (phidefaults.fgc != curparms.fgc)
		buf[i++] = 0xc0 + phidefaults.fgc;
	if (phidefaults.attrib != curparms.attrib)
		buf[i++] = 0xa0 + phidefaults.attrib;
	if (phidefaults.bank != curparms.bank)
		buf[i++] = 0x90 + phidefaults.bank;
	buf[i++] = 0;
	curparms = phidefaults;
	return i;
}
static int installphichar(wchar_t curchar, unsigned char *buf, int i)
{
	PHITEXT newparms;
	int rv = 0;
	buf = buf + i;
	newparms = curparms;
	newparms.cwb = (char)(curchar & 0x7f);
	if (newparms.cwb >= 32) {
		newparms.size = (char )(curchar >> 28);
		newparms.style = (char)((curchar >> 24) &0x0f);
		newparms.fgc = (char)((curchar >> 20) &0x0f);
		newparms.bgc = (char)((curchar >> 16) &0x0f);
		newparms.attrib = (char)((curchar>>11) & 0x1f);
		newparms.bank = (char)((curchar >> 7) & 0xf);
		if (newparms.size != curparms.size)
			buf[rv++] = 0xf0 + newparms.size;
		if (newparms.style != curparms.style)
			buf[rv++] = 0xe0 + newparms.style;
		if (newparms.bgc != curparms.bgc)
			buf[rv++] = 0xd0 + newparms.bgc;
		if (newparms.fgc != curparms.fgc)
			buf[rv++] = 0xc0 + newparms.fgc;
		if (newparms.attrib != curparms.attrib)
			buf[rv++] = 0xa0 + newparms.attrib;
		if (newparms.bank != curparms.bank)
			buf[rv++] = 0x90 + newparms.bank;
	}
	if (newparms.cwb != curparms.cwb || rv) {
		buf[rv++] = newparms.cwb;
		newparms.repsize = 1;
	}
	else {	
		newparms.repsize++;
		if (newparms.repsize == 2)
			buf[rv++] = newparms.cwb;
		else
			if (newparms.repsize == 3) {
				*(buf-1) = 0x80;
			}
			else
				if (newparms.repsize == 19) {
					buf[rv++] = 0x80;
					*(buf-1) = 0x8f;
				}
				else
					if (newparms.repsize == 260) {
						*(buf-2) = 0x8f;
						*(buf-1) = 0x8f;
						buf[rv++] = 0x80;
					}
					else if (newparms.repsize < 19) {
						(*(buf-1))++;
					}
					else if (newparms.repsize < 260) {
						(*(buf-2))++;
						if (*(buf-2) == 0x90) {
							*(buf-2) = 0x80;
							(*(buf-1))++;
						}
					}
					else {
						(*(buf-3))++;
						if (*(buf-3) == 0x90) {
							*(buf-3) = 0x80;
							(*(buf-2))++;
							if (*(buf-2) == 0x90) {
								*(buf-2) = 0x80;
								(*(buf-1))++;
							}
						}
					}
	}
	if (newparms.cwb == '\n')
		curparms =phidefaults;
	else
		curparms = newparms;
	return(rv);
}
int wctombflush(char *s)
{
	int i;
	if (s)
	{
		return flush(s,0)-1;
	}
	return 0;
}
int wctomb(char *s, wchar_t wchar)
{
	int i=0;
	if (!s) {
		curparms = phidefaults;
		return 0;
	}
	i+=installphichar(wchar,s,i);
	return i;
}
size_t wcstombs(char *mbs, const wchar_t *pwcs, size_t n)
{
	int i=0,j=0;
	if (!mbs) {
		curparms = phidefaults;
		return 0;
	}
	while (j < n)
		i+=installphichar(pwcs[j++],mbs,i);
	return flush(mbs,i)-1;
}
