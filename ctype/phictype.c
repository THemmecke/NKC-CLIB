#define __USELOCALES__
#include <ctype.h>

static unsigned char alchars[256] ={
/* Bank 0 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x7f,0xff,0xff,0xe0,
	0x7f,0xff,0xff,0xe0,

/* Bank 1 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x7e,0x11,0x00,
	0x00,0x00,0x00,0x00,

/* Bank 2 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0xff,0xff,
	0xff,0xff,0xff,0xff,
	0xff,0xff,0xff,0xff,

/* Bank 3 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0xff,0xff,0xff,0xff,
	0xff,0xfc,0x00,0x00,

/* Bank 4*/
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0xff,0xff,0xff,0x00,
	0xff,0xff,0xff,0x00,

/* Bank 5*/
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0xff,0xff,0xf8,0x00,
	0xff,0xff,0xff,0xf0,

/* Bank 6 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,

/* Bank 7 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,

/* Bank 8 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,

/* Bank 9 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,

/* Bank 10 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,

/* Bank 11 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,

/* Bank 12 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,

/* Bank 13 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,

/* Bank 14 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,

/* Bank 15 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00
};

static unsigned char spacechars[256] ={
/* Bank 0 */
	0x00,0x24,0x00,0x00,
	0x80,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x01,

/* Bank 1 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,

/* Bank 2 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,

/* Bank 3 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,

/* Bank 4*/
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,

/* Bank 5*/
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,

/* Bank 6 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,

/* Bank 7 */
	0x00,0x00,0x00,0x00,
	0x2a,0xa8,0xb1,0xd8,
	0x80,0x76,0x3b,0x10,
	0x08,0x04,0x02,0x01,

/* Bank 8 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,

/* Bank 9 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,

/* Bank 10 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,

/* Bank 11 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,

/* Bank 12 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,

/* Bank 13 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,

/* Bank 14 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,

/* Bank 15 */
	0x00,0x00,0x00,0x00,
	0xff,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00
};

static unsigned char punctchars[256] ={
/* Bank 0 */
	0x00,0x00,0x00,0x00,
	0x65,0xca,0x00,0x31,
	0x00,0x00,0x00,0x1d,
	0x80,0x00,0x00,0x14,

/* Bank 1 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x76,0xee,0xc0,
	0x00,0x00,0x00,0x00,

/* Bank 2 */
	0x00,0x00,0x00,0x00,
	0xff,0xe0,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,

/* Bank 3 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,

/* Bank 4*/
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x0f,0xfc,
	0x00,0x00,0x00,0xfc,
	0x00,0x00,0x00,0xf0,

/* Bank 5*/
	0x00,0x00,0x00,0x00,
	0x00,0x40,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,

/* Bank 6 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,

/* Bank 7 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,

/* Bank 8 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,

/* Bank 9 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,

/* Bank 10 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,

/* Bank 11 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,

/* Bank 12 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,

/* Bank 13 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,

/* Bank 14 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,

/* Bank 15 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00
};
static unsigned char lowerchars[256] ={
/* Bank 0 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x7f,0xff,0xff,0xe0,

/* Bank 1 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,

/* Bank 2 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x55,0x55,
	0x55,0x55,0x55,0x55,
	0x55,0x55,0x55,0x55,

/* Bank 3 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0xff,0xff,0xff,0xff,
	0xfe,0x00,0x00,0x00,

/* Bank 4*/
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0xff,0xff,0xff,0x00,

/* Bank 5*/
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0xff,0xff,0xff,0xf0,

/* Bank 6 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,

/* Bank 7 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,

/* Bank 8 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,

/* Bank 9 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,

/* Bank 10 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,

/* Bank 11 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,

/* Bank 12 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,

/* Bank 13 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,

/* Bank 14 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,

/* Bank 15 */
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00,
	0x00,0x00,0x00,0x00
};
int isspace(int c)
{
	int val,bit;
	c &= 0x7ff;
	val = (c >> 3) ;
	bit = 0x80 >> (c & 7);
	return((spacechars[val] & bit) != 0);
}
int isalpha(int c)
{
	int val,bit;
	c &= 0x7ff;
	val = (c >> 3) ;
	bit = 0x80 >> (c & 7);
	return((alchars[val] & bit) != 0);
}
int ispunct(int c)
{
	int val,bit;
	c &= 0x7ff;
	val = (c >> 3) ;
	bit = 0x80 >> (c & 7);
	return((punctchars[val] & bit) != 0);
}
int islower(int c)
{
	int val,bit;
	c &= 0x7ff;
	val = (c >> 3) ;
	bit = 0x80 >> (c & 7);
	return((lowerchars[val] & bit) != 0);
}
int isupper(int c)
{
	return(isalpha(c) && !islower(c));
}
int isprint(int c)
{
	return 1;
}

int isalnum(int c)
{
	int val,bit;
	c &= 0x7ff;
	val = (c >> 3) ;
	bit = 0x80 >> (c & 7);
	if (alchars[val] & bit)
		return 1;
	else
		return( ('0' <= c) && (c <= '9'));
}
int isgraph(int c)
{
	return(isalnum(c) || isxdigit(c) || ispunct(c));
}
int isdigit(int c)
{
	c &= 0x7ff;
	return( ('0' <= c) && (c <= '9'));
}
int isxdigit(int c)
{
	c &= 0x7ff;
	return(isdigit(c) || (('a' <= c) && ('f' >= c)) ||  (('A' <= c) && ('F' >= c)));
}
#undef isascii
int isascii(int c)
{
	c &= 0x7ff;
	return ( c < 0x80);
}
int iscntrl(int c)
{
	c &= 0x7ff;
	return( (c & 0x7f) < 0x20);
}
int _ltolower(int c)
{
	if (isupper(c))
		return c+32;
	return c;
}
int _ltoupper(int c)
{
	if (islower(c))
		return c-32;
	return c;
}

int isnumber(char* _s)
{
  while(_s) {
    if(!isdigit(_s++)) return 0;
  }
  return 1;
}