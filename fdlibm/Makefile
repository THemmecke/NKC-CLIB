

# disable all implicit make rules:
.SUFFIXES:

# wehere am i 
BASEDIR=$(shell  pwd)/..


include $(BASEDIR)/Makefile.rules


# ###################################################

LIBDIR=$(BASEDIR)/lib/
INCLUDE=$(BASEDIR)/include
LIBNAME=libfdlibm

export PATH:=/opt/m68k-elf-tools/bin:$(PATH)

LIBOBJS = k_standard.o  k_rem_pio2.o k_cos.o k_sin.o k_tan.o e_acos.o e_acosh.o e_asin.o e_atan2.o e_atanh.o \
e_cosh.o e_exp.o e_fmod.o e_gamma.o e_gamma_r.o e_hypot.o e_j0.o e_j1.o e_jn.o e_lgamma.o e_lgamma_r.o e_log.o \
e_log10.o e_rem_pio2.o e_remainder.o e_scalb.o  e_sinh.o  w_acos.o w_acosh.o  w_asin.o  w_atan2.o w_atanh.o \
w_cosh.o w_exp.o w_fmod.o w_gamma.o w_gamma_r.o w_hypot.o w_j0.o w_j1.o w_jn.o  w_lgamma.o w_lgamma_r.o w_log.o \
w_log10.o w_remainder.o w_scalb.o w_sinh.o s_asinh.o s_atan.o s_cbrt.o s_ceil.o s_cos.o s_erf.o \
s_expm1.o s_finite.o s_floor.o s_frexp.o s_ilogb.o s_isnan.o s_ldexp.o s_lib_version.o s_log1p.o s_logb.o s_matherr.o \
s_modf.o s_nextafter.o s_rint.o s_signgam.o s_significand.o s_sin.o s_tan.o s_tanh.o

LIBOBJS += e_pow.o
LIBOBJS += w_pow.o 
LIBOBJS += e_sqrt.o 
LIBOBJS += w_sqrt.o 
LIBOBJS += s_fabs.o  
LIBOBJS += s_scalbn.o 
LIBOBJS += s_copysign.o 

OBJECTS = $(LIBOBJS)

ifeq ($(CONFIG_FPU),0)
ifeq ($(CONFIG_IEEE_MATH),1)
# only inlcude those function if no FPU and IEEE math should be included (see Makefile in /object)
OBJECTS += e_pow.o
OBJECTS += w_pow.o 
OBJECTS += e_sqrt.o 
OBJECTS += w_sqrt.o 
OBJECTS += s_fabs.o  
OBJECTS += s_scalbn.o 
OBJECTS += s_copysign.o 
endif
endif

# ------------------------------------------------------------------------------------

############### compiler flags ###########################
# verbose output
#CCFLAGS +=--verbose

#
# Default IEEE libm
#
CCFLAGS += -D_IEEE_LIBM 

CCFLAGS += -D__STDC__

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
all:	$(OBJECTS); \
	ar rcs $(LIBDIR)$(LIBNAME).a $(LIBOBJS)

	
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
	rm -f $(LIBDIR)$(LIBNAME).a
