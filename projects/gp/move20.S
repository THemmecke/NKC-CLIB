.text


 /*                       GC.ASM                             */
 /*  transportiert das GP an das RAM-Ende                    */



 /*  KONSTANTEN */

    .equ cpu    , 4		/* 1=68008, 2=68000, 4=68020 */
    .equ bank   , 0xffffffc9*cpu /*  Bankenregister */

    .equ gpziel, 0x3C0000
 /* gpziel	equ $....		* bei Verwendung der RAM Erweiterung und entsprechendem GP */

    .equ bbziel  , 0x30000 /*  Zielbereich (RAM-Start) )für BBOOT Code (muss im RAM liegen) */
							* RAM beginnt bei 0x20000 (>128KB)

    .equ gpstart, 0x100 /*  Startadresse des GP im EPROM (Offset 0x100 im EPROM) */
    .equ gpsize , 0xFFFE


 /*  Konstanten f. Seriell: */
    .equ serbase        , 0xFFFFFFF0*cpu
    .equ control        , 0xFFFFFFF3*cpu
    .equ command        , 0xFFFFFFF2*cpu
    .equ status         , 0xFFFFFFF1*cpu
    .equ transmit       , 0xFFFFFFF0*cpu
    .equ receive        , 0xFFFFFFF0*cpu




      .org 0x0              	  /*  code fuer 0x0 erzeugen (EPROM) */

 /*  dummy stack */
 .long 0x11ffe
 /*  reset vector */
 .long start
 

start:  

 /* ******** GP in's RAM kopieren */

        move.w #gpsize,%d3
        lea gpziel,%a0
        lea gpstart,%a1         /*  Start Adresse des GPs im EPROM */
gpmove:  
        move.w (%a1)+,(%a0)+
        dbra %d3,gpmove




 /*                       BBOOT.ASM                        */
 /*  bootet das GP im hinteren RAM Bereich und             */
 /*  blendet das EPROM aus                                 */


bboot:  
        move #ende-anf-1,%d3
        lea bbziel,%a0
        lea anf(%pc),%a1

transport:  
        move.b (%a1)+,(%a0)+
        dbra %d3,transport


        jmp bbziel

anf:  
boot:  

        move.b #0x80,bank




        lea gpziel,%a0
loop:  
        cmp.l #0x5aa58001,(%a0)
        jeq gefunden
        adda.l #0x4,%a0
        jra loop

gefunden:  




        cmp #0x6000,0x20(%a0)
        jne loop
        cmp #0x6000,0x24(%a0)
        jne loop
        jmp 0x24(%a0)

 ende:
	.org gpstart-2
	nop
_gpstart: 

