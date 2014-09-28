# disable all implicit make rules:
.SUFFIXES:

# wehere am i 
BASEDIR=$(shell  pwd)/..

include $(BASEDIR)/Makefile.rules

# ############### m68k-tools ###################################
 

OBJECTS= mbtowc.o memchr.o memcmp.o memcpy.o memmove.o memset.o \
	strcat.o strchr.o strcmp.o strcpy.o strcspn.o strerr.o strlen.o \
	strncat.o strncmp.o strncpy.o strpbrk.o strrchr.o strstr.o strtok.o wctomb.o

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

