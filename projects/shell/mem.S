	.text

	.global memset16, memcpy16, memmove16
	
/*
	void *memset16(void *str, int c, size_t n)
	void *memcpy16(void *dest, const void *src, size_t n)
	void *memmove16(void *dest, const void *src, size_t n)
*/		


/*
	void *memset16(void *str, int c, size_t n)
*/	
memset16:
	movem.l %d2,-(%sp)	/* save regs    */
	move.l	(16,%a7),%d1	/* count	*/
	lsr.l   #1,%d1		/* set words..  */
	move.l	(12,%a7),%d2	/* int		*/
	move.l	(8,%a7),%a0	/* dest		*/
	move.l	%a0,%d0		/* save dest    */
lp0:
	move.w	%d2,(%a0)+
	dbra    %d1,lp0
	move.l	%d0,%a0		/* restore dst  */
	movem.l (%sp)+,%d2	/* restore regs */
	rts


	
/*
	void *memcpy16(void *dest, const void *src, size_t n)
*/		

memcpy16:
	move.l	(12,%a7),%d1		/* count	*/
	lsr.l   #1,%d1			/* cpy words..  */
	move.l	(8,%a7),%a1		/* src		*/
	move.l	(4,%a7),%a0		/* dest		*/
	move.l	%a0,%d0			/* save dest    */
lp1:
	move.w	(%a1)+,(%a0)+
	dbra	%d1,lp1
	move.l %d0,%a0          /* pointer must be returned in %a0 in gcc */
	rts

/*
	void *memmove16(void *dest, const void *src, size_t n)
*/
	
memmove16:
	move.l	(12,%a7),%d1	/* count	*/	
	move.l	(8,%a7),%a1	/* src		*/
	move.l	(4,%a7),%a0	/* dest		*/
	move.l	%a0,%d0		/* dest		*/
	cmp.l	%a1,%a0
	bcc	negmove
	
	lsr.l   #1,%d1		/* move words.. */
lp2:
	move.w	(%a1)+,(%a0)+
	dbra	%d1,lp2
	move.l %d0,%a0
	rts
negmove:
	add.l	%d1,%a1
	add.l	%d1,%a0
	
	lsr.l   #1,%d1		/* move words.. */
lp3:
	move.w	-(%a1),-(%a0)
	dbra	%d1,lp3
	move.l %d0,%a0
	rts




/*
  Aufbau Bildschirm:

	Auflösung einer Seite:  

		(x)512 x (y)256 Bildpunkte = 131072 Bildpunkte

		1Byte speichert 8 Bildpunkte (Monochrom-Mode)
		1 Seite benötigt damit 16KByte (16483Bytes), 4 Seiten 64KByte

		1Byte speichert 2 Bildpunkte (Farb-Version)
		1 Pixel besteht dabei aus 4 Bit die ein Index in die CLUT sind, damit können 16 (2^4) aus 512 (2^9) Farben gleichzeitig dargestellt werden.
		(Die CLUT besteht aus 16 9Bit Einträgen)
		1 Seite benötigt damit 64KByte, 4 Seiten 256KByte

		In der Farbversion mit 68020 ist also (Base == 0x70.0000*cpu): 
			Page 0  == 1C00000 .... 1C0FFFF
			Page 1  == 1C10000 .... 1C1FFFF
			Page 2  == 1C20000 .... 1C2FFFF
			Page 3  == 1C30000 .... 1C3FFFF
					== 1Cp0000 .... 1CpFFFF
					== 1C00000 + p<<20

			Zeile 0 == 1C00000 .... 1C000FF
			Zeile 1 == 1C00100 .... 1C001FF
			Zeile n == 1C0nn00 .... 1C0nnFF (mit nn = 0x00...0xFF )
			        == 1C00000 + nn<<8

			Pixel k == 1C00000 + k/2  => es wird immer auf 2 Pixel gleichzeitig zugegriffen !!

			pixel (x,y) == 1Cp0000 + y<<8 + x/2

			Speicher f. Fenster mit ObenLinks(x1,y1), UntenRechts(x2,y2):

			pixel (x1,y1) == 1Cp0000 + y1<<8 + x1/2
			pixel (x2,y2) == 1Cp0000 + y2<<8 + x2/2


			0,1 2,3 4,5 ....
			Pixel k(x,y) setzen:  
				d0 <= 1Cp0000 + ky<<8 + kx/2
				wenn (kx mod 2 == 0) dann oberes Nibble (Sonderfall x=0) ansonsten oberes Nibble von d0.b setzen und d0 zurückschreiben.
*/



/* 
	void setpixel(const int x, const int y, const int color)
*/

setpixel:
	move.l	(12,%a7),%d1 /* color	 */
	move.l	(8,%a7),%d1 /* y	 */
	move.l	(4,%a7),%d2	 /* x	 */


	rts	

/* 
	void *saveblock(void *dest, const int x1, const int y1, const int x2, const int y2)
*/

saveblock:
	move.l	(20,%a7),%d1 /* y2	 */
	move.l	(16,%a7),%d1 /* x2	 */
	move.l	(12,%a7),%d1 /* y1	 */
	move.l	(8,%a7),%d2	 /* x1	 */
	move.l	(4,%a7),%a0	 /* dest */


	rts	

/* 
	void *restoreblock(void *src, const int x1, const int y1, const int x2, const int y2)
*/

restoreblock:
	move.l	(20,%a7),%d1 /* y2	 */
	move.l	(16,%a7),%d1 /* x2	 */
	move.l	(12,%a7),%d1 /* y1	 */
	move.l	(8,%a7),%d2	 /* x1	 */
	move.l	(4,%a7),%a0	 /* src */


	rts		