#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <debug.h>

/* Floating point not supported */



char *skipspace(char *buf, int *width, int *skip)
{
	int i;
	*skip = 0;
	if (*width == 0) 
		while (isspace(*buf))
			buf++;
	else {
		for (i=*width; i >=0 && isspace(*buf); i--)
			buf++;
		if (i < 0) {
			i = 0;
			*skip = 1;
		}
		*width = i;
	}
	return buf;
}
static char *strtoone(char **buffer, const char *format, void *arg, int *count,int *chars)
{
	int ignore = 0;
	int width = 0;
	int size = 0;
	int sgn = 0;
	int c,skip=0,didit = 0;
	unsigned cu;
	char vals[132],*s;
	int i;
	vals[0] = 0;
	if (*format == '*') {
		ignore = 1;
		format++;
	}
	if (isdigit(*format)) 
		while (isdigit(*format))
			width = width *10 + *format++ -'0';
	if (*format == 'h' || *format == 'l' || *format == 'L')
		size = *format++;
	switch(*format++) {
		case 'c':
			(*chars)++;
			c = *(*buffer)++;
			(*chars)++;
			if (c == 0)
				return 0;
			if (!ignore) {
				(*count)++;
				*(char *)arg = (char)c;
			}		
			break;
		case 'd':
		case 'i':
			*buffer = skipspace(*buffer,&width,&skip);
			c = 0;
			if (!skip) {
				if (*(*buffer) == '-') {
					sgn = 1;
					if (width)
						width--;
					(*buffer)++;
					(*chars)++;
				}
				else {
					if (*(*buffer) == '+') {
						(*buffer)++;
						if (width)
				    	width--;
						(*chars)++;
					}
				}
				if (width) {
					while(width && isdigit(**buffer)) {
						didit = 1;
						width--;
						c*=10;
						(*chars)++;
						c+=*(*buffer)++ - '0';
					}
					while (width && **buffer) {
						(*buffer)++;
						width--;
					}
				}
				else
					while(isdigit(**buffer)) {
						didit = 1;
						c*=10;
						(*chars)++;
						c+=*(*buffer)++ - '0';
					}
				if (sgn)
					c = -c;
			}
			if (!ignore) {
				(*count)+=didit;
				if (size == 'h') 
					*(short *)arg = (short)c;
				else
					*(int *)arg = c;
			}
			break;
		case 'e':
		case 'f':
		case 'g': 
#ifndef USE_FLOAT
/*				fprintf(stderr,"FP not linked"); */
				if (!ignore)
					(*count)++;
#endif
				break;	
		case 'n':
			*(int *)arg = (*count)++;
			break;
		case 'o':
			*buffer = skipspace(*buffer,&width,&skip);
			cu = 0;
			if (!skip) {
				if (width) {
					while(width && isdigit(**buffer) && *(*buffer) < '8') {
						didit = 1;
						width--;
						cu*=8;
						(*chars)++;
						cu+=*(*buffer)++ - '0';
					}
					while (width && **buffer) {
						(*buffer)++;
						width--;
					}
				}
				else
					while(isdigit(**buffer) && *(*buffer) < '8') {
						didit = 1;
						cu*=10;
						(*chars)++;
						cu+=*(*buffer)++ - '0';
					}
			}
			if (!ignore) {
				(*count)+=didit;
				if (size == 'h') 
					*(unsigned short *)arg = (unsigned short)cu;
				else
					*(unsigned *)arg = cu;
			} 	
			break;
		case '[':
			i = 0;
			while (*format != 0 && *format != ']')
				vals[i++] = *format++;
			vals[i] = 0;
		case 's':
			s = (char *)arg;
			skip = width;
			switch (vals[0]) {
				case 0:
					while (*(*buffer) != 0 && (width || !skip)) {
						if (!ignore)
							*s++ = *(*buffer)++;
						else
							(*buffer)++;
						width--;
						(*chars)++;
					}
					if (!ignore) {
						*s = 0;
						(*count) ++;
					}
					break;
				case '^':
					while (!strchr(&vals[1],*(*buffer)) && *(*buffer) != 0 && (width || !skip)) {
						if (!ignore)
							*s++ = *(*buffer)++;
						else
							(*buffer)++;
						width--;
						(*chars)++;
					}
					if (!ignore) {
						*s = 0;
						(*count) ++;
					}
					break;
					
				default:
					while (strchr(&vals[0],*(*buffer)) && *(*buffer) != 0 && (width || !skip)) {
						if (!ignore)
							*s++ = *(*buffer)++;
						else
							(*buffer)++;
						width--;
						(*chars)++;
					}
					if (!ignore) {
						*s = 0;
						(*count) ++;
					}
					break;
			}
			break;
		case 'u':
			*buffer = skipspace(*buffer,&width,&skip);
			if (!skip) {
				cu = 0;
				if (width) {
					while(width && isdigit(**buffer)) {
						didit = 1;
						width--;
						cu*=10;
						(*chars)++;
						cu+=*(*buffer)++ - '0';
					}
					while (width && **buffer) {
						(*buffer)++;
						width--;
					}
				}
				else
					while(isdigit(**buffer)) {
						didit = 1;
						cu*=10;
						(*chars)++;
						cu+=*(*buffer)++ - '0';
					}
			}
			if (!ignore) {
				(*count)+=didit;
				if (size == 'h') 
					*(unsigned short *)arg = (unsigned short)cu;
				else
					*(unsigned *)arg = cu;
			}
			break;
		case 'x':
		case 'p':
			cu = 0;
			*buffer = skipspace(*buffer,&width,&skip);
			if (!skip) {
				if (*(*buffer) == '0' && (*(*buffer+1) == 'X' || *(*buffer+1)== 'x')) {
					(*chars)+=2;
					*buffer+=2;
					if (width) {
						width-=2;
						if (width == 0)
							goto nox;
					}
				}
				if (width) {
					while(width && isxdigit(**buffer)) {
						didit = 1;
						width--;
						cu*=16;
						(*chars)++;
						cu+=*(*buffer) - '0';
						if (*(*buffer) >= 'a')
							cu -= 32;
						if (*(*buffer) >= 'A')
							cu -= 7;
					}
					while (width && **buffer) {
						(*buffer)++;
						width--;
					}
				}
				else
					while(isxdigit(**buffer)) {
						didit = 1;
						cu*=16;
						(*chars)++;
						cu+=*(*buffer) - '0';
						if (*(*buffer) >= 'a')
							cu -= 32;
						if (*(*buffer) >= 'A')
							cu -= 7;
						(*buffer)++;
					}
			}
nox:
			if (!ignore) {
				(*count)+=didit;
				if (size == 'h') 
					*(unsigned short *)arg =(unsigned short) cu;
				else
					*(unsigned *)arg = cu;
			}
			break;
		case '%':
				if (*format == **buffer)
					(*buffer)++;
		default:
			format++;
	}
	return format;
}

int _scanf(char *buffer, const char *format,void *arglist)
{
	int i = 0,j=0;
	int spacing = 1;
	while (format && *format) {
		while (*format != '%' && *format != 0) {
			if (isspace(*format)) {
				if (spacing) {
					while (isspace(*buffer)!= 0) {
						if (*++buffer == 0)
							return(i);
						j++;
					}
					spacing = 0;
				}
			}
			else  {
				if (*format == *buffer)
					buffer++;
				spacing = 1;
			}
			format++;
		}
		spacing = 1;
		if (*format && *++format)
			format = strtoone(&buffer,format,((char **)arglist)[i],&i,&j);
		if (!*buffer)
			return i;
	}
	return(i);
}
/* should have a const but const isn't working right... */
/* TH: need the const for working with GNU :-) - maybe some problem with BC ? */


int sscanf(const char *buf, const char *format, ...)
{
	return _scanf(buf,format,(((char *)&format)+sizeof(char *)));
}
