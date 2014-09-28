# disable all implicit make rules:
.SUFFIXES:

# wehere am i 
BASEDIR=$(shell  pwd)/..

include $(BASEDIR)/Makefile.rules
# ############### m68k-tools ###################################
 

OBJECTS= clearerr.o fclose.o fflush.o fget.o fgetpos.o fgets.o fopen.o fprintf.o fputc.o fputs.o fread.o \
	freopen.o fseek.o fsetpos.o ftell.o fwrite.o gets.o printf.o putget.o puts.o readbuf.o remove.o \
	rename.o rewind.o scanf.o setbuf.o setvbuf.o sprintf.o sscanf.o tmpfil.o ungetc.o writebuf.o 

all: 	$(OBJECTS)
        
# define a pattern rule to compile all *.c files to *.o files:
%.o: %.c
#       $< = xxx.o, $@ = xxx.c, $* = xxx
	$(CC) $(INCLUDE) $(CCFLAGS) $(AFLAGS) -c $< > $*.lst


# define a pattern rule to compile all *.S files to *.o files:
%.o: %.S
#       $< = xxx.o, $@ = xxx.c, $* = xxx
	$(CC) $(CCFLAGS) $(AFLAGS) -c $< -o $@ > $*.lst

# ##############################################################
	

clean:
	rm -f *.s; \
	rm -f *.o; \
	rm -f *.lst; \
	rm -f *.elf; \
	rm -f *.68k; \
	rm -f *.flt; \
	rm -f *.map; \
	rm -f libc

