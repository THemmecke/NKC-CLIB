

# disable all implicit make rules:
.SUFFIXES:

# wehere am i 
BASEDIR=$(shell  pwd)/..


include $(BASEDIR)/Makefile.rules


# ###################################################

LIBDIR=$(BASEDIR)/lib/
INCLUDE=$(BASEDIR)/include
ARCH=$(BASEDIR)/arch/m68k

export PATH:=/opt/m68k-elf-tools/bin:$(PATH)

#LIBOBJECTS= abort.o argset.o asctime.o assert.o atexit.o atof.o atoi.o bsearch.o calloc.o clearerr.o clock.o ctime.o ctype.o difftime.o envset.o exit.o fclose.o fflush.o fget.o fgetpos.o fgets.o fopen.o fprintf.o fputc.o fputs.o fread.o free.o freopen.o fseek.o fsetpos.o ftell.o fwrite.o getenv.o gets.o gmtime.o first.o llmisc.o llopen.o llopenc.o llsig.o llstd.o llnkc.o lotime.o malloc.o mbtowc.o memchr.o memcmp.o memcpy.o memmove.o memset.o mktime.o phictype.o printf.o putget.o puts.o qsort.o readbuf.o realloc.o remove.o rename.o rewind.o scanf.o setbuf.o setjmp.o setvbuf.o signal.o sprintf.o sscanf.o strpbrk.o strcat.o strchr.o strcmp.o strcpy.o strcspn.o strdup.o strerr.o strftime.o strlen.o strncat.o strncmp.o strncpy.o strrchr.o strstr.o strtok.o strtoul.o system.o time.o tmpfil.o ungetc.o wctomb.o writebuf.o startup.o divmod64.o rand.o abs.o

LIBOBJECTS= abort.o argset.o asctime.o assert.o atexit.o atof.o atoi.o bsearch.o calloc.o clearerr.o clock.o ctime.o ctype.o difftime.o envset.o exit.o fclose.o fflush.o fget.o fgetpos.o fgets.o fopen.o fprintf.o fputc.o fputs.o fread.o free.o freopen.o fseek.o fsetpos.o ftell.o fwrite.o getenv.o gets.o gmtime.o first.o llmisc.o llopen.o llsig.o llstd.o llnkc.o lotime.o malloc.o mbtowc.o memchr.o memcmp.o memcpy.o memmove.o memset.o mktime.o phictype.o printf.o putget.o puts.o qsort.o readbuf.o realloc.o remove.o rename.o rewind.o scanf.o setbuf.o setjmp.o setvbuf.o signal.o sprintf.o sscanf.o strpbrk.o strcat.o strchr.o strcmp.o strcpy.o strcspn.o strdup.o strerr.o strftime.o strlen.o strncat.o strncmp.o strncpy.o strrchr.o strstr.o strtok.o strtoul.o system.o time.o tmpfil.o ungetc.o wctomb.o writebuf.o startup.o divmod64.o rand.o abs.o conio.o

ifeq ($(CONFIG_FS),1)
LIBOBJECTS += fs.o
	ifeq ($(CONFIG_FS_NKC),1)
	LIBOBJECTS += fs_nkc.o fs_nkcS.o
	endif
	ifeq ($(CONFIG_FS_FAT),1)
	LIBOBJECTS += fs_fat.o ff.o diskio.o gideS.o
	endif
endif


# add libgcc functions from comlib to libobjects:
LIBOBJECTS += _mulsi3.o _udivsi3.o _nedf2.o _divsi3.o _umodsi3.o _modsi3.o _double.o _float.o _floatex.o _eqdf2.o _gtdf2.o _gedf2.o _ltdf2.o _ledf2.o _eqsf2.o _nesf2.o _gtsf2.o _gesf2.o _ltsf2.o _lesf2.o fpgnulib.o libgcc2.o


# functions in math make use of FPU, so disable them if no FPU and use soft-float routines from fdlibm !!
ifeq ($(CONFIG_FPU),1)
LIBOBJECTS += acos.o asin.o atan.o ceil.o cos.o cosh.o exp.o fabs.o floor.o fmod.o frexp.o ldexp.o log.o log10.o modf.o pow.o sin.o sinh.o sqrt.o tan.o tanh.o 
else
# we need those in the clib (atof.c), the come from fdlibm - use them if no FPU available !
# only include if IEEE lib is not used
ifeq ($(CONFIG_IEEE_MATH),0)
LIBOBJECTS += e_pow.o
LIBOBJECTS += w_pow.o
LIBOBJECTS += e_sqrt.o 
LIBOBJECTS += w_sqrt.o 
LIBOBJECTS += s_fabs.o 
LIBOBJECTS += s_scalbn.o 
LIBOBJECTS += s_copysign.o 
endif
endif

#	$(LD) $(LDFLAGS) $(LIBOBJECTS) -o $(LIBDIR)/libCC.o; \
# create a static library	
all:
	ar rcs $(LIBDIR)libCC.a $(LIBOBJECTS)
	
	
# define a pattern rule to compile all *.c files to *.o files:
%.o: %.c
#       $< = xxx.o, $@ = xxx.c, $* = xxx
	$(CC) $(INCLUDE) $(CCFLAGS) $(AFLAGS) -c $< > $*.lst

# define a pattern rule to compile all *.S files to *.o files:
%.o: %.S
#       $< = xxx.o, $@ = xxx.c, $* = xxx
	$(CC) $(CCFLAGS) $(AFLAGS) -c $< -o $@ > $*.lst
	
clean:
	rm -f $(OUTFILE).o; \
	rm -f $(OUTFILE).lst; \
	rm -f $(OUTFILE).68k; \
	rm -f $(OUTFILE).map; \
	rm -f $(OUTFILE).elf; \
	rm -f $(OUTFILE).flt; \
	rm -f *.o; \
	rm -f *.lst; \
	rm -f *.68k; \
	rm -f *.map; \
	rm -f .elf; \
	rm -f *.flt; \
	rm -f $(LIBDIR)libCC.a
