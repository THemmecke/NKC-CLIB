#include <stdlib.h>
#include <phitext.h>

static PHITEXT phidefaults = { 4,0,0x0f,0,0,0,0x7f };
static PHITEXT curparms;
static int repeat;
/*
#pragma startup mbinit 120
*/

//static void mbinit(void)
void mbinit(void)
{
	repeat = 0;
	curparms = phidefaults;
}
static wchar_t parsechar(const unsigned char **buf, size_t *len)
{
	unsigned char temp;
	wchar_t rv;
	*len = 0;
	while (1) {
		if (**buf == 0)
			return 0;
		if (repeat) {
			repeat--;
			rv = curparms.cwb + (curparms.bank << 7) 
					+ (curparms.attrib <<11) 
					+ (curparms.fgc<<16) + (curparms.bgc << 20) + (curparms.style<<24)
					+ (curparms.size << 28);
			break;
		}
		temp = *(*buf)++;                                                    
		(*len)++;
		if (temp & 0x80) {
			char grp = temp & 0x70;
			switch (grp) {
				case 0: {
							int repeatlevel = 0;
							(*buf)--;
							(*len)--;
							while (((temp = **buf)& 0xf0) == 0x80) {
								(*len)++;
								(*buf)++;
								repeat += ((temp & 0x0f)<<(repeatlevel++ * 4)) +1;
							}
							repeat++;
						}
						break;
				case 0x10:
						curparms.bank = temp & 0x0f;
						break;
				case 0x20:
				case 0x30:
						curparms.attrib = temp & 0x1f;
						break;
				case 0x40:
						curparms.fgc = temp & 0x0f;
						break;
				case 0x50:
						curparms.bgc = temp & 0x0f;
						break;
				case 0x60:
						curparms.style = temp & 0x0f;
						break;
				case 0x70:
						curparms.size = temp & 0x0f;
						break;
			}
		}
		else {
			if (temp)
				curparms.cwb = temp;
			if (temp & 0x60) {
				rv = temp + (curparms.bank << 7)
  				+ (curparms.attrib <<11) 
					+ (curparms.fgc<<16) + (curparms.bgc << 20) + (curparms.style<<24)
					+ (curparms.size << 28);
			}
			else {
				rv = temp;
				if (temp == 0x0a)
					curparms = phidefaults;
			}
			break;
		}
	}
	return(rv);
}
int mbtowc(wchar_t *pwchar, const char *s, size_t n)
{
	size_t len=0;
	*pwchar = parsechar(&s,&len);
	if (len <= n)
		return len;
	else
		return -1;
}
int mblen(const char *s, size_t n)
{
	size_t len=0;
	if (!s) {
		curparms = phidefaults;
		repeat = 0;
		return 0;
	}
	if (repeat)
		return 0;
	if ((*s & 0xf0) == 0x80) {
		while ((*s++ & 0xf0) == 0x80)
			len++;
	}
	else
		parsechar(&s,&len);
	if (len <=n)
		return len;
	return - 1;
}

size_t mbstowcs(wchar_t *pwcs,const char *mbs, size_t n)
{
	int i;
	size_t len=0;
	wchar_t cchar = 1;
	if (!mbs) {
		curparms = phidefaults;
		repeat = 0;
		return 0;
	}
	for (i=0; (i < n-1) && ((cchar & 0xff) != 0); i++)
		*pwcs++ = cchar = parsechar(&mbs,&len);
	if (i < n-1)
		*pwcs++ = 0;
	return i;
}
