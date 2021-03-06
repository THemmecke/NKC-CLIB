#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <debug.h>


#define USE_printF2

#ifdef USE_printF2

/*******************************************************************************

 http://home.comcast.net/~derelict/snippets.html

 Copyright 2001, 2002 Georges Menie (<URL snipped>)
  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU Lesser General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.
  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  GNU Lesser General Public License for more details.
  You should have received a copy of the GNU Lesser General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
*/

/*******************************************************************************
 putchar is the only external dependency for this file, 
 if you have a working putchar, just remove the following
 define. If the function should be called something else,
 replace outbyte(c) by your own function call.
*/
//*******************************************************************************
//  Updated by Daniel D Miller.  Changes to the original Menie code are
//  Copyright 2009-2013 Daniel D Miller
//  All such changes are distributed under the same license as the original,
//  as described above.
//  11/06/09 - adding floating-point support
//  03/19/10 - pad fractional portion of floating-point number with 0s
//  03/30/10 - document the \% bug
//  07/20/10 - Fix a round-off bug in floating-point conversions
//             ( 0.99 with %.1f did not round to 1.0 )
//  10/25/11 - Add support for %+ format (always show + on positive numbers)
//  05/10/13 - Add stringfn() function, which takes a maximum-output-buffer
//             length as an argument.  Similar to sn_printf()
//  10/08/13 - Add support for signed/unsigned long long (u64/i64)
//*******************************************************************************
//  BUGS
//  If '%' is included in a format string, in the form \% with the intent
//  of including the percent sign in the output string, this function will
//  mis-handle the data entirely!!  
//  Essentially, it will just discard the character following the percent sign.  
//  This bug is not easy to fix in the existing code; 
//  for now, I'll just try to remember to use %% instead of \% ...
//*******************************************************************************
//  compile command for stand-alone mode (TEST_printF)
//  gcc -Wall -O2 -DTEST_printF -s _printf2.c -o _printf2.exe
//*******************************************************************************

//lint -esym(752, debug_output)
//lint -esym(766, stdio.h)

// uncomment the following line to support ll (i.r. long long 64Bit)
// you need to supply 64bit/64bit division (with gcc this is _udivdi3, _umoddi3)
#define SUPPORT_LL


// ASCII character set... 
#define NUL         0x00
#define STX         0x02
#define ETX         0x03
#define EOT         0x04
#define ACK         0x06
#define BS          0x08
#define LF          0x0A
#define CR          0x0D
#define DLE         0x10
#define ESC         0x1B
#define SPC         0x20
#define MAX_PRN     0x7E
#define DEL         0x7F

//extern int putchar (int c);
//lint -e534  Ignoring return value of function 
//lint -e539  Did not expect positive indentation from line ...
//lint -e525  Negative indentation from line ...

typedef  unsigned char  u8 ;
typedef  unsigned int   uint ;


static uint _use_leading_plus = 0 ;

static int _max_output_len = -1 ;
static int _curr_output_len = 0 ;

#ifdef USE_DYNAMIC_VSPRINTF_BUFFER
#define CHUNK_SIZE 512
unsigned int _curr_num_chunks;
unsigned int _curr_chunk_len;
static unsigned char _dynamic_buffer = 1;
char **buffer_ptr;
char *buffer_start;
#endif

uint _fixed_overrun = 0 ;
int _last_bad_char = 0 ;
uint _invalid_char = 0 ;

//****************************************************************************

static void _printchar (char **str, int c)
{

char* vptr;	

long a,b,x;

xxprintf_lldbg("_printchar:\n");


a = 0x12345;
b = 788;

x = a/b;

a=x;

   if (_max_output_len >= 0  &&  _curr_output_len >= _max_output_len) {
      _fixed_overrun++ ;
      return ;
   }

   //  check for overrun of our stuff_talkf[] buffer
//    if (_curr_output_len >= TALK_LINE_LEN) {
//       _fixed_overrun++ ;
//       return ;
//    }
   if (c > MAX_PRN) {
      _invalid_char++ ;
      _last_bad_char = c ;
      c = '?' ;
   } else
   if (c < SPC) {  //  ASCII 32 = Space
      switch (c) {
      case CR:
      case LF:
      case STX:
      case ETX:
         break;

      default:
         _invalid_char++ ;
         _last_bad_char = c ;
         c = '?' ;
         break;
      }
   }

	if (str) {
	    xxprintf_lldbg(" ...\n");

	    
	    #ifdef USE_DYNAMIC_VSPRINTF_BUFFER
	    if(_dynamic_buffer == 1) {
	      if(_curr_num_chunks == 0 ||
	         _curr_chunk_len == CHUNK_SIZE) {
	          _curr_num_chunks++;	  
	          xxprintf_lldbg(" realloc ...\n");	          	          
	          xxprintf_lldbghex(" pbuffer  = 0x",*buffer_ptr);
		  xxprintf_lldbgwait(" ");
	             
	          vptr=(char*)realloc(buffer_start,_curr_num_chunks*CHUNK_SIZE+1);
	          if(vptr){	                
	                *buffer_ptr = vptr;
	                buffer_start = vptr;
	                *str = vptr+(_curr_num_chunks-1)*CHUNK_SIZE;	          
	                _curr_chunk_len=0;
	                xxprintf_lldbg(" success\n");
	                xxprintf_lldbghex(" pbuffer  = 0x",*buffer_ptr);
    	                xxprintf_lldbgwait(" ");
	          } else {
	                xxprintf_lldbg(" failed\n");
	                
	                _curr_num_chunks--;
	                _fixed_overrun++ ;
                        return ;
	          }
	      }    
	    }      	          
	    #endif    	    
            **str = (char) c;
	    ++(*str);
            _curr_output_len++ ;
            #ifdef USE_DYNAMIC_VSPRINTF_BUFFER
            _curr_chunk_len++;
            #endif
	}

}

//****************************************************************************
//  This version returns the length of the output string.
//  It is more useful when implementing a walking-string function.
//****************************************************************************
static const double _round_nums[8] = {  
   0.5,
   0.05,
   0.005,
   0.0005,
   0.00005,
   0.000005,
   0.0000005,
   0.00000005
} ;


static unsigned _dbl2stri(char *outbfr, double dbl, unsigned dec_digits)
{
   static char local_bfr[128] ;
   char *output = (outbfr == 0) ? local_bfr : outbfr ;

   //*******************************************
   //  extract negative info
   //*******************************************
   if (dbl < 0.0) {
      *output++ = '-' ;
      dbl *= -1.0 ;
   } else {
      if (_use_leading_plus) {
         *output++ = '+' ;
      }
      
   }

   //  handling rounding by adding .5LSB to the floating-point data
   if (dec_digits < 8) {
      dbl += _round_nums[dec_digits] ;
   }

   //**************************************************************************
   //  construct fractional multiplier for specified number of digits.
   //**************************************************************************
   uint mult = 1 ;
   uint idx ;
   for (idx=0; idx < dec_digits; idx++)
      mult *= 10 ;

   // _printf("mult=%u\n", mult) ;
   uint wholeNum = (uint) dbl ;
   uint decimalNum = (uint) ((dbl - wholeNum) * mult);

   //*******************************************
   //  convert integer portion
   //*******************************************
   char tbfr[40] ;
   idx = 0 ;
   while (wholeNum != 0) {
      tbfr[idx++] = '0' + (wholeNum % 10) ;
      wholeNum /= 10 ;
   }
   // _printf("%.3f: whole=%s, dec=%d\n", dbl, tbfr, decimalNum) ;
   if (idx == 0) {
      *output++ = '0' ;
   } else {
      while (idx > 0) {
         *output++ = tbfr[idx-1] ;  //lint !e771
         idx-- ;
      }
   }
   if (dec_digits > 0) {
      *output++ = '.' ;

      //*******************************************
      //  convert fractional portion
      //*******************************************
      idx = 0 ;
      while (decimalNum != 0) {
         tbfr[idx++] = '0' + (decimalNum % 10) ;
         decimalNum /= 10 ;
      }
      //  pad the decimal portion with 0s as necessary;
      //  We wouldn't want to report 3.093 as 3.93, would we??
      while (idx < dec_digits) {
         tbfr[idx++] = '0' ;
      }
      // _printf("decimal=%s\n", tbfr) ;
      if (idx == 0) {
         *output++ = '0' ;
      } else {
         while (idx > 0) {
            *output++ = tbfr[idx-1] ;
            idx-- ;
         }
      }
   }
   *output = 0 ;

   //  prepare output
   output = (outbfr == 0) ? local_bfr : outbfr ;

   return strlen(output) ;

}

//****************************************************************************
#define  PAD_RIGHT   1
#define  PAD_ZERO    2


static int _prints (char **out, const char *string, int width, int pad)
{
   // [831326121984], width=0, pad=0
   // _printf("[%s], width=%u, pad=%u\n", string, width, pad) ;
	register int pc = 0, padchar = ' ';
	if (width > 0) {
      int len = 0;
      const char *ptr;
		for (ptr = string; *ptr; ++ptr)
			++len;
		if (len >= width)
			width = 0;
		else
			width -= len;
		if (pad & PAD_ZERO)
			padchar = '0';
	}
	if (!(pad & PAD_RIGHT)) {
		for (; width > 0; --width) {
			_printchar (out, padchar);
			++pc;
		}
	}
	for (; *string; ++string) {
		_printchar (out, *string);
		++pc;
	}
	for (; width > 0; --width) {
		_printchar (out, padchar);
		++pc;
	}
	return pc;
}

//****************************************************************************
/* the following should be enough for 32 bit int */
//  -2,147,483,648
#define print_buf_LEN 12
static int _printi (char **out, int i, uint base, int sign, int width, int pad, int letbase)
{
   char print_buf[print_buf_LEN];
   char *s;
   int t, neg = 0, pc = 0;
   unsigned u = (unsigned) i;
	if (i == 0) {
		print_buf[0] = '0';
		print_buf[1] = '\0';
		return _prints (out, print_buf, width, pad);
	}
   if (sign && base == 10 && i < 0) {
		neg = 1;
      u = (unsigned) -i;
	}
   //  make sure print_buf is NULL-term
	s = print_buf + print_buf_LEN - 1;
	*s = '\0';

	while (u) {
      t = u % base;  //lint !e573 !e737 !e713 Warning 573: Signed-unsigned mix with divide
		if (t >= 10)
			t += letbase - '0' - 10;
      *--s = (char) t + '0';
      u /= base;  //lint !e573 !e737  Signed-unsigned mix with divide
	}
	if (neg) {
		if (width && (pad & PAD_ZERO)) {
			_printchar (out, '-');
			++pc;
			--width;
		}
		else {
			*--s = '-';
		}
   } else {
      if (_use_leading_plus) {
         *--s = '+';
      }
   }
	return pc + _prints (out, s, width, pad);
}



//****************************************************************************
/* the following should be enough for 64 bit int, without commas */
// _UI64_MAX
// Maximum value for a variable of type unsigned _int64
//                         xx..xx..xx..xx..
// 18446744073709551615 (0xffffffffffffffff)
// -9223372036854775808
// 18,446,744,073,709,551,615
#define _print_LLBUF_LEN 22
static int _printlli (char **out, long long i, uint base, int sign, int width, int pad, int letbase)
{
#ifndef SUPPORT_LL
	return 0;
#else
   char print_buf[_print_LLBUF_LEN];
   char *s;
   int t, neg = 0, pc = 0;
   unsigned long long u = (unsigned long long) i;



   if (i == 0) {
      print_buf[0] = '0';
      print_buf[1] = '\0';
      return _prints (out, print_buf, width, pad);
   }
   if (sign && base == 10 && i < 0) {
      neg = 1;
      u = (unsigned long long) -i;
   }
   //  make sure print_buf is NULL-term
   s = print_buf + _print_LLBUF_LEN - 1;
   *s = '\0';

   while (u) {
      t = u % base;  //lint !e573 !e737 !e713 Warning 573: Signed-unsigned mix with divide
      if (t >= 10)
         t += letbase - '0' - 10;
      *--s = (char) t + '0';
      u /= base;  //lint !e573 !e737  Signed-unsigned mix with divide
   }
   if (neg) {
      if (width && (pad & PAD_ZERO)) {
         _printchar (out, '-');
         ++pc;
         --width;
      }
      else {
         *--s = '-';
      }
   } else {
      if (_use_leading_plus) {
         *--s = '+';
      }
   }
   return pc + _prints (out, s, width, pad);
   #endif
}



//****************************************************************************


static int _print(char **out, const char* format,void *arglist) 
{
   int post_decimal ;
   int width, pad ;
   unsigned dec_width = 6 ;
   int pc = 0; // number of characters written to out
   //char *format = (char *) (*varg++);
   int* varg = arglist;

   char scr[2];
   _use_leading_plus = 0 ;  //  start out with this clear
   
   for (; *format != 0; ++format) {
     if (*format == '%') {
        dec_width = 6 ;
        ++format;
	width = pad = 0;
	if (*format == '\0')
		break;
	if (*format == '%')
                goto out_lbl;
	if (*format == '-') {
		++format;
		pad = PAD_RIGHT;
	}
        if (*format == '+') {
                ++format;
                _use_leading_plus = 1 ;
        }
        while (*format == '0') {
		++format;
		pad |= PAD_ZERO;
	}
        post_decimal = 0 ;
        if (*format == '.'  ||
           (*format >= '0' &&  *format <= '9')) {

            while (1) {
               if (*format == '.') {
                  post_decimal = 1 ;
                  dec_width = 0 ;
                  format++ ;
               } else if ((*format >= '0' &&  *format <= '9')) {
                  if (post_decimal) {
                     dec_width *= 10;
                     dec_width += (uint) (u8) (*format - '0');
                  } else {
                     width *= 10;
                     width += *format - '0';
                  }
                  format++ ;
               } else {
                  break;
               }
            }
        }
        
        uint use_longlong = 0 ;
        long long *uvarg ;
        long long llvalue ;
        if (*format == 'l') {
            ++format;
            if (*format == 'l') {
               ++format;
               use_longlong = 1 ;
            }
        }
        switch (*format) {
         case 's':
            {
            // char *s = *((char **) varg++);   //lint !e740
            char *s = (char *) *varg++ ;  //lint !e740 !e826  
            pc += _prints (out, s ? s : "(null)", width, pad);
            _use_leading_plus = 0 ;  //  reset this flag after _printing one value
            }
            break;
         case 'd':
            if (use_longlong) {
               uvarg = (long long *) varg ;
               llvalue = *uvarg++ ;
               varg = (int *) uvarg ;
               pc += _printlli(out, llvalue, 10, 1, width, pad, 'a');
            }
            else {
               pc += _printi  (out, *varg++, 10, 1, width, pad, 'a');
            }
            _use_leading_plus = 0 ;  //  reset this flag after _printing one value
            break;
         case 'x':
            if (use_longlong) {
               uvarg = (long long *) varg ;
               llvalue = *uvarg++ ;
               varg = (int *) uvarg ;
               pc += _printlli(out, llvalue, 16, 0, width, pad, 'a');
            }
            else {
               pc += _printi  (out, *varg++, 16, 0, width, pad, 'a');
            }
            _use_leading_plus = 0 ;  //  reset this flag after _printing one value
            break;
         case 'o':
            if (use_longlong) {
               uvarg = (long long *) varg ;
               llvalue = *uvarg++ ;
               varg = (int *) uvarg ;
               pc += _printlli(out, llvalue, 8, 0, width, pad, 'a');
            }
            else {
               pc += _printi  (out, *varg++, 8, 0, width, pad, 'a');
            }
            _use_leading_plus = 0 ;  //  reset this flag after _printing one value
            break;
         case 'X':
            if (use_longlong) {
               uvarg = (long long *) varg ;
               llvalue = *uvarg++ ;
               varg = (int *) uvarg ;
               pc += _printlli(out, llvalue, 16, 0, width, pad, 'A');
            }
            else {
               pc += _printi  (out, *varg++, 16, 0, width, pad, 'A');
            }
            _use_leading_plus = 0 ;  //  reset this flag after _printing one value
            break;
         case 'p':
         case 'u':
            if (use_longlong) {
               uvarg = (long long *) varg ;
               llvalue = *uvarg++ ;
               varg = (int *) uvarg ;
               pc += _printlli(out, llvalue, 10, 0, width, pad, 'a');
            }
            else {
               pc += _printi  (out, *varg++, 10, 0, width, pad, 'a');
            }
            _use_leading_plus = 0 ;  //  reset this flag after _printing one value
            break;
         case 'c':
            /* char are converted to int then pushed on the stack */
            scr[0] = (char) *varg++;
            scr[1] = '\0';
            pc += _prints (out, scr, width, pad);
            _use_leading_plus = 0 ;  //  reset this flag after _printing one value
            break;

         case 'f':
            {
            // http://wiki.debian.org/ArmEabiPort#Structpackingandalignment
            // Stack alignment
            // 
            // The ARM EABI requires 8-byte stack alignment at public function entry points, 
            // compared to the previous 4-byte alignment.

            double *dblptr = (double *) varg ;  //lint !e740 !e826  convert to double pointer

            double dbl = *dblptr++ ;   //  increment double pointer
            varg = (int *) dblptr ;    //lint !e740  copy updated pointer back to base pointer
            char bfr[81] ;
            // unsigned slen =
            _dbl2stri(bfr, dbl, dec_width) ;
            // stuff_talkf("[%s], width=%u, dec_width=%u\n", bfr, width, dec_width) ;
            pc += _prints (out, bfr, width, pad);
            _use_leading_plus = 0 ;  //  reset this flag after _printing one value
            }
            break;

         default:
            _printchar (out, '%');
            _printchar (out, *format);
            _use_leading_plus = 0 ;  //  reset this flag after _printing one value
            //++pc; // !!!!!!!!!!!! MUSS DAS NICHT SO SEIN ? !!!!!!!!!!!!!!!!!!!!!
            break;
         }
      } else 
      // if (*format == '\\') {
      //    
      // } else 
      {
out_lbl:
      _printchar (out, *format);
      ++pc;
     }
   }  //  for each char in format string
   if (out) //lint !e850
		**out = '\0';  // add terminating character NULL
	return pc;
}

/* ==================================================================================================== */

#ifdef USE_DYNAMIC_VSPRINTF_BUFFER
int vsprintf(char **pbuffer, const char *format, void *arglist)  
#else
int vsprintf(char *buffer, const char *format, void *arglist)  
#endif
{
	_max_output_len = -1 ;
	_curr_output_len = 0 ;	
	
	#ifdef USE_DYNAMIC_VSPRINTF_BUFFER
	int res;
        _curr_num_chunks=0;
        _curr_chunk_len=0;
        buffer_ptr=pbuffer;
        buffer_start=*pbuffer;
        res = _print (pbuffer, format, arglist);
        *pbuffer=buffer_start;
        _dynamic_buffer = 1;
        return res;
  #else
        _max_output_len = 512 ;
        return _print (&buffer, format, arglist);
  #endif

	

}

int sprintf(char *buffer, const char *format, ...)
{
  #ifdef USE_DYNAMIC_VSPRINTF_BUFFER        
        _dynamic_buffer = 0; // disable use of dynamic buffer for sprintf (see definition of sprintf)
	       return vsprintf(&buffer,format,(((char *)&format) + sizeof(char *)));
	#else
	       return vsprintf(buffer,format,(((char *)&format) + sizeof(char *)));
	#endif
}







#else // use original sprintf of CLIBS (FIX: use of dynamic buffer...)

#define USE_FLOAT

#define NUM_SIZE 32
static int getnum(char *string, int num,int radix,int lc,int unsign)
{
	int i,sz=0;
	unsigned unum;
	for (i=0; i < NUM_SIZE-1; i++)
		string[i] = '0';
	string[NUM_SIZE-1] = 0;
	if (num < 0 && !unsign)
		unum = - num;
	else
		unum = num;
	i = NUM_SIZE-2;
	while (unum) {
		string[i] = (char)((unum % radix)+ '0');
		if (string[i] > '9') {
			string[i] += 7;
			if (lc)
				string[i] += 32;
		}
		i--;
		unum /= radix;
		sz++;
	}
	if (sz == 0)
		sz++;
	return sz;
}
static char *onetostr(char *obuf,char **buffer, const char *format, void *arg,int *count)
{

	int c,sz;
	int *p;
	int looping = 1;
	int issigned = 0, ljustify = 0, spaced = 0, prefixed = 0;
	int	leadzero = 0;
	int width = 0;
	int prec = 6;
	int mode = 0;
	int lc,i;
	char locbuf[NUM_SIZE],*ofm = format;
	while (looping) 
		switch (*format) {
			case '+':	issigned = 1;
					format++;
					break;
			case '-':	ljustify = 1;
					format++;
					break;
			case ' ': spaced = 1;
					format++;
					break;
			case '#': prefixed = 1;
					format++;
					break;
			case '0':	leadzero = 1;
					format++;
					break;
			default:
					looping = 0;
		}
	if (isdigit(*format)) {
		width = 0;
		while (isdigit(*format)) {
			width *= 10;
			width += *format++ - '0';
		}
	}
	if (*format == '.') {
		format++;
		prec = 0;
		while (isdigit(*format)) {
			prec *= 10;
			prec += *format++ - '0';
		}
	}
	if (*format == 'h' || *format == 'l' || *format == 'L')
		mode = *format++;
	switch (*format++) {
		case '%':
			*(*buffer)++ = '%';
			*(*buffer) = 0;
			break;
		case 'c':
			(*count)++;
			c = *(int *)arg;
			*(*buffer)++ = (char)c;
			*(*buffer) = 0;
			break;
		case 'd':
		case 'i':
			(*count)++;
			c = *(int *)arg;
			if (mode == 'h') {
				c &= 0xffff;
				if (c & 0x8000)
					c |= 0xffff0000;
			}
			sz = getnum(locbuf,c,10,0,0);
			if (issigned) {
				if (c < 0) 
					*(*buffer)++ = '-';
				else
					*(*buffer)++ = '+';
				if (width)
					width--;
			}
			else if (spaced) {
				if (c < 0) 
					*(*buffer)++ = '-';
				else
					*(*buffer)++ = ' ';
				if (width)
					width--;
			}
			else {
				if (c < 0) {
					*(*buffer)++ = '-';
					if (width)
						width--;
				}
			}
			goto numfin;
				
		case 'e':
		case 'E':
		case 'f': 
		case 'g':
		case 'G':
#ifndef USE_FLOAT
			(*count)++;
			if (mode == 'L')
				(*count)++;
			strcpy(*buffer,"FP not implemented (sprinf.c)");
			*buffer += strlen(*buffer);
#endif
			break;
		case 'n':
			(*count)++;
			p = *(int **)arg;
			*p = (int)((*buffer) - obuf);
			break;
		case 'o':
			(*count)++;
			c = *(int *)arg;
			if (mode == 'h') {
				c &= 0xffff;
				if (c & 0x8000)
					c |= 0xffff0000;
			}
			sz = getnum(locbuf,c,8,0,1);
			if (prefixed && c)
				sz--;
			if (issigned) {
				*(*buffer)++ = '+';
				if (width)
					width--;
			}
			else if (spaced) {
				*(*buffer)++ = ' ';
				if (width)
					width--;
			}
			goto numfin;
		case 's':
			(*count)++;
			sz = strlen(*(char **)arg);
			if (width && (sz < width))
				if (ljustify) {
					for (i=0; i < width-sz; i++)
						*(*buffer)++ = ' ';
					strcpy(*buffer,*(char **)arg);
			 		*buffer += strlen(*buffer);
				}
				else {
					strcpy(*buffer,*(char **)arg);
			 		*buffer += strlen(*buffer);
					for (i=0; i < width-sz; i++)
						*(*buffer)++ = ' ';
				}
			else {
				strcpy(*buffer,*(char **)arg);
				*buffer += strlen(*buffer);
			}
			break;
		case 'u':
			(*count)++;
			c = (int )arg;
			if (mode == 'h') {
				c &= 0xffff;
				if (c & 0x8000)
					c |= 0xffff0000;
			}
			sz = getnum(locbuf,*(int *)arg,10,0,1);

			if (issigned) {
				*(*buffer)++ = '+';
				if (width)
					width--;
			}
			else if (spaced) {
				*(*buffer)++ = ' ';
				if (width)
					width--;
			}
			goto numfin;
		case 'x':
		case 'p':
					lc = 1;
		case 'X':
			(*count)++;
			if (*(format-1) == 'X')
				lc = 0;
			c = *(int *)arg;
			if (mode == 'h') {
				c &= 0xffff;
				if (c & 0x8000)
					c |= 0xffff0000;
			}
			sz = getnum(locbuf,c,16,lc,1);
			if (issigned) {
				*(*buffer)++ = '+';
				if (width)
					width--;
			}
			else if (spaced) {
				*(*buffer)++ = ' ';
				if (width)
					width--;
			}
			if (prefixed) {
				*(*buffer)++ = '0';
				*(*buffer)++ = 'x';
			}
numfin:
			if (width) {
				if (width <= sz) {
					goto nowidth;
				}
				if (!ljustify || leadzero) {
					if (leadzero) {
						for (i=0; i < width-sz; i++)
							*(*buffer)++ = '0';
					}
					else {
						for (i=0; i < width-sz; i++)
							*(*buffer)++ = ' ';
					}
					strcpy(*buffer,&locbuf[NUM_SIZE-sz-1]);
					(*buffer) += strlen(*buffer);
				}
				else {
					strcpy(*buffer,&locbuf[NUM_SIZE-sz-1]);
					(*buffer) += strlen(*buffer);
					for (i=0; i < width-sz; i++)
						*(*buffer)++ = ' ';
					*(*buffer) = 0;
				}
			}
			else {
nowidth:
				strcpy(*buffer,&locbuf[NUM_SIZE-sz-1]);
				(*buffer) += strlen(*buffer);
				*(*buffer) = 0;
			}
			break;
		default:
		 	*(*buffer)++ = '%';
			format = ofm;
			break;
	}
	return(format);
}
int vsprintf(char *buffer, const char *format,
                                    void *arglist)
{
	int i = 0;
	char *obuf = buffer;
	
	
	while (*format) {
		while (*format != '%' && *format != 0)
			*buffer++ = *format++;
		if (*format && *(format+1))
/*			format = onetostr(obuf,&buffer,format+1,&((char **)arglist+i),&i);*/
			format = onetostr(obuf,&buffer,format+1,(char **)arglist+i,&i);
						
	}
	*buffer++ = 0;
	return(strlen(obuf));
}
int sprintf(char *buffer, const char *format, ...)
{
	return vsprintf(buffer,format,(((char *)&format) + sizeof(char *)));
}

#endif
