

# disable all implicit make rules:
.SUFFIXES:

# wehere am i 
BASEDIR=$(shell  pwd)/..


include $(BASEDIR)/Makefile.rules

#ifdef M68000
CCFLAGS +=  -DL_muldi3
#endif

# ###################################################

LIBDIR=$(BASEDIR)/lib/
INCLUDE=$(BASEDIR)/include

export PATH:=/opt/m68k-elf-tools/bin:$(PATH)

OBJECTS =

LIB1ASMFUNCS = _mulsi3 _udivsi3 _divsi3 _umodsi3 _modsi3 _double _float _floatex _eqdf2 _nedf2 _gtdf2 _gedf2 _ltdf2 _ledf2 _eqsf2 _nesf2 _gtsf2 _gesf2 _ltsf2 _lesf2
LIB1ASMSRC = lb1sf68.S

OBJECTS += _mulsi3.o
OBJECTS += _udivsi3.o
OBJECTS += _nedf2.o
OBJECTS += _divsi3.o 
OBJECTS += _umodsi3.o 
OBJECTS += _modsi3.o 
OBJECTS += _double.o 
OBJECTS += _float.o 
OBJECTS += _floatex.o 
OBJECTS += _eqdf2.o 
OBJECTS += _gtdf2.o 
OBJECTS += _gedf2.o 
OBJECTS += _ltdf2.o 
OBJECTS += _ledf2.o 
OBJECTS += _eqsf2.o 
OBJECTS += _nesf2.o 
OBJECTS += _gtsf2.o 
OBJECTS += _gesf2.o 
OBJECTS += _ltsf2.o 
OBJECTS += _lesf2.o
OBJECTS += fpgnulib.o

OBJECTS += libgcc2.o

# ------------------------------------------------------------------------------------

############### compiler flags ###########################
# verbose output
#CCFLAGS +=--verbose


############### assembler flags ###########################
AFLAGS = 
# ######### ##############
AFLAGS += -pipe 
# ######### preprocessor variable ##############
AFLAGS += -DM$(CPU) 
# ######### assembler switch: assemble for $(CPU) ##############
AFLAGS += -m$(CPU) 
# ### tell the compiler to use FPU commands or software floating point ###
ifeq ($(CONFIG_FPU),1)
AFLAGS += -m68881
else
AFLAGS += -msoft-float
endif

# -Wa,option instrucs the gnu c compiler to pass option to the assembler, so this is an assembler option given to the compiler
AFLAGS += -Wa,-a,-ad


#	$(LD) $(LDFLAGS) $(LIBOBJECTS) -o $(LIBDIR)/libCC.o; \
# create a static library	
all:	
	for FUNC in $(LIB1ASMFUNCS); do \
		echo $$FUNC; \
		$(CC) $(INCLUDE) $(CCFLAGS) -DL$$FUNC $(AFLAGS) -c $(LIB1ASMSRC) -o $$FUNC.o > $$FUNC.lst; \
		#$$OBJECTS += $$FUNC.o; \
	done		
	$(CC) $(INCLUDE) $(CCFLAGS) $(AFLAGS) -c fpgnulib.c -o fpgnulib.o > fpgnulib.lst; \
	$(CC) $(INCLUDE) $(CCFLAGS) $(AFLAGS) -c libgcc2.c -o libgcc2.o > libgcc2.lst; \
#	ar rcs $(LIBDIR)libmath.a $(OBJECTS)

fpgnulib:
	$(CC) $(INCLUDE) $(CCFLAGS) $(AFLAGS) -c fpgnulib.c -o fpgnulib.o > fpgnulib.lst
libgcc2:
	$(CC) $(INCLUDE) $(CCFLAGS) $(AFLAGS) -c libgcc.c -o libgcc.o > libgcc.lst

lib:
	for x in $(LIB1ASMFUNCS); do \
		echo $$x;\
	done
	
	
# define a pattern rule to compile all *.c files to *.o files:
%.o: %.c
#       $< = xxx.o, $@ = xxx.c, $* = xxx
	$(CC) $(INCLUDE) $(CCFLAGS) $(AFLAGS) -c $< > $*.lst

# define a pattern rule to compile all *.S files to *.o files:
%.o: %.S
#       $< = xxx.o, $@ = xxx.c, $* = xxx
	$(CC) $(CCFLAGS) $(AFLAGS) -c $< -o $@ > $*.lst

# define a pattern rule to compile all *.asm files to *.o files:
%.o: %.asm
#       $< = xxx.o, $@ = xxx.c, $* = xxx
	$(CC) $(CCFLAGS) $(AFLAGS) -c $< -o $@ > $*.lst
	
clean:	
	rm -f *.o; \
	rm -f *.lst; \
	rm -f *.68k; \
	rm -f *.map; \
	rm -f .elf; \
	rm -f *.flt; \
	rm -f $(LIBDIR)libmath.a
