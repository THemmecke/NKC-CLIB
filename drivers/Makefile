# disable all implicit make rules:
.SUFFIXES:

# wehere am i 
BASEDIR=$(shell  pwd)/..

include $(BASEDIR)/Makefile.rules
# ############### m68k-tools ###################################
MODULES=

ifeq ($(CONFIG_BLOCK_DEVICES),1)
MODULES += block
endif

ifeq ($(CONFIG_CHAR_DEVICES),1)
MODULES += char
endif 

OBJECTS= drivers.o

all: 	$(OBJECTS)
	for dir in $(MODULES); do \
		(cd $$dir; ${MAKE} all;cp *.o ..; cd ..); \
	done

	
	
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
	for dir in $(MODULES); do \
		(cd $$dir; ${MAKE} clean); \
        done
        
	rm -f *.s; \
	rm -f *.o; \
	rm -f *.lst; \
	rm -f *.elf; \
	rm -f *.68k; \
	rm -f *.flt; \
	rm -f *.map; \
	rm -f libc

