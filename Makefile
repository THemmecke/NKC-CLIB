# Top-Level Makefile (development)

include Makefile.rules

MODULES=alloc complib ctype data io math procont sort string time startup nkc fdlibm

ifeq ($(CONFIG_FS),1)
MODULES += fs
endif


all:
	for dir in $(MODULES); do \
		(cd $$dir; ${MAKE} all;cp *.o ../object;); \
	done
	cd object; make all
	
	
clean:
	for dir in $(MODULES); do \
		(cd $$dir; ${MAKE} clean); \
        done
	rm -f object/*.o
	rm -f lib/libCC.a; \
	rm -f lib/startup.o
