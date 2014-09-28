#include <ctype.h>

unsigned char _ctype[256] = {
	_IS_CTL, _IS_CTL,_IS_CTL,_IS_CTL,
	_IS_CTL, _IS_CTL,_IS_CTL,_IS_CTL,
	_IS_CTL, _IS_CTL | _IS_SP,_IS_CTL,_IS_CTL,
	_IS_CTL, _IS_CTL,_IS_CTL,_IS_CTL,
	_IS_CTL, _IS_CTL,_IS_CTL,_IS_CTL,
	_IS_CTL, _IS_CTL,_IS_CTL,_IS_CTL,
	_IS_CTL, _IS_CTL,_IS_CTL,_IS_CTL,
	_IS_CTL, _IS_CTL,_IS_CTL,_IS_CTL,
	_IS_SP | _IS_BLK, _IS_PUN, _IS_PUN,0,
	0,0,0,_IS_PUN,
	_IS_PUN, _IS_PUN, 0,0,
	_IS_PUN,0, _IS_PUN,0,
	_IS_DIG | _IS_HEX, _IS_DIG | _IS_HEX,_IS_DIG | _IS_HEX, _IS_DIG | _IS_HEX,
	_IS_DIG | _IS_HEX, _IS_DIG | _IS_HEX,_IS_DIG | _IS_HEX, _IS_DIG | _IS_HEX,
	_IS_DIG | _IS_HEX, _IS_DIG | _IS_HEX,_IS_PUN, _IS_PUN,
	0,0,0, _IS_PUN,
	0, _IS_UPP | _IS_HEX,_IS_UPP | _IS_HEX,_IS_UPP | _IS_HEX,
	_IS_UPP | _IS_HEX,_IS_UPP | _IS_HEX,_IS_UPP | _IS_HEX,_IS_UPP,
	_IS_UPP,_IS_UPP,_IS_UPP,_IS_UPP,
	_IS_UPP,_IS_UPP,_IS_UPP,_IS_UPP,
	_IS_UPP,_IS_UPP,_IS_UPP,_IS_UPP,
	_IS_UPP,_IS_UPP,_IS_UPP,_IS_UPP,
	_IS_UPP,_IS_UPP,_IS_UPP,_IS_PUN,
	_IS_PUN,_IS_PUN,0,_IS_PUN,
	_IS_PUN, _IS_LOW | _IS_HEX,_IS_LOW | _IS_HEX,_IS_LOW | _IS_HEX,
	_IS_LOW | _IS_HEX,_IS_LOW | _IS_HEX,_IS_LOW | _IS_HEX,_IS_LOW,
	_IS_LOW,_IS_LOW,_IS_LOW,_IS_LOW,
	_IS_LOW,_IS_LOW,_IS_LOW,_IS_LOW,
	_IS_LOW,_IS_LOW,_IS_LOW,_IS_LOW,
	_IS_LOW,_IS_LOW,_IS_LOW,_IS_LOW,
	_IS_LOW,_IS_LOW,_IS_LOW,_IS_PUN,
	0,_IS_PUN,0,_IS_CTL,
	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
};
int tolower(int c)
{
	if (_ctype[c] & _IS_UPP)
		c+=32;
	return c;
}
int toupper(int c)
{
	if (_ctype[c] & _IS_LOW)
		c-=32;
	return c;
}
		