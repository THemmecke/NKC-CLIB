

# disable all implicit make rules:
.SUFFIXES:

# wehere am i 
BASEDIR=$(shell  pwd)/..


include $(BASEDIR)/Makefile.rules


# ###################################################

LIBCSRC=$(BASEDIR)/lib/
INCLUDE=$(BASEDIR)/include



# ############### m68k-tools ###################################
 

OBJECTS= calloc.o free.o malloc.o realloc.o strdup.o


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

