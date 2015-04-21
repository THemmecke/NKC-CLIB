idetest:                        
                                
 btst.b #5,keydil(a5)           
 beq.s hderr                    
 tst.b d4
 beq.s hderr                    
 and.b #$0f, d4
 movem.l d1-d4/a1/a6, -(a7)
 cmp.b #1, d4
 bne.s idt01
 lea idemgeo(a5), a6            
 move #$a0, d4                  
 bra.s idt02
idt01:                          
 cmp.b #2, d4
 bne.s idterr                   
 lea idesgeo(a5), a6            
 move #$b0, d4                  
idt02:
 bsr ideid                      
 tst d0
 bmi.s idterr                   
 bsr ideinit                    
 tst d0
 bmi.s idterr                   
 movea.l a6, a0
 movem.l (a7)+, d1-d4/a1/a6
bra carres

idterr:
 movem.l (a7)+, d1-d4/a1/a6
 bra.s hderr

ideid:                          
 move.b d4, idesdh.w            
idlp01:
 clr numcyl(a6)                 
 clr.b numhead(a6)
 clr.b numsec(a6)
 bsr idewr
 tst d0
 bmi idlp20
 move.b #cmdident, idecmd.w     
 bsr idewd                      
 tst d0
 bmi idlp20                     
 lea idebuff(a5),a0             
 lea idedat.w, a1
 move #512-1, d3
idlp04:
 move.b (a1), (a0)+             
 dbra d3, idlp04
 bsr idewr                      
 tst d0
 bmi idlp20                     
 lea idebuff(a5),a0             
 clr.l d0
 move.b 3(a0), d0               
 lsl #8, d0
 move.b 2(a0), d0               
 move d0, numcyl(a6)            
 clr.l d0
 move.b 6(a0), numhead(a6)      
 move.b 12(a0), numsec(a6)      
 movea.l a6, a1
 adda.l #idename, a1            
 adda.l #54, a0                 
 move #12-1, d3                 
idlp10:
 move.b 1(a0), (a1)+            
 move.b 0(a0), (a1)+
 addq.l #2, a0
 dbra d3, idlp10
 move #$0, (a1)+                
 clr d0
 bra.b idex
idlp20:
 move #-1, d0
idex:
 rts

ideinit:                        
 move.b #6, idedor.w
 move.l #255, d3
ideilp01:
 dbra d3, ideilp01              
 move.b #2, idedor.w
 bsr idewr                      
 tst d0
 beq.b ideilp03                 
 bra ideierr
ideilp03:
 move.b numsec(a6), idescnt.w   
 move.b numcyl+1(a6), ideclo.w  
 move.b numcyl(a6), idechi.w    
 move.b numhead(a6), d0         
 subq.b #1, d0                  
 or.b d4, d0                    
 move.b d0, idesdh.w            
 move.b #cmdinit, idecmd.w      
ideiex:
 clr d0
 rts
ideierr:
 move #-1, d0
 rts

idediski:                       
 moveq #1, d0                   
 bra.s idedisk1

idedisk:                        
 moveq #0, d0                   
idedisk1:
 btst.b #5,keydil(a5)           
 beq hderr                      
 movem.l d1-d5/a0-a3/a6, -(a7)
 bsr.s idecomm                  
 movem.l (a7)+, d1-d5/a0-a3/a6
rts

idebeftab:                      
 dc.w ideok-idebeftab           
 dc.w idebef1-idebeftab         
 dc.w idebef2-idebeftab         
 dc.w idenok-idebeftab          
 dc.w idenok-idebeftab          
 dc.w ideok-idebeftab           
 dc.w ideok-idebeftab           
 dc.w ideok-idebeftab           
 dc.w idebef8-idebeftab         
 dc.w ideok-idebeftab           
 dc.w ideok-idebeftab           
 dc.w idenok-idebeftab          
 dc.w idenok-idebeftab          
 dc.w idenok-idebeftab          
 dc.w idenok-idebeftab          
 dc.w ideok-idebeftab           
 dc.w ideok-idebeftab           
 dc.w idenok-idebeftab          
 dc.w idenok-idebeftab          
 dc.w ideok-idebeftab           
 dc.w idenok-idebeftab          
 dc.w ideok-idebeftab         
 dc.w idebef22-idebeftab      
 dc.w idenok-idebeftab        
 dc.w idebef24-idebeftab      
 dc.w ideok-idebeftab         
 dc.w ideok-idebeftab           
 dc.w ideok-idebeftab           
 dc.w ideok-idebeftab           

idecomm:
 cmp #29, d1
 beq ideok                      
 bhi hderr                      
 and #$0f, d4
 cmp #1, d4                     
 bne.s idec1                    
 lea idemgeo(a5), a6
 bra.s idec2
idec1:
 cmp #2, d4                     
 bne.s idenok                   
 lea idesgeo(a5), a6
idec2:
 add d1, d1                     
 move idebeftab(pc,d1.w), d1    
 jsr idebeftab(pc,d1.w)
 cmp #-1, d0
 beq carset                     
 bra carres

ideok:                          
 clr d0
 bra carres

idenok:                         
 moveq #-1, d0
 rts

idebef1:                        
 cmp #1, d4                     
 bne.s idb1a                    
 move #$a0, d4
 bra.s idb1b
idb1a:
 cmp #2, d4                     
 bne idb1err                    
 move #$b0, d4
idb1b:
 asl.l d0, d2                   
 asl.l d0, d3                   
 move.l d2, d0                  
 move d3, d1                    
 tst d1                         
 bne.s idb1e                    
 move.l #256, d2
 bra.s idb1f
idb1e:
 cmp #256, d1                   
 blt.s idb1c                    
idb1d:
 clr.l d2
 lsr #1, d1                     
 move d1, d2                    
idb1f:
 move.l d0, d3                  
 bsr iderdsek                   
 tst d0
 bne.s idb1err
 move.l d3, d0                  
 add.l d2, d0                   
 mulu #512, d2                  
 adda.l d2, a0                  
idb1c:
 bsr iderdsek                   
 tst d0
 beq.s idb1ex
idb1err:
 move #-1, d0
idb1ex:
 rts

idebef2:                        
 cmp #1, d4                     
 bne.s idb2a                    
 move #$a0, d4
 bra.s idb2b
idb2a:
 cmp #2, d4                     
 bne idb2err                    
 move #$b0, d4
idb2b:
 asl.l d0, d2                   
 asl.l d0, d3                   
 move.l d2, d0                  
 move d3, d1                    
 tst d1                         
 bne.s idb2e                    
 move.l #256, d2
 bra.s idb2f
idb2e:
 cmp #256, d1                   
 blt.s idb2c                    
idb2d:
 clr.l d2
 lsr #1, d1                     
 move d1, d2                    
 addq #1, d2                    
idb2f:
 move.l d0, d3                  
 bsr idewrsek                  
 tst d0
 bne.s idb2err
 move.l d3, d0                  
 add.l d2, d0                   
 mulu #512, d2                  
 adda.l d2, a0                  
idb2c:
 bsr idewrsek                   
 tst d0
 beq.s idb2ex
idb2err:
 move #-1, d0
idb2ex:
 rts

idebef8:                        
 btst.b #7, idecmd.w            
 beq.s idb8a
 move.l #4, d0                  
 bra.s idb8ex
idb8a:
 clr.l d0                       
idb8ex:
 rts

idebef22:                       
 clr.l d2
 move.b numsec(a6), d2
 move.l #512, d1                
 cmp #1, d3                     
 bne.s idb22a                   
 lsr.l d0, d2                   
 asl.l d0, d1                   
 bra.s idb22ex
idb22a:
 move.b numhead(a6), d3
 mulu d3, d2                    
 move numcyl(a6), d3
 mulu d3, d2                    
 lsr.l d0, d2                   
 asl.l d0, d1                   
idb22ex:
 move.l d2, 0(a0)
 move.l d1, 4(a0)
 clr.l d0
 rts

idebef24:                       
 move #36-1, d3                 
 movea.l a0, a1
idb24a:
 clr.b (a1)+                    
 dbra d3, idb24a
 move.b #1, 3(a0)               
 move.b #$3d, 4(a0)             
 move #24-1, d3                 
 movea.l a6, a1                 
 adda.l #idename, a1
 adda.l #8, a0
idb24b:
 move.b (a1)+, (a0)+            
 dbra d3, idb24b
 clr.l d0
 rts


iderdsek: 
 movem.l d1-d7/a1-a6, -(a7)              
 move #10-1, d5     
 move.l d0,d2
 move.l d1,d3    			
		
rdlp01:
 move.l d2,d1			
 lsr.l  #8,d1
 lsr.l  #8,d1
 lsr.l  #8,d1
 or.b   #$E0,d1
 move.b  d1,idesdh.w
 move.b #0,ideerr.w		
 move.b	d3,idescnt.w	
 move.l d2,d1			
 move.b  d1,idesnum.w	
 lsr.l	#8,d1
 move.b  d1,ideclo.w	
 lsr.l	#8,d1
 move.b  d1,idechi.w						
rdlp02:	
 movea.l a0,a2			
 move.l  d3,d7			
 tst d7				
 bne rdlp03
 move #256,d7
rdlp03:
 subq #1,d7
 lea idedat.w, a1       
 bsr idewrd             
 bsr idewr				
 tst d0					
 bne rdlp06        
 move sr, -(a7)        
 ori #$0700, sr         
 move.b  #cmdrd,idecmd.w    			
rdlp04:
 move #512-1, d6                    	
 bsr idewr						
 tst d0								
 beq rdlp04a           			
 move (a7)+, sr               		
 bra.s rdlp06
rdlp04a:
 bsr idewd 
 tst d0
 beq.s rdlp05                  
 move (a7)+, sr               		
 bra.s rdlp06                 
	
rdlp05:
 move.b (a1), (a2)+               
 dbra 	d6, rdlp05             
 dbra 	d7, rdlp04             	 	
 move (a7)+, sr                 
 bsr idewr                        
 tst d0
 bne rdlp06               		
 move.b idecmd.w, d0
 move.b d0,d1
 and.b #%00100001, d1							
 beq  rdlp09                
 bra  rdlp07 	
rdlp06:
 dbra d5, rdlp02	                 	
 bra rdlp08	
rdlp07:
 bsr ideres						
 dbra d5, rdlp01                 	
rdlp08:
 bra rdlp10	
rdlp09:
 clr.l d0
rdlp10:	
 movem.l (a7)+, d1-d7/a1-a2
 rts


idewrsek:           
 movem.l d1-d7/a1-a6, -(a7)              
 move #10-1, d5     
 move.l d0,d2
 move.l d1,d3   
 
wrlp01:
 move.l d2,d1
 lsr.l  #8,d1
 lsr.l  #8,d1
 lsr.l  #8,d1
 or.b	#$E0,d1
 move.b  d1,idesdh.w
 move.b #0,ideerr.w
 move.b	d3,idescnt.w
 move.l d2,d1			
 move.b  d1,idesnum.w
 lsr.l	#8,d1
 move.b  d1,ideclo.w
 lsr.l	#8,d1
 move.b  d1,idechi.w		
wrlp01a:	
 movea.l a0,a2	
 move.l  d3,d7
 tst d7		
 bne wrlp01b
 move #256,d7
wrlp01b:
 subq #1,d7	
 lea idedat.w, a1			
 bsr idewrd
 bsr idewr	
 tst d0
 bne wrlp04
 move sr, -(a7)
 ori #$0700, sr
 move.b #cmdwr,idecmd.w	
wrlp02:
 move #512-1, d6 
 bsr idewr	
 tst d0	
 beq wrlp02a 
 move (a7)+, sr  
 bra.s wrlp04 
wrlp02a:
 bsr idewd
 tst d0
 beq.s wrlp03    
 move (a7)+, sr       
 bra.s wrlp04  	
wrlp03:
 bra *+4
 move.b (a2)+, (a1) 
 dbra d6, wrlp03
 dbra d7, wrlp02  	
 move (a7)+, sr           
 bsr idewr         
 tst d0
 bne wrlp04       
 move.b idecmd.w, d0
 move.b d0,d1
 and.b #%00100001, d1
 beq  wrlp07 
 bra  wrlp05	
wrlp04: 		
 dbra d5, wrlp01a 
 bra wrlp06	
wrlp05:
 bsr ideres		
 dbra d5, wrlp01	
wrlp06:	
 bsr idefl
 bra wrlp08
wrlp07:	
 clr.l d0
wrlp08:	
 bsr idefl
 movem.l (a7)+,d1-d7/a1-a6	
 rts


lba2chs:                     
                             
                             
 clr.l d1
 move.b numsec(a6), d1
 divu d1, d0                 
 swap d0                     
 move.b d0, d2               
 addq.b #1, d2               
 clr d0
 swap d0                     
 move.b numhead(a6), d1
 divu d1, d0                 
 move d0, d3                 
 swap d0                     
 move.b d0, d1
 rts

idewr:                       
 move.l #idedel*cpu, d0      
idewr1:
 subq.l #1,d0
 beq idewr2            
 btst.b #7,idecmd.w		   
 btst.b #7,idecmd.w		    
 btst.b #7,idecmd.w		    
 btst.b #7,idecmd.w		    
 btst.b #7,idecmd.w		    
 beq idewr3			
 bra idewr1			   
idewr2:
 moveq #-3,d0
 bra idewr4
idewr3:
 clr.l d0	
idewr4:
 rts	

idewd:                       
 move.l #idedel*cpu, d0      
idewd1:
 subq.l #1,d0
 beq idewd2           
 btst.b #3,idecmd.w		   
 btst.b #3,idecmd.w		  
 btst.b #3,idecmd.w		  
 btst.b #3,idecmd.w		  
 btst.b #3,idecmd.w		  
 bne idewd3		 
 bra idewd1			  
idewd2:
 moveq #-2,d0
 bra idewd4
idewd3:
 clr.l d0
idewd4:
 rts 
 
idewrd:                
 move.l #idedel*cpu,d0          
idewrd1:
 subq.l #1,d0
 beq idewrderr            	
 btst.b #6,idecmd.w		  	
 btst.b #6,idecmd.w		  	
 btst.b #6,idecmd.w		  	
 btst.b #6,idecmd.w		  	
 btst.b #6,idecmd.w		  	
 bne idewrdsucc		  	
 bra idewrd1		 		
idewrderr:
 moveq #-1,d0
 bra idewrdend
idewrdsucc:
 clr.l d0
idewrdend:
 rts	 

idefl:
 move.b #cmdflush, idecmd.w
 bsr idewr
 rts

ideres:					
 bset #1,idedor.w
 bsr wawa
 bclr #1,idedor.w
 bsr idewr
 bsr idewrd
 rts
	
numcyl     equ 0
numhead    equ 2
numsec     equ 3
nkcmode    equ 4
idename    equ 8

idedel     equ 80000

cmdrd      equ $20
cmdwr      equ $30
cmdinit    equ $91
cmdident   equ $ec
cmdflush   equ $e7

sets2i:                     
 move.b d0, scsi2ide(a5)
 clr d0
 rts

gets2i:                     
 move.b scsi2ide(a5), d0
 rts
