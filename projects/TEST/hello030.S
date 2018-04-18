#include "../nkc/nkc.h"
#include "../nkc/macros.h"






	.text
	.global _start,__rexit,__main,__getErrno
	
	.equ _STACK         , 0x300000   /* define stack origin (if JADOS is not used), the stack grows decreasing addresses */
/*	
;
; Main program
;
*/
_start:

/* save old stackvalue, will be restored if program ends */
	
        lea _OLDSTACK(%pc),%a0
	move.l %sp,(%a0)	

     
/* Clear errno system variable */
	lea errno(%pc),%a0
	movel	#0, (%a0)

       
       bsr.l relocate		// do program relocation 1st
       cmp #0,%d2		// continue if successful
       bne __end		// exit otherwise
       				// from now on all addresses are relocated !  
       
/*	
;
; Clear BSS
;
*/
		
	lea _sbss(%pc),%a0            
        lea _ebss(%pc),%a1      
              
LD2:
	movel	#0, (%a0)+
	cmpal	%a0, %a1
	bhi	LD2
/*	
	writeln msg01(%pc)
*/

/*
;
;  Initialize HEAP
;
*/
	lea _ebss(%pc),%a0		/* save _HEAP variable (HEAP base) */
	move.l #0,(%a0)	
	lea _HEAP(%pc),%a1
	move.l %a0,(%a1)	/* _HEAP is already relocated, but... */
	
#ifdef USE_JADOS	
	moveq #62,%d7            /* get _RAM_TOP from JADOS */
        trap #6
        move.l %a0,%d0
#else
	move.l #_STACK,%d0	/* use _STACK var if no JADOS */
#endif
        lea _RAM_TOP(%pc),%a0
        move.l %d0,(%a0)
        
        
#ifdef CONFIG_DEBUG_MM   
        crlf
        crlf
        writeln msg24(%pc)	/* Heap starts at ... */
        lea _HEAP(%pc),%a1
        move.l (%a1),%d0
       	prthex8 (%d0)    
       	crlf
        writeln msg25(%pc)	/* Stack starts at ... */
        lea _RAM_TOP(%pc),%a0
        move.l (%a1),%d0
       	prthex8 (%d0)
       	crlf
#endif       	
       	
        
#ifdef  CONFIG_DEBUG_SIO_OUT
       writeln dbgmsg00(%pc)         
       
#ifdef CONFIG_DEBUG_SIO_PORT_2
       writeln dbgmsg03(%pc)  /* port 2 */
#else
       writeln dbgmsg02(%pc)  /* port 1 */
#endif

#ifdef CONFIG_DEBUG_SIO_BAUD_115200        
       writeln dbgmsg05(%pc)  /* 8N1,115200 baud */
#else
       writeln dbgmsg04(%pc)  /* 8N1,9600 baud */
#endif
       
       
#ifdef CONFIG_DEBUG_SIO_PORT_2
      /* insert code for port 2 initialisation */
#else
       move.l #0x0b,-(%sp)       
#ifdef CONFIG_DEBUG_SIO_BAUD_115200              
       move.l #0x13,-(%sp)	/* init serial 1 8N1, 115200 baud, no parity, no IRQ */	
#else       
       move.l #0x1e,-(%sp)	/* init serial 1 8N1, 9600 baud, no parity, no IRQ */
#endif

       bsr.l nkc_init_ser1	/* init serial 1 8N1, 9600 baud, no parity, no IRQ */
       
       crlf
#endif


       add.l #8,%sp		/* Stack aufräumen */                                   
       
       lea dbgmsg01(%pc),%a0
       move.l %a0,-(%sp)
       bsr.l nkc_ser1_write
       add.l #4,%sp
       
       writeln dbgmsg01(%pc)   
#endif


/*       
       writeln msg25(%pc)       
       prthex8 %d0
       writeln buffer(%pc)
       crlf	
       waitcr
*/
       /*
       	prthex8 _HEAP(%pc)
       	writeln buffer(%pc)
       	writeln TAB(%pc)
       	prthex8 _RAM_TOP(%pc)
       	writeln buffer(%pc)
       	crlf
       	*/
       	
  /*     
       	writeln msg02(%pc)
*/
	bsr.l mm_init        	/* init memory management */
	
/*	
;x
; Get command line  
; --> von JADOS mit getparm holen (bis zu 4 Parameter können übergeben werden)
*/

#ifdef USE_JADOS
	moveq #25,%d7
	trap #6
	/* %a0 zeigt auf Null-Terminierten Parameter String  */	
	lea _CMDLINE(%pc),%a1				
LD1:	move.b (%a0)+,(%a1)+	/* copy command line */
        bne LD1
        move.b #0,(%a1)		/* terminating NULL */
        
        lea _CMDLINE(%pc),%a1
        lea _cmdline(%pc),%a0	/* set command line in argset.c */
	move.l %a1,(%a0)
#endif
/*	
;
; Execute startup routines
;
*/
/*
startup/envset.c:#pragma startup envset 19
startup/argset.c:#pragma startup argset 19
string/mbtowc.c:#pragma startup mbinit 120
string/wctomb.c:#pragma startup wcinit 120
io/fclose.c:#pragma startup fileinit 120
procont/signal.c:#pragma startup siginit 128
*/

/*
	bsr.l envset	; Umgebungsvariable setzen 	(Speicher allokieren 4 Bytes in _env_arr)	
	bsr.l argset	; argc, argv holen 		(Speicher allokieren 4 Bytes in _argv_arr)
	bsr.l mbinit	; -> string/mbtowc.c
	bsr.l wcinit	; -> string/wctomb.c
	bsr.l fileinit	; -> io/fclose.c (ruft _ll_init in nkc/llopen.S)
	bsr.l siginit	; -> procont/signal.c
*/
#ifdef USE_JADOS
	clr.l %d0
	bsr.l jd_get_drive
	lea _DRIVE(%pc),%a0
	move.b %d0,(%a0)
#endif
	
	bsr.l envset			
	bsr.l argset	
	bsr.l mbinit
	bsr.l wcinit	
	bsr.l drvinit		// initialize device drivers
	bsr.l fileinit		// initialze file systems
	bsr.l timerinit
	bsr.l siginit
/*	
;
; Call main
;
*/	

/*
	writeln msg05(%pc)
*/	
	move.l (_env_arr,%pc),-(%sp)
	move.l (_argv_arr,%pc),-(%sp)
	move.l (_argc,%pc),-(%sp)		
	bsr.l	main		/* Hauptprogramm aufrufen */
	add.l #12,%sp		/* Stack aufräumen */
	bra __end	

/* int * __getErrno(void); */

__getErrno:
	move.l errno(%pc),%d0
	rts
/*
;
; exit/abort comes here 
;	(buggy, abort should not execute rundown routines in standard C)
*/
__rexit:

	writeln msg23(%pc) 
	crlf      	
       	//waitcr	
       	
       	
       	// restore stack
   	lea _OLDSTACK(%pc),%a0
	move.l (%a0),%sp
	//bra __end // do not execute rundown routines

/*
;
; Execute rundown routines
;
*/
/*
procont/atexit.c:#pragma rundown procexit 128
io/fclose.c:#pragma rundown closeall 10
alloc/malloc.c:#pragma rundown memdelete 0
*/
	/*
	bsr.l procexit (call registered functions -> see atexit.c)
	bsr.l closeall (close all fileandles)
	bsr.l memdelete
	*/
	
//	bra __end
	

/*	
;
; handle code/data fixups for PIC mode
;
*/
__end:
	bsr.l closeall
	//bsr.l memdelete
	bsr.l mm_free
	bsr.l timerclose
	
	writeln msg17(%pc)
	rts
	
/*	
;
; Handle startup/rundown routines
;
*/

/*
; This is called as the first thing from the C main routine
*/

__main:
	
 	rts
 	
relocate:

	lea _start(%pc),%a0
	lea _sbss(%pc),%a1	
	lea _RAM_TOP(%pc),%a2
	
rel00:  cmpa.l (%a2),%a1
	ble rel02      
	cmp.l #0xDEADBEAF,(%a1)+				
	bne rel00			
    cmp.l #0x5AA58001,(%a1)+	// check MAGIC
    bne rel00       	
    cmp.l #0xDEADBEAF,(%a1)+	// check MAGIC
    bne rel00
       
        			// %a1->LoadAddress ( die ist erst mal uninteressant, weil alle Werte relativ 0 im BSS Segment stehen !)	
	suba.l (%a1)+,%a0	// sub linker load address (linkers _start ) from current _start (%a0 = %a0 - (%a1))	
	cmpa.l #0,%a0
	bne rel01
/*	
	writeln msg18(%pc)	// "No relocation nessecary"
	crlf
	waitcr			// wait for ENTER
*/
	clr.l %d2
	rts			

	

rel01:	
        
  	move.l (%a1)+,%d0	// do relocations %d0 = number of relocations
  	
  	beq rel07               // panic !, there is no relocation information ! 

  	/*
	writeln msg13(%pc)	// Number of relocations
	prthex8 %d0				
       	writeln buffer(%pc)       	
       	crlf
	*/
	
	sub.l #1,%d0		// adjust for dbra
        lea _start(%pc),%a0     // current start address -> a0
        
rel04:				// %a1->Entry; %a1+0=Offset, %a1+4=Type, %a1+8=Value, %a1+12=next Entry


	cmp.l #1,4(%a1)		// type = R_68K_32 ?
	bne rel05
	
	
	move.l 8(%a1),%d1	// load address value into %d1	
	add.l %a0,%d1		// add program start differenece	%d1 = %d1 + %a0
	movea.l 0(%a1),%a2	// load offset value into %a2
	adda.l %a0,%a2		// and add program start address diff   %a2 = %a2 + %a0
	
	move.l %d1,(%a2)	// do the relocation
	
	cmp.l (%a2),%d1         // DEBUG: don't relocate, only check ...
        beq rel06               // and continue to next reloc if ok
                                // otherwise print info about relocation

        writeln msg26(%pc)	// Type ...
	prthex8 4(%a1)		
	writeln buffer(%pc)
	writeln msg27(%pc)	// at ...
	prthex8 0(%a1)		
       	writeln buffer(%pc)
	writeln msg28(%pc)	// value  ...
	prthex8 8(%a1)		
       	writeln buffer(%pc)
       	writeln msg29(%pc)	// offset  ...
       	prthex8 %a0             
       	writeln buffer(%pc)    	
        writeln msg30(%pc)	// current value at offset  ...
       	prthex8 (%a2)             
       	writeln buffer(%pc)
       	crlf      	
	waitcr
        
	bra rel06
		
rel05:	writeln msg14(%pc)	// unsupported relocation
       	
       	move.l #1,%d2		// set error flag
	//bra rel06		// for now we go through all the relocs (DEBUG)
       	bra rel03		// and exit       	       	
       	
rel06: 	add.l #12,%a1		// go to next relocation
  	dbra %d0,rel04  	  		
  	move.l #0,%d2		// clear error flag
  	bra rel03     		// and exit (success)
  	
rel07:  writeln msg31(%pc)      // relocation info needed but not found !
 	move.l #1,%d2		// set error flag
  	bra rel03		// and exit
  	  	
rel02:	writeln msg12(%pc)      // print >Magic not found<
	crlf      	
       	waitcr
       	move.l #1,%d2		// set error flag
       	
rel03:       
/*
	 writeln msg15(%pc)    // print sucess message   
       waitcr
  */     	
	rts 	
	
	

		
 	
	.data
	.global _HEAP,_RAM_TOP,_CMDLINE,_DRIVE,errno
	
	
errno:		ds.l 1
_HEAP:		ds.l 1
_RAM_TOP:	ds.l 1
_OLDSTACK:	ds.l 1

_DRIVE:		ds.b 1
_CMDLINE:	ds.b 255


TAB:	.asciz "    "

OPEN_BR: .asciz "("
CLOSE_BR: .asciz ")"
HEX_PREFIX: .asciz "0x"

msg00:	.ascii " NKC-CLIB (C) 2014 Torsten Hemmecke" 	
	.byte 0x0d,0x0a,0x00
	
msg01:	.ascii " BSS segment initailized" 	
	.byte 0x0d,0x0a,0x00	
	
msg02:	.ascii " HEAP calculated ...." 	
	.byte 0x0d,0x0a,0x00
	
msg03:	.ascii " ...and initialized" 	
	.byte 0x0d,0x0a,0x00	
	
msg04:	.ascii " args and env copied to program area" 	
	.byte 0x0d,0x0a,0x00			

msg05:	.ascii " startup routines executed, now calling main" 	
	.byte 0x0d,0x0a,0x0d,0x0a,0x00	
	
msg06:	.ascii " fake routine called from main, returning immediately" 	
	.byte 0x0d,0x0a,0x00	
	
msg07:	.ascii " executing rundown routines...bye bye..." 	
	.byte 0x0d,0x0a,0x00		
	
msg08:	.ascii " load address : 0x" 	
	.byte 0x00	
	
msg09:	.ascii " bss starts at: 0x" 	
	.byte 0x00	
	
msg10:	.ascii " Relocation Table:" 	
	.byte 0x0d,0x0a,0x0d,0x0a
	.ascii " offset    type       value"
	.byte 0x0d,0x0a,0x00
	
msg11: 	.ascii " Magic found"
	.byte 0x0d,0x0a,0x00

msg12: 	.ascii " Magic not found"
	.byte 0x0d,0x0a,0x00
		
msg13: 	.ascii " number of relocations: 0x"
	.byte 0x00
	
msg14: 	.ascii " unsupported relocation ! "
	.byte 0x0d,0x0a,0x00	
	
msg15: 	.ascii " Relocations done ! "
	.byte 0x0d,0x0a,0x00	
	
msg16:	.ascii " loading...."
	.byte 0x0d,0x0a,0x00	
	
msg17:	.byte 0x0d,0x0a,0x0d,0x0a
	.ascii " exit..."
	.byte 0x0d,0x0a,0x00	

msg18:	.ascii " no relocation necessary"
	.byte 0x0d,0x0a,0x00

msg19:	.ascii " compiled for address: 0x"
	.byte 0x00

msg20:	.ascii " ADDR 0x"
	.byte 0x00
msg21:	.ascii " = 0x"
	.byte 0x00
msg22:	.ascii " ---> 0x"
	.byte 0x00	
msg23:	.ascii " __rexit ...." 	
	.byte 0x0d,0x0a,0x00	
msg24:	.ascii " bss ends (HEAP starts) at: 0x" 	
	.byte 0x00
msg25:	.ascii " RAM_TOP (STACK starts) at: 0x" 	
	.byte 0x00									

msg26:	.ascii " Ty: 0x" 	
	.byte 0x00	
msg27:	.ascii " at: 0x" 	
	.byte 0x00	
msg28:	.ascii " val: 0x" 	
	.byte 0x00
msg29:	.ascii " off: 0x" 	
	.byte 0x00
msg30:	.ascii " 0x" 	
	.byte 0x00		
msg31:	.ascii " relocation info needed but not found !" 	
	.byte 0x0d,0x0a,0x00	

#ifdef  CONFIG_DEBUG_SIO_OUT
dbgmsg00:
        .byte 0x0a
	.ascii "initializing serial debugging ..." 	
	.byte 0x0a,0x00
	
dbgmsg01:
	.ascii "serial debugging enabled"
	.byte 0x0a,0x00
	
dbgmsg02:
	.ascii "   - serial port: 1"
	.byte 0x0a,0x00
	
dbgmsg03:
	.ascii "   - serial port: 2"
	.byte 0x0a,0x00	
	
dbgmsg04:
	.ascii "   - 8N1, 9600 baud"
	.byte 0x0a,0x00	
	
dbgmsg05:
	.ascii "   - 8N1, 115200 baud"
	.byte 0x0a,0x00		
	
#endif
buffer:	ds.b 255		
