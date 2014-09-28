	# disable all implicit make rules:
.SUFFIXES:

# wehere am i 
BASEDIR=$(shell  pwd)/..

include $(BASEDIR)/Makefile.rules
# ############### m68k-tools ###################################
 
ifeq ($(CONFIG_FPU),0)
OBJECTS= abs.o divmod64.o rand.o
else
OBJECTS= abs.o acos.o asin.o atan.o ceil.o cos.o cosh.o divmod64.o exp.o fabs.o \
	 floor.o fmod.o frexp.o ldexp.o log.o log10.o modf.o pow.o rand.o sin.o \
	 sinh.o sqrt.o tan.o tanh.o
endif


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

