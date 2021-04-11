# disable all implicit make rules:
.SUFFIXES:

# wehere am i 
BASEDIR=$(shell  pwd)/../..

include $(BASEDIR)/Makefile.rules

OBJECTS= test.o
OUTFILE=test
LOADADDR=1024
#LOADADDR=1280


all: $(OBJECTS) 
	$(LD) $(BUILD_NUMBER_LDFLAGS) $(OBJECTS) $(LDFLAGS) -o $(OUTFILE).elf  > $(OUTFILE).map;		
	$(BASEDIR)/tools/elf2bin -r -s -l $(LOADADDR) -o $(OUTFILE).68k $(OUTFILE).elf; \
	$(OD) -D -b binary -m m68k $(OUTFILE).68k > $(OUTFILE).dis;\
	cp $(OUTFILE).68k NKC68K.ROM



#all: $(OBJECTS)	
#	$(LD)  $(LDFLAGS) -o $(OUTFILE).elf $(OBJECTS) > $(OUTFILE).map;	\
#	$(BASEDIR)/tools/elf2bin -r -s -l $(LOADADDR) -o $(OUTFILE) $(OUTFILE).elf; \
#	$(OC) -I elf32-m68k -S --adjust-start $(LOADADDR) $(OUTFILE).elf $(OUTFILE)_.68k; \
#	$(OD) -D -b binary -m m68k $(OUTFILE).68k > $(OUTFILE).S; \
#	$(OD) -D -b binary -m m68k $(OUTFILE)_.68k > $(OUTFILE)_.S; 


# m68k-uclinux-objcopy -O binary -I elf32-m68k -Sgv --adjust-start $(LOADADDR) $(OUTFILE).elf $(OUTFILE).68k;
#       -O binary       output type
#       -I elf32-m68k   architecture
#       -S              strip all 
#       -g              strip debug


#call: call.o
#	$(LD)  $(LDFLAGS) -o call.elf call.o  > call.map	
		
# define a pattern rule to compile all *.c files to *.o files:
%.o: %.c
#       $< = xxx.o, $@ = xxx.c, $* = xxx
	$(CC) $(INCLUDE) $(CCFLAGS) $(AFLAGS) -c $< > $*.lst

# define a pattern rule to compile all *.S files to *.o files:
%.o: %.S
#       $< = xxx.o, $@ = xxx.c, $* = xxx
	$(CC) $(CCFLAGS) $(AFLAGS) -c $< -o $@ > $*.lst
	

clean:
	rm -f *.o; \
	rm -f *.lst; \
	rm -f *.68k; \
	rm -f *.map; \
	rm -f *.elf; \
	rm -f *.dis; \
	rm -f *.e2b; \
	rm -f *.flt
