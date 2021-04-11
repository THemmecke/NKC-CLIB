
test.68k_.68k:     file format binary


Disassembly of section .data:

00000000 <.data>:
   0:	4e56 fff0      	linkw %fp,#-16
   4:	700a           	moveq #10,%d0
   6:	2d40 fffc      	movel %d0,%fp@(-4)
   a:	4878 000a      	pea 0xa
   e:	70f1           	moveq #-15,%d0
  10:	d08e           	addl %fp,%d0
  12:	2f00           	movel %d0,%sp@-
  14:	2f2e fffc      	movel %fp@(-4),%sp@-
  18:	4eb9 0000 0000 	jsr 0x0
  1e:	4fef 000c      	lea %sp@(12),%sp
  22:	70f1           	moveq #-15,%d0
  24:	d08e           	addl %fp,%d0
  26:	2f00           	movel %d0,%sp@-
  28:	4eb9 0000 0000 	jsr 0x0
  2e:	588f           	addql #4,%sp
  30:	2d40 fffc      	movel %d0,%fp@(-4)
  34:	70f1           	moveq #-15,%d0
  36:	d08e           	addl %fp,%d0
  38:	4878 000a      	pea 0xa
  3c:	2f00           	movel %d0,%sp@-
  3e:	70f1           	moveq #-15,%d0
  40:	d08e           	addl %fp,%d0
  42:	2f00           	movel %d0,%sp@-
  44:	4eb9 0000 0000 	jsr 0x0
  4a:	4fef 000c      	lea %sp@(12),%sp
  4e:	4879 0000 0000 	pea 0x0
  54:	4eb9 0000 0000 	jsr 0x0
  5a:	588f           	addql #4,%sp
  5c:	4e5e           	unlk %fp
  5e:	4e75           	rts
  60:	4865           	.short 0x4865
  62:	6c6c           	bges 0xd0
  64:	6f20           	bles 0x86
  66:	576f 726c      	subqw #3,%sp@(29292)
  6a:	6421           	bccs 0x8d
	...
