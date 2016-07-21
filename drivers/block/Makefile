# disable all implicit make rules:
.SUFFIXES:

# wehere am i 
BASEDIR=$(shell  pwd)/../..

include $(BASEDIR)/Makefile.rules
# ############### m68k-tools ###################################
OBJECTS=
ifeq ($(CONFIG_DRV_SD),1) 
OBJECTS= sd_block_drv.o sdS.o 
endif
ifeq ($(CONFIG_DRV_GIDE),1)
OBJECTS+=hd_block_drv.o gideS.o
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

