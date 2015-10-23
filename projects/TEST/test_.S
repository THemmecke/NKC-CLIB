
test_.68k:     Dateiformat binary


Disassembly of section .data:

00000000 <.data>:
       0:	41fb 0170 0000 	lea %pc@(0x2),%a0
       6:	0000 
       8:	208f           	movel %sp,%a0@
       a:	41fb 0170 0000 	lea %pc@(0xc),%a0
      10:	0000 
      12:	20bc 0000 0000 	movel #0,%a0@
      18:	61ff 0000 0154 	bsrl 0x16e
      1e:	0c42 0000      	cmpiw #0,%d2
      22:	6600 0116      	bnew 0x13a
      26:	41fb 0170 0000 	lea %pc@(0x28),%a0
      2c:	0000 
      2e:	43fb 0170 0000 	lea %pc@(0x30),%a1
      34:	0000 
      36:	20fc 0000 0000 	movel #0,%a0@+
      3c:	b3c8           	cmpal %a0,%a1
      3e:	6200 fff6      	bhiw 0x36
      42:	41fb 0170 0000 	lea %pc@(0x44),%a0
      48:	0000 
      4a:	20bc 0000 0000 	movel #0,%a0@
      50:	43fb 0170 0000 	lea %pc@(0x52),%a1
      56:	0000 
      58:	2288           	movel %a0,%a1@
      5a:	7e3e           	moveq #62,%d7
      5c:	4e46           	trap #6
      5e:	2008           	movel %a0,%d0
      60:	41fb 0170 0000 	lea %pc@(0x62),%a0
      66:	0000 
      68:	2080           	movel %d0,%a0@
      6a:	61ff 0000 0000 	bsrl 0x6c
      70:	7e19           	moveq #25,%d7
      72:	4e46           	trap #6
      74:	43fb 0170 0000 	lea %pc@(0x76),%a1
      7a:	0000 
      7c:	12d8           	moveb %a0@+,%a1@+
      7e:	6600 fffc      	bnew 0x7c
      82:	12bc 0000      	moveb #0,%a1@
      86:	43fb 0170 0000 	lea %pc@(0x88),%a1
      8c:	0000 
      8e:	41fb 0170 0000 	lea %pc@(0x90),%a0
      94:	0000 
      96:	2089           	movel %a1,%a0@
      98:	4280           	clrl %d0
      9a:	61ff 0000 0000 	bsrl 0x9c
      a0:	41fb 0170 0000 	lea %pc@(0xa2),%a0
      a6:	0000 
      a8:	1080           	moveb %d0,%a0@
      aa:	61ff 0000 0000 	bsrl 0xac
      b0:	61ff 0000 0000 	bsrl 0xb2
      b6:	61ff 0000 0000 	bsrl 0xb8
      bc:	61ff 0000 0000 	bsrl 0xbe
      c2:	61ff 0000 0000 	bsrl 0xc4
      c8:	61ff 0000 0000 	bsrl 0xca
      ce:	61ff 0000 0000 	bsrl 0xd0
      d4:	2f3b 0170 0000 	movel %pc@(0xd6),%sp@-
      da:	0000 
      dc:	2f3b 0170 0000 	movel %pc@(0xde),%sp@-
      e2:	0000 
      e4:	2f3b 0170 0000 	movel %pc@(0xe6),%sp@-
      ea:	0000 
      ec:	61ff 0000 0000 	bsrl 0xee
      f2:	dffc 0000 000c 	addal #12,%sp
      f8:	6000 0040      	braw 0x13a
      fc:	203b 0170 0000 	movel %pc@(0xfe),%d0
     102:	0000 
     104:	4e75           	rts
     106:	48e7 fffe      	moveml %d0-%fp,%sp@-
     10a:	41fb 0170 0000 	lea %pc@(0x10c),%a0
     110:	0000 
     112:	1018           	moveb %a0@+,%d0
     114:	6700 000a      	beqw 0x120
     118:	7e21           	moveq #33,%d7
     11a:	4e41           	trap #1
     11c:	6000 fff4      	braw 0x112
     120:	4cdf 7fff      	moveml %sp@+,%d0-%fp
     124:	48e7 fffe      	moveml %d0-%fp,%sp@-
     128:	7e63           	moveq #99,%d7
     12a:	4e41           	trap #1
     12c:	4cdf 7fff      	moveml %sp@+,%d0-%fp
     130:	41fb 0170 0000 	lea %pc@(0x132),%a0
     136:	0000 
     138:	2e50           	moveal %a0@,%sp
     13a:	61ff 0000 0000 	bsrl 0x13c
     140:	61ff 0000 0000 	bsrl 0x142
     146:	61ff 0000 0000 	bsrl 0x148
     14c:	48e7 fffe      	moveml %d0-%fp,%sp@-
     150:	41fb 0170 0000 	lea %pc@(0x152),%a0
     156:	0000 
     158:	1018           	moveb %a0@+,%d0
     15a:	6700 000a      	beqw 0x166
     15e:	7e21           	moveq #33,%d7
     160:	4e41           	trap #1
     162:	6000 fff4      	braw 0x158
     166:	4cdf 7fff      	moveml %sp@+,%d0-%fp
     16a:	4e75           	rts
     16c:	4e75           	rts
     16e:	41fa fe90      	lea %pc@(0x0),%a0
     172:	43fb 0170 0000 	lea %pc@(0x174),%a1
     178:	0000 
     17a:	45fb 0170 0000 	lea %pc@(0x17c),%a2
     180:	0000 
     182:	b3d2           	cmpal %a2@,%a1
     184:	6f00 02d0      	blew 0x456
     188:	0c99 dead beaf 	cmpil #-559038801,%a1@+
     18e:	6600 fff2      	bnew 0x182
     192:	0c99 5aa5 8001 	cmpil #1520795649,%a1@+
     198:	6600 ffe8      	bnew 0x182
     19c:	0c99 dead beaf 	cmpil #-559038801,%a1@+
     1a2:	6600 ffde      	bnew 0x182
     1a6:	91d9           	subal %a1@+,%a0
     1a8:	b1fc 0000 0000 	cmpal #0,%a0
     1ae:	6600 0006      	bnew 0x1b6
     1b2:	4282           	clrl %d2
     1b4:	4e75           	rts
     1b6:	2019           	movel %a1@+,%d0
     1b8:	6700 0278      	beqw 0x432
     1bc:	48e7 fffe      	moveml %d0-%fp,%sp@-
     1c0:	41fb 0170 0000 	lea %pc@(0x1c2),%a0
     1c6:	0000 
     1c8:	1018           	moveb %a0@+,%d0
     1ca:	6700 000a      	beqw 0x1d6
     1ce:	7e21           	moveq #33,%d7
     1d0:	4e41           	trap #1
     1d2:	6000 fff4      	braw 0x1c8
     1d6:	4cdf 7fff      	moveml %sp@+,%d0-%fp
     1da:	48e7 fffe      	moveml %d0-%fp,%sp@-
     1de:	2000           	movel %d0,%d0
     1e0:	41fb 0170 0000 	lea %pc@(0x1e2),%a0
     1e6:	0000 
     1e8:	7e2c           	moveq #44,%d7
     1ea:	4e41           	trap #1
     1ec:	4cdf 7fff      	moveml %sp@+,%d0-%fp
     1f0:	48e7 fffe      	moveml %d0-%fp,%sp@-
     1f4:	41fb 0170 0000 	lea %pc@(0x1f6),%a0
     1fa:	0000 
     1fc:	1018           	moveb %a0@+,%d0
     1fe:	6700 000a      	beqw 0x20a
     202:	7e21           	moveq #33,%d7
     204:	4e41           	trap #1
     206:	6000 fff4      	braw 0x1fc
     20a:	4cdf 7fff      	moveml %sp@+,%d0-%fp
     20e:	48e7 fffe      	moveml %d0-%fp,%sp@-
     212:	7e63           	moveq #99,%d7
     214:	4e41           	trap #1
     216:	4cdf 7fff      	moveml %sp@+,%d0-%fp
     21a:	5380           	subql #1,%d0
     21c:	41fa fde2      	lea %pc@(0x0),%a0
     220:	0ca9 0000 0001 	cmpil #1,%a1@(4)
     226:	0004 
     228:	6600 01d4      	bnew 0x3fe
     22c:	2229 0008      	movel %a1@(8),%d1
     230:	d288           	addl %a0,%d1
     232:	2451           	moveal %a1@,%a2
     234:	d5c8           	addal %a0,%a2
     236:	2481           	movel %d1,%a2@
     238:	b292           	cmpl %a2@,%d1
     23a:	6700 01e6      	beqw 0x422
     23e:	48e7 fffe      	moveml %d0-%fp,%sp@-
     242:	41fb 0170 0000 	lea %pc@(0x244),%a0
     248:	0000 
     24a:	1018           	moveb %a0@+,%d0
     24c:	6700 000a      	beqw 0x258
     250:	7e21           	moveq #33,%d7
     252:	4e41           	trap #1
     254:	6000 fff4      	braw 0x24a
     258:	4cdf 7fff      	moveml %sp@+,%d0-%fp
     25c:	48e7 fffe      	moveml %d0-%fp,%sp@-
     260:	2029 0004      	movel %a1@(4),%d0
     264:	41fb 0170 0000 	lea %pc@(0x266),%a0
     26a:	0000 
     26c:	7e2c           	moveq #44,%d7
     26e:	4e41           	trap #1
     270:	4cdf 7fff      	moveml %sp@+,%d0-%fp
     274:	48e7 fffe      	moveml %d0-%fp,%sp@-
     278:	41fb 0170 0000 	lea %pc@(0x27a),%a0
     27e:	0000 
     280:	1018           	moveb %a0@+,%d0
     282:	6700 000a      	beqw 0x28e
     286:	7e21           	moveq #33,%d7
     288:	4e41           	trap #1
     28a:	6000 fff4      	braw 0x280
     28e:	4cdf 7fff      	moveml %sp@+,%d0-%fp
     292:	48e7 fffe      	moveml %d0-%fp,%sp@-
     296:	41fb 0170 0000 	lea %pc@(0x298),%a0
     29c:	0000 
     29e:	1018           	moveb %a0@+,%d0
     2a0:	6700 000a      	beqw 0x2ac
     2a4:	7e21           	moveq #33,%d7
     2a6:	4e41           	trap #1
     2a8:	6000 fff4      	braw 0x29e
     2ac:	4cdf 7fff      	moveml %sp@+,%d0-%fp
     2b0:	48e7 fffe      	moveml %d0-%fp,%sp@-
     2b4:	2011           	movel %a1@,%d0
     2b6:	41fb 0170 0000 	lea %pc@(0x2b8),%a0
     2bc:	0000 
     2be:	7e2c           	moveq #44,%d7
     2c0:	4e41           	trap #1
     2c2:	4cdf 7fff      	moveml %sp@+,%d0-%fp
     2c6:	48e7 fffe      	moveml %d0-%fp,%sp@-
     2ca:	41fb 0170 0000 	lea %pc@(0x2cc),%a0
     2d0:	0000 
     2d2:	1018           	moveb %a0@+,%d0
     2d4:	6700 000a      	beqw 0x2e0
     2d8:	7e21           	moveq #33,%d7
     2da:	4e41           	trap #1
     2dc:	6000 fff4      	braw 0x2d2
     2e0:	4cdf 7fff      	moveml %sp@+,%d0-%fp
     2e4:	48e7 fffe      	moveml %d0-%fp,%sp@-
     2e8:	41fb 0170 0000 	lea %pc@(0x2ea),%a0
     2ee:	0000 
     2f0:	1018           	moveb %a0@+,%d0
     2f2:	6700 000a      	beqw 0x2fe
     2f6:	7e21           	moveq #33,%d7
     2f8:	4e41           	trap #1
     2fa:	6000 fff4      	braw 0x2f0
     2fe:	4cdf 7fff      	moveml %sp@+,%d0-%fp
     302:	48e7 fffe      	moveml %d0-%fp,%sp@-
     306:	2029 0008      	movel %a1@(8),%d0
     30a:	41fb 0170 0000 	lea %pc@(0x30c),%a0
     310:	0000 
     312:	7e2c           	moveq #44,%d7
     314:	4e41           	trap #1
     316:	4cdf 7fff      	moveml %sp@+,%d0-%fp
     31a:	48e7 fffe      	moveml %d0-%fp,%sp@-
     31e:	41fb 0170 0000 	lea %pc@(0x320),%a0
     324:	0000 
     326:	1018           	moveb %a0@+,%d0
     328:	6700 000a      	beqw 0x334
     32c:	7e21           	moveq #33,%d7
     32e:	4e41           	trap #1
     330:	6000 fff4      	braw 0x326
     334:	4cdf 7fff      	moveml %sp@+,%d0-%fp
     338:	48e7 fffe      	moveml %d0-%fp,%sp@-
     33c:	41fb 0170 0000 	lea %pc@(0x33e),%a0
     342:	0000 
     344:	1018           	moveb %a0@+,%d0
     346:	6700 000a      	beqw 0x352
     34a:	7e21           	moveq #33,%d7
     34c:	4e41           	trap #1
     34e:	6000 fff4      	braw 0x344
     352:	4cdf 7fff      	moveml %sp@+,%d0-%fp
     356:	48e7 fffe      	moveml %d0-%fp,%sp@-
     35a:	2008           	movel %a0,%d0
     35c:	41fb 0170 0000 	lea %pc@(0x35e),%a0
     362:	0000 
     364:	7e2c           	moveq #44,%d7
     366:	4e41           	trap #1
     368:	4cdf 7fff      	moveml %sp@+,%d0-%fp
     36c:	48e7 fffe      	moveml %d0-%fp,%sp@-
     370:	41fb 0170 0000 	lea %pc@(0x372),%a0
     376:	0000 
     378:	1018           	moveb %a0@+,%d0
     37a:	6700 000a      	beqw 0x386
     37e:	7e21           	moveq #33,%d7
     380:	4e41           	trap #1
     382:	6000 fff4      	braw 0x378
     386:	4cdf 7fff      	moveml %sp@+,%d0-%fp
     38a:	48e7 fffe      	moveml %d0-%fp,%sp@-
     38e:	41fb 0170 0000 	lea %pc@(0x390),%a0
     394:	0000 
     396:	1018           	moveb %a0@+,%d0
     398:	6700 000a      	beqw 0x3a4
     39c:	7e21           	moveq #33,%d7
     39e:	4e41           	trap #1
     3a0:	6000 fff4      	braw 0x396
     3a4:	4cdf 7fff      	moveml %sp@+,%d0-%fp
     3a8:	48e7 fffe      	moveml %d0-%fp,%sp@-
     3ac:	2012           	movel %a2@,%d0
     3ae:	41fb 0170 0000 	lea %pc@(0x3b0),%a0
     3b4:	0000 
     3b6:	7e2c           	moveq #44,%d7
     3b8:	4e41           	trap #1
     3ba:	4cdf 7fff      	moveml %sp@+,%d0-%fp
     3be:	48e7 fffe      	moveml %d0-%fp,%sp@-
     3c2:	41fb 0170 0000 	lea %pc@(0x3c4),%a0
     3c8:	0000 
     3ca:	1018           	moveb %a0@+,%d0
     3cc:	6700 000a      	beqw 0x3d8
     3d0:	7e21           	moveq #33,%d7
     3d2:	4e41           	trap #1
     3d4:	6000 fff4      	braw 0x3ca
     3d8:	4cdf 7fff      	moveml %sp@+,%d0-%fp
     3dc:	48e7 fffe      	moveml %d0-%fp,%sp@-
     3e0:	7e63           	moveq #99,%d7
     3e2:	4e41           	trap #1
     3e4:	4cdf 7fff      	moveml %sp@+,%d0-%fp
     3e8:	48e7 fffe      	moveml %d0-%fp,%sp@-
     3ec:	7e0c           	moveq #12,%d7
     3ee:	4e41           	trap #1
     3f0:	0c00 000d      	cmpib #13,%d0
     3f4:	66f6           	bnes 0x3ec
     3f6:	4cdf 7fff      	moveml %sp@+,%d0-%fp
     3fa:	6000 0026      	braw 0x422
     3fe:	48e7 fffe      	moveml %d0-%fp,%sp@-
     402:	41fb 0170 0000 	lea %pc@(0x404),%a0
     408:	0000 
     40a:	1018           	moveb %a0@+,%d0
     40c:	6700 000a      	beqw 0x418
     410:	7e21           	moveq #33,%d7
     412:	4e41           	trap #1
     414:	6000 fff4      	braw 0x40a
     418:	4cdf 7fff      	moveml %sp@+,%d0-%fp
     41c:	7401           	moveq #1,%d2
     41e:	6000 0074      	braw 0x494
     422:	d3fc 0000 000c 	addal #12,%a1
     428:	51c8 fdf6      	dbf %d0,0x220
     42c:	7400           	moveq #0,%d2
     42e:	6000 0064      	braw 0x494
     432:	48e7 fffe      	moveml %d0-%fp,%sp@-
     436:	41fb 0170 0000 	lea %pc@(0x438),%a0
     43c:	0000 
     43e:	1018           	moveb %a0@+,%d0
     440:	6700 000a      	beqw 0x44c
     444:	7e21           	moveq #33,%d7
     446:	4e41           	trap #1
     448:	6000 fff4      	braw 0x43e
     44c:	4cdf 7fff      	moveml %sp@+,%d0-%fp
     450:	7401           	moveq #1,%d2
     452:	6000 0040      	braw 0x494
     456:	48e7 fffe      	moveml %d0-%fp,%sp@-
     45a:	41fb 0170 0000 	lea %pc@(0x45c),%a0
     460:	0000 
     462:	1018           	moveb %a0@+,%d0
     464:	6700 000a      	beqw 0x470
     468:	7e21           	moveq #33,%d7
     46a:	4e41           	trap #1
     46c:	6000 fff4      	braw 0x462
     470:	4cdf 7fff      	moveml %sp@+,%d0-%fp
     474:	48e7 fffe      	moveml %d0-%fp,%sp@-
     478:	7e63           	moveq #99,%d7
     47a:	4e41           	trap #1
     47c:	4cdf 7fff      	moveml %sp@+,%d0-%fp
     480:	48e7 fffe      	moveml %d0-%fp,%sp@-
     484:	7e0c           	moveq #12,%d7
     486:	4e41           	trap #1
     488:	0c00 000d      	cmpib #13,%d0
     48c:	66f6           	bnes 0x484
     48e:	4cdf 7fff      	moveml %sp@+,%d0-%fp
     492:	7401           	moveq #1,%d2
     494:	48e7 fffe      	moveml %d0-%fp,%sp@-
     498:	41fb 0170 0000 	lea %pc@(0x49a),%a0
     49e:	0000 
     4a0:	1018           	moveb %a0@+,%d0
     4a2:	6700 000a      	beqw 0x4ae
     4a6:	7e21           	moveq #33,%d7
     4a8:	4e41           	trap #1
     4aa:	6000 fff4      	braw 0x4a0
     4ae:	4cdf 7fff      	moveml %sp@+,%d0-%fp
     4b2:	48e7 fffe      	moveml %d0-%fp,%sp@-
     4b6:	7e0c           	moveq #12,%d7
     4b8:	4e41           	trap #1
     4ba:	0c00 000d      	cmpib #13,%d0
     4be:	66f6           	bnes 0x4b6
     4c0:	4cdf 7fff      	moveml %sp@+,%d0-%fp
     4c4:	4e75           	rts
     4c6:	4e71           	nop
     4c8:	4e56 0000      	linkw %fp,#0
     4cc:	4878 0016      	pea 0x16
     4d0:	4eb9 0000 0000 	jsr 0x0
     4d6:	588f           	addql #4,%sp
     4d8:	4e5e           	unlk %fp
     4da:	4e75           	rts
     4dc:	4e56 fda4      	linkw %fp,#-604
     4e0:	2f02           	movel %d2,%sp@-
     4e2:	7001           	moveq #1,%d0
     4e4:	23c0 0000 0000 	movel %d0,0x0
     4ea:	2d7c 0000 0000 	movel #0,%fp@(-604)
     4f0:	fda4 
     4f2:	6000 0104      	braw 0x5f8
     4f6:	2039 0000 0000 	movel 0x0,%d0
     4fc:	5280           	addql #1,%d0
     4fe:	23c0 0000 0000 	movel %d0,0x0
     504:	6002           	bras 0x508
     506:	4e71           	nop
     508:	2039 0000 0000 	movel 0x0,%d0
     50e:	2040           	moveal %d0,%a0
     510:	1010           	moveb %a0@,%d0
     512:	49c0           	extbl %d0
     514:	1030 09b0 0000 	moveb @(00000000,%d0:l),%d0
     51a:	0000 
     51c:	1000           	moveb %d0,%d0
     51e:	0280 0000 00ff 	andil #255,%d0
     524:	7201           	moveq #1,%d1
     526:	c081           	andl %d1,%d0
     528:	1000           	moveb %d0,%d0
     52a:	4a00           	tstb %d0
     52c:	66c8           	bnes 0x4f6
     52e:	2039 0000 0000 	movel 0x0,%d0
     534:	2040           	moveal %d0,%a0
     536:	1010           	moveb %a0@,%d0
     538:	4a00           	tstb %d0
     53a:	6700 00bc      	beqw 0x5f8
     53e:	42ae fffc      	clrl %fp@(-4)
     542:	602a           	bras 0x56e
     544:	2039 0000 0000 	movel 0x0,%d0
     54a:	2240           	moveal %d0,%a1
     54c:	1211           	moveb %a1@,%d1
     54e:	3041           	moveaw %d1,%a0
     550:	220e           	movel %fp,%d1
     552:	0681 ffff ff34 	addil #-204,%d1
     558:	d2ae fffc      	addl %fp@(-4),%d1
     55c:	3408           	movew %a0,%d2
     55e:	2241           	moveal %d1,%a1
     560:	1282           	moveb %d2,%a1@
     562:	52ae fffc      	addql #1,%fp@(-4)
     566:	5280           	addql #1,%d0
     568:	23c0 0000 0000 	movel %d0,0x0
     56e:	2039 0000 0000 	movel 0x0,%d0
     574:	2040           	moveal %d0,%a0
     576:	1010           	moveb %a0@,%d0
     578:	49c0           	extbl %d0
     57a:	1030 09b0 0000 	moveb @(00000000,%d0:l),%d0
     580:	0000 
     582:	1000           	moveb %d0,%d0
     584:	0280 0000 00ff 	andil #255,%d0
     58a:	7201           	moveq #1,%d1
     58c:	c081           	andl %d1,%d0
     58e:	4a80           	tstl %d0
     590:	660e           	bnes 0x5a0
     592:	2039 0000 0000 	movel 0x0,%d0
     598:	2040           	moveal %d0,%a0
     59a:	1010           	moveb %a0@,%d0
     59c:	4a00           	tstb %d0
     59e:	66a4           	bnes 0x544
     5a0:	200e           	movel %fp,%d0
     5a2:	0680 ffff ff34 	addil #-204,%d0
     5a8:	d0ae fffc      	addl %fp@(-4),%d0
     5ac:	2240           	moveal %d0,%a1
     5ae:	4211           	clrb %a1@
     5b0:	52ae fffc      	addql #1,%fp@(-4)
     5b4:	2439 0000 0000 	movel 0x0,%d2
     5ba:	202e fffc      	movel %fp@(-4),%d0
     5be:	2f00           	movel %d0,%sp@-
     5c0:	4eb9 0000 0000 	jsr 0x0
     5c6:	588f           	addql #4,%sp
     5c8:	2008           	movel %a0,%d0
     5ca:	2d80 2d20 fda4 	movel %d0,%fp@(fffffda4,%d2:l:4)
     5d0:	2039 0000 0000 	movel 0x0,%d0
     5d6:	2236 0d20 fda4 	movel %fp@(fffffda4,%d0:l:4),%d1
     5dc:	5280           	addql #1,%d0
     5de:	23c0 0000 0000 	movel %d0,0x0
     5e4:	200e           	movel %fp,%d0
     5e6:	0680 ffff ff34 	addil #-204,%d0
     5ec:	2f00           	movel %d0,%sp@-
     5ee:	2f01           	movel %d1,%sp@-
     5f0:	4eb9 0000 0000 	jsr 0x0
     5f6:	508f           	addql #8,%sp
     5f8:	2039 0000 0000 	movel 0x0,%d0
     5fe:	2040           	moveal %d0,%a0
     600:	1010           	moveb %a0@,%d0
     602:	4a00           	tstb %d0
     604:	6600 ff00      	bnew 0x506
     608:	2039 0000 0000 	movel 0x0,%d0
     60e:	e588           	lsll #2,%d0
     610:	2f00           	movel %d0,%sp@-
     612:	4eb9 0000 0000 	jsr 0x0
     618:	588f           	addql #4,%sp
     61a:	2008           	movel %a0,%d0
     61c:	23c0 0000 0000 	movel %d0,0x0
     622:	2039 0000 0000 	movel 0x0,%d0
     628:	e588           	lsll #2,%d0
     62a:	2239 0000 0000 	movel 0x0,%d1
     630:	2f00           	movel %d0,%sp@-
     632:	200e           	movel %fp,%d0
     634:	0680 ffff fda4 	addil #-604,%d0
     63a:	2f00           	movel %d0,%sp@-
     63c:	2f01           	movel %d1,%sp@-
     63e:	4eb9 0000 0000 	jsr 0x0
     644:	4fef 000c      	lea %sp@(12),%sp
     648:	242e fda0      	movel %fp@(-608),%d2
     64c:	4e5e           	unlk %fp
     64e:	4e75           	rts
     650:	4e56 0000      	linkw %fp,#0
     654:	2f2e 0008      	movel %fp@(8),%sp@-
     658:	4879 0000 0000 	pea 0x0
     65e:	4878 001a      	pea 0x1a
     662:	4879 0000 0000 	pea 0x0
     668:	4eb9 0000 0000 	jsr 0x0
     66e:	4fef 0010      	lea %sp@(16),%sp
     672:	203c 0000 0000 	movel #0,%d0
     678:	2200           	movel %d0,%d1
     67a:	2041           	moveal %d1,%a0
     67c:	4e5e           	unlk %fp
     67e:	4e75           	rts
     680:	4e56 0000      	linkw %fp,#0
     684:	203c 0000 0000 	movel #0,%d0
     68a:	5080           	addql #8,%d0
     68c:	2040           	moveal %d0,%a0
     68e:	2010           	movel %a0@,%d0
     690:	2f2e 0014      	movel %fp@(20),%sp@-
     694:	2f2e 0010      	movel %fp@(16),%sp@-
     698:	2f2e 000c      	movel %fp@(12),%sp@-
     69c:	2f2e 0008      	movel %fp@(8),%sp@-
     6a0:	4879 0000 0000 	pea 0x0
     6a6:	2f00           	movel %d0,%sp@-
     6a8:	4eb9 0000 0000 	jsr 0x0
     6ae:	4fef 0018      	lea %sp@(24),%sp
     6b2:	4878 0001      	pea 0x1
     6b6:	4eb9 0000 0000 	jsr 0x0
     6bc:	588f           	addql #4,%sp
     6be:	4e5e           	unlk %fp
     6c0:	4e75           	rts
     6c2:	4e71           	nop
     6c4:	4e56 fffc      	linkw %fp,#-4
     6c8:	2039 0000 0000 	movel 0x0,%d0
     6ce:	4a80           	tstl %d0
     6d0:	6626           	bnes 0x6f8
     6d2:	2d79 0000 0000 	movel 0x0,%fp@(-4)
     6d8:	fffc 
     6da:	6016           	bras 0x6f2
     6dc:	202e fffc      	movel %fp@(-4),%d0
     6e0:	5380           	subql #1,%d0
     6e2:	2030 0db0 0000 	movel @(00000000,%d0:l:4),%d0
     6e8:	0000 
     6ea:	2040           	moveal %d0,%a0
     6ec:	4e90           	jsr %a0@
     6ee:	53ae fffc      	subql #1,%fp@(-4)
     6f2:	4aae fffc      	tstl %fp@(-4)
     6f6:	6ee4           	bgts 0x6dc
     6f8:	4e5e           	unlk %fp
     6fa:	4e75           	rts
     6fc:	4e56 0000      	linkw %fp,#0
     700:	2039 0000 0000 	movel 0x0,%d0
     706:	721f           	moveq #31,%d1
     708:	b280           	cmpl %d0,%d1
     70a:	6d1c           	blts 0x728
     70c:	2039 0000 0000 	movel 0x0,%d0
     712:	21ae 0008 0db0 	movel %fp@(8),@(00000000,%d0:l:4)
     718:	0000 0000 
     71c:	5280           	addql #1,%d0
     71e:	23c0 0000 0000 	movel %d0,0x0
     724:	4280           	clrl %d0
     726:	6002           	bras 0x72a
     728:	70ff           	moveq #-1,%d0
     72a:	4e5e           	unlk %fp
     72c:	4e75           	rts
     72e:	4e71           	nop
     730:	4e56 ffe8      	linkw %fp,#-24
     734:	2f02           	movel %d2,%sp@-
     736:	42ae fffc      	clrl %fp@(-4)
     73a:	42ae fff4      	clrl %fp@(-12)
     73e:	42ae fff8      	clrl %fp@(-8)
     742:	42ae ffec      	clrl %fp@(-20)
     746:	42ae fff0      	clrl %fp@(-16)
     74a:	42ae ffe8      	clrl %fp@(-24)
     74e:	6004           	bras 0x754
     750:	52ae 0008      	addql #1,%fp@(8)
     754:	202e 0008      	movel %fp@(8),%d0
     758:	2040           	moveal %d0,%a0
     75a:	1010           	moveb %a0@,%d0
     75c:	49c0           	extbl %d0
     75e:	1030 09b0 0000 	moveb @(00000000,%d0:l),%d0
     764:	0000 
     766:	1000           	moveb %d0,%d0
     768:	0280 0000 00ff 	andil #255,%d0
     76e:	7201           	moveq #1,%d1
     770:	c081           	andl %d1,%d0
     772:	1000           	moveb %d0,%d0
     774:	4a00           	tstb %d0
     776:	66d8           	bnes 0x750
     778:	202e 0008      	movel %fp@(8),%d0
     77c:	2040           	moveal %d0,%a0
     77e:	1010           	moveb %a0@,%d0
     780:	0c00 002d      	cmpib #45,%d0
     784:	660a           	bnes 0x790
     786:	52ae fffc      	addql #1,%fp@(-4)
     78a:	52ae 0008      	addql #1,%fp@(8)
     78e:	6012           	bras 0x7a2
     790:	202e 0008      	movel %fp@(8),%d0
     794:	2040           	moveal %d0,%a0
     796:	1010           	moveb %a0@,%d0
     798:	0c00 002b      	cmpib #43,%d0
     79c:	6604           	bnes 0x7a2
     79e:	52ae 0008      	addql #1,%fp@(8)
     7a2:	202e 0008      	movel %fp@(8),%d0
     7a6:	2040           	moveal %d0,%a0
     7a8:	1010           	moveb %a0@,%d0
     7aa:	0c00 002e      	cmpib #46,%d0
     7ae:	6614           	bnes 0x7c4
     7b0:	2d7c 3fb9 9999 	movel #1069128089,%fp@(-12)
     7b6:	fff4 
     7b8:	2d7c 9999 999a 	movel #-1717986918,%fp@(-8)
     7be:	fff8 
     7c0:	52ae 0008      	addql #1,%fp@(8)
     7c4:	206e fff4      	moveal %fp@(-12),%a0
     7c8:	226e fff8      	moveal %fp@(-8),%a1
     7cc:	4280           	clrl %d0
     7ce:	4281           	clrl %d1
     7d0:	2f09           	movel %a1,%sp@-
     7d2:	2f08           	movel %a0,%sp@-
     7d4:	f21f 5400      	fmoved %sp@+,%fp0
     7d8:	2f01           	movel %d1,%sp@-
     7da:	2f00           	movel %d0,%sp@-
     7dc:	f21f 5480      	fmoved %sp@+,%fp1
     7e0:	f200 0438      	fcmpx %fp1,%fp0
     7e4:	f240 000e      	fsne %d0
     7e8:	4400           	negb %d0
     7ea:	0a00 0001      	eorib #1,%d0
     7ee:	4a00           	tstb %d0
     7f0:	6700 008a      	beqw 0x87c
     7f4:	6042           	bras 0x838
     7f6:	f200 5c33      	fmovecrx #51,%fp0
     7fa:	f22e 5423 ffec 	fmuld %fp@(-20),%fp0
     800:	f22e 7400 ffec 	fmoved %fp0,%fp@(-20)
     806:	202e 0008      	movel %fp@(8),%d0
     80a:	2040           	moveal %d0,%a0
     80c:	1010           	moveb %a0@,%d0
     80e:	49c0           	extbl %d0
     810:	72d0           	moveq #-48,%d1
     812:	d081           	addl %d1,%d0
     814:	f200 4000      	fmovel %d0,%fp0
     818:	f227 7400      	fmoved %fp0,%sp@-
     81c:	201f           	movel %sp@+,%d0
     81e:	221f           	movel %sp@+,%d1
     820:	2f01           	movel %d1,%sp@-
     822:	2f00           	movel %d0,%sp@-
     824:	f21f 5480      	fmoved %sp@+,%fp1
     828:	f22e 54a2 ffec 	faddd %fp@(-20),%fp1
     82e:	f22e 7480 ffec 	fmoved %fp1,%fp@(-20)
     834:	52ae 0008      	addql #1,%fp@(8)
     838:	202e 0008      	movel %fp@(8),%d0
     83c:	2040           	moveal %d0,%a0
     83e:	1010           	moveb %a0@,%d0
     840:	49c0           	extbl %d0
     842:	1030 09b0 0000 	moveb @(00000000,%d0:l),%d0
     848:	0000 
     84a:	1000           	moveb %d0,%d0
     84c:	0280 0000 00ff 	andil #255,%d0
     852:	7202           	moveq #2,%d1
     854:	c081           	andl %d1,%d0
     856:	4a80           	tstl %d0
     858:	669c           	bnes 0x7f6
     85a:	202e 0008      	movel %fp@(8),%d0
     85e:	2040           	moveal %d0,%a0
     860:	1010           	moveb %a0@,%d0
     862:	0c00 002e      	cmpib #46,%d0
     866:	6614           	bnes 0x87c
     868:	2d7c 3fb9 9999 	movel #1069128089,%fp@(-12)
     86e:	fff4 
     870:	2d7c 9999 999a 	movel #-1717986918,%fp@(-8)
     876:	fff8 
     878:	52ae 0008      	addql #1,%fp@(8)
     87c:	206e fff4      	moveal %fp@(-12),%a0
     880:	226e fff8      	moveal %fp@(-8),%a1
     884:	4280           	clrl %d0
     886:	4281           	clrl %d1
     888:	2f09           	movel %a1,%sp@-
     88a:	2f08           	movel %a0,%sp@-
     88c:	f21f 5400      	fmoved %sp@+,%fp0
     890:	2f01           	movel %d1,%sp@-
     892:	2f00           	movel %d0,%sp@-
     894:	f21f 5480      	fmoved %sp@+,%fp1
     898:	f200 0438      	fcmpx %fp1,%fp0
     89c:	f281 006e      	fbeq 0x90c
     8a0:	6048           	bras 0x8ea
     8a2:	202e 0008      	movel %fp@(8),%d0
     8a6:	2040           	moveal %d0,%a0
     8a8:	1010           	moveb %a0@,%d0
     8aa:	49c0           	extbl %d0
     8ac:	72d0           	moveq #-48,%d1
     8ae:	d081           	addl %d1,%d0
     8b0:	f200 4000      	fmovel %d0,%fp0
     8b4:	f227 7400      	fmoved %fp0,%sp@-
     8b8:	201f           	movel %sp@+,%d0
     8ba:	221f           	movel %sp@+,%d1
     8bc:	2f01           	movel %d1,%sp@-
     8be:	2f00           	movel %d0,%sp@-
     8c0:	f21f 5480      	fmoved %sp@+,%fp1
     8c4:	f22e 54a3 fff4 	fmuld %fp@(-12),%fp1
     8ca:	f227 7480      	fmoved %fp1,%sp@-
     8ce:	201f           	movel %sp@+,%d0
     8d0:	221f           	movel %sp@+,%d1
     8d2:	2f01           	movel %d1,%sp@-
     8d4:	2f00           	movel %d0,%sp@-
     8d6:	f21f 5400      	fmoved %sp@+,%fp0
     8da:	f22e 5422 ffec 	faddd %fp@(-20),%fp0
     8e0:	f22e 7400 ffec 	fmoved %fp0,%fp@(-20)
     8e6:	52ae 0008      	addql #1,%fp@(8)
     8ea:	202e 0008      	movel %fp@(8),%d0
     8ee:	2040           	moveal %d0,%a0
     8f0:	1010           	moveb %a0@,%d0
     8f2:	49c0           	extbl %d0
     8f4:	1030 09b0 0000 	moveb @(00000000,%d0:l),%d0
     8fa:	0000 
     8fc:	1000           	moveb %d0,%d0
     8fe:	0280 0000 00ff 	andil #255,%d0
     904:	7202           	moveq #2,%d1
     906:	c081           	andl %d1,%d0
     908:	4a80           	tstl %d0
     90a:	6696           	bnes 0x8a2
     90c:	4aae fffc      	tstl %fp@(-4)
     910:	670c           	beqs 0x91e
     912:	f22e 541a ffec 	fnegd %fp@(-20),%fp0
     918:	f22e 7400 ffec 	fmoved %fp0,%fp@(-20)
     91e:	42ae fffc      	clrl %fp@(-4)
     922:	202e 0008      	movel %fp@(8),%d0
     926:	2040           	moveal %d0,%a0
     928:	1010           	moveb %a0@,%d0
     92a:	0c00 0065      	cmpib #101,%d0
     92e:	672c           	beqs 0x95c
     930:	202e 0008      	movel %fp@(8),%d0
     934:	2040           	moveal %d0,%a0
     936:	1010           	moveb %a0@,%d0
     938:	0c00 0045      	cmpib #69,%d0
     93c:	671e           	beqs 0x95c
     93e:	202e 0008      	movel %fp@(8),%d0
     942:	2040           	moveal %d0,%a0
     944:	1010           	moveb %a0@,%d0
     946:	0c00 0064      	cmpib #100,%d0
     94a:	6710           	beqs 0x95c
     94c:	202e 0008      	movel %fp@(8),%d0
     950:	2040           	moveal %d0,%a0
     952:	1010           	moveb %a0@,%d0
     954:	0c00 0045      	cmpib #69,%d0
     958:	6600 00d2      	bnew 0xa2c
     95c:	52ae 0008      	addql #1,%fp@(8)
     960:	202e 0008      	movel %fp@(8),%d0
     964:	2040           	moveal %d0,%a0
     966:	1010           	moveb %a0@,%d0
     968:	0c00 002d      	cmpib #45,%d0
     96c:	660a           	bnes 0x978
     96e:	52ae fffc      	addql #1,%fp@(-4)
     972:	53ae 0008      	subql #1,%fp@(8)
     976:	6040           	bras 0x9b8
     978:	202e 0008      	movel %fp@(8),%d0
     97c:	2040           	moveal %d0,%a0
     97e:	1010           	moveb %a0@,%d0
     980:	0c00 002b      	cmpib #43,%d0
     984:	6630           	bnes 0x9b6
     986:	52ae 0008      	addql #1,%fp@(8)
     98a:	602c           	bras 0x9b8
     98c:	202e ffe8      	movel %fp@(-24),%d0
     990:	d080           	addl %d0,%d0
     992:	2200           	movel %d0,%d1
     994:	e589           	lsll #2,%d1
     996:	2400           	movel %d0,%d2
     998:	d481           	addl %d1,%d2
     99a:	2d42 ffe8      	movel %d2,%fp@(-24)
     99e:	202e 0008      	movel %fp@(8),%d0
     9a2:	2040           	moveal %d0,%a0
     9a4:	1010           	moveb %a0@,%d0
     9a6:	49c0           	extbl %d0
     9a8:	72d0           	moveq #-48,%d1
     9aa:	d081           	addl %d1,%d0
     9ac:	d1ae ffe8      	addl %d0,%fp@(-24)
     9b0:	52ae 0008      	addql #1,%fp@(8)
     9b4:	6002           	bras 0x9b8
     9b6:	4e71           	nop
     9b8:	202e 0008      	movel %fp@(8),%d0
     9bc:	2040           	moveal %d0,%a0
     9be:	1010           	moveb %a0@,%d0
     9c0:	49c0           	extbl %d0
     9c2:	1030 09b0 0000 	moveb @(00000000,%d0:l),%d0
     9c8:	0000 
     9ca:	1000           	moveb %d0,%d0
     9cc:	0280 0000 00ff 	andil #255,%d0
     9d2:	7202           	moveq #2,%d1
     9d4:	c081           	andl %d1,%d0
     9d6:	4a80           	tstl %d0
     9d8:	66b2           	bnes 0x98c
     9da:	0cae 0000 03ff 	cmpil #1023,%fp@(-24)
     9e0:	ffe8 
     9e2:	6f08           	bles 0x9ec
     9e4:	2d7c 0000 03ff 	movel #1023,%fp@(-24)
     9ea:	ffe8 
     9ec:	4aae fffc      	tstl %fp@(-4)
     9f0:	6704           	beqs 0x9f6
     9f2:	44ae ffe8      	negl %fp@(-24)
     9f6:	2f2e ffe8      	movel %fp@(-24),%sp@-
     9fa:	42a7           	clrl %sp@-
     9fc:	2f3c 4024 0000 	movel #1076101120,%sp@-
     a02:	4eb9 0000 0000 	jsr 0x0
     a08:	4fef 000c      	lea %sp@(12),%sp
     a0c:	f200 4000      	fmovel %d0,%fp0
     a10:	f227 7400      	fmoved %fp0,%sp@-
     a14:	201f           	movel %sp@+,%d0
     a16:	221f           	movel %sp@+,%d1
     a18:	2f01           	movel %d1,%sp@-
     a1a:	2f00           	movel %d0,%sp@-
     a1c:	f21f 5480      	fmoved %sp@+,%fp1
     a20:	f22e 54a3 ffec 	fmuld %fp@(-20),%fp1
     a26:	f22e 7480 ffec 	fmoved %fp1,%fp@(-20)
     a2c:	4aae 000c      	tstl %fp@(12)
     a30:	670a           	beqs 0xa3c
     a32:	202e 000c      	movel %fp@(12),%d0
     a36:	2040           	moveal %d0,%a0
     a38:	20ae 0008      	movel %fp@(8),%a0@
     a3c:	202e ffec      	movel %fp@(-20),%d0
     a40:	222e fff0      	movel %fp@(-16),%d1
     a44:	2f01           	movel %d1,%sp@-
     a46:	2f00           	movel %d0,%sp@-
     a48:	f21f 5400      	fmoved %sp@+,%fp0
     a4c:	242e ffe4      	movel %fp@(-28),%d2
     a50:	4e5e           	unlk %fp
     a52:	4e75           	rts
     a54:	4e56 0000      	linkw %fp,#0
     a58:	42a7           	clrl %sp@-
     a5a:	2f2e 0008      	movel %fp@(8),%sp@-
     a5e:	4eba fcd0      	jsr %pc@(0x730)
     a62:	508f           	addql #8,%sp
     a64:	f227 7400      	fmoved %fp0,%sp@-
     a68:	201f           	movel %sp@+,%d0
     a6a:	221f           	movel %sp@+,%d1
     a6c:	2f01           	movel %d1,%sp@-
     a6e:	2f00           	movel %d0,%sp@-
     a70:	f21f 5400      	fmoved %sp@+,%fp0
     a74:	4e5e           	unlk %fp
     a76:	4e75           	rts
     a78:	4e56 fff4      	linkw %fp,#-12
     a7c:	42ae fffc      	clrl %fp@(-4)
     a80:	42ae fff8      	clrl %fp@(-8)
     a84:	6004           	bras 0xa8a
     a86:	52ae 0008      	addql #1,%fp@(8)
     a8a:	202e 0008      	movel %fp@(8),%d0
     a8e:	2040           	moveal %d0,%a0
     a90:	1010           	moveb %a0@,%d0
     a92:	49c0           	extbl %d0
     a94:	1030 09b0 0000 	moveb @(00000000,%d0:l),%d0
     a9a:	0000 
     a9c:	1000           	moveb %d0,%d0
     a9e:	0280 0000 00ff 	andil #255,%d0
     aa4:	7201           	moveq #1,%d1
     aa6:	c081           	andl %d1,%d0
     aa8:	1000           	moveb %d0,%d0
     aaa:	4a00           	tstb %d0
     aac:	66d8           	bnes 0xa86
     aae:	202e 0008      	movel %fp@(8),%d0
     ab2:	2040           	moveal %d0,%a0
     ab4:	1010           	moveb %a0@,%d0
     ab6:	0c00 002d      	cmpib #45,%d0
     aba:	660a           	bnes 0xac6
     abc:	52ae fffc      	addql #1,%fp@(-4)
     ac0:	52ae 0008      	addql #1,%fp@(8)
     ac4:	6012           	bras 0xad8
     ac6:	202e 0008      	movel %fp@(8),%d0
     aca:	2040           	moveal %d0,%a0
     acc:	1010           	moveb %a0@,%d0
     ace:	0c00 002b      	cmpib #43,%d0
     ad2:	6604           	bnes 0xad8
     ad4:	52ae 0008      	addql #1,%fp@(8)
     ad8:	202e 0008      	movel %fp@(8),%d0
     adc:	2040           	moveal %d0,%a0
     ade:	1010           	moveb %a0@,%d0
     ae0:	0c00 0030      	cmpib #48,%d0
     ae4:	6600 008c      	bnew 0xb72
     ae8:	7008           	moveq #8,%d0
     aea:	2d40 0010      	movel %d0,%fp@(16)
     aee:	52ae 0008      	addql #1,%fp@(8)
     af2:	202e 0008      	movel %fp@(8),%d0
     af6:	2040           	moveal %d0,%a0
     af8:	1010           	moveb %a0@,%d0
     afa:	0c00 0078      	cmpib #120,%d0
     afe:	670e           	beqs 0xb0e
     b00:	202e 0008      	movel %fp@(8),%d0
     b04:	2040           	moveal %d0,%a0
     b06:	1010           	moveb %a0@,%d0
     b08:	0c00 0058      	cmpib #88,%d0
     b0c:	6668           	bnes 0xb76
     b0e:	7010           	moveq #16,%d0
     b10:	2d40 0010      	movel %d0,%fp@(16)
     b14:	52ae 0008      	addql #1,%fp@(8)
     b18:	605e           	bras 0xb78
     b1a:	202e 0008      	movel %fp@(8),%d0
     b1e:	2040           	moveal %d0,%a0
     b20:	1010           	moveb %a0@,%d0
     b22:	49c0           	extbl %d0
     b24:	52ae 0008      	addql #1,%fp@(8)
     b28:	2f00           	movel %d0,%sp@-
     b2a:	4eb9 0000 0000 	jsr 0x0
     b30:	588f           	addql #4,%sp
     b32:	72d0           	moveq #-48,%d1
     b34:	d081           	addl %d1,%d0
     b36:	2d40 fff4      	movel %d0,%fp@(-12)
     b3a:	7009           	moveq #9,%d0
     b3c:	b0ae fff4      	cmpl %fp@(-12),%d0
     b40:	6404           	bccs 0xb46
     b42:	5fae fff4      	subql #7,%fp@(-12)
     b46:	202e 0010      	movel %fp@(16),%d0
     b4a:	b0ae fff4      	cmpl %fp@(-12),%d0
     b4e:	6206           	bhis 0xb56
     b50:	53ae 0008      	subql #1,%fp@(8)
     b54:	6044           	bras 0xb9a
     b56:	222e fff8      	movel %fp@(-8),%d1
     b5a:	4c2e 1800 0010 	mulsl %fp@(16),%d1
     b60:	2d41 fff8      	movel %d1,%fp@(-8)
     b64:	202e fff8      	movel %fp@(-8),%d0
     b68:	d0ae fff4      	addl %fp@(-12),%d0
     b6c:	2d40 fff8      	movel %d0,%fp@(-8)
     b70:	6006           	bras 0xb78
     b72:	4e71           	nop
     b74:	6002           	bras 0xb78
     b76:	4e71           	nop
     b78:	202e 0008      	movel %fp@(8),%d0
     b7c:	2040           	moveal %d0,%a0
     b7e:	1010           	moveb %a0@,%d0
     b80:	49c0           	extbl %d0
     b82:	1030 09b0 0000 	moveb @(00000000,%d0:l),%d0
     b88:	0000 
     b8a:	1000           	moveb %d0,%d0
     b8c:	0280 0000 00ff 	andil #255,%d0
     b92:	720e           	moveq #14,%d1
     b94:	c081           	andl %d1,%d0
     b96:	4a80           	tstl %d0
     b98:	6680           	bnes 0xb1a
     b9a:	4aae fffc      	tstl %fp@(-4)
     b9e:	6704           	beqs 0xba4
     ba0:	44ae fff8      	negl %fp@(-8)
     ba4:	4aae 000c      	tstl %fp@(12)
     ba8:	670a           	beqs 0xbb4
     baa:	202e 000c      	movel %fp@(12),%d0
     bae:	2040           	moveal %d0,%a0
     bb0:	20ae 0008      	movel %fp@(8),%a0@
     bb4:	202e fff8      	movel %fp@(-8),%d0
     bb8:	4e5e           	unlk %fp
     bba:	4e75           	rts
     bbc:	4e56 0000      	linkw %fp,#0
     bc0:	4878 000a      	pea 0xa
     bc4:	42a7           	clrl %sp@-
     bc6:	2f2e 0008      	movel %fp@(8),%sp@-
     bca:	4eba feac      	jsr %pc@(0xa78)
     bce:	4fef 000c      	lea %sp@(12),%sp
     bd2:	4e5e           	unlk %fp
     bd4:	4e75           	rts
     bd6:	4e71           	nop
     bd8:	4e56 fff0      	linkw %fp,#-16
     bdc:	42ae fffc      	clrl %fp@(-4)
     be0:	2d6e 0010 fff8 	movel %fp@(16),%fp@(-8)
     be6:	6002           	bras 0xbea
     be8:	4e71           	nop
     bea:	202e fff8      	movel %fp@(-8),%d0
     bee:	d0ae fffc      	addl %fp@(-4),%d0
     bf2:	e288           	lsrl #1,%d0
     bf4:	2d40 fff4      	movel %d0,%fp@(-12)
     bf8:	202e fff4      	movel %fp@(-12),%d0
     bfc:	4c2e 0800 0014 	mulsl %fp@(20),%d0
     c02:	d0ae 000c      	addl %fp@(12),%d0
     c06:	2f00           	movel %d0,%sp@-
     c08:	2f2e 0008      	movel %fp@(8),%sp@-
     c0c:	202e 0018      	movel %fp@(24),%d0
     c10:	2040           	moveal %d0,%a0
     c12:	4e90           	jsr %a0@
     c14:	508f           	addql #8,%sp
     c16:	2d40 fff0      	movel %d0,%fp@(-16)
     c1a:	4aae fff0      	tstl %fp@(-16)
     c1e:	6610           	bnes 0xc30
     c20:	202e fff4      	movel %fp@(-12),%d0
     c24:	4c2e 0800 0014 	mulsl %fp@(20),%d0
     c2a:	d0ae 000c      	addl %fp@(12),%d0
     c2e:	6026           	bras 0xc56
     c30:	4aae fff0      	tstl %fp@(-16)
     c34:	6c08           	bges 0xc3e
     c36:	2d6e fff4 fff8 	movel %fp@(-12),%fp@(-8)
     c3c:	6006           	bras 0xc44
     c3e:	2d6e fff4 fffc 	movel %fp@(-12),%fp@(-4)
     c44:	202e fff8      	movel %fp@(-8),%d0
     c48:	d0ae fffc      	addl %fp@(-4),%d0
     c4c:	e288           	lsrl #1,%d0
     c4e:	b0ae fff4      	cmpl %fp@(-12),%d0
     c52:	6694           	bnes 0xbe8
     c54:	4280           	clrl %d0
     c56:	2200           	movel %d0,%d1
     c58:	2041           	moveal %d1,%a0
     c5a:	4e5e           	unlk %fp
     c5c:	4e75           	rts
     c5e:	4e71           	nop
     c60:	4e56 fff8      	linkw %fp,#-8
     c64:	202e 0008      	movel %fp@(8),%d0
     c68:	4c2e 0800 000c 	mulsl %fp@(12),%d0
     c6e:	2d40 fffc      	movel %d0,%fp@(-4)
     c72:	2f2e fffc      	movel %fp@(-4),%sp@-
     c76:	4eb9 0000 0000 	jsr 0x0
     c7c:	588f           	addql #4,%sp
     c7e:	2d48 fff8      	movel %a0,%fp@(-8)
     c82:	4aae fff8      	tstl %fp@(-8)
     c86:	6714           	beqs 0xc9c
     c88:	2f2e fffc      	movel %fp@(-4),%sp@-
     c8c:	42a7           	clrl %sp@-
     c8e:	2f2e fff8      	movel %fp@(-8),%sp@-
     c92:	4eb9 0000 0000 	jsr 0x0
     c98:	4fef 000c      	lea %sp@(12),%sp
     c9c:	202e fff8      	movel %fp@(-8),%d0
     ca0:	2200           	movel %d0,%d1
     ca2:	2041           	moveal %d1,%a0
     ca4:	4e5e           	unlk %fp
     ca6:	4e75           	rts
     ca8:	4e56 0000      	linkw %fp,#0
     cac:	202e 0008      	movel %fp@(8),%d0
     cb0:	2040           	moveal %d0,%a0
     cb2:	3028 001a      	movew %a0@(26),%d0
     cb6:	0c40 444c      	cmpiw #17484,%d0
     cba:	6618           	bnes 0xcd4
     cbc:	202e 0008      	movel %fp@(8),%d0
     cc0:	2040           	moveal %d0,%a0
     cc2:	2028 0004      	movel %a0@(4),%d0
     cc6:	72cf           	moveq #-49,%d1
     cc8:	c280           	andl %d0,%d1
     cca:	202e 0008      	movel %fp@(8),%d0
     cce:	2040           	moveal %d0,%a0
     cd0:	2141 0004      	movel %d1,%a0@(4)
     cd4:	4e5e           	unlk %fp
     cd6:	4e75           	rts
     cd8:	4e56 0000      	linkw %fp,#0
     cdc:	4eb9 0000 0000 	jsr 0x0
     ce2:	4e5e           	unlk %fp
     ce4:	4e75           	rts
     ce6:	4e71           	nop
     ce8:	4e56 ffd8      	linkw %fp,#-40
     cec:	2f2e 0008      	movel %fp@(8),%sp@-
     cf0:	4eb9 0000 0000 	jsr 0x0
     cf6:	588f           	addql #4,%sp
     cf8:	2d48 fffc      	movel %a0,%fp@(-4)
     cfc:	202e fffc      	movel %fp@(-4),%d0
     d00:	2200           	movel %d0,%d1
     d02:	70d8           	moveq #-40,%d0
     d04:	d08e           	addl %fp,%d0
     d06:	2040           	moveal %d0,%a0
     d08:	2241           	moveal %d1,%a1
     d0a:	2091           	movel %a1@,%a0@
     d0c:	5880           	addql #4,%d0
     d0e:	5881           	addql #4,%d1
     d10:	2040           	moveal %d0,%a0
     d12:	2241           	moveal %d1,%a1
     d14:	2091           	movel %a1@,%a0@
     d16:	5880           	addql #4,%d0
     d18:	5881           	addql #4,%d1
     d1a:	2040           	moveal %d0,%a0
     d1c:	2241           	moveal %d1,%a1
     d1e:	2091           	movel %a1@,%a0@
     d20:	5880           	addql #4,%d0
     d22:	5881           	addql #4,%d1
     d24:	2040           	moveal %d0,%a0
     d26:	2241           	moveal %d1,%a1
     d28:	2091           	movel %a1@,%a0@
     d2a:	5880           	addql #4,%d0
     d2c:	5881           	addql #4,%d1
     d2e:	2040           	moveal %d0,%a0
     d30:	2241           	moveal %d1,%a1
     d32:	2091           	movel %a1@,%a0@
     d34:	5880           	addql #4,%d0
     d36:	5881           	addql #4,%d1
     d38:	2040           	moveal %d0,%a0
     d3a:	2241           	moveal %d1,%a1
     d3c:	2091           	movel %a1@,%a0@
     d3e:	5880           	addql #4,%d0
     d40:	5881           	addql #4,%d1
     d42:	2040           	moveal %d0,%a0
     d44:	2241           	moveal %d1,%a1
     d46:	2091           	movel %a1@,%a0@
     d48:	5880           	addql #4,%d0
     d4a:	5881           	addql #4,%d1
     d4c:	2040           	moveal %d0,%a0
     d4e:	2241           	moveal %d1,%a1
     d50:	2091           	movel %a1@,%a0@
     d52:	5880           	addql #4,%d0
     d54:	5881           	addql #4,%d1
     d56:	2040           	moveal %d0,%a0
     d58:	2241           	moveal %d1,%a1
     d5a:	2091           	movel %a1@,%a0@
     d5c:	5880           	addql #4,%d0
     d5e:	5881           	addql #4,%d1
     d60:	70d8           	moveq #-40,%d0
     d62:	d08e           	addl %fp,%d0
     d64:	2f00           	movel %d0,%sp@-
     d66:	4eb9 0000 0000 	jsr 0x0
     d6c:	588f           	addql #4,%sp
     d6e:	2008           	movel %a0,%d0
     d70:	2200           	movel %d0,%d1
     d72:	2041           	moveal %d1,%a0
     d74:	4e5e           	unlk %fp
     d76:	4e75           	rts
     d78:	4e56 0000      	linkw %fp,#0
     d7c:	202e 0008      	movel %fp@(8),%d0
     d80:	0680 0000 0000 	addil #0,%d0
     d86:	2040           	moveal %d0,%a0
     d88:	1010           	moveb %a0@,%d0
     d8a:	1000           	moveb %d0,%d0
     d8c:	0280 0000 00ff 	andil #255,%d0
     d92:	7204           	moveq #4,%d1
     d94:	c081           	andl %d1,%d0
     d96:	4a80           	tstl %d0
     d98:	6706           	beqs 0xda0
     d9a:	7020           	moveq #32,%d0
     d9c:	d1ae 0008      	addl %d0,%fp@(8)
     da0:	202e 0008      	movel %fp@(8),%d0
     da4:	4e5e           	unlk %fp
     da6:	4e75           	rts
     da8:	4e56 0000      	linkw %fp,#0
     dac:	202e 0008      	movel %fp@(8),%d0
     db0:	0680 0000 0000 	addil #0,%d0
     db6:	2040           	moveal %d0,%a0
     db8:	1010           	moveb %a0@,%d0
     dba:	1000           	moveb %d0,%d0
     dbc:	0280 0000 00ff 	andil #255,%d0
     dc2:	7208           	moveq #8,%d1
     dc4:	c081           	andl %d1,%d0
     dc6:	4a80           	tstl %d0
     dc8:	6706           	beqs 0xdd0
     dca:	70e0           	moveq #-32,%d0
     dcc:	d1ae 0008      	addl %d0,%fp@(8)
     dd0:	202e 0008      	movel %fp@(8),%d0
     dd4:	4e5e           	unlk %fp
     dd6:	4e75           	rts
     dd8:	4e56 0000      	linkw %fp,#0
     ddc:	202e 0008      	movel %fp@(8),%d0
     de0:	90ae 000c      	subl %fp@(12),%d0
     de4:	f200 4000      	fmovel %d0,%fp0
     de8:	f227 7400      	fmoved %fp0,%sp@-
     dec:	201f           	movel %sp@+,%d0
     dee:	221f           	movel %sp@+,%d1
     df0:	2f01           	movel %d1,%sp@-
     df2:	2f00           	movel %d0,%sp@-
     df4:	f21f 5400      	fmoved %sp@+,%fp0
     df8:	4e5e           	unlk %fp
     dfa:	4e75           	rts
     dfc:	4e56 fbf8      	linkw %fp,#-1032
     e00:	2f02           	movel %d2,%sp@-
     e02:	42a7           	clrl %sp@-
     e04:	42a7           	clrl %sp@-
     e06:	4eb9 0000 0000 	jsr 0x0
     e0c:	508f           	addql #8,%sp
     e0e:	2d40 fff8      	movel %d0,%fp@(-8)
     e12:	4aae fff8      	tstl %fp@(-8)
     e16:	6700 00bc      	beqw 0xed4
     e1a:	202e fff8      	movel %fp@(-8),%d0
     e1e:	5280           	addql #1,%d0
     e20:	e588           	lsll #2,%d0
     e22:	2f00           	movel %d0,%sp@-
     e24:	4eb9 0000 0000 	jsr 0x0
     e2a:	588f           	addql #4,%sp
     e2c:	2008           	movel %a0,%d0
     e2e:	23c0 0000 0000 	movel %d0,0x0
     e34:	7001           	moveq #1,%d0
     e36:	2d40 fffc      	movel %d0,%fp@(-4)
     e3a:	6078           	bras 0xeb4
     e3c:	2f2e fffc      	movel %fp@(-4),%sp@-
     e40:	200e           	movel %fp,%d0
     e42:	0680 ffff fbf8 	addil #-1032,%d0
     e48:	2f00           	movel %d0,%sp@-
     e4a:	4eb9 0000 0000 	jsr 0x0
     e50:	508f           	addql #8,%sp
     e52:	2239 0000 0000 	movel 0x0,%d1
     e58:	202e fffc      	movel %fp@(-4),%d0
     e5c:	5380           	subql #1,%d0
     e5e:	e588           	lsll #2,%d0
     e60:	2401           	movel %d1,%d2
     e62:	d480           	addl %d0,%d2
     e64:	200e           	movel %fp,%d0
     e66:	0680 ffff fbf8 	addil #-1032,%d0
     e6c:	2f00           	movel %d0,%sp@-
     e6e:	4eb9 0000 0000 	jsr 0x0
     e74:	588f           	addql #4,%sp
     e76:	5280           	addql #1,%d0
     e78:	2f00           	movel %d0,%sp@-
     e7a:	4eb9 0000 0000 	jsr 0x0
     e80:	588f           	addql #4,%sp
     e82:	2008           	movel %a0,%d0
     e84:	2042           	moveal %d2,%a0
     e86:	2080           	movel %d0,%a0@
     e88:	2239 0000 0000 	movel 0x0,%d1
     e8e:	202e fffc      	movel %fp@(-4),%d0
     e92:	5380           	subql #1,%d0
     e94:	e588           	lsll #2,%d0
     e96:	d081           	addl %d1,%d0
     e98:	2040           	moveal %d0,%a0
     e9a:	2210           	movel %a0@,%d1
     e9c:	200e           	movel %fp,%d0
     e9e:	0680 ffff fbf8 	addil #-1032,%d0
     ea4:	2f00           	movel %d0,%sp@-
     ea6:	2f01           	movel %d1,%sp@-
     ea8:	4eb9 0000 0000 	jsr 0x0
     eae:	508f           	addql #8,%sp
     eb0:	52ae fffc      	addql #1,%fp@(-4)
     eb4:	202e fffc      	movel %fp@(-4),%d0
     eb8:	b0ae fff8      	cmpl %fp@(-8),%d0
     ebc:	6f00 ff7e      	blew 0xe3c
     ec0:	2239 0000 0000 	movel 0x0,%d1
     ec6:	202e fff8      	movel %fp@(-8),%d0
     eca:	e588           	lsll #2,%d0
     ecc:	d081           	addl %d1,%d0
     ece:	2040           	moveal %d0,%a0
     ed0:	4290           	clrl %a0@
     ed2:	601e           	bras 0xef2
     ed4:	4878 0004      	pea 0x4
     ed8:	4eb9 0000 0000 	jsr 0x0
     ede:	588f           	addql #4,%sp
     ee0:	2008           	movel %a0,%d0
     ee2:	23c0 0000 0000 	movel %d0,0x0
     ee8:	2039 0000 0000 	movel 0x0,%d0
     eee:	2040           	moveal %d0,%a0
     ef0:	4290           	clrl %a0@
     ef2:	242e fbf4      	movel %fp@(-1036),%d2
     ef6:	4e5e           	unlk %fp
     ef8:	4e75           	rts
     efa:	4e71           	nop
     efc:	202f 0004      	movel %sp@(4),%d0
     f00:	41fb 0170 0000 	lea %pc@(0xf02),%a0
     f06:	0000 
     f08:	2e88           	movel %a0,%sp@
     f0a:	4e75           	rts
	...
    1008:	0000 004e      	orib #78,%d0
    100c:	4e56 0000      	linkw %fp,#0
    1010:	4eb9 0000 0000 	jsr 0x0
    1016:	4eb9 0000 0000 	jsr 0x0
    101c:	4e5e           	unlk %fp
    101e:	4e75           	rts
    1020:	4e56 fffc      	linkw %fp,#-4
    1024:	2039 0000 0000 	movel 0x0,%d0
    102a:	4a80           	tstl %d0
    102c:	662e           	bnes 0x105c
    102e:	2039 0000 0000 	movel 0x0,%d0
    1034:	2200           	movel %d0,%d1
    1036:	5381           	subql #1,%d1
    1038:	2d41 fffc      	movel %d1,%fp@(-4)
    103c:	6018           	bras 0x1056
    103e:	202e fffc      	movel %fp@(-4),%d0
    1042:	2030 0db0 0000 	movel @(00000000,%d0:l:4),%d0
    1048:	0000 
    104a:	2f00           	movel %d0,%sp@-
    104c:	4eba 018a      	jsr %pc@(0x11d8)
    1050:	588f           	addql #4,%sp
    1052:	53ae fffc      	subql #1,%fp@(-4)
    1056:	4aae fffc      	tstl %fp@(-4)
    105a:	6ce2           	bges 0x103e
    105c:	4e5e           	unlk %fp
    105e:	4e75           	rts
    1060:	4e56 fff0      	linkw %fp,#-16
    1064:	202e 0008      	movel %fp@(8),%d0
    1068:	2040           	moveal %d0,%a0
    106a:	3028 001a      	movew %a0@(26),%d0
    106e:	0c40 444c      	cmpiw #17484,%d0
    1072:	6600 015e      	bnew 0x11d2
    1076:	2039 0000 0000 	movel 0x0,%d0
    107c:	4a80           	tstl %d0
    107e:	6700 0152      	beqw 0x11d2
    1082:	202e 0008      	movel %fp@(8),%d0
    1086:	2040           	moveal %d0,%a0
    1088:	2028 0016      	movel %a0@(22),%d0
    108c:	2d40 fff0      	movel %d0,%fp@(-16)
    1090:	202e 0008      	movel %fp@(8),%d0
    1094:	2040           	moveal %d0,%a0
    1096:	2028 0004      	movel %a0@(4),%d0
    109a:	0280 0000 0100 	andil #256,%d0
    10a0:	4a80           	tstl %d0
    10a2:	670c           	beqs 0x10b0
    10a4:	2f2e 0008      	movel %fp@(8),%sp@-
    10a8:	4eb9 0000 0000 	jsr 0x0
    10ae:	588f           	addql #4,%sp
    10b0:	202e 0008      	movel %fp@(8),%d0
    10b4:	2040           	moveal %d0,%a0
    10b6:	317c ffff 001a 	movew #-1,%a0@(26)
    10bc:	2039 0000 0000 	movel 0x0,%d0
    10c2:	7201           	moveq #1,%d1
    10c4:	b280           	cmpl %d0,%d1
    10c6:	6c7c           	bges 0x1144
    10c8:	42ae fff8      	clrl %fp@(-8)
    10cc:	605c           	bras 0x112a
    10ce:	202e fff8      	movel %fp@(-8),%d0
    10d2:	2030 0db0 0000 	movel @(00000000,%d0:l:4),%d0
    10d8:	0000 
    10da:	b0ae 0008      	cmpl %fp@(8),%d0
    10de:	6646           	bnes 0x1126
    10e0:	202e fff8      	movel %fp@(-8),%d0
    10e4:	2d70 0db0 0000 	movel @(00000000,%d0:l:4),%fp@(-12)
    10ea:	0000 fff4 
    10ee:	2039 0000 0000 	movel 0x0,%d0
    10f4:	5380           	subql #1,%d0
    10f6:	2230 0db0 0000 	movel @(00000000,%d0:l:4),%d1
    10fc:	0000 
    10fe:	202e fff8      	movel %fp@(-8),%d0
    1102:	2181 0db0 0000 	movel %d1,@(00000000,%d0:l:4)
    1108:	0000 
    110a:	2039 0000 0000 	movel 0x0,%d0
    1110:	5380           	subql #1,%d0
    1112:	2230 0db0 0000 	movel @(00000000,%d0:l:4),%d1
    1118:	0000 
    111a:	202e fff8      	movel %fp@(-8),%d0
    111e:	2181 0db0 0000 	movel %d1,@(00000000,%d0:l:4)
    1124:	0000 
    1126:	52ae fff8      	addql #1,%fp@(-8)
    112a:	2039 0000 0000 	movel 0x0,%d0
    1130:	b0ae fff8      	cmpl %fp@(-8),%d0
    1134:	6e98           	bgts 0x10ce
    1136:	2039 0000 0000 	movel 0x0,%d0
    113c:	5380           	subql #1,%d0
    113e:	23c0 0000 0000 	movel %d0,0x0
    1144:	202e 0008      	movel %fp@(8),%d0
    1148:	2040           	moveal %d0,%a0
    114a:	1028 0008      	moveb %a0@(8),%d0
    114e:	49c0           	extbl %d0
    1150:	2f00           	movel %d0,%sp@-
    1152:	4eb9 0000 0000 	jsr 0x0
    1158:	588f           	addql #4,%sp
    115a:	2d40 fffc      	movel %d0,%fp@(-4)
    115e:	4aae fff0      	tstl %fp@(-16)
    1162:	6716           	beqs 0x117a
    1164:	4aae fff4      	tstl %fp@(-12)
    1168:	6710           	beqs 0x117a
    116a:	2f2e fff4      	movel %fp@(-12),%sp@-
    116e:	4eb9 0000 0000 	jsr 0x0
    1174:	588f           	addql #4,%sp
    1176:	c1ae fffc      	andl %d0,%fp@(-4)
    117a:	4aae fff4      	tstl %fp@(-12)
    117e:	670c           	beqs 0x118c
    1180:	2f2e fff4      	movel %fp@(-12),%sp@-
    1184:	4eb9 0000 0000 	jsr 0x0
    118a:	588f           	addql #4,%sp
    118c:	202e 0008      	movel %fp@(8),%d0
    1190:	2040           	moveal %d0,%a0
    1192:	2028 0004      	movel %a0@(4),%d0
    1196:	7204           	moveq #4,%d1
    1198:	c081           	andl %d1,%d0
    119a:	4a80           	tstl %d0
    119c:	6714           	beqs 0x11b2
    119e:	202e 0008      	movel %fp@(8),%d0
    11a2:	2040           	moveal %d0,%a0
    11a4:	2028 000e      	movel %a0@(14),%d0
    11a8:	2f00           	movel %d0,%sp@-
    11aa:	4eb9 0000 0000 	jsr 0x0
    11b0:	588f           	addql #4,%sp
    11b2:	4aae 000c      	tstl %fp@(12)
    11b6:	670c           	beqs 0x11c4
    11b8:	2f2e 0008      	movel %fp@(8),%sp@-
    11bc:	4eb9 0000 0000 	jsr 0x0
    11c2:	588f           	addql #4,%sp
    11c4:	4aae fffc      	tstl %fp@(-4)
    11c8:	6604           	bnes 0x11ce
    11ca:	4280           	clrl %d0
    11cc:	6006           	bras 0x11d4
    11ce:	70ff           	moveq #-1,%d0
    11d0:	6002           	bras 0x11d4
    11d2:	70ff           	moveq #-1,%d0
    11d4:	4e5e           	unlk %fp
    11d6:	4e75           	rts
    11d8:	4e56 0000      	linkw %fp,#0
    11dc:	4878 0001      	pea 0x1
    11e0:	2f2e 0008      	movel %fp@(8),%sp@-
    11e4:	4eba fe7a      	jsr %pc@(0x1060)
    11e8:	508f           	addql #8,%sp
    11ea:	4e5e           	unlk %fp
    11ec:	4e75           	rts
    11ee:	4e71           	nop
    11f0:	4e56 fff8      	linkw %fp,#-8
    11f4:	2f02           	movel %d2,%sp@-
    11f6:	2d7c 0000 0000 	movel #0,%fp@(-8)
    11fc:	fff8 
    11fe:	42ae fffc      	clrl %fp@(-4)
    1202:	202e 0008      	movel %fp@(8),%d0
    1206:	2040           	moveal %d0,%a0
    1208:	3028 001a      	movew %a0@(26),%d0
    120c:	0c40 444c      	cmpiw #17484,%d0
    1210:	6600 0162      	bnew 0x1374
    1214:	202e 0008      	movel %fp@(8),%d0
    1218:	2240           	moveal %d0,%a1
    121a:	2029 000e      	movel %a1@(14),%d0
    121e:	4a80           	tstl %d0
    1220:	6700 00c0      	beqw 0x12e2
    1224:	202e 0008      	movel %fp@(8),%d0
    1228:	2040           	moveal %d0,%a0
    122a:	2028 0004      	movel %a0@(4),%d0
    122e:	0280 0000 0100 	andil #256,%d0
    1234:	4a80           	tstl %d0
    1236:	6768           	beqs 0x12a0
    1238:	202e 0008      	movel %fp@(8),%d0
    123c:	2240           	moveal %d0,%a1
    123e:	2011           	movel %a1@,%d0
    1240:	2040           	moveal %d0,%a0
    1242:	202e 0008      	movel %fp@(8),%d0
    1246:	2240           	moveal %d0,%a1
    1248:	2229 000e      	movel %a1@(14),%d1
    124c:	202e 0008      	movel %fp@(8),%d0
    1250:	2240           	moveal %d0,%a1
    1252:	1029 0008      	moveb %a1@(8),%d0
    1256:	49c0           	extbl %d0
    1258:	2f08           	movel %a0,%sp@-
    125a:	2f01           	movel %d1,%sp@-
    125c:	2f00           	movel %d0,%sp@-
    125e:	4eb9 0000 0000 	jsr 0x0
    1264:	4fef 000c      	lea %sp@(12),%sp
    1268:	2d40 fffc      	movel %d0,%fp@(-4)
    126c:	4aae fffc      	tstl %fp@(-4)
    1270:	6620           	bnes 0x1292
    1272:	202e 0008      	movel %fp@(8),%d0
    1276:	2040           	moveal %d0,%a0
    1278:	2028 0004      	movel %a0@(4),%d0
    127c:	7210           	moveq #16,%d1
    127e:	8280           	orl %d0,%d1
    1280:	202e 0008      	movel %fp@(8),%d0
    1284:	2240           	moveal %d0,%a1
    1286:	2341 0004      	movel %d1,%a1@(4)
    128a:	70ff           	moveq #-1,%d0
    128c:	2d40 fffc      	movel %d0,%fp@(-4)
    1290:	6004           	bras 0x1296
    1292:	42ae fffc      	clrl %fp@(-4)
    1296:	202e 0008      	movel %fp@(8),%d0
    129a:	2040           	moveal %d0,%a0
    129c:	4290           	clrl %a0@
    129e:	6042           	bras 0x12e2
    12a0:	202e 0008      	movel %fp@(8),%d0
    12a4:	2240           	moveal %d0,%a1
    12a6:	2029 0004      	movel %a1@(4),%d0
    12aa:	7201           	moveq #1,%d1
    12ac:	c081           	andl %d1,%d0
    12ae:	1000           	moveb %d0,%d0
    12b0:	4a00           	tstb %d0
    12b2:	672e           	beqs 0x12e2
    12b4:	202e 0008      	movel %fp@(8),%d0
    12b8:	2040           	moveal %d0,%a0
    12ba:	2028 000a      	movel %a0@(10),%d0
    12be:	2200           	movel %d0,%d1
    12c0:	202e 0008      	movel %fp@(8),%d0
    12c4:	2240           	moveal %d0,%a1
    12c6:	2029 000e      	movel %a1@(14),%d0
    12ca:	2f01           	movel %d1,%sp@-
    12cc:	42a7           	clrl %sp@-
    12ce:	2f00           	movel %d0,%sp@-
    12d0:	4eb9 0000 0000 	jsr 0x0
    12d6:	4fef 000c      	lea %sp@(12),%sp
    12da:	202e 0008      	movel %fp@(8),%d0
    12de:	2040           	moveal %d0,%a0
    12e0:	4290           	clrl %a0@
    12e2:	202e 0008      	movel %fp@(8),%d0
    12e6:	2240           	moveal %d0,%a1
    12e8:	4229 0009      	clrb %a1@(9)
    12ec:	202e 0008      	movel %fp@(8),%d0
    12f0:	2040           	moveal %d0,%a0
    12f2:	2228 000e      	movel %a0@(14),%d1
    12f6:	202e 0008      	movel %fp@(8),%d0
    12fa:	2240           	moveal %d0,%a1
    12fc:	2341 0012      	movel %d1,%a1@(18)
    1300:	202e 0008      	movel %fp@(8),%d0
    1304:	2040           	moveal %d0,%a0
    1306:	2028 0004      	movel %a0@(4),%d0
    130a:	727f           	moveq #127,%d1
    130c:	4601           	notb %d1
    130e:	c081           	andl %d1,%d0
    1310:	4a80           	tstl %d0
    1312:	6740           	beqs 0x1354
    1314:	202e 0008      	movel %fp@(8),%d0
    1318:	2040           	moveal %d0,%a0
    131a:	1028 0008      	moveb %a0@(8),%d0
    131e:	49c0           	extbl %d0
    1320:	2f00           	movel %d0,%sp@-
    1322:	4eb9 0000 0000 	jsr 0x0
    1328:	588f           	addql #4,%sp
    132a:	222e 0008      	movel %fp@(8),%d1
    132e:	2241           	moveal %d1,%a1
    1330:	2211           	movel %a1@,%d1
    1332:	2400           	movel %d0,%d2
    1334:	9481           	subl %d1,%d2
    1336:	2202           	movel %d2,%d1
    1338:	202e 0008      	movel %fp@(8),%d0
    133c:	2040           	moveal %d0,%a0
    133e:	1028 0008      	moveb %a0@(8),%d0
    1342:	49c0           	extbl %d0
    1344:	42a7           	clrl %sp@-
    1346:	2f01           	movel %d1,%sp@-
    1348:	2f00           	movel %d0,%sp@-
    134a:	4eb9 0000 0000 	jsr 0x0
    1350:	4fef 000c      	lea %sp@(12),%sp
    1354:	202e 0008      	movel %fp@(8),%d0
    1358:	2240           	moveal %d0,%a1
    135a:	2029 0004      	movel %a1@(4),%d0
    135e:	2200           	movel %d0,%d1
    1360:	0241 fe7f      	andiw #-385,%d1
    1364:	202e 0008      	movel %fp@(8),%d0
    1368:	2040           	moveal %d0,%a0
    136a:	2141 0004      	movel %d1,%a0@(4)
    136e:	202e fffc      	movel %fp@(-4),%d0
    1372:	6002           	bras 0x1376
    1374:	70ff           	moveq #-1,%d0
    1376:	242e fff4      	movel %fp@(-12),%d2
    137a:	4e5e           	unlk %fp
    137c:	4e75           	rts
    137e:	4e56 fff4      	linkw %fp,#-12
    1382:	4aae 0008      	tstl %fp@(8)
    1386:	6714           	beqs 0x139c
    1388:	2f2e 0008      	movel %fp@(8),%sp@-
    138c:	4eba fe62      	jsr %pc@(0x11f0)
    1390:	588f           	addql #4,%sp
    1392:	2d40 fff4      	movel %d0,%fp@(-12)
    1396:	202e fff4      	movel %fp@(-12),%d0
    139a:	6032           	bras 0x13ce
    139c:	42ae fff8      	clrl %fp@(-8)
    13a0:	601c           	bras 0x13be
    13a2:	202e fff8      	movel %fp@(-8),%d0
    13a6:	2030 0db0 0000 	movel @(00000000,%d0:l:4),%d0
    13ac:	0000 
    13ae:	2f00           	movel %d0,%sp@-
    13b0:	4eba fe3e      	jsr %pc@(0x11f0)
    13b4:	588f           	addql #4,%sp
    13b6:	81ae fffc      	orl %d0,%fp@(-4)
    13ba:	52ae fff8      	addql #1,%fp@(-8)
    13be:	2039 0000 0000 	movel 0x0,%d0
    13c4:	b0ae fff8      	cmpl %fp@(-8),%d0
    13c8:	6ed8           	bgts 0x13a2
    13ca:	202e fffc      	movel %fp@(-4),%d0
    13ce:	4e5e           	unlk %fp
    13d0:	4e75           	rts
    13d2:	4e71           	nop
    13d4:	4e56 fffc      	linkw %fp,#-4
    13d8:	202e 0008      	movel %fp@(8),%d0
    13dc:	2040           	moveal %d0,%a0
    13de:	3028 001a      	movew %a0@(26),%d0
    13e2:	0c40 444c      	cmpiw #17484,%d0
    13e6:	6704           	beqs 0x13ec
    13e8:	70ff           	moveq #-1,%d0
    13ea:	6042           	bras 0x142e
    13ec:	202e 0008      	movel %fp@(8),%d0
    13f0:	2040           	moveal %d0,%a0
    13f2:	2028 0004      	movel %a0@(4),%d0
    13f6:	7201           	moveq #1,%d1
    13f8:	c081           	andl %d1,%d0
    13fa:	4a80           	tstl %d0
    13fc:	661c           	bnes 0x141a
    13fe:	202e 0008      	movel %fp@(8),%d0
    1402:	2040           	moveal %d0,%a0
    1404:	2028 0004      	movel %a0@(4),%d0
    1408:	7210           	moveq #16,%d1
    140a:	8280           	orl %d0,%d1
    140c:	202e 0008      	movel %fp@(8),%d0
    1410:	2040           	moveal %d0,%a0
    1412:	2141 0004      	movel %d1,%a0@(4)
    1416:	70ff           	moveq #-1,%d0
    1418:	6014           	bras 0x142e
    141a:	2f2e 0008      	movel %fp@(8),%sp@-
    141e:	4eb9 0000 0000 	jsr 0x0
    1424:	588f           	addql #4,%sp
    1426:	2d40 fffc      	movel %d0,%fp@(-4)
    142a:	202e fffc      	movel %fp@(-4),%d0
    142e:	4e5e           	unlk %fp
    1430:	4e75           	rts
    1432:	4e56 0000      	linkw %fp,#0
    1436:	2f2e 0008      	movel %fp@(8),%sp@-
    143a:	4eba ff98      	jsr %pc@(0x13d4)
    143e:	588f           	addql #4,%sp
    1440:	4e5e           	unlk %fp
    1442:	4e75           	rts
    1444:	4e56 0000      	linkw %fp,#0
    1448:	203c 0000 0000 	movel #0,%d0
    144e:	2040           	moveal %d0,%a0
    1450:	2010           	movel %a0@,%d0
    1452:	2f00           	movel %d0,%sp@-
    1454:	4eba ff7e      	jsr %pc@(0x13d4)
    1458:	588f           	addql #4,%sp
    145a:	4e5e           	unlk %fp
    145c:	4e75           	rts
    145e:	4e71           	nop
    1460:	4e56 0000      	linkw %fp,#0
    1464:	2f02           	movel %d2,%sp@-
    1466:	202e 0008      	movel %fp@(8),%d0
    146a:	2040           	moveal %d0,%a0
    146c:	3028 001a      	movew %a0@(26),%d0
    1470:	0c40 444c      	cmpiw #17484,%d0
    1474:	6600 00b0      	bnew 0x1526
    1478:	202e 0008      	movel %fp@(8),%d0
    147c:	2040           	moveal %d0,%a0
    147e:	1028 0008      	moveb %a0@(8),%d0
    1482:	49c0           	extbl %d0
    1484:	2f00           	movel %d0,%sp@-
    1486:	4eb9 0000 0000 	jsr 0x0
    148c:	588f           	addql #4,%sp
    148e:	2200           	movel %d0,%d1
    1490:	202e 000c      	movel %fp@(12),%d0
    1494:	2040           	moveal %d0,%a0
    1496:	2081           	movel %d1,%a0@
    1498:	202e 000c      	movel %fp@(12),%d0
    149c:	2040           	moveal %d0,%a0
    149e:	2010           	movel %a0@,%d0
    14a0:	4a80           	tstl %d0
    14a2:	6c1c           	bges 0x14c0
    14a4:	202e 0008      	movel %fp@(8),%d0
    14a8:	2040           	moveal %d0,%a0
    14aa:	2028 0004      	movel %a0@(4),%d0
    14ae:	7210           	moveq #16,%d1
    14b0:	8280           	orl %d0,%d1
    14b2:	202e 0008      	movel %fp@(8),%d0
    14b6:	2040           	moveal %d0,%a0
    14b8:	2141 0004      	movel %d1,%a0@(4)
    14bc:	70ff           	moveq #-1,%d0
    14be:	6068           	bras 0x1528
    14c0:	202e 0008      	movel %fp@(8),%d0
    14c4:	2040           	moveal %d0,%a0
    14c6:	2028 0004      	movel %a0@(4),%d0
    14ca:	727f           	moveq #127,%d1
    14cc:	4601           	notb %d1
    14ce:	c081           	andl %d1,%d0
    14d0:	4a80           	tstl %d0
    14d2:	6720           	beqs 0x14f4
    14d4:	202e 000c      	movel %fp@(12),%d0
    14d8:	2040           	moveal %d0,%a0
    14da:	2010           	movel %a0@,%d0
    14dc:	222e 0008      	movel %fp@(8),%d1
    14e0:	2041           	moveal %d1,%a0
    14e2:	2210           	movel %a0@,%d1
    14e4:	2400           	movel %d0,%d2
    14e6:	9481           	subl %d1,%d2
    14e8:	2202           	movel %d2,%d1
    14ea:	202e 000c      	movel %fp@(12),%d0
    14ee:	2040           	moveal %d0,%a0
    14f0:	2081           	movel %d1,%a0@
    14f2:	602e           	bras 0x1522
    14f4:	202e 0008      	movel %fp@(8),%d0
    14f8:	2040           	moveal %d0,%a0
    14fa:	2028 0004      	movel %a0@(4),%d0
    14fe:	0280 0000 0100 	andil #256,%d0
    1504:	4a80           	tstl %d0
    1506:	671a           	beqs 0x1522
    1508:	202e 000c      	movel %fp@(12),%d0
    150c:	2040           	moveal %d0,%a0
    150e:	2210           	movel %a0@,%d1
    1510:	202e 0008      	movel %fp@(8),%d0
    1514:	2040           	moveal %d0,%a0
    1516:	2010           	movel %a0@,%d0
    1518:	d280           	addl %d0,%d1
    151a:	202e 000c      	movel %fp@(12),%d0
    151e:	2040           	moveal %d0,%a0
    1520:	2081           	movel %d1,%a0@
    1522:	4280           	clrl %d0
    1524:	6002           	bras 0x1528
    1526:	70ff           	moveq #-1,%d0
    1528:	242e fffc      	movel %fp@(-4),%d2
    152c:	4e5e           	unlk %fp
    152e:	4e75           	rts
    1530:	4e56 fff8      	linkw %fp,#-8
    1534:	42ae fffc      	clrl %fp@(-4)
    1538:	6002           	bras 0x153c
    153a:	4e71           	nop
    153c:	2f2e 0010      	movel %fp@(16),%sp@-
    1540:	4eb9 0000 0000 	jsr 0x0
    1546:	588f           	addql #4,%sp
    1548:	2d40 fff8      	movel %d0,%fp@(-8)
    154c:	70ff           	moveq #-1,%d0
    154e:	b0ae fff8      	cmpl %fp@(-8),%d0
    1552:	672a           	beqs 0x157e
    1554:	202e fffc      	movel %fp@(-4),%d0
    1558:	d0ae 0008      	addl %fp@(8),%d0
    155c:	222e fff8      	movel %fp@(-8),%d1
    1560:	1201           	moveb %d1,%d1
    1562:	2040           	moveal %d0,%a0
    1564:	1081           	moveb %d1,%a0@
    1566:	52ae fffc      	addql #1,%fp@(-4)
    156a:	53ae 000c      	subql #1,%fp@(12)
    156e:	4aae 000c      	tstl %fp@(12)
    1572:	670e           	beqs 0x1582
    1574:	700a           	moveq #10,%d0
    1576:	b0ae fff8      	cmpl %fp@(-8),%d0
    157a:	66be           	bnes 0x153a
    157c:	6006           	bras 0x1584
    157e:	4e71           	nop
    1580:	6002           	bras 0x1584
    1582:	4e71           	nop
    1584:	202e fffc      	movel %fp@(-4),%d0
    1588:	d0ae 0008      	addl %fp@(8),%d0
    158c:	2040           	moveal %d0,%a0
    158e:	4210           	clrb %a0@
    1590:	70ff           	moveq #-1,%d0
    1592:	b0ae fff8      	cmpl %fp@(-8),%d0
    1596:	6604           	bnes 0x159c
    1598:	4280           	clrl %d0
    159a:	6004           	bras 0x15a0
    159c:	202e 0008      	movel %fp@(8),%d0
    15a0:	2200           	movel %d0,%d1
    15a2:	2041           	moveal %d1,%a0
    15a4:	4e5e           	unlk %fp
    15a6:	4e75           	rts
    15a8:	4e56 ffe0      	linkw %fp,#-32
    15ac:	2f02           	movel %d2,%sp@-
    15ae:	42ae fffc      	clrl %fp@(-4)
    15b2:	42ae fff8      	clrl %fp@(-8)
    15b6:	42ae fff4      	clrl %fp@(-12)
    15ba:	42ae fff0      	clrl %fp@(-16)
    15be:	2039 0000 0000 	movel 0x0,%d0
    15c4:	7214           	moveq #20,%d1
    15c6:	b280           	cmpl %d0,%d1
    15c8:	6606           	bnes 0x15d0
    15ca:	4280           	clrl %d0
    15cc:	6000 0316      	braw 0x18e4
    15d0:	42ae ffec      	clrl %fp@(-20)
    15d4:	607a           	bras 0x1650
    15d6:	202e ffec      	movel %fp@(-20),%d0
    15da:	d0ae 000c      	addl %fp@(12),%d0
    15de:	2040           	moveal %d0,%a0
    15e0:	1010           	moveb %a0@,%d0
    15e2:	49c0           	extbl %d0
    15e4:	7272           	moveq #114,%d1
    15e6:	b280           	cmpl %d0,%d1
    15e8:	6728           	beqs 0x1612
    15ea:	7272           	moveq #114,%d1
    15ec:	b280           	cmpl %d0,%d1
    15ee:	6d14           	blts 0x1604
    15f0:	7261           	moveq #97,%d1
    15f2:	b280           	cmpl %d0,%d1
    15f4:	672c           	beqs 0x1622
    15f6:	7262           	moveq #98,%d1
    15f8:	b280           	cmpl %d0,%d1
    15fa:	673c           	beqs 0x1638
    15fc:	722b           	moveq #43,%d1
    15fe:	b280           	cmpl %d0,%d1
    1600:	672e           	beqs 0x1630
    1602:	6042           	bras 0x1646
    1604:	7274           	moveq #116,%d1
    1606:	b280           	cmpl %d0,%d1
    1608:	6736           	beqs 0x1640
    160a:	7277           	moveq #119,%d1
    160c:	b280           	cmpl %d0,%d1
    160e:	670a           	beqs 0x161a
    1610:	6034           	bras 0x1646
    1612:	7001           	moveq #1,%d0
    1614:	81ae fffc      	orl %d0,%fp@(-4)
    1618:	6032           	bras 0x164c
    161a:	7202           	moveq #2,%d1
    161c:	83ae fffc      	orl %d1,%fp@(-4)
    1620:	602a           	bras 0x164c
    1622:	7002           	moveq #2,%d0
    1624:	81ae fffc      	orl %d0,%fp@(-4)
    1628:	7201           	moveq #1,%d1
    162a:	2d41 fff8      	movel %d1,%fp@(-8)
    162e:	601c           	bras 0x164c
    1630:	7001           	moveq #1,%d0
    1632:	2d40 fff4      	movel %d0,%fp@(-12)
    1636:	6014           	bras 0x164c
    1638:	7240           	moveq #64,%d1
    163a:	83ae fffc      	orl %d1,%fp@(-4)
    163e:	600c           	bras 0x164c
    1640:	70bf           	moveq #-65,%d0
    1642:	c1ae fffc      	andl %d0,%fp@(-4)
    1646:	4280           	clrl %d0
    1648:	6000 029a      	braw 0x18e4
    164c:	52ae ffec      	addql #1,%fp@(-20)
    1650:	242e ffec      	movel %fp@(-20),%d2
    1654:	2f2e 000c      	movel %fp@(12),%sp@-
    1658:	4eb9 0000 0000 	jsr 0x0
    165e:	588f           	addql #4,%sp
    1660:	b082           	cmpl %d2,%d0
    1662:	6200 ff72      	bhiw 0x15d6
    1666:	7003           	moveq #3,%d0
    1668:	c0ae fffc      	andl %fp@(-4),%d0
    166c:	4a80           	tstl %d0
    166e:	6606           	bnes 0x1676
    1670:	4280           	clrl %d0
    1672:	6000 0270      	braw 0x18e4
    1676:	2f2e 0008      	movel %fp@(8),%sp@-
    167a:	4eb9 0000 0000 	jsr 0x0
    1680:	588f           	addql #4,%sp
    1682:	5280           	addql #1,%d0
    1684:	2f00           	movel %d0,%sp@-
    1686:	4eb9 0000 0000 	jsr 0x0
    168c:	588f           	addql #4,%sp
    168e:	2008           	movel %a0,%d0
    1690:	2d40 ffe4      	movel %d0,%fp@(-28)
    1694:	4aae ffe4      	tstl %fp@(-28)
    1698:	6606           	bnes 0x16a0
    169a:	4280           	clrl %d0
    169c:	6000 0246      	braw 0x18e4
    16a0:	2f2e 0008      	movel %fp@(8),%sp@-
    16a4:	2f2e ffe4      	movel %fp@(-28),%sp@-
    16a8:	4eb9 0000 0000 	jsr 0x0
    16ae:	508f           	addql #8,%sp
    16b0:	4aae 0010      	tstl %fp@(16)
    16b4:	6708           	beqs 0x16be
    16b6:	2d6e 0010 ffe8 	movel %fp@(16),%fp@(-24)
    16bc:	603e           	bras 0x16fc
    16be:	4878 001c      	pea 0x1c
    16c2:	4eb9 0000 0000 	jsr 0x0
    16c8:	588f           	addql #4,%sp
    16ca:	2008           	movel %a0,%d0
    16cc:	2d40 ffe8      	movel %d0,%fp@(-24)
    16d0:	4aae ffe8      	tstl %fp@(-24)
    16d4:	6612           	bnes 0x16e8
    16d6:	2f2e ffe4      	movel %fp@(-28),%sp@-
    16da:	4eb9 0000 0000 	jsr 0x0
    16e0:	588f           	addql #4,%sp
    16e2:	4280           	clrl %d0
    16e4:	6000 01fe      	braw 0x18e4
    16e8:	4878 001c      	pea 0x1c
    16ec:	42a7           	clrl %sp@-
    16ee:	2f2e ffe8      	movel %fp@(-24),%sp@-
    16f2:	4eb9 0000 0000 	jsr 0x0
    16f8:	4fef 000c      	lea %sp@(12),%sp
    16fc:	202e ffe8      	movel %fp@(-24),%d0
    1700:	2040           	moveal %d0,%a0
    1702:	42a8 0004      	clrl %a0@(4)
    1706:	4878 0200      	pea 0x200
    170a:	4eb9 0000 0000 	jsr 0x0
    1710:	588f           	addql #4,%sp
    1712:	2008           	movel %a0,%d0
    1714:	2d40 ffe0      	movel %d0,%fp@(-32)
    1718:	4aae ffe0      	tstl %fp@(-32)
    171c:	661e           	bnes 0x173c
    171e:	2f2e ffe4      	movel %fp@(-28),%sp@-
    1722:	4eb9 0000 0000 	jsr 0x0
    1728:	588f           	addql #4,%sp
    172a:	2f2e ffe8      	movel %fp@(-24),%sp@-
    172e:	4eb9 0000 0000 	jsr 0x0
    1734:	588f           	addql #4,%sp
    1736:	4280           	clrl %d0
    1738:	6000 01aa      	braw 0x18e4
    173c:	7003           	moveq #3,%d0
    173e:	c0ae fffc      	andl %fp@(-4),%d0
    1742:	7201           	moveq #1,%d1
    1744:	b280           	cmpl %d0,%d1
    1746:	671c           	beqs 0x1764
    1748:	7201           	moveq #1,%d1
    174a:	b280           	cmpl %d0,%d1
    174c:	6d08           	blts 0x1756
    174e:	4a80           	tstl %d0
    1750:	6700 0130      	beqw 0x1882
    1754:	606c           	bras 0x17c2
    1756:	7202           	moveq #2,%d1
    1758:	b280           	cmpl %d0,%d1
    175a:	6734           	beqs 0x1790
    175c:	7203           	moveq #3,%d1
    175e:	b280           	cmpl %d0,%d1
    1760:	675a           	beqs 0x17bc
    1762:	605e           	bras 0x17c2
    1764:	4aae fff4      	tstl %fp@(-12)
    1768:	6706           	beqs 0x1770
    176a:	7002           	moveq #2,%d0
    176c:	81ae fffc      	orl %d0,%fp@(-4)
    1770:	2f2e fffc      	movel %fp@(-4),%sp@-
    1774:	4eb9 0000 0000 	jsr 0x0
    177a:	588f           	addql #4,%sp
    177c:	2f00           	movel %d0,%sp@-
    177e:	2f2e 0008      	movel %fp@(8),%sp@-
    1782:	4eb9 0000 0000 	jsr 0x0
    1788:	508f           	addql #8,%sp
    178a:	2d40 fff0      	movel %d0,%fp@(-16)
    178e:	6032           	bras 0x17c2
    1790:	4aae fff4      	tstl %fp@(-12)
    1794:	6706           	beqs 0x179c
    1796:	7201           	moveq #1,%d1
    1798:	83ae fffc      	orl %d1,%fp@(-4)
    179c:	2f2e fffc      	movel %fp@(-4),%sp@-
    17a0:	4eb9 0000 0000 	jsr 0x0
    17a6:	588f           	addql #4,%sp
    17a8:	2f00           	movel %d0,%sp@-
    17aa:	2f2e 0008      	movel %fp@(8),%sp@-
    17ae:	4eb9 0000 0000 	jsr 0x0
    17b4:	508f           	addql #8,%sp
    17b6:	2d40 fff0      	movel %d0,%fp@(-16)
    17ba:	6006           	bras 0x17c2
    17bc:	4280           	clrl %d0
    17be:	6000 0124      	braw 0x18e4
    17c2:	4aae fff0      	tstl %fp@(-16)
    17c6:	6700 00be      	beqw 0x1886
    17ca:	202e ffe8      	movel %fp@(-24),%d0
    17ce:	2040           	moveal %d0,%a0
    17d0:	317c 444c 001a 	movew #17484,%a0@(26)
    17d6:	202e ffe8      	movel %fp@(-24),%d0
    17da:	2040           	moveal %d0,%a0
    17dc:	4290           	clrl %a0@
    17de:	202e fff0      	movel %fp@(-16),%d0
    17e2:	1200           	moveb %d0,%d1
    17e4:	202e ffe8      	movel %fp@(-24),%d0
    17e8:	2040           	moveal %d0,%a0
    17ea:	1141 0008      	moveb %d1,%a0@(8)
    17ee:	202e ffe8      	movel %fp@(-24),%d0
    17f2:	2040           	moveal %d0,%a0
    17f4:	2228 0004      	movel %a0@(4),%d1
    17f8:	202e fffc      	movel %fp@(-4),%d0
    17fc:	8280           	orl %d0,%d1
    17fe:	202e ffe8      	movel %fp@(-24),%d0
    1802:	2040           	moveal %d0,%a0
    1804:	2141 0004      	movel %d1,%a0@(4)
    1808:	202e ffe8      	movel %fp@(-24),%d0
    180c:	2040           	moveal %d0,%a0
    180e:	42a8 0016      	clrl %a0@(22)
    1812:	202e ffe8      	movel %fp@(-24),%d0
    1816:	2040           	moveal %d0,%a0
    1818:	4228 0009      	clrb %a0@(9)
    181c:	7040           	moveq #64,%d0
    181e:	c0ae fffc      	andl %fp@(-4),%d0
    1822:	4a80           	tstl %d0
    1824:	671c           	beqs 0x1842
    1826:	4878 0200      	pea 0x200
    182a:	4878 0001      	pea 0x1
    182e:	2f2e ffe0      	movel %fp@(-32),%sp@-
    1832:	2f2e ffe8      	movel %fp@(-24),%sp@-
    1836:	4eb9 0000 0000 	jsr 0x0
    183c:	4fef 0010      	lea %sp@(16),%sp
    1840:	601a           	bras 0x185c
    1842:	4878 0200      	pea 0x200
    1846:	4878 0002      	pea 0x2
    184a:	2f2e ffe0      	movel %fp@(-32),%sp@-
    184e:	2f2e ffe8      	movel %fp@(-24),%sp@-
    1852:	4eb9 0000 0000 	jsr 0x0
    1858:	4fef 0010      	lea %sp@(16),%sp
    185c:	7004           	moveq #4,%d0
    185e:	81ae fffc      	orl %d0,%fp@(-4)
    1862:	4aae fff8      	tstl %fp@(-8)
    1866:	6750           	beqs 0x18b8
    1868:	4878 0002      	pea 0x2
    186c:	42a7           	clrl %sp@-
    186e:	2f2e ffe8      	movel %fp@(-24),%sp@-
    1872:	4eb9 0000 0000 	jsr 0x0
    1878:	4fef 000c      	lea %sp@(12),%sp
    187c:	4a80           	tstl %d0
    187e:	6738           	beqs 0x18b8
    1880:	6006           	bras 0x1888
    1882:	4e71           	nop
    1884:	6002           	bras 0x1888
    1886:	4e71           	nop
    1888:	2f2e ffe4      	movel %fp@(-28),%sp@-
    188c:	4eb9 0000 0000 	jsr 0x0
    1892:	588f           	addql #4,%sp
    1894:	202e ffe8      	movel %fp@(-24),%d0
    1898:	2040           	moveal %d0,%a0
    189a:	2028 000e      	movel %a0@(14),%d0
    189e:	2f00           	movel %d0,%sp@-
    18a0:	4eb9 0000 0000 	jsr 0x0
    18a6:	588f           	addql #4,%sp
    18a8:	2f2e ffe8      	movel %fp@(-24),%sp@-
    18ac:	4eb9 0000 0000 	jsr 0x0
    18b2:	588f           	addql #4,%sp
    18b4:	4280           	clrl %d0
    18b6:	602c           	bras 0x18e4
    18b8:	2039 0000 0000 	movel 0x0,%d0
    18be:	21ae ffe4 0db0 	movel %fp@(-28),@(00000000,%d0:l:4)
    18c4:	0000 0000 
    18c8:	2039 0000 0000 	movel 0x0,%d0
    18ce:	21ae ffe8 0db0 	movel %fp@(-24),@(00000000,%d0:l:4)
    18d4:	0000 0000 
    18d8:	5280           	addql #1,%d0
    18da:	23c0 0000 0000 	movel %d0,0x0
    18e0:	202e ffe8      	movel %fp@(-24),%d0
    18e4:	2200           	movel %d0,%d1
    18e6:	2041           	moveal %d1,%a0
    18e8:	242e ffdc      	movel %fp@(-36),%d2
    18ec:	4e5e           	unlk %fp
    18ee:	4e75           	rts
    18f0:	4e56 0000      	linkw %fp,#0
    18f4:	42a7           	clrl %sp@-
    18f6:	2f2e 000c      	movel %fp@(12),%sp@-
    18fa:	2f2e 0008      	movel %fp@(8),%sp@-
    18fe:	4eba fca8      	jsr %pc@(0x15a8)
    1902:	4fef 000c      	lea %sp@(12),%sp
    1906:	2008           	movel %a0,%d0
    1908:	2200           	movel %d0,%d1
    190a:	2041           	moveal %d1,%a0
    190c:	4e5e           	unlk %fp
    190e:	4e75           	rts
    1910:	4e56 fff8      	linkw %fp,#-8
    1914:	42ae fff8      	clrl %fp@(-8)
    1918:	2f2e 0010      	movel %fp@(16),%sp@-
    191c:	2f2e 000c      	movel %fp@(12),%sp@-
    1920:	200e           	movel %fp,%d0
    1922:	5180           	subql #8,%d0
    1924:	2f00           	movel %d0,%sp@-
    1926:	4eb9 0000 0000 	jsr 0x0
    192c:	4fef 000c      	lea %sp@(12),%sp
    1930:	2d40 fffc      	movel %d0,%fp@(-4)
    1934:	202e fff8      	movel %fp@(-8),%d0
    1938:	2f2e 0008      	movel %fp@(8),%sp@-
    193c:	2f00           	movel %d0,%sp@-
    193e:	4eb9 0000 0000 	jsr 0x0
    1944:	508f           	addql #8,%sp
    1946:	72ff           	moveq #-1,%d1
    1948:	b280           	cmpl %d0,%d1
    194a:	6604           	bnes 0x1950
    194c:	42ae fffc      	clrl %fp@(-4)
    1950:	202e fff8      	movel %fp@(-8),%d0
    1954:	2f00           	movel %d0,%sp@-
    1956:	4eb9 0000 0000 	jsr 0x0
    195c:	588f           	addql #4,%sp
    195e:	202e fffc      	movel %fp@(-4),%d0
    1962:	4e5e           	unlk %fp
    1964:	4e75           	rts
    1966:	4e56 0000      	linkw %fp,#0
    196a:	700c           	moveq #12,%d0
    196c:	d08e           	addl %fp,%d0
    196e:	5880           	addql #4,%d0
    1970:	222e 000c      	movel %fp@(12),%d1
    1974:	2f00           	movel %d0,%sp@-
    1976:	2f01           	movel %d1,%sp@-
    1978:	2f2e 0008      	movel %fp@(8),%sp@-
    197c:	4eba ff92      	jsr %pc@(0x1910)
    1980:	4fef 000c      	lea %sp@(12),%sp
    1984:	4e5e           	unlk %fp
    1986:	4e75           	rts
    1988:	4e56 0000      	linkw %fp,#0
    198c:	202e 000c      	movel %fp@(12),%d0
    1990:	2040           	moveal %d0,%a0
    1992:	3028 001a      	movew %a0@(26),%d0
    1996:	0c40 444c      	cmpiw #17484,%d0
    199a:	6704           	beqs 0x19a0
    199c:	70ff           	moveq #-1,%d0
    199e:	603e           	bras 0x19de
    19a0:	202e 000c      	movel %fp@(12),%d0
    19a4:	2040           	moveal %d0,%a0
    19a6:	2028 0004      	movel %a0@(4),%d0
    19aa:	7202           	moveq #2,%d1
    19ac:	c081           	andl %d1,%d0
    19ae:	4a80           	tstl %d0
    19b0:	661c           	bnes 0x19ce
    19b2:	202e 000c      	movel %fp@(12),%d0
    19b6:	2040           	moveal %d0,%a0
    19b8:	2028 0004      	movel %a0@(4),%d0
    19bc:	7210           	moveq #16,%d1
    19be:	8280           	orl %d0,%d1
    19c0:	202e 000c      	movel %fp@(12),%d0
    19c4:	2040           	moveal %d0,%a0
    19c6:	2141 0004      	movel %d1,%a0@(4)
    19ca:	70ff           	moveq #-1,%d0
    19cc:	6010           	bras 0x19de
    19ce:	2f2e 000c      	movel %fp@(12),%sp@-
    19d2:	2f2e 0008      	movel %fp@(8),%sp@-
    19d6:	4eb9 0000 0000 	jsr 0x0
    19dc:	508f           	addql #8,%sp
    19de:	4e5e           	unlk %fp
    19e0:	4e75           	rts
    19e2:	4e56 0000      	linkw %fp,#0
    19e6:	2f2e 000c      	movel %fp@(12),%sp@-
    19ea:	2f2e 0008      	movel %fp@(8),%sp@-
    19ee:	4eba ff98      	jsr %pc@(0x1988)
    19f2:	508f           	addql #8,%sp
    19f4:	4e5e           	unlk %fp
    19f6:	4e75           	rts
    19f8:	4e56 0000      	linkw %fp,#0
    19fc:	203c 0000 0000 	movel #0,%d0
    1a02:	5880           	addql #4,%d0
    1a04:	2040           	moveal %d0,%a0
    1a06:	2010           	movel %a0@,%d0
    1a08:	2f00           	movel %d0,%sp@-
    1a0a:	2f2e 0008      	movel %fp@(8),%sp@-
    1a0e:	4eba ff78      	jsr %pc@(0x1988)
    1a12:	508f           	addql #8,%sp
    1a14:	4e5e           	unlk %fp
    1a16:	4e75           	rts
    1a18:	4e56 fff8      	linkw %fp,#-8
    1a1c:	2f2e 0008      	movel %fp@(8),%sp@-
    1a20:	4eb9 0000 0000 	jsr 0x0
    1a26:	588f           	addql #4,%sp
    1a28:	2d40 fff8      	movel %d0,%fp@(-8)
    1a2c:	42ae fffc      	clrl %fp@(-4)
    1a30:	602a           	bras 0x1a5c
    1a32:	202e fffc      	movel %fp@(-4),%d0
    1a36:	d0ae 0008      	addl %fp@(8),%d0
    1a3a:	2040           	moveal %d0,%a0
    1a3c:	1010           	moveb %a0@,%d0
    1a3e:	49c0           	extbl %d0
    1a40:	2f2e 000c      	movel %fp@(12),%sp@-
    1a44:	2f00           	movel %d0,%sp@-
    1a46:	4eb9 0000 0000 	jsr 0x0
    1a4c:	508f           	addql #8,%sp
    1a4e:	72ff           	moveq #-1,%d1
    1a50:	b280           	cmpl %d0,%d1
    1a52:	6604           	bnes 0x1a58
    1a54:	70ff           	moveq #-1,%d0
    1a56:	6010           	bras 0x1a68
    1a58:	52ae fffc      	addql #1,%fp@(-4)
    1a5c:	206e fffc      	moveal %fp@(-4),%a0
    1a60:	b1ee fff8      	cmpal %fp@(-8),%a0
    1a64:	6dcc           	blts 0x1a32
    1a66:	7001           	moveq #1,%d0
    1a68:	4e5e           	unlk %fp
    1a6a:	4e75           	rts
    1a6c:	4e56 fff0      	linkw %fp,#-16
    1a70:	202e 0010      	movel %fp@(16),%d0
    1a74:	4c2e 0800 000c 	mulsl %fp@(12),%d0
    1a7a:	2d40 fff4      	movel %d0,%fp@(-12)
    1a7e:	2d6e 0008 fff8 	movel %fp@(8),%fp@(-8)
    1a84:	202e 0014      	movel %fp@(20),%d0
    1a88:	2040           	moveal %d0,%a0
    1a8a:	3028 001a      	movew %a0@(26),%d0
    1a8e:	0c40 444c      	cmpiw #17484,%d0
    1a92:	6704           	beqs 0x1a98
    1a94:	4280           	clrl %d0
    1a96:	607c           	bras 0x1b14
    1a98:	202e 0014      	movel %fp@(20),%d0
    1a9c:	2040           	moveal %d0,%a0
    1a9e:	2028 0004      	movel %a0@(4),%d0
    1aa2:	7201           	moveq #1,%d1
    1aa4:	c081           	andl %d1,%d0
    1aa6:	4a80           	tstl %d0
    1aa8:	661c           	bnes 0x1ac6
    1aaa:	202e 0014      	movel %fp@(20),%d0
    1aae:	2040           	moveal %d0,%a0
    1ab0:	2028 0004      	movel %a0@(4),%d0
    1ab4:	7210           	moveq #16,%d1
    1ab6:	8280           	orl %d0,%d1
    1ab8:	202e 0014      	movel %fp@(20),%d0
    1abc:	2040           	moveal %d0,%a0
    1abe:	2141 0004      	movel %d1,%a0@(4)
    1ac2:	4280           	clrl %d0
    1ac4:	604e           	bras 0x1b14
    1ac6:	42ae fffc      	clrl %fp@(-4)
    1aca:	603a           	bras 0x1b06
    1acc:	2f2e 0014      	movel %fp@(20),%sp@-
    1ad0:	4eb9 0000 0000 	jsr 0x0
    1ad6:	588f           	addql #4,%sp
    1ad8:	2d40 fff0      	movel %d0,%fp@(-16)
    1adc:	70ff           	moveq #-1,%d0
    1ade:	b0ae fff0      	cmpl %fp@(-16),%d0
    1ae2:	660c           	bnes 0x1af0
    1ae4:	202e fffc      	movel %fp@(-4),%d0
    1ae8:	4c6e 0001 000c 	divull %fp@(12),%d1,%d0
    1aee:	6024           	bras 0x1b14
    1af0:	202e fff0      	movel %fp@(-16),%d0
    1af4:	1200           	moveb %d0,%d1
    1af6:	202e fff8      	movel %fp@(-8),%d0
    1afa:	2040           	moveal %d0,%a0
    1afc:	1081           	moveb %d1,%a0@
    1afe:	52ae fff8      	addql #1,%fp@(-8)
    1b02:	52ae fffc      	addql #1,%fp@(-4)
    1b06:	202e fffc      	movel %fp@(-4),%d0
    1b0a:	b0ae fff4      	cmpl %fp@(-12),%d0
    1b0e:	6dbc           	blts 0x1acc
    1b10:	202e 0010      	movel %fp@(16),%d0
    1b14:	4e5e           	unlk %fp
    1b16:	4e75           	rts
    1b18:	4e56 0000      	linkw %fp,#0
    1b1c:	2f2e 0008      	movel %fp@(8),%sp@-
    1b20:	4eb9 0000 0000 	jsr 0x0
    1b26:	588f           	addql #4,%sp
    1b28:	4e5e           	unlk %fp
    1b2a:	4e75           	rts
    1b2c:	4e56 0000      	linkw %fp,#0
    1b30:	42a7           	clrl %sp@-
    1b32:	2f2e 0010      	movel %fp@(16),%sp@-
    1b36:	4eb9 0000 0000 	jsr 0x0
    1b3c:	508f           	addql #8,%sp
    1b3e:	4a80           	tstl %d0
    1b40:	6704           	beqs 0x1b46
    1b42:	4280           	clrl %d0
    1b44:	6024           	bras 0x1b6a
    1b46:	2f2e 0010      	movel %fp@(16),%sp@-
    1b4a:	2f2e 000c      	movel %fp@(12),%sp@-
    1b4e:	2f2e 0008      	movel %fp@(8),%sp@-
    1b52:	4eb9 0000 0000 	jsr 0x0
    1b58:	4fef 000c      	lea %sp@(12),%sp
    1b5c:	2008           	movel %a0,%d0
    1b5e:	4a80           	tstl %d0
    1b60:	6604           	bnes 0x1b66
    1b62:	4280           	clrl %d0
    1b64:	6004           	bras 0x1b6a
    1b66:	202e 0010      	movel %fp@(16),%d0
    1b6a:	2200           	movel %d0,%d1
    1b6c:	2041           	moveal %d1,%a0
    1b6e:	4e5e           	unlk %fp
    1b70:	4e75           	rts
    1b72:	4e71           	nop
    1b74:	4e56 0000      	linkw %fp,#0
    1b78:	202e 0008      	movel %fp@(8),%d0
    1b7c:	2040           	moveal %d0,%a0
    1b7e:	3028 001a      	movew %a0@(26),%d0
    1b82:	0c40 444c      	cmpiw #17484,%d0
    1b86:	6706           	beqs 0x1b8e
    1b88:	70ff           	moveq #-1,%d0
    1b8a:	6000 0084      	braw 0x1c10
    1b8e:	202e 0010      	movel %fp@(16),%d0
    1b92:	4281           	clrl %d1
    1b94:	d081           	addl %d1,%d0
    1b96:	7202           	moveq #2,%d1
    1b98:	b280           	cmpl %d0,%d1
    1b9a:	6572           	bcss 0x1c0e
    1b9c:	2f2e 0008      	movel %fp@(8),%sp@-
    1ba0:	4eb9 0000 0000 	jsr 0x0
    1ba6:	588f           	addql #4,%sp
    1ba8:	4a80           	tstl %d0
    1baa:	671c           	beqs 0x1bc8
    1bac:	202e 0008      	movel %fp@(8),%d0
    1bb0:	2040           	moveal %d0,%a0
    1bb2:	2028 0004      	movel %a0@(4),%d0
    1bb6:	7210           	moveq #16,%d1
    1bb8:	8280           	orl %d0,%d1
    1bba:	202e 0008      	movel %fp@(8),%d0
    1bbe:	2040           	moveal %d0,%a0
    1bc0:	2141 0004      	movel %d1,%a0@(4)
    1bc4:	70ff           	moveq #-1,%d0
    1bc6:	6048           	bras 0x1c10
    1bc8:	222e 000c      	movel %fp@(12),%d1
    1bcc:	202e 0008      	movel %fp@(8),%d0
    1bd0:	2040           	moveal %d0,%a0
    1bd2:	1028 0008      	moveb %a0@(8),%d0
    1bd6:	49c0           	extbl %d0
    1bd8:	2f2e 0010      	movel %fp@(16),%sp@-
    1bdc:	2f01           	movel %d1,%sp@-
    1bde:	2f00           	movel %d0,%sp@-
    1be0:	4eb9 0000 0000 	jsr 0x0
    1be6:	4fef 000c      	lea %sp@(12),%sp
    1bea:	4a80           	tstl %d0
    1bec:	671c           	beqs 0x1c0a
    1bee:	202e 0008      	movel %fp@(8),%d0
    1bf2:	2040           	moveal %d0,%a0
    1bf4:	2028 0004      	movel %a0@(4),%d0
    1bf8:	7210           	moveq #16,%d1
    1bfa:	8280           	orl %d0,%d1
    1bfc:	202e 0008      	movel %fp@(8),%d0
    1c00:	2040           	moveal %d0,%a0
    1c02:	2141 0004      	movel %d1,%a0@(4)
    1c06:	70ff           	moveq #-1,%d0
    1c08:	6006           	bras 0x1c10
    1c0a:	4280           	clrl %d0
    1c0c:	6002           	bras 0x1c10
    1c0e:	70ff           	moveq #-1,%d0
    1c10:	4e5e           	unlk %fp
    1c12:	4e75           	rts
    1c14:	4e56 0000      	linkw %fp,#0
    1c18:	202e 0008      	movel %fp@(8),%d0
    1c1c:	2040           	moveal %d0,%a0
    1c1e:	3028 001a      	movew %a0@(26),%d0
    1c22:	0c40 444c      	cmpiw #17484,%d0
    1c26:	6618           	bnes 0x1c40
    1c28:	202e 0008      	movel %fp@(8),%d0
    1c2c:	2040           	moveal %d0,%a0
    1c2e:	2028 0004      	movel %a0@(4),%d0
    1c32:	72df           	moveq #-33,%d1
    1c34:	c280           	andl %d0,%d1
    1c36:	202e 0008      	movel %fp@(8),%d0
    1c3a:	2040           	moveal %d0,%a0
    1c3c:	2141 0004      	movel %d1,%a0@(4)
    1c40:	202e 000c      	movel %fp@(12),%d0
    1c44:	2040           	moveal %d0,%a0
    1c46:	2010           	movel %a0@,%d0
    1c48:	42a7           	clrl %sp@-
    1c4a:	2f00           	movel %d0,%sp@-
    1c4c:	2f2e 0008      	movel %fp@(8),%sp@-
    1c50:	4eb9 0000 0000 	jsr 0x0
    1c56:	4fef 000c      	lea %sp@(12),%sp
    1c5a:	4e5e           	unlk %fp
    1c5c:	4e75           	rts
    1c5e:	4e71           	nop
    1c60:	4e56 fffc      	linkw %fp,#-4
    1c64:	42ae fffc      	clrl %fp@(-4)
    1c68:	200e           	movel %fp,%d0
    1c6a:	5980           	subql #4,%d0
    1c6c:	2f00           	movel %d0,%sp@-
    1c6e:	2f2e 0008      	movel %fp@(8),%sp@-
    1c72:	4eb9 0000 0000 	jsr 0x0
    1c78:	508f           	addql #8,%sp
    1c7a:	4a80           	tstl %d0
    1c7c:	6704           	beqs 0x1c82
    1c7e:	70ff           	moveq #-1,%d0
    1c80:	6004           	bras 0x1c86
    1c82:	202e fffc      	movel %fp@(-4),%d0
    1c86:	4e5e           	unlk %fp
    1c88:	4e75           	rts
    1c8a:	4e71           	nop
    1c8c:	4e56 fff4      	linkw %fp,#-12
    1c90:	202e 000c      	movel %fp@(12),%d0
    1c94:	4c2e 0800 0010 	mulsl %fp@(16),%d0
    1c9a:	2d40 fff8      	movel %d0,%fp@(-8)
    1c9e:	202e 0014      	movel %fp@(20),%d0
    1ca2:	2040           	moveal %d0,%a0
    1ca4:	3028 001a      	movew %a0@(26),%d0
    1ca8:	0c40 444c      	cmpiw #17484,%d0
    1cac:	6706           	beqs 0x1cb4
    1cae:	4280           	clrl %d0
    1cb0:	6000 0082      	braw 0x1d34
    1cb4:	202e 0014      	movel %fp@(20),%d0
    1cb8:	2040           	moveal %d0,%a0
    1cba:	2028 0004      	movel %a0@(4),%d0
    1cbe:	7202           	moveq #2,%d1
    1cc0:	c081           	andl %d1,%d0
    1cc2:	4a80           	tstl %d0
    1cc4:	661c           	bnes 0x1ce2
    1cc6:	202e 0014      	movel %fp@(20),%d0
    1cca:	2040           	moveal %d0,%a0
    1ccc:	2028 0004      	movel %a0@(4),%d0
    1cd0:	7210           	moveq #16,%d1
    1cd2:	8280           	orl %d0,%d1
    1cd4:	202e 0014      	movel %fp@(20),%d0
    1cd8:	2040           	moveal %d0,%a0
    1cda:	2141 0004      	movel %d1,%a0@(4)
    1cde:	4280           	clrl %d0
    1ce0:	6052           	bras 0x1d34
    1ce2:	42ae fffc      	clrl %fp@(-4)
    1ce6:	603e           	bras 0x1d26
    1ce8:	202e 0008      	movel %fp@(8),%d0
    1cec:	2040           	moveal %d0,%a0
    1cee:	1010           	moveb %a0@,%d0
    1cf0:	1000           	moveb %d0,%d0
    1cf2:	0280 0000 00ff 	andil #255,%d0
    1cf8:	52ae 0008      	addql #1,%fp@(8)
    1cfc:	2f2e 0014      	movel %fp@(20),%sp@-
    1d00:	2f00           	movel %d0,%sp@-
    1d02:	4eb9 0000 0000 	jsr 0x0
    1d08:	508f           	addql #8,%sp
    1d0a:	2d40 fff4      	movel %d0,%fp@(-12)
    1d0e:	70ff           	moveq #-1,%d0
    1d10:	b0ae fff4      	cmpl %fp@(-12),%d0
    1d14:	660c           	bnes 0x1d22
    1d16:	202e fffc      	movel %fp@(-4),%d0
    1d1a:	4c6e 0001 000c 	divull %fp@(12),%d1,%d0
    1d20:	6012           	bras 0x1d34
    1d22:	52ae fffc      	addql #1,%fp@(-4)
    1d26:	222e fffc      	movel %fp@(-4),%d1
    1d2a:	b2ae fff8      	cmpl %fp@(-8),%d1
    1d2e:	6db8           	blts 0x1ce8
    1d30:	202e 0010      	movel %fp@(16),%d0
    1d34:	4e5e           	unlk %fp
    1d36:	4e75           	rts
    1d38:	4e56 fff8      	linkw %fp,#-8
    1d3c:	2d79 0000 0000 	movel 0x0,%fp@(-4)
    1d42:	fffc 
    1d44:	2f2e 0008      	movel %fp@(8),%sp@-
    1d48:	4eb9 0000 0000 	jsr 0x0
    1d4e:	588f           	addql #4,%sp
    1d50:	2d40 fff8      	movel %d0,%fp@(-8)
    1d54:	6038           	bras 0x1d8e
    1d56:	222e fff8      	movel %fp@(-8),%d1
    1d5a:	202e fffc      	movel %fp@(-4),%d0
    1d5e:	2040           	moveal %d0,%a0
    1d60:	2010           	movel %a0@,%d0
    1d62:	2f01           	movel %d1,%sp@-
    1d64:	2f00           	movel %d0,%sp@-
    1d66:	2f2e 0008      	movel %fp@(8),%sp@-
    1d6a:	4eb9 0000 0000 	jsr 0x0
    1d70:	4fef 000c      	lea %sp@(12),%sp
    1d74:	4a80           	tstl %d0
    1d76:	6612           	bnes 0x1d8a
    1d78:	202e fffc      	movel %fp@(-4),%d0
    1d7c:	2040           	moveal %d0,%a0
    1d7e:	2210           	movel %a0@,%d1
    1d80:	202e fff8      	movel %fp@(-8),%d0
    1d84:	5280           	addql #1,%d0
    1d86:	d081           	addl %d1,%d0
    1d88:	6012           	bras 0x1d9c
    1d8a:	58ae fffc      	addql #4,%fp@(-4)
    1d8e:	202e fffc      	movel %fp@(-4),%d0
    1d92:	2040           	moveal %d0,%a0
    1d94:	2010           	movel %a0@,%d0
    1d96:	4a80           	tstl %d0
    1d98:	66bc           	bnes 0x1d56
    1d9a:	4280           	clrl %d0
    1d9c:	2200           	movel %d0,%d1
    1d9e:	2041           	moveal %d1,%a0
    1da0:	4e5e           	unlk %fp
    1da2:	4e75           	rts
    1da4:	4e56 fff8      	linkw %fp,#-8
    1da8:	42ae fffc      	clrl %fp@(-4)
    1dac:	6002           	bras 0x1db0
    1dae:	4e71           	nop
    1db0:	203c 0000 0000 	movel #0,%d0
    1db6:	2040           	moveal %d0,%a0
    1db8:	2010           	movel %a0@,%d0
    1dba:	2f00           	movel %d0,%sp@-
    1dbc:	4eb9 0000 0000 	jsr 0x0
    1dc2:	588f           	addql #4,%sp
    1dc4:	2d40 fff8      	movel %d0,%fp@(-8)
    1dc8:	70ff           	moveq #-1,%d0
    1dca:	b0ae fff8      	cmpl %fp@(-8),%d0
    1dce:	673a           	beqs 0x1e0a
    1dd0:	203c 0000 0000 	movel #0,%d0
    1dd6:	5880           	addql #4,%d0
    1dd8:	2040           	moveal %d0,%a0
    1dda:	2010           	movel %a0@,%d0
    1ddc:	2f00           	movel %d0,%sp@-
    1dde:	2f2e fff8      	movel %fp@(-8),%sp@-
    1de2:	4eb9 0000 0000 	jsr 0x0
    1de8:	508f           	addql #8,%sp
    1dea:	202e fffc      	movel %fp@(-4),%d0
    1dee:	d0ae 0008      	addl %fp@(8),%d0
    1df2:	222e fff8      	movel %fp@(-8),%d1
    1df6:	1201           	moveb %d1,%d1
    1df8:	2040           	moveal %d0,%a0
    1dfa:	1081           	moveb %d1,%a0@
    1dfc:	52ae fffc      	addql #1,%fp@(-4)
    1e00:	700a           	moveq #10,%d0
    1e02:	b0ae fff8      	cmpl %fp@(-8),%d0
    1e06:	66a6           	bnes 0x1dae
    1e08:	6002           	bras 0x1e0c
    1e0a:	4e71           	nop
    1e0c:	4aae fffc      	tstl %fp@(-4)
    1e10:	6606           	bnes 0x1e18
    1e12:	7001           	moveq #1,%d0
    1e14:	2d40 fffc      	movel %d0,%fp@(-4)
    1e18:	202e fffc      	movel %fp@(-4),%d0
    1e1c:	5380           	subql #1,%d0
    1e1e:	d0ae 0008      	addl %fp@(8),%d0
    1e22:	2040           	moveal %d0,%a0
    1e24:	4210           	clrb %a0@
    1e26:	70ff           	moveq #-1,%d0
    1e28:	b0ae fff8      	cmpl %fp@(-8),%d0
    1e2c:	6604           	bnes 0x1e32
    1e2e:	4280           	clrl %d0
    1e30:	6004           	bras 0x1e36
    1e32:	202e 0008      	movel %fp@(8),%d0
    1e36:	2200           	movel %d0,%d1
    1e38:	2041           	moveal %d1,%a0
    1e3a:	4e5e           	unlk %fp
    1e3c:	4e75           	rts
    1e3e:	4e71           	nop
    1e40:	4e56 fff4      	linkw %fp,#-12
    1e44:	2f02           	movel %d2,%sp@-
    1e46:	202e 0008      	movel %fp@(8),%d0
    1e4a:	2040           	moveal %d0,%a0
    1e4c:	2d50 fff8      	movel %a0@,%fp@(-8)
    1e50:	42ae fff4      	clrl %fp@(-12)
    1e54:	202e fff8      	movel %fp@(-8),%d0
    1e58:	2400           	movel %d0,%d2
    1e5a:	4c3c 2c01 8888 	mulsl #-2004318071,%d1,%d2
    1e60:	8889 
    1e62:	d280           	addl %d0,%d1
    1e64:	ea81           	asrl #5,%d1
    1e66:	2400           	movel %d0,%d2
    1e68:	d482           	addl %d2,%d2
    1e6a:	9582           	subxl %d2,%d2
    1e6c:	2042           	moveal %d2,%a0
    1e6e:	9288           	subl %a0,%d1
    1e70:	2401           	movel %d1,%d2
    1e72:	e58a           	lsll #2,%d2
    1e74:	2042           	moveal %d2,%a0
    1e76:	2208           	movel %a0,%d1
    1e78:	e989           	lsll #4,%d1
    1e7a:	9288           	subl %a0,%d1
    1e7c:	2400           	movel %d0,%d2
    1e7e:	9481           	subl %d1,%d2
    1e80:	2202           	movel %d2,%d1
    1e82:	23c1 0000 0000 	movel %d1,0x0
    1e88:	202e fff8      	movel %fp@(-8),%d0
    1e8c:	2400           	movel %d0,%d2
    1e8e:	4c3c 2c01 8888 	mulsl #-2004318071,%d1,%d2
    1e94:	8889 
    1e96:	d280           	addl %d0,%d1
    1e98:	ea81           	asrl #5,%d1
    1e9a:	d080           	addl %d0,%d0
    1e9c:	9180           	subxl %d0,%d0
    1e9e:	2401           	movel %d1,%d2
    1ea0:	9480           	subl %d0,%d2
    1ea2:	2002           	movel %d2,%d0
    1ea4:	2d40 fff8      	movel %d0,%fp@(-8)
    1ea8:	202e fff8      	movel %fp@(-8),%d0
    1eac:	2400           	movel %d0,%d2
    1eae:	4c3c 2c01 8888 	mulsl #-2004318071,%d1,%d2
    1eb4:	8889 
    1eb6:	d280           	addl %d0,%d1
    1eb8:	ea81           	asrl #5,%d1
    1eba:	2400           	movel %d0,%d2
    1ebc:	d482           	addl %d2,%d2
    1ebe:	9582           	subxl %d2,%d2
    1ec0:	2042           	moveal %d2,%a0
    1ec2:	9288           	subl %a0,%d1
    1ec4:	2401           	movel %d1,%d2
    1ec6:	e58a           	lsll #2,%d2
    1ec8:	2042           	moveal %d2,%a0
    1eca:	2208           	movel %a0,%d1
    1ecc:	e989           	lsll #4,%d1
    1ece:	9288           	subl %a0,%d1
    1ed0:	2400           	movel %d0,%d2
    1ed2:	9481           	subl %d1,%d2
    1ed4:	2202           	movel %d2,%d1
    1ed6:	23c1 0000 0000 	movel %d1,0x0
    1edc:	202e fff8      	movel %fp@(-8),%d0
    1ee0:	2400           	movel %d0,%d2
    1ee2:	4c3c 2c01 8888 	mulsl #-2004318071,%d1,%d2
    1ee8:	8889 
    1eea:	d280           	addl %d0,%d1
    1eec:	ea81           	asrl #5,%d1
    1eee:	d080           	addl %d0,%d0
    1ef0:	9180           	subxl %d0,%d0
    1ef2:	2401           	movel %d1,%d2
    1ef4:	9480           	subl %d0,%d2
    1ef6:	2002           	movel %d2,%d0
    1ef8:	2d40 fff8      	movel %d0,%fp@(-8)
    1efc:	222e fff8      	movel %fp@(-8),%d1
    1f00:	2401           	movel %d1,%d2
    1f02:	4c3c 2c00 2aaa 	mulsl #715827883,%d0,%d2
    1f08:	aaab 
    1f0a:	e480           	asrl #2,%d0
    1f0c:	2401           	movel %d1,%d2
    1f0e:	d482           	addl %d2,%d2
    1f10:	9582           	subxl %d2,%d2
    1f12:	2042           	moveal %d2,%a0
    1f14:	9088           	subl %a0,%d0
    1f16:	2400           	movel %d0,%d2
    1f18:	e78a           	lsll #3,%d2
    1f1a:	2042           	moveal %d2,%a0
    1f1c:	2008           	movel %a0,%d0
    1f1e:	e588           	lsll #2,%d0
    1f20:	9088           	subl %a0,%d0
    1f22:	2401           	movel %d1,%d2
    1f24:	9480           	subl %d0,%d2
    1f26:	2002           	movel %d2,%d0
    1f28:	23c0 0000 0000 	movel %d0,0x0
    1f2e:	202e fff8      	movel %fp@(-8),%d0
    1f32:	2400           	movel %d0,%d2
    1f34:	4c3c 2c01 2aaa 	mulsl #715827883,%d1,%d2
    1f3a:	aaab 
    1f3c:	e481           	asrl #2,%d1
    1f3e:	d080           	addl %d0,%d0
    1f40:	9180           	subxl %d0,%d0
    1f42:	2401           	movel %d1,%d2
    1f44:	9480           	subl %d0,%d2
    1f46:	2002           	movel %d2,%d0
    1f48:	2d40 fff8      	movel %d0,%fp@(-8)
    1f4c:	23ee fff8 0000 	movel %fp@(-8),0x0
    1f52:	0000 
    1f54:	202e fff8      	movel %fp@(-8),%d0
    1f58:	5880           	addql #4,%d0
    1f5a:	2400           	movel %d0,%d2
    1f5c:	4c3c 2c01 9249 	mulsl #-1840700269,%d1,%d2
    1f62:	2493 
    1f64:	d280           	addl %d0,%d1
    1f66:	e481           	asrl #2,%d1
    1f68:	2400           	movel %d0,%d2
    1f6a:	d482           	addl %d2,%d2
    1f6c:	9582           	subxl %d2,%d2
    1f6e:	2042           	moveal %d2,%a0
    1f70:	9288           	subl %a0,%d1
    1f72:	2041           	moveal %d1,%a0
    1f74:	2408           	movel %a0,%d2
    1f76:	e78a           	lsll #3,%d2
    1f78:	2042           	moveal %d2,%a0
    1f7a:	91c1           	subal %d1,%a0
    1f7c:	2200           	movel %d0,%d1
    1f7e:	9288           	subl %a0,%d1
    1f80:	23c1 0000 0000 	movel %d1,0x0
    1f86:	2039 0000 0000 	movel 0x0,%d0
    1f8c:	2400           	movel %d0,%d2
    1f8e:	4c3c 2c01 b38c 	mulsl #-1282606671,%d1,%d2
    1f94:	f9b1 
    1f96:	d280           	addl %d0,%d1
    1f98:	e081           	asrl #8,%d1
    1f9a:	d080           	addl %d0,%d0
    1f9c:	9180           	subxl %d0,%d0
    1f9e:	2401           	movel %d1,%d2
    1fa0:	9480           	subl %d0,%d2
    1fa2:	2002           	movel %d2,%d0
    1fa4:	7246           	moveq #70,%d1
    1fa6:	d081           	addl %d1,%d0
    1fa8:	23c0 0000 0000 	movel %d0,0x0
    1fae:	2239 0000 0000 	movel 0x0,%d1
    1fb4:	2401           	movel %d1,%d2
    1fb6:	4c3c 2c00 b38c 	mulsl #-1282606671,%d0,%d2
    1fbc:	f9b1 
    1fbe:	d081           	addl %d1,%d0
    1fc0:	e080           	asrl #8,%d0
    1fc2:	2401           	movel %d1,%d2
    1fc4:	d482           	addl %d2,%d2
    1fc6:	9582           	subxl %d2,%d2
    1fc8:	2042           	moveal %d2,%a0
    1fca:	2240           	moveal %d0,%a1
    1fcc:	93c8           	subal %a0,%a1
    1fce:	2049           	moveal %a1,%a0
    1fd0:	2008           	movel %a0,%d0
    1fd2:	e788           	lsll #3,%d0
    1fd4:	2400           	movel %d0,%d2
    1fd6:	e78a           	lsll #3,%d2
    1fd8:	2242           	moveal %d2,%a1
    1fda:	d089           	addl %a1,%d0
    1fdc:	d088           	addl %a0,%d0
    1fde:	2400           	movel %d0,%d2
    1fe0:	e58a           	lsll #2,%d2
    1fe2:	2042           	moveal %d2,%a0
    1fe4:	d088           	addl %a0,%d0
    1fe6:	2041           	moveal %d1,%a0
    1fe8:	91c0           	subal %d0,%a0
    1fea:	23c8 0000 0000 	movel %a0,0x0
    1ff0:	2239 0000 0000 	movel 0x0,%d1
    1ff6:	2039 0000 0000 	movel 0x0,%d0
    1ffc:	74bb           	moveq #-69,%d2
    1ffe:	d082           	addl %d2,%d0
    2000:	4a80           	tstl %d0
    2002:	6c02           	bges 0x2006
    2004:	5680           	addql #3,%d0
    2006:	e480           	asrl #2,%d0
    2008:	2401           	movel %d1,%d2
    200a:	9480           	subl %d0,%d2
    200c:	2002           	movel %d2,%d0
    200e:	23c0 0000 0000 	movel %d0,0x0
    2014:	2039 0000 0000 	movel 0x0,%d0
    201a:	4a80           	tstl %d0
    201c:	6c38           	bges 0x2056
    201e:	23fc 0000 016c 	movel #364,0x0
    2024:	0000 0000 
    2028:	2039 0000 0000 	movel 0x0,%d0
    202e:	5380           	subql #1,%d0
    2030:	23c0 0000 0000 	movel %d0,0x0
    2036:	2039 0000 0000 	movel 0x0,%d0
    203c:	72b8           	moveq #-72,%d1
    203e:	d081           	addl %d1,%d0
    2040:	7403           	moveq #3,%d2
    2042:	c082           	andl %d2,%d0
    2044:	4a80           	tstl %d0
    2046:	660e           	bnes 0x2056
    2048:	2039 0000 0000 	movel 0x0,%d0
    204e:	5280           	addql #1,%d0
    2050:	23c0 0000 0000 	movel %d0,0x0
    2056:	2039 0000 0000 	movel 0x0,%d0
    205c:	723c           	moveq #60,%d1
    205e:	b280           	cmpl %d0,%d1
    2060:	6c28           	bges 0x208a
    2062:	2039 0000 0000 	movel 0x0,%d0
    2068:	74b8           	moveq #-72,%d2
    206a:	d082           	addl %d2,%d0
    206c:	7203           	moveq #3,%d1
    206e:	c081           	andl %d1,%d0
    2070:	4a80           	tstl %d0
    2072:	6616           	bnes 0x208a
    2074:	2039 0000 0000 	movel 0x0,%d0
    207a:	741e           	moveq #30,%d2
    207c:	b480           	cmpl %d0,%d2
    207e:	670a           	beqs 0x208a
    2080:	13fc 001d 0000 	moveb #29,0x0
    2086:	0000 
    2088:	6008           	bras 0x2092
    208a:	13fc 001c 0000 	moveb #28,0x0
    2090:	0000 
    2092:	2d79 0000 0000 	movel 0x0,%fp@(-4)
    2098:	fffc 
    209a:	70ff           	moveq #-1,%d0
    209c:	23c0 0000 0000 	movel %d0,0x0
    20a2:	6022           	bras 0x20c6
    20a4:	2039 0000 0000 	movel 0x0,%d0
    20aa:	5280           	addql #1,%d0
    20ac:	23c0 0000 0000 	movel %d0,0x0
    20b2:	2039 0000 0000 	movel 0x0,%d0
    20b8:	1030 09b0 0000 	moveb @(00000000,%d0:l),%d0
    20be:	0000 
    20c0:	49c0           	extbl %d0
    20c2:	91ae fffc      	subl %d0,%fp@(-4)
    20c6:	4aae fffc      	tstl %fp@(-4)
    20ca:	6cd8           	bges 0x20a4
    20cc:	2039 0000 0000 	movel 0x0,%d0
    20d2:	1030 09b0 0000 	moveb @(00000000,%d0:l),%d0
    20d8:	0000 
    20da:	49c0           	extbl %d0
    20dc:	d0ae fffc      	addl %fp@(-4),%d0
    20e0:	5280           	addql #1,%d0
    20e2:	23c0 0000 0000 	movel %d0,0x0
    20e8:	42b9 0000 0000 	clrl 0x0
    20ee:	203c 0000 0000 	movel #0,%d0
    20f4:	2200           	movel %d0,%d1
    20f6:	2041           	moveal %d1,%a0
    20f8:	241f           	movel %sp@+,%d2
    20fa:	4e5e           	unlk %fp
    20fc:	4e75           	rts
    20fe:	4e71           	nop
    2100:	4e56 fff8      	linkw %fp,#-8
    2104:	2039 0000 0000 	movel 0x0,%d0
    210a:	2d40 fffc      	movel %d0,%fp@(-4)
    210e:	6032           	bras 0x2142
    2110:	202e fffc      	movel %fp@(-4),%d0
    2114:	2040           	moveal %d0,%a0
    2116:	2028 000c      	movel %a0@(12),%d0
    211a:	7201           	moveq #1,%d1
    211c:	b280           	cmpl %d0,%d1
    211e:	6614           	bnes 0x2134
    2120:	202e fffc      	movel %fp@(-4),%d0
    2124:	2040           	moveal %d0,%a0
    2126:	2228 0004      	movel %a0@(4),%d1
    212a:	7010           	moveq #16,%d0
    212c:	d0ae 0008      	addl %fp@(8),%d0
    2130:	b081           	cmpl %d1,%d0
    2132:	6316           	blss 0x214a
    2134:	202e fffc      	movel %fp@(-4),%d0
    2138:	2040           	moveal %d0,%a0
    213a:	2028 0008      	movel %a0@(8),%d0
    213e:	2d40 fffc      	movel %d0,%fp@(-4)
    2142:	4aae fffc      	tstl %fp@(-4)
    2146:	66c8           	bnes 0x2110
    2148:	6002           	bras 0x214c
    214a:	4e71           	nop
    214c:	4aae fffc      	tstl %fp@(-4)
    2150:	6606           	bnes 0x2158
    2152:	4280           	clrl %d0
    2154:	6000 0088      	braw 0x21de
    2158:	202e fffc      	movel %fp@(-4),%d0
    215c:	d0ae 0008      	addl %fp@(8),%d0
    2160:	7210           	moveq #16,%d1
    2162:	d081           	addl %d1,%d0
    2164:	2d40 fff8      	movel %d0,%fp@(-8)
    2168:	202e fff8      	movel %fp@(-8),%d0
    216c:	7210           	moveq #16,%d1
    216e:	d280           	addl %d0,%d1
    2170:	202e fff8      	movel %fp@(-8),%d0
    2174:	2040           	moveal %d0,%a0
    2176:	2081           	movel %d1,%a0@
    2178:	202e fffc      	movel %fp@(-4),%d0
    217c:	2040           	moveal %d0,%a0
    217e:	2028 0004      	movel %a0@(4),%d0
    2182:	90ae 0008      	subl %fp@(8),%d0
    2186:	72f0           	moveq #-16,%d1
    2188:	d280           	addl %d0,%d1
    218a:	202e fff8      	movel %fp@(-8),%d0
    218e:	2040           	moveal %d0,%a0
    2190:	2141 0004      	movel %d1,%a0@(4)
    2194:	202e fffc      	movel %fp@(-4),%d0
    2198:	2040           	moveal %d0,%a0
    219a:	2228 0008      	movel %a0@(8),%d1
    219e:	202e fff8      	movel %fp@(-8),%d0
    21a2:	2040           	moveal %d0,%a0
    21a4:	2141 0008      	movel %d1,%a0@(8)
    21a8:	202e fff8      	movel %fp@(-8),%d0
    21ac:	7201           	moveq #1,%d1
    21ae:	2040           	moveal %d0,%a0
    21b0:	2141 000c      	movel %d1,%a0@(12)
    21b4:	202e fffc      	movel %fp@(-4),%d0
    21b8:	2040           	moveal %d0,%a0
    21ba:	216e fff8 0008 	movel %fp@(-8),%a0@(8)
    21c0:	202e fffc      	movel %fp@(-4),%d0
    21c4:	2040           	moveal %d0,%a0
    21c6:	42a8 000c      	clrl %a0@(12)
    21ca:	202e fffc      	movel %fp@(-4),%d0
    21ce:	2040           	moveal %d0,%a0
    21d0:	216e 0008 0004 	movel %fp@(8),%a0@(4)
    21d6:	202e fffc      	movel %fp@(-4),%d0
    21da:	2040           	moveal %d0,%a0
    21dc:	2010           	movel %a0@,%d0
    21de:	2200           	movel %d0,%d1
    21e0:	2041           	moveal %d1,%a0
    21e2:	4e5e           	unlk %fp
    21e4:	4e75           	rts
    21e6:	4e56 fff4      	linkw %fp,#-12
    21ea:	2039 0000 0000 	movel 0x0,%d0
    21f0:	2d40 fffc      	movel %d0,%fp@(-4)
    21f4:	42ae fff4      	clrl %fp@(-12)
    21f8:	2d6e fff4 fff8 	movel %fp@(-12),%fp@(-8)
    21fe:	6024           	bras 0x2224
    2200:	202e fffc      	movel %fp@(-4),%d0
    2204:	2040           	moveal %d0,%a0
    2206:	2210           	movel %a0@,%d1
    2208:	202e 0008      	movel %fp@(8),%d0
    220c:	b081           	cmpl %d1,%d0
    220e:	671c           	beqs 0x222c
    2210:	2d6e fffc fff8 	movel %fp@(-4),%fp@(-8)
    2216:	202e fffc      	movel %fp@(-4),%d0
    221a:	2040           	moveal %d0,%a0
    221c:	2028 0008      	movel %a0@(8),%d0
    2220:	2d40 fffc      	movel %d0,%fp@(-4)
    2224:	4aae fffc      	tstl %fp@(-4)
    2228:	66d6           	bnes 0x2200
    222a:	6002           	bras 0x222e
    222c:	4e71           	nop
    222e:	4aae fffc      	tstl %fp@(-4)
    2232:	6700 00c0      	beqw 0x22f4
    2236:	202e fffc      	movel %fp@(-4),%d0
    223a:	7201           	moveq #1,%d1
    223c:	2040           	moveal %d0,%a0
    223e:	2141 000c      	movel %d1,%a0@(12)
    2242:	202e fffc      	movel %fp@(-4),%d0
    2246:	2040           	moveal %d0,%a0
    2248:	2028 0008      	movel %a0@(8),%d0
    224c:	2d40 fff4      	movel %d0,%fp@(-12)
    2250:	4aae fff8      	tstl %fp@(-8)
    2254:	674e           	beqs 0x22a4
    2256:	202e fff8      	movel %fp@(-8),%d0
    225a:	2040           	moveal %d0,%a0
    225c:	2028 000c      	movel %a0@(12),%d0
    2260:	7201           	moveq #1,%d1
    2262:	b280           	cmpl %d0,%d1
    2264:	663e           	bnes 0x22a4
    2266:	202e fffc      	movel %fp@(-4),%d0
    226a:	2040           	moveal %d0,%a0
    226c:	2228 0008      	movel %a0@(8),%d1
    2270:	202e fff8      	movel %fp@(-8),%d0
    2274:	2040           	moveal %d0,%a0
    2276:	2141 0008      	movel %d1,%a0@(8)
    227a:	202e fff8      	movel %fp@(-8),%d0
    227e:	2040           	moveal %d0,%a0
    2280:	2228 0004      	movel %a0@(4),%d1
    2284:	202e fffc      	movel %fp@(-4),%d0
    2288:	2040           	moveal %d0,%a0
    228a:	2028 0004      	movel %a0@(4),%d0
    228e:	d081           	addl %d1,%d0
    2290:	7210           	moveq #16,%d1
    2292:	d280           	addl %d0,%d1
    2294:	202e fff8      	movel %fp@(-8),%d0
    2298:	2040           	moveal %d0,%a0
    229a:	2141 0004      	movel %d1,%a0@(4)
    229e:	2d6e fff8 fffc 	movel %fp@(-8),%fp@(-4)
    22a4:	4aae fff4      	tstl %fp@(-12)
    22a8:	674c           	beqs 0x22f6
    22aa:	202e fff4      	movel %fp@(-12),%d0
    22ae:	2040           	moveal %d0,%a0
    22b0:	2028 000c      	movel %a0@(12),%d0
    22b4:	7201           	moveq #1,%d1
    22b6:	b280           	cmpl %d0,%d1
    22b8:	663c           	bnes 0x22f6
    22ba:	202e fff4      	movel %fp@(-12),%d0
    22be:	2040           	moveal %d0,%a0
    22c0:	2228 0008      	movel %a0@(8),%d1
    22c4:	202e fffc      	movel %fp@(-4),%d0
    22c8:	2040           	moveal %d0,%a0
    22ca:	2141 0008      	movel %d1,%a0@(8)
    22ce:	202e fffc      	movel %fp@(-4),%d0
    22d2:	2040           	moveal %d0,%a0
    22d4:	2228 0004      	movel %a0@(4),%d1
    22d8:	202e fff4      	movel %fp@(-12),%d0
    22dc:	2040           	moveal %d0,%a0
    22de:	2028 0004      	movel %a0@(4),%d0
    22e2:	d081           	addl %d1,%d0
    22e4:	7210           	moveq #16,%d1
    22e6:	d280           	addl %d0,%d1
    22e8:	202e fffc      	movel %fp@(-4),%d0
    22ec:	2040           	moveal %d0,%a0
    22ee:	2141 0004      	movel %d1,%a0@(4)
    22f2:	6002           	bras 0x22f6
    22f4:	4e71           	nop
    22f6:	4e5e           	unlk %fp
    22f8:	4e75           	rts
    22fa:	4e56 0000      	linkw %fp,#0
    22fe:	4e5e           	unlk %fp
    2300:	4e75           	rts
    2302:	4e56 0000      	linkw %fp,#0
    2306:	2f02           	movel %d2,%sp@-
    2308:	2039 0000 0000 	movel 0x0,%d0
    230e:	2239 0000 0000 	movel 0x0,%d1
    2314:	9081           	subl %d1,%d0
    2316:	23c0 0000 0000 	movel %d0,0x0
    231c:	2039 0000 0000 	movel 0x0,%d0
    2322:	2239 0000 0000 	movel 0x0,%d1
    2328:	7410           	moveq #16,%d2
    232a:	d282           	addl %d2,%d1
    232c:	2040           	moveal %d0,%a0
    232e:	2081           	movel %d1,%a0@
    2330:	2039 0000 0000 	movel 0x0,%d0
    2336:	2239 0000 0000 	movel 0x0,%d1
    233c:	74f0           	moveq #-16,%d2
    233e:	d282           	addl %d2,%d1
    2340:	2040           	moveal %d0,%a0
    2342:	2141 0004      	movel %d1,%a0@(4)
    2346:	2039 0000 0000 	movel 0x0,%d0
    234c:	2040           	moveal %d0,%a0
    234e:	42a8 0008      	clrl %a0@(8)
    2352:	2039 0000 0000 	movel 0x0,%d0
    2358:	7201           	moveq #1,%d1
    235a:	2040           	moveal %d0,%a0
    235c:	2141 000c      	movel %d1,%a0@(12)
    2360:	241f           	movel %sp@+,%d2
    2362:	4e5e           	unlk %fp
    2364:	4e75           	rts
    2366:	4e56 0000      	linkw %fp,#0
    236a:	4eba ff96      	jsr %pc@(0x2302)
    236e:	4e5e           	unlk %fp
    2370:	4e75           	rts
    2372:	4e56 fff4      	linkw %fp,#-12
    2376:	2039 0000 0000 	movel 0x0,%d0
    237c:	2d40 fffc      	movel %d0,%fp@(-4)
    2380:	42ae fff8      	clrl %fp@(-8)
    2384:	42ae fff4      	clrl %fp@(-12)
    2388:	4879 0000 0000 	pea 0x0
    238e:	4eb9 0000 0000 	jsr 0x0
    2394:	588f           	addql #4,%sp
    2396:	4879 0000 0000 	pea 0x0
    239c:	4eb9 0000 0000 	jsr 0x0
    23a2:	588f           	addql #4,%sp
    23a4:	6000 00f6      	braw 0x249c
    23a8:	4879 0000 0000 	pea 0x0
    23ae:	4eb9 0000 0000 	jsr 0x0
    23b4:	588f           	addql #4,%sp
    23b6:	202e fff4      	movel %fp@(-12),%d0
    23ba:	1000           	moveb %d0,%d0
    23bc:	1000           	moveb %d0,%d0
    23be:	0280 0000 00ff 	andil #255,%d0
    23c4:	2f00           	movel %d0,%sp@-
    23c6:	4eb9 0000 0000 	jsr 0x0
    23cc:	588f           	addql #4,%sp
    23ce:	4879 0000 0000 	pea 0x0
    23d4:	4eb9 0000 0000 	jsr 0x0
    23da:	588f           	addql #4,%sp
    23dc:	202e fffc      	movel %fp@(-4),%d0
    23e0:	2040           	moveal %d0,%a0
    23e2:	2010           	movel %a0@,%d0
    23e4:	2f00           	movel %d0,%sp@-
    23e6:	4eb9 0000 0000 	jsr 0x0
    23ec:	588f           	addql #4,%sp
    23ee:	4879 0000 0000 	pea 0x0
    23f4:	4eb9 0000 0000 	jsr 0x0
    23fa:	588f           	addql #4,%sp
    23fc:	202e fffc      	movel %fp@(-4),%d0
    2400:	2040           	moveal %d0,%a0
    2402:	2028 0004      	movel %a0@(4),%d0
    2406:	2f00           	movel %d0,%sp@-
    2408:	4eb9 0000 0000 	jsr 0x0
    240e:	588f           	addql #4,%sp
    2410:	4879 0000 0000 	pea 0x0
    2416:	4eb9 0000 0000 	jsr 0x0
    241c:	588f           	addql #4,%sp
    241e:	202e fffc      	movel %fp@(-4),%d0
    2422:	2040           	moveal %d0,%a0
    2424:	2028 0008      	movel %a0@(8),%d0
    2428:	2f00           	movel %d0,%sp@-
    242a:	4eb9 0000 0000 	jsr 0x0
    2430:	588f           	addql #4,%sp
    2432:	4879 0000 0000 	pea 0x0
    2438:	4eb9 0000 0000 	jsr 0x0
    243e:	588f           	addql #4,%sp
    2440:	202e fffc      	movel %fp@(-4),%d0
    2444:	2040           	moveal %d0,%a0
    2446:	2028 000c      	movel %a0@(12),%d0
    244a:	1000           	moveb %d0,%d0
    244c:	1000           	moveb %d0,%d0
    244e:	0280 0000 00ff 	andil #255,%d0
    2454:	2f00           	movel %d0,%sp@-
    2456:	4eb9 0000 0000 	jsr 0x0
    245c:	588f           	addql #4,%sp
    245e:	4879 0000 0000 	pea 0x0
    2464:	4eb9 0000 0000 	jsr 0x0
    246a:	588f           	addql #4,%sp
    246c:	202e fffc      	movel %fp@(-4),%d0
    2470:	2040           	moveal %d0,%a0
    2472:	2028 0008      	movel %a0@(8),%d0
    2476:	2d40 fffc      	movel %d0,%fp@(-4)
    247a:	52ae fff8      	addql #1,%fp@(-8)
    247e:	52ae fff4      	addql #1,%fp@(-12)
    2482:	4aae fffc      	tstl %fp@(-4)
    2486:	670a           	beqs 0x2492
    2488:	7004           	moveq #4,%d0
    248a:	b0ae fff8      	cmpl %fp@(-8),%d0
    248e:	6c00 ff18      	bgew 0x23a8
    2492:	4eb9 0000 0000 	jsr 0x0
    2498:	42ae fff8      	clrl %fp@(-8)
    249c:	4aae fffc      	tstl %fp@(-4)
    24a0:	66e0           	bnes 0x2482
    24a2:	4879 0000 0000 	pea 0x0
    24a8:	4eb9 0000 0000 	jsr 0x0
    24ae:	588f           	addql #4,%sp
    24b0:	4e5e           	unlk %fp
    24b2:	4e75           	rts
    24b4:	48e7 0020      	moveml %a2,%sp@-
    24b8:	246f 0008      	moveal %sp@(8),%a2
    24bc:	48e7 00c0      	moveml %a0-%a1,%sp@-
    24c0:	4280           	clrl %d0
    24c2:	11fc 0000 ffe8 	moveb #0,0xffffffe8
    24c8:	1038 ffec      	moveb 0xffffffec,%d0
    24cc:	4cdf 0300      	moveml %sp@+,%a0-%a1
    24d0:	48e7 4000      	moveml %d1,%sp@-
    24d4:	2200           	movel %d0,%d1
    24d6:	0240 000f      	andiw #15,%d0
    24da:	e849           	lsrw #4,%d1
    24dc:	c2fc 000a      	muluw #10,%d1
    24e0:	d041           	addw %d1,%d0
    24e2:	4cdf 0002      	moveml %sp@+,%d1
    24e6:	2480           	movel %d0,%a2@
    24e8:	48e7 00c0      	moveml %a0-%a1,%sp@-
    24ec:	4280           	clrl %d0
    24ee:	11fc 0002 ffe8 	moveb #2,0xffffffe8
    24f4:	1038 ffec      	moveb 0xffffffec,%d0
    24f8:	4cdf 0300      	moveml %sp@+,%a0-%a1
    24fc:	48e7 4000      	moveml %d1,%sp@-
    2500:	2200           	movel %d0,%d1
    2502:	0240 000f      	andiw #15,%d0
    2506:	e849           	lsrw #4,%d1
    2508:	c2fc 000a      	muluw #10,%d1
    250c:	d041           	addw %d1,%d0
    250e:	4cdf 0002      	moveml %sp@+,%d1
    2512:	2540 0004      	movel %d0,%a2@(4)
    2516:	48e7 00c0      	moveml %a0-%a1,%sp@-
    251a:	4280           	clrl %d0
    251c:	11fc 0004 ffe8 	moveb #4,0xffffffe8
    2522:	1038 ffec      	moveb 0xffffffec,%d0
    2526:	4cdf 0300      	moveml %sp@+,%a0-%a1
    252a:	48e7 4000      	moveml %d1,%sp@-
    252e:	2200           	movel %d0,%d1
    2530:	0240 000f      	andiw #15,%d0
    2534:	e849           	lsrw #4,%d1
    2536:	c2fc 000a      	muluw #10,%d1
    253a:	d041           	addw %d1,%d0
    253c:	4cdf 0002      	moveml %sp@+,%d1
    2540:	2540 0008      	movel %d0,%a2@(8)
    2544:	48e7 00c0      	moveml %a0-%a1,%sp@-
    2548:	4280           	clrl %d0
    254a:	11fc 0007 ffe8 	moveb #7,0xffffffe8
    2550:	1038 ffec      	moveb 0xffffffec,%d0
    2554:	4cdf 0300      	moveml %sp@+,%a0-%a1
    2558:	48e7 4000      	moveml %d1,%sp@-
    255c:	2200           	movel %d0,%d1
    255e:	0240 000f      	andiw #15,%d0
    2562:	e849           	lsrw #4,%d1
    2564:	c2fc 000a      	muluw #10,%d1
    2568:	d041           	addw %d1,%d0
    256a:	4cdf 0002      	moveml %sp@+,%d1
    256e:	2540 000c      	movel %d0,%a2@(12)
    2572:	48e7 00c0      	moveml %a0-%a1,%sp@-
    2576:	4280           	clrl %d0
    2578:	11fc 0008 ffe8 	moveb #8,0xffffffe8
    257e:	1038 ffec      	moveb 0xffffffec,%d0
    2582:	4cdf 0300      	moveml %sp@+,%a0-%a1
    2586:	48e7 4000      	moveml %d1,%sp@-
    258a:	2200           	movel %d0,%d1
    258c:	0240 000f      	andiw #15,%d0
    2590:	e849           	lsrw #4,%d1
    2592:	c2fc 000a      	muluw #10,%d1
    2596:	d041           	addw %d1,%d0
    2598:	4cdf 0002      	moveml %sp@+,%d1
    259c:	5380           	subql #1,%d0
    259e:	2540 0010      	movel %d0,%a2@(16)
    25a2:	48e7 00c0      	moveml %a0-%a1,%sp@-
    25a6:	4280           	clrl %d0
    25a8:	11fc 0009 ffe8 	moveb #9,0xffffffe8
    25ae:	1038 ffec      	moveb 0xffffffec,%d0
    25b2:	4cdf 0300      	moveml %sp@+,%a0-%a1
    25b6:	48e7 4000      	moveml %d1,%sp@-
    25ba:	2200           	movel %d0,%d1
    25bc:	0240 000f      	andiw #15,%d0
    25c0:	e849           	lsrw #4,%d1
    25c2:	c2fc 000a      	muluw #10,%d1
    25c6:	d041           	addw %d1,%d0
    25c8:	4cdf 0002      	moveml %sp@+,%d1
    25cc:	2540 0014      	movel %d0,%a2@(20)
    25d0:	48e7 00c0      	moveml %a0-%a1,%sp@-
    25d4:	4280           	clrl %d0
    25d6:	11fc 0006 ffe8 	moveb #6,0xffffffe8
    25dc:	1038 ffec      	moveb 0xffffffec,%d0
    25e0:	4cdf 0300      	moveml %sp@+,%a0-%a1
    25e4:	48e7 4000      	moveml %d1,%sp@-
    25e8:	2200           	movel %d0,%d1
    25ea:	0240 000f      	andiw #15,%d0
    25ee:	e849           	lsrw #4,%d1
    25f0:	c2fc 000a      	muluw #10,%d1
    25f4:	d041           	addw %d1,%d0
    25f6:	4cdf 0002      	moveml %sp@+,%d1
    25fa:	2540 0018      	movel %d0,%a2@(24)
    25fe:	200a           	movel %a2,%d0
    2600:	4cdf 0400      	moveml %sp@+,%a2
    2604:	4e75           	rts
    2606:	41fb 0170 0000 	lea %pc@(0x2608),%a0
    260c:	0000 
    260e:	2010           	movel %a0@,%d0
    2610:	4e75           	rts
    2612:	41fb 0170 0000 	lea %pc@(0x2614),%a0
    2618:	0000 
    261a:	4250           	clrw %a0@
    261c:	41fb 0170 0000 	lea %pc@(0x261e),%a0
    2622:	0000 
    2624:	4250           	clrw %a0@
    2626:	41fb 0170 0000 	lea %pc@(0x2628),%a0
    262c:	0000 
    262e:	4250           	clrw %a0@
    2630:	41fb 0170 0000 	lea %pc@(0x2632),%a0
    2636:	0000 
    2638:	20b8 007c      	movel 0x7c,%a0@
    263c:	41fb 0170 0000 	lea %pc@(0x263e),%a0
    2642:	0000 
    2644:	20b8 0074      	movel 0x74,%a0@
    2648:	41fa 005e      	lea %pc@(0x26a8),%a0
    264c:	21c8 007c      	movel %a0,0x7c
    2650:	21c8 0074      	movel %a0,0x74
    2654:	41fb 0170 0000 	lea %pc@(0x2656),%a0
    265a:	0000 
    265c:	10bc 0000      	moveb #0,%a0@
    2660:	41f8 ffd0      	lea 0xffffffd0,%a0
    2664:	43f8 ffd4      	lea 0xffffffd4,%a1
    2668:	45f8 ffd8      	lea 0xffffffd8,%a2
    266c:	10bc 0004      	moveb #4,%a0@
    2670:	12bc 0003      	moveb #3,%a1@
    2674:	14bc 00e8      	moveb #-24,%a2@
    2678:	10bc 0081      	moveb #-127,%a0@
    267c:	027c f8ff      	andiw #-1793,%sr
    2680:	4e75           	rts
    2682:	41f8 ffd0      	lea 0xffffffd0,%a0
    2686:	10bc 0000      	moveb #0,%a0@
    268a:	007c 0700      	oriw #1792,%sr
    268e:	41fb 0170 0000 	lea %pc@(0x2690),%a0
    2694:	0000 
    2696:	21d0 007c      	movel %a0@,0x7c
    269a:	41fb 0170 0000 	lea %pc@(0x269c),%a0
    26a0:	0000 
    26a2:	21d0 0074      	movel %a0@,0x74
    26a6:	4e75           	rts
    26a8:	48e7 fffe      	moveml %d0-%fp,%sp@-
    26ac:	40e7           	movew %sr,%sp@-
    26ae:	007c 0700      	oriw #1792,%sr
    26b2:	41fb 0170 0000 	lea %pc@(0x26b4),%a0
    26b8:	0000 
    26ba:	5290           	addql #1,%a0@
    26bc:	1038 fda0      	moveb 0xfffffda0,%d0
    26c0:	6b68           	bmis 0x272a
    26c2:	0c00 0003      	cmpib #3,%d0
    26c6:	6630           	bnes 0x26f8
    26c8:	4a38 fda4      	tstb 0xfffffda4
    26cc:	48e7 fffe      	moveml %d0-%fp,%sp@-
    26d0:	41fb 0170 0000 	lea %pc@(0x26d2),%a0
    26d6:	0000 
    26d8:	1018           	moveb %a0@+,%d0
    26da:	6700 000a      	beqw 0x26e6
    26de:	7e21           	moveq #33,%d7
    26e0:	4e41           	trap #1
    26e2:	6000 fff4      	braw 0x26d8
    26e6:	4cdf 7fff      	moveml %sp@+,%d0-%fp
    26ea:	2f3c 0000 0015 	movel #21,%sp@-
    26f0:	6100 0000      	bsrw 0x26f2
    26f4:	6000 0034      	braw 0x272a
    26f8:	41fb 0170 0000 	lea %pc@(0x26fa),%a0
    26fe:	0000 
    2700:	43fb 0170 0000 	lea %pc@(0x2702),%a1
    2706:	0000 
    2708:	45fb 0170 0000 	lea %pc@(0x270a),%a2
    270e:	0000 
    2710:	0c51 0100      	cmpiw #256,%a1@
    2714:	6c14           	bges 0x272a
    2716:	5251           	addqw #1,%a1@
    2718:	3212           	movew %a2@,%d1
    271a:	1180 1000      	moveb %d0,%a0@(00000000,%d1:w)
    271e:	4a38 fda4      	tstb 0xfffffda4
    2722:	5241           	addqw #1,%d1
    2724:	0241 00ff      	andiw #255,%d1
    2728:	3481           	movew %d1,%a2@
    272a:	41f8 ffd0      	lea 0xffffffd0,%a0
    272e:	10bc 0081      	moveb #-127,%a0@
    2732:	46df           	movew %sp@+,%sr
    2734:	4cdf 7fff      	moveml %sp@+,%d0-%fp
    2738:	4e73           	rte
    273a:	48e7 0002      	moveml %fp,%sp@-
    273e:	206f 0008      	moveal %sp@(8),%a0
    2742:	7e5c           	moveq #92,%d7
    2744:	4e46           	trap #6
    2746:	4cdf 4000      	moveml %sp@+,%fp
    274a:	7000           	moveq #0,%d0
    274c:	4e75           	rts
    274e:	7000           	moveq #0,%d0
    2750:	4e75           	rts
    2752:	48e7 41e0      	moveml %d1/%d7-%a2,%sp@-
    2756:	41fb 0170 0000 	lea %pc@(0x2758),%a0
    275c:	0000 
    275e:	43fb 0170 0000 	lea %pc@(0x2760),%a1
    2764:	0000 
    2766:	45fb 0170 0000 	lea %pc@(0x2768),%a2
    276c:	0000 
    276e:	3e3c 003d      	movew #61,%d7
    2772:	4e41           	trap #1
    2774:	3e3c 003c      	movew #60,%d7
    2778:	4e41           	trap #1
    277a:	4a51           	tstw %a1@
    277c:	67f6           	beqs 0x2774
    277e:	3212           	movew %a2@,%d1
    2780:	1030 1000      	moveb %a0@(00000000,%d1:w),%d0
    2784:	5241           	addqw #1,%d1
    2786:	0241 00ff      	andiw #255,%d1
    278a:	3481           	movew %d1,%a2@
    278c:	5351           	subqw #1,%a1@
    278e:	3e3c 003e      	movew #62,%d7
    2792:	4e41           	trap #1
    2794:	4cdf 0782      	moveml %sp@+,%d1/%d7-%a2
    2798:	4e75           	rts
    279a:	48e7 41e0      	moveml %d1/%d7-%a2,%sp@-
    279e:	41fb 0170 0000 	lea %pc@(0x27a0),%a0
    27a4:	0000 
    27a6:	43fb 0170 0000 	lea %pc@(0x27a8),%a1
    27ac:	0000 
    27ae:	45fb 0170 0000 	lea %pc@(0x27b0),%a2
    27b4:	0000 
    27b6:	4a51           	tstw %a1@
    27b8:	67fc           	beqs 0x27b6
    27ba:	3212           	movew %a2@,%d1
    27bc:	1030 1000      	moveb %a0@(00000000,%d1:w),%d0
    27c0:	5241           	addqw #1,%d1
    27c2:	0241 00ff      	andiw #255,%d1
    27c6:	3481           	movew %d1,%a2@
    27c8:	5351           	subqw #1,%a1@
    27ca:	4cdf 0782      	moveml %sp@+,%d1/%d7-%a2
    27ce:	4e75           	rts
    27d0:	43fb 0170 0000 	lea %pc@(0x27d2),%a1
    27d6:	0000 
    27d8:	3011           	movew %a1@,%d0
    27da:	4e75           	rts
    27dc:	41fb 0170 0000 	lea %pc@(0x27de),%a0
    27e2:	0000 
    27e4:	43fb 0170 0000 	lea %pc@(0x27e6),%a1
    27ea:	0000 
    27ec:	22c8           	movel %a0,%a1@+
    27ee:	22c8           	movel %a0,%a1@+
    27f0:	41fb 0170 0000 	lea %pc@(0x27f2),%a0
    27f6:	0000 
    27f8:	22c8           	movel %a0,%a1@+
    27fa:	23fc 0000 000a 	movel #10,0x0
    2800:	0000 0000 
    2804:	4e75           	rts
    2806:	206f 0004      	moveal %sp@(4),%a0
    280a:	202f 0008      	movel %sp@(8),%d0
    280e:	4e75           	rts
    2810:	206f 0004      	moveal %sp@(4),%a0
    2814:	202f 0008      	movel %sp@(8),%d0
    2818:	4e75           	rts
    281a:	202f 0004      	movel %sp@(4),%d0
    281e:	4e75           	rts
    2820:	202f 0004      	movel %sp@(4),%d0
    2824:	4e75           	rts
    2826:	222f 0004      	movel %sp@(4),%d1
    282a:	4280           	clrl %d0
    282c:	0801 0001      	btst #1,%d1
    2830:	6700 000e      	beqw 0x2840
    2834:	5240           	addqw #1,%d0
    2836:	0801 0002      	btst #2,%d1
    283a:	6700 0004      	beqw 0x2840
    283e:	5240           	addqw #1,%d0
    2840:	4e75           	rts
    2842:	2f02           	movel %d2,%sp@-
    2844:	202f 0008      	movel %sp@(8),%d0
    2848:	222f 000c      	movel %sp@(12),%d1
    284c:	242f 0010      	movel %sp@(16),%d2
    2850:	241f           	movel %sp@+,%d2
    2852:	4e75           	rts
    2854:	4e75           	rts
    2856:	4e75           	rts
    2858:	4e73           	rte
    285a:	4e73           	rte
    285c:	48e7 3f3e      	moveml %d2-%d7/%a2-%fp,%sp@-
    2860:	202f 0034      	movel %sp@(52),%d0
    2864:	222f 0038      	movel %sp@(56),%d1
    2868:	242f 0030      	movel %sp@(48),%d2
    286c:	0c82 0000 0001 	cmpil #1,%d2
    2872:	6700 0010      	beqw 0x2884
    2876:	0c82 0000 0002 	cmpil #2,%d2
    287c:	6700 0006      	beqw 0x2884
    2880:	6000 0018      	braw 0x289a
    2884:	2040           	moveal %d0,%a0
    2886:	5381           	subql #1,%d1
    2888:	1018           	moveb %a0@+,%d0
    288a:	7e21           	moveq #33,%d7
    288c:	4e41           	trap #1
    288e:	51c9 fff8      	dbf %d1,0x2888
    2892:	202f 0038      	movel %sp@(56),%d0
    2896:	6000 001c      	braw 0x28b4
    289a:	2f01           	movel %d1,%sp@-
    289c:	2f00           	movel %d0,%sp@-
    289e:	2f02           	movel %d2,%sp@-
    28a0:	4ebb 0170 0000 	jsr %pc@(0x28a2)
    28a6:	0000 
    28a8:	dffc 0000 000c 	addal #12,%sp
    28ae:	6000 0004      	braw 0x28b4
    28b2:	4280           	clrl %d0
    28b4:	4cdf 7cfc      	moveml %sp@+,%d2-%d7/%a2-%fp
    28b8:	4e75           	rts
    28ba:	48e7 3f3e      	moveml %d2-%d7/%a2-%fp,%sp@-
    28be:	202f 0034      	movel %sp@(52),%d0
    28c2:	222f 0038      	movel %sp@(56),%d1
    28c6:	242f 0030      	movel %sp@(48),%d2
    28ca:	0c82 0000 0001 	cmpil #1,%d2
    28d0:	6700 0006      	beqw 0x28d8
    28d4:	6000 0018      	braw 0x28ee
    28d8:	2040           	moveal %d0,%a0
    28da:	5381           	subql #1,%d1
    28dc:	6100 0000      	bsrw 0x28de
    28e0:	10c0           	moveb %d0,%a0@+
    28e2:	51c9 fff8      	dbf %d1,0x28dc
    28e6:	202f 0038      	movel %sp@(56),%d0
    28ea:	6000 001c      	braw 0x2908
    28ee:	2f01           	movel %d1,%sp@-
    28f0:	2f00           	movel %d0,%sp@-
    28f2:	2f02           	movel %d2,%sp@-
    28f4:	4ebb 0170 0000 	jsr %pc@(0x28f6)
    28fa:	0000 
    28fc:	dffc 0000 000c 	addal #12,%sp
    2902:	6000 0004      	braw 0x2908
    2906:	4280           	clrl %d0
    2908:	4cdf 7cfc      	moveml %sp@+,%d2-%d7/%a2-%fp
    290c:	4e75           	rts
    290e:	4e71           	nop
    2910:	48e7 fffe      	moveml %d0-%fp,%sp@-
    2914:	7e14           	moveq #20,%d7
    2916:	4e41           	trap #1
    2918:	4cdf 7fff      	moveml %sp@+,%d0-%fp
    291c:	4e75           	rts
    291e:	7e0d           	moveq #13,%d7
    2920:	4e41           	trap #1
    2922:	4e75           	rts
    2924:	48e7 fffe      	moveml %d0-%fp,%sp@-
    2928:	206f 0040      	moveal %sp@(64),%a0
    292c:	1018           	moveb %a0@+,%d0
    292e:	6700 001a      	beqw 0x294a
    2932:	0c00 000a      	cmpib #10,%d0
    2936:	6600 000a      	bnew 0x2942
    293a:	700d           	moveq #13,%d0
    293c:	7e21           	moveq #33,%d7
    293e:	4e41           	trap #1
    2940:	700a           	moveq #10,%d0
    2942:	7e21           	moveq #33,%d7
    2944:	4e41           	trap #1
    2946:	6000 ffe4      	braw 0x292c
    294a:	4cdf 7fff      	moveml %sp@+,%d0-%fp
    294e:	4e75           	rts
    2950:	48e7 fffe      	moveml %d0-%fp,%sp@-
    2954:	206f 0040      	moveal %sp@(64),%a0
    2958:	226f 0044      	moveal %sp@(68),%a1
    295c:	7e65           	moveq #101,%d7
    295e:	4e41           	trap #1
    2960:	1081           	moveb %d1,%a0@
    2962:	1282           	moveb %d2,%a1@
    2964:	4cdf 7fff      	moveml %sp@+,%d0-%fp
    2968:	4e75           	rts
    296a:	48e7 fffe      	moveml %d0-%fp,%sp@-
    296e:	122f 0043      	moveb %sp@(67),%d1
    2972:	142f 0047      	moveb %sp@(71),%d2
    2976:	7e66           	moveq #102,%d7
    2978:	4e41           	trap #1
    297a:	4cdf 7fff      	moveml %sp@+,%d0-%fp
    297e:	4e75           	rts
    2980:	102f 0007      	moveb %sp@(7),%d0
    2984:	41fb 0170 0000 	lea %pc@(0x2986),%a0
    298a:	0000 
    298c:	7e29           	moveq #41,%d7
    298e:	4e41           	trap #1
    2990:	48e7 fffe      	moveml %d0-%fp,%sp@-
    2994:	41fb 0170 0000 	lea %pc@(0x2996),%a0
    299a:	0000 
    299c:	1018           	moveb %a0@+,%d0
    299e:	6700 000a      	beqw 0x29aa
    29a2:	7e21           	moveq #33,%d7
    29a4:	4e41           	trap #1
    29a6:	6000 fff4      	braw 0x299c
    29aa:	4cdf 7fff      	moveml %sp@+,%d0-%fp
    29ae:	4e75           	rts
    29b0:	202f 0004      	movel %sp@(4),%d0
    29b4:	41fb 0170 0000 	lea %pc@(0x29b6),%a0
    29ba:	0000 
    29bc:	7e2c           	moveq #44,%d7
    29be:	4e41           	trap #1
    29c0:	48e7 fffe      	moveml %d0-%fp,%sp@-
    29c4:	41fb 0170 0000 	lea %pc@(0x29c6),%a0
    29ca:	0000 
    29cc:	1018           	moveb %a0@+,%d0
    29ce:	6700 000a      	beqw 0x29da
    29d2:	7e21           	moveq #33,%d7
    29d4:	4e41           	trap #1
    29d6:	6000 fff4      	braw 0x29cc
    29da:	4cdf 7fff      	moveml %sp@+,%d0-%fp
    29de:	4e75           	rts
    29e0:	202f 0004      	movel %sp@(4),%d0
    29e4:	41fb 0170 0000 	lea %pc@(0x29e6),%a0
    29ea:	0000 
    29ec:	7e46           	moveq #70,%d7
    29ee:	4e41           	trap #1
    29f0:	48e7 fffe      	moveml %d0-%fp,%sp@-
    29f4:	41fb 0170 0000 	lea %pc@(0x29f6),%a0
    29fa:	0000 
    29fc:	1018           	moveb %a0@+,%d0
    29fe:	6700 000a      	beqw 0x2a0a
    2a02:	7e21           	moveq #33,%d7
    2a04:	4e41           	trap #1
    2a06:	6000 fff4      	braw 0x29fc
    2a0a:	4cdf 7fff      	moveml %sp@+,%d0-%fp
    2a0e:	4e75           	rts
    2a10:	48e7 7ffe      	moveml %d1-%fp,%sp@-
    2a14:	7e0c           	moveq #12,%d7
    2a16:	4e41           	trap #1
    2a18:	4cdf 7ffe      	moveml %sp@+,%d1-%fp
    2a1c:	4e75           	rts
    2a1e:	102f 0007      	moveb %sp@(7),%d0
    2a22:	6700 0016      	beqw 0x2a3a
    2a26:	0c00 000a      	cmpib #10,%d0
    2a2a:	6600 000a      	bnew 0x2a36
    2a2e:	700d           	moveq #13,%d0
    2a30:	7e21           	moveq #33,%d7
    2a32:	4e41           	trap #1
    2a34:	700a           	moveq #10,%d0
    2a36:	7e21           	moveq #33,%d7
    2a38:	4e41           	trap #1
    2a3a:	4e75           	rts
    2a3c:	7e52           	moveq #82,%d7
    2a3e:	4e41           	trap #1
    2a40:	4e75           	rts
    2a42:	7e51           	moveq #81,%d7
    2a44:	4e41           	trap #1
    2a46:	4e75           	rts
    2a48:	4280           	clrl %d0
    2a4a:	4281           	clrl %d1
    2a4c:	102f 0007      	moveb %sp@(7),%d0
    2a50:	122f 000b      	moveb %sp@(11),%d1
    2a54:	7e22           	moveq #34,%d7
    2a56:	4e41           	trap #1
    2a58:	4e75           	rts
    2a5a:	4280           	clrl %d0
    2a5c:	4281           	clrl %d1
    2a5e:	102f 0007      	moveb %sp@(7),%d0
    2a62:	122f 000b      	moveb %sp@(11),%d1
    2a66:	7e1b           	moveq #27,%d7
    2a68:	4e41           	trap #1
    2a6a:	4e75           	rts
    2a6c:	48e7 0002      	moveml %fp,%sp@-
    2a70:	206f 000c      	moveal %sp@(12),%a0
    2a74:	7e0b           	moveq #11,%d7
    2a76:	4e46           	trap #6
    2a78:	226f 0008      	moveal %sp@(8),%a1
    2a7c:	206f 000c      	moveal %sp@(12),%a0
    2a80:	7e12           	moveq #18,%d7
    2a82:	4e46           	trap #6
    2a84:	4cdf 4000      	moveml %sp@+,%fp
    2a88:	4e75           	rts
    2a8a:	48e7 0002      	moveml %fp,%sp@-
    2a8e:	226f 0008      	moveal %sp@(8),%a1
    2a92:	7e13           	moveq #19,%d7
    2a94:	4e46           	trap #6
    2a96:	4cdf 4000      	moveml %sp@+,%fp
    2a9a:	4e75           	rts
    2a9c:	48e7 0002      	moveml %fp,%sp@-
    2aa0:	226f 0008      	moveal %sp@(8),%a1
    2aa4:	7e10           	moveq #16,%d7
    2aa6:	4e46           	trap #6
    2aa8:	4cdf 4000      	moveml %sp@+,%fp
    2aac:	4e75           	rts
    2aae:	48e7 0002      	moveml %fp,%sp@-
    2ab2:	226f 0008      	moveal %sp@(8),%a1
    2ab6:	7e0e           	moveq #14,%d7
    2ab8:	4e46           	trap #6
    2aba:	4cdf 4000      	moveml %sp@+,%fp
    2abe:	4e75           	rts
    2ac0:	48e7 0002      	moveml %fp,%sp@-
    2ac4:	226f 0008      	moveal %sp@(8),%a1
    2ac8:	7e11           	moveq #17,%d7
    2aca:	4e46           	trap #6
    2acc:	4cdf 4000      	moveml %sp@+,%fp
    2ad0:	4e75           	rts
    2ad2:	48e7 0002      	moveml %fp,%sp@-
    2ad6:	226f 0008      	moveal %sp@(8),%a1
    2ada:	7e14           	moveq #20,%d7
    2adc:	4e46           	trap #6
    2ade:	4cdf 4000      	moveml %sp@+,%fp
    2ae2:	4e75           	rts
    2ae4:	48e7 0002      	moveml %fp,%sp@-
    2ae8:	226f 0008      	moveal %sp@(8),%a1
    2aec:	7e17           	moveq #23,%d7
    2aee:	4e46           	trap #6
    2af0:	4cdf 4000      	moveml %sp@+,%fp
    2af4:	4e75           	rts
    2af6:	48e7 0002      	moveml %fp,%sp@-
    2afa:	226f 0008      	moveal %sp@(8),%a1
    2afe:	222f 000c      	movel %sp@(12),%d1
    2b02:	7e5d           	moveq #93,%d7
    2b04:	4e46           	trap #6
    2b06:	4cdf 4000      	moveml %sp@+,%fp
    2b0a:	4e75           	rts
    2b0c:	48e7 0002      	moveml %fp,%sp@-
    2b10:	226f 0008      	moveal %sp@(8),%a1
    2b14:	206f 000c      	moveal %sp@(12),%a0
    2b18:	2348 002c      	movel %a0,%a1@(44)
    2b1c:	4cdf 4000      	moveml %sp@+,%fp
    2b20:	4e75           	rts
    2b22:	48e7 fffe      	moveml %d0-%fp,%sp@-
    2b26:	200f           	movel %sp,%d0
    2b28:	41fb 0170 0000 	lea %pc@(0x2b2a),%a0
    2b2e:	0000 
    2b30:	7e2c           	moveq #44,%d7
    2b32:	4e41           	trap #1
    2b34:	4cdf 7fff      	moveml %sp@+,%d0-%fp
    2b38:	48e7 fffe      	moveml %d0-%fp,%sp@-
    2b3c:	41fb 0170 0000 	lea %pc@(0x2b3e),%a0
    2b42:	0000 
    2b44:	1018           	moveb %a0@+,%d0
    2b46:	6700 000a      	beqw 0x2b52
    2b4a:	7e21           	moveq #33,%d7
    2b4c:	4e41           	trap #1
    2b4e:	6000 fff4      	braw 0x2b44
    2b52:	4cdf 7fff      	moveml %sp@+,%d0-%fp
    2b56:	48e7 fffe      	moveml %d0-%fp,%sp@-
    2b5a:	7e63           	moveq #99,%d7
    2b5c:	4e41           	trap #1
    2b5e:	4cdf 7fff      	moveml %sp@+,%d0-%fp
    2b62:	4e75           	rts
    2b64:	4280           	clrl %d0
    2b66:	102f 0007      	moveb %sp@(7),%d0
    2b6a:	48e7 4000      	moveml %d1,%sp@-
    2b6e:	2200           	movel %d0,%d1
    2b70:	0240 000f      	andiw #15,%d0
    2b74:	e849           	lsrw #4,%d1
    2b76:	c2fc 000a      	muluw #10,%d1
    2b7a:	d041           	addw %d1,%d0
    2b7c:	4cdf 0002      	moveml %sp@+,%d1
    2b80:	4e75           	rts
    2b82:	4280           	clrl %d0
    2b84:	102f 0007      	moveb %sp@(7),%d0
    2b88:	48e7 4000      	moveml %d1,%sp@-
    2b8c:	0280 0000 00ff 	andil #255,%d0
    2b92:	80fc 000a      	divuw #10,%d0
    2b96:	3200           	movew %d0,%d1
    2b98:	e949           	lslw #4,%d1
    2b9a:	4840           	swap %d0
    2b9c:	d240           	addw %d0,%d1
    2b9e:	c141           	exg %d0,%d1
    2ba0:	4cdf 0002      	moveml %sp@+,%d1
    2ba4:	4e75           	rts
    2ba6:	122f 0007      	moveb %sp@(7),%d1
    2baa:	48e7 00c0      	moveml %a0-%a1,%sp@-
    2bae:	4280           	clrl %d0
    2bb0:	11c1 ffe8      	moveb %d1,0xffffffe8
    2bb4:	1038 ffec      	moveb 0xffffffec,%d0
    2bb8:	4cdf 0300      	moveml %sp@+,%a0-%a1
    2bbc:	4e75           	rts
    2bbe:	4e71           	nop
    2bc0:	4e56 fffc      	linkw %fp,#-4
    2bc4:	2f2e 0008      	movel %fp@(8),%sp@-
    2bc8:	4eb9 0000 0000 	jsr 0x0
    2bce:	588f           	addql #4,%sp
    2bd0:	2d48 fffc      	movel %a0,%fp@(-4)
    2bd4:	202e fffc      	movel %fp@(-4),%d0
    2bd8:	2040           	moveal %d0,%a0
    2bda:	2028 0008      	movel %a0@(8),%d0
    2bde:	7217           	moveq #23,%d1
    2be0:	b280           	cmpl %d0,%d1
    2be2:	6c00 00ac      	bgew 0x2c90
    2be6:	202e fffc      	movel %fp@(-4),%d0
    2bea:	2040           	moveal %d0,%a0
    2bec:	2028 0008      	movel %a0@(8),%d0
    2bf0:	72e8           	moveq #-24,%d1
    2bf2:	d280           	addl %d0,%d1
    2bf4:	202e fffc      	movel %fp@(-4),%d0
    2bf8:	2040           	moveal %d0,%a0
    2bfa:	2141 0008      	movel %d1,%a0@(8)
    2bfe:	202e fffc      	movel %fp@(-4),%d0
    2c02:	2040           	moveal %d0,%a0
    2c04:	2028 000c      	movel %a0@(12),%d0
    2c08:	2200           	movel %d0,%d1
    2c0a:	5281           	addql #1,%d1
    2c0c:	202e fffc      	movel %fp@(-4),%d0
    2c10:	2040           	moveal %d0,%a0
    2c12:	2141 000c      	movel %d1,%a0@(12)
    2c16:	202e fffc      	movel %fp@(-4),%d0
    2c1a:	2040           	moveal %d0,%a0
    2c1c:	2028 0010      	movel %a0@(16),%d0
    2c20:	1030 09b0 0000 	moveb @(00000000,%d0:l),%d0
    2c26:	0000 
    2c28:	49c0           	extbl %d0
    2c2a:	222e fffc      	movel %fp@(-4),%d1
    2c2e:	2041           	moveal %d1,%a0
    2c30:	2228 000c      	movel %a0@(12),%d1
    2c34:	b280           	cmpl %d0,%d1
    2c36:	6f58           	bles 0x2c90
    2c38:	202e fffc      	movel %fp@(-4),%d0
    2c3c:	2040           	moveal %d0,%a0
    2c3e:	2028 0010      	movel %a0@(16),%d0
    2c42:	2200           	movel %d0,%d1
    2c44:	5281           	addql #1,%d1
    2c46:	202e fffc      	movel %fp@(-4),%d0
    2c4a:	2040           	moveal %d0,%a0
    2c4c:	2141 0010      	movel %d1,%a0@(16)
    2c50:	202e fffc      	movel %fp@(-4),%d0
    2c54:	7201           	moveq #1,%d1
    2c56:	2040           	moveal %d0,%a0
    2c58:	2141 000c      	movel %d1,%a0@(12)
    2c5c:	202e fffc      	movel %fp@(-4),%d0
    2c60:	2040           	moveal %d0,%a0
    2c62:	2028 0010      	movel %a0@(16),%d0
    2c66:	720c           	moveq #12,%d1
    2c68:	b280           	cmpl %d0,%d1
    2c6a:	6c24           	bges 0x2c90
    2c6c:	202e fffc      	movel %fp@(-4),%d0
    2c70:	7201           	moveq #1,%d1
    2c72:	2040           	moveal %d0,%a0
    2c74:	2141 0010      	movel %d1,%a0@(16)
    2c78:	202e fffc      	movel %fp@(-4),%d0
    2c7c:	2040           	moveal %d0,%a0
    2c7e:	2028 0014      	movel %a0@(20),%d0
    2c82:	2200           	movel %d0,%d1
    2c84:	5281           	addql #1,%d1
    2c86:	202e fffc      	movel %fp@(-4),%d0
    2c8a:	2040           	moveal %d0,%a0
    2c8c:	2141 0014      	movel %d1,%a0@(20)
    2c90:	202e fffc      	movel %fp@(-4),%d0
    2c94:	2200           	movel %d0,%d1
    2c96:	2041           	moveal %d1,%a0
    2c98:	4e5e           	unlk %fp
    2c9a:	4e75           	rts
    2c9c:	4e56 0000      	linkw %fp,#0
    2ca0:	2f2e 0008      	movel %fp@(8),%sp@-
    2ca4:	4eb9 0000 0000 	jsr 0x0
    2caa:	588f           	addql #4,%sp
    2cac:	2008           	movel %a0,%d0
    2cae:	2200           	movel %d0,%d1
    2cb0:	2041           	moveal %d1,%a0
    2cb2:	4e5e           	unlk %fp
    2cb4:	4e75           	rts
    2cb6:	4e71           	nop
    2cb8:	4e56 0000      	linkw %fp,#0
    2cbc:	42b9 0000 0000 	clrl 0x0
    2cc2:	203c 0000 0000 	movel #0,%d0
    2cc8:	223c 0000 0000 	movel #0,%d1
    2cce:	2041           	moveal %d1,%a0
    2cd0:	2240           	moveal %d0,%a1
    2cd2:	2091           	movel %a1@,%a0@
    2cd4:	5881           	addql #4,%d1
    2cd6:	5880           	addql #4,%d0
    2cd8:	2041           	moveal %d1,%a0
    2cda:	2240           	moveal %d0,%a1
    2cdc:	2091           	movel %a1@,%a0@
    2cde:	5881           	addql #4,%d1
    2ce0:	5880           	addql #4,%d0
    2ce2:	2041           	moveal %d1,%a0
    2ce4:	2240           	moveal %d0,%a1
    2ce6:	2091           	movel %a1@,%a0@
    2ce8:	5881           	addql #4,%d1
    2cea:	5880           	addql #4,%d0
    2cec:	4e5e           	unlk %fp
    2cee:	4e75           	rts
    2cf0:	4e56 fff4      	linkw %fp,#-12
    2cf4:	2f02           	movel %d2,%sp@-
    2cf6:	202e 000c      	movel %fp@(12),%d0
    2cfa:	2040           	moveal %d0,%a0
    2cfc:	4290           	clrl %a0@
    2cfe:	202e 0008      	movel %fp@(8),%d0
    2d02:	2240           	moveal %d0,%a1
    2d04:	2011           	movel %a1@,%d0
    2d06:	2040           	moveal %d0,%a0
    2d08:	1010           	moveb %a0@,%d0
    2d0a:	4a00           	tstb %d0
    2d0c:	6606           	bnes 0x2d14
    2d0e:	4280           	clrl %d0
    2d10:	6000 02f4      	braw 0x3006
    2d14:	2039 0000 0000 	movel 0x0,%d0
    2d1a:	4a80           	tstl %d0
    2d1c:	6772           	beqs 0x2d90
    2d1e:	2039 0000 0000 	movel 0x0,%d0
    2d24:	5380           	subql #1,%d0
    2d26:	23c0 0000 0000 	movel %d0,0x0
    2d2c:	1039 0000 0000 	moveb 0x0,%d0
    2d32:	1200           	moveb %d0,%d1
    2d34:	49c1           	extbl %d1
    2d36:	1039 0000 0000 	moveb 0x0,%d0
    2d3c:	49c0           	extbl %d0
    2d3e:	ef88           	lsll #7,%d0
    2d40:	d280           	addl %d0,%d1
    2d42:	1039 0000 0000 	moveb 0x0,%d0
    2d48:	49c0           	extbl %d0
    2d4a:	740b           	moveq #11,%d2
    2d4c:	e5a8           	lsll %d2,%d0
    2d4e:	d280           	addl %d0,%d1
    2d50:	1039 0000 0000 	moveb 0x0,%d0
    2d56:	49c0           	extbl %d0
    2d58:	4840           	swap %d0
    2d5a:	4240           	clrw %d0
    2d5c:	d280           	addl %d0,%d1
    2d5e:	1039 0000 0000 	moveb 0x0,%d0
    2d64:	49c0           	extbl %d0
    2d66:	7414           	moveq #20,%d2
    2d68:	e5a8           	lsll %d2,%d0
    2d6a:	d280           	addl %d0,%d1
    2d6c:	1039 0000 0000 	moveb 0x0,%d0
    2d72:	49c0           	extbl %d0
    2d74:	7418           	moveq #24,%d2
    2d76:	e5a8           	lsll %d2,%d0
    2d78:	d280           	addl %d0,%d1
    2d7a:	1039 0000 0000 	moveb 0x0,%d0
    2d80:	49c0           	extbl %d0
    2d82:	741c           	moveq #28,%d2
    2d84:	e5a8           	lsll %d2,%d0
    2d86:	d081           	addl %d1,%d0
    2d88:	2d40 fffc      	movel %d0,%fp@(-4)
    2d8c:	6000 0274      	braw 0x3002
    2d90:	202e 0008      	movel %fp@(8),%d0
    2d94:	2040           	moveal %d0,%a0
    2d96:	2010           	movel %a0@,%d0
    2d98:	2240           	moveal %d0,%a1
    2d9a:	1d51 fff7      	moveb %a1@,%fp@(-9)
    2d9e:	2200           	movel %d0,%d1
    2da0:	5281           	addql #1,%d1
    2da2:	202e 0008      	movel %fp@(8),%d0
    2da6:	2040           	moveal %d0,%a0
    2da8:	2081           	movel %d1,%a0@
    2daa:	202e 000c      	movel %fp@(12),%d0
    2dae:	2240           	moveal %d0,%a1
    2db0:	2011           	movel %a1@,%d0
    2db2:	2200           	movel %d0,%d1
    2db4:	5281           	addql #1,%d1
    2db6:	202e 000c      	movel %fp@(12),%d0
    2dba:	2040           	moveal %d0,%a0
    2dbc:	2081           	movel %d1,%a0@
    2dbe:	102e fff7      	moveb %fp@(-9),%d0
    2dc2:	4a00           	tstb %d0
    2dc4:	6c00 0180      	bgew 0x2f46
    2dc8:	102e fff7      	moveb %fp@(-9),%d0
    2dcc:	1200           	moveb %d0,%d1
    2dce:	0201 0070      	andib #112,%d1
    2dd2:	1d41 fff6      	moveb %d1,%fp@(-10)
    2dd6:	102e fff6      	moveb %fp@(-10),%d0
    2dda:	49c0           	extbl %d0
    2ddc:	7430           	moveq #48,%d2
    2dde:	b480           	cmpl %d0,%d2
    2de0:	6700 0110      	beqw 0x2ef2
    2de4:	7230           	moveq #48,%d1
    2de6:	b280           	cmpl %d0,%d1
    2de8:	6d18           	blts 0x2e02
    2dea:	7410           	moveq #16,%d2
    2dec:	b480           	cmpl %d0,%d2
    2dee:	6700 00f2      	beqw 0x2ee2
    2df2:	7220           	moveq #32,%d1
    2df4:	b280           	cmpl %d0,%d1
    2df6:	6700 00fa      	beqw 0x2ef2
    2dfa:	4a80           	tstl %d0
    2dfc:	6732           	beqs 0x2e30
    2dfe:	6000 fefe      	braw 0x2cfe
    2e02:	7450           	moveq #80,%d2
    2e04:	b480           	cmpl %d0,%d2
    2e06:	6700 010a      	beqw 0x2f12
    2e0a:	7250           	moveq #80,%d1
    2e0c:	b280           	cmpl %d0,%d1
    2e0e:	6d0c           	blts 0x2e1c
    2e10:	7440           	moveq #64,%d2
    2e12:	b480           	cmpl %d0,%d2
    2e14:	6700 00ec      	beqw 0x2f02
    2e18:	6000 fee4      	braw 0x2cfe
    2e1c:	7260           	moveq #96,%d1
    2e1e:	b280           	cmpl %d0,%d1
    2e20:	6700 0100      	beqw 0x2f22
    2e24:	7470           	moveq #112,%d2
    2e26:	b480           	cmpl %d0,%d2
    2e28:	6700 0108      	beqw 0x2f32
    2e2c:	6000 fed0      	braw 0x2cfe
    2e30:	42ae fff8      	clrl %fp@(-8)
    2e34:	202e 0008      	movel %fp@(8),%d0
    2e38:	2040           	moveal %d0,%a0
    2e3a:	2010           	movel %a0@,%d0
    2e3c:	2200           	movel %d0,%d1
    2e3e:	5381           	subql #1,%d1
    2e40:	202e 0008      	movel %fp@(8),%d0
    2e44:	2240           	moveal %d0,%a1
    2e46:	2281           	movel %d1,%a1@
    2e48:	202e 000c      	movel %fp@(12),%d0
    2e4c:	2040           	moveal %d0,%a0
    2e4e:	2010           	movel %a0@,%d0
    2e50:	2200           	movel %d0,%d1
    2e52:	5381           	subql #1,%d1
    2e54:	202e 000c      	movel %fp@(12),%d0
    2e58:	2240           	moveal %d0,%a1
    2e5a:	2281           	movel %d1,%a1@
    2e5c:	6052           	bras 0x2eb0
    2e5e:	202e 000c      	movel %fp@(12),%d0
    2e62:	2040           	moveal %d0,%a0
    2e64:	2010           	movel %a0@,%d0
    2e66:	2200           	movel %d0,%d1
    2e68:	5281           	addql #1,%d1
    2e6a:	202e 000c      	movel %fp@(12),%d0
    2e6e:	2240           	moveal %d0,%a1
    2e70:	2281           	movel %d1,%a1@
    2e72:	202e 0008      	movel %fp@(8),%d0
    2e76:	2040           	moveal %d0,%a0
    2e78:	2010           	movel %a0@,%d0
    2e7a:	2200           	movel %d0,%d1
    2e7c:	5281           	addql #1,%d1
    2e7e:	202e 0008      	movel %fp@(8),%d0
    2e82:	2240           	moveal %d0,%a1
    2e84:	2281           	movel %d1,%a1@
    2e86:	4280           	clrl %d0
    2e88:	102e fff7      	moveb %fp@(-9),%d0
    2e8c:	720f           	moveq #15,%d1
    2e8e:	c280           	andl %d0,%d1
    2e90:	202e fff8      	movel %fp@(-8),%d0
    2e94:	e588           	lsll #2,%d0
    2e96:	2401           	movel %d1,%d2
    2e98:	e1aa           	lsll %d0,%d2
    2e9a:	2002           	movel %d2,%d0
    2e9c:	5280           	addql #1,%d0
    2e9e:	2239 0000 0000 	movel 0x0,%d1
    2ea4:	d081           	addl %d1,%d0
    2ea6:	23c0 0000 0000 	movel %d0,0x0
    2eac:	52ae fff8      	addql #1,%fp@(-8)
    2eb0:	202e 0008      	movel %fp@(8),%d0
    2eb4:	2040           	moveal %d0,%a0
    2eb6:	2010           	movel %a0@,%d0
    2eb8:	2240           	moveal %d0,%a1
    2eba:	1d51 fff7      	moveb %a1@,%fp@(-9)
    2ebe:	4280           	clrl %d0
    2ec0:	102e fff7      	moveb %fp@(-9),%d0
    2ec4:	720f           	moveq #15,%d1
    2ec6:	4601           	notb %d1
    2ec8:	c081           	andl %d1,%d0
    2eca:	0c80 0000 0080 	cmpil #128,%d0
    2ed0:	678c           	beqs 0x2e5e
    2ed2:	2039 0000 0000 	movel 0x0,%d0
    2ed8:	5280           	addql #1,%d0
    2eda:	23c0 0000 0000 	movel %d0,0x0
    2ee0:	6060           	bras 0x2f42
    2ee2:	102e fff7      	moveb %fp@(-9),%d0
    2ee6:	0200 000f      	andib #15,%d0
    2eea:	13c0 0000 0000 	moveb %d0,0x0
    2ef0:	6050           	bras 0x2f42
    2ef2:	102e fff7      	moveb %fp@(-9),%d0
    2ef6:	0200 001f      	andib #31,%d0
    2efa:	13c0 0000 0000 	moveb %d0,0x0
    2f00:	6040           	bras 0x2f42
    2f02:	102e fff7      	moveb %fp@(-9),%d0
    2f06:	0200 000f      	andib #15,%d0
    2f0a:	13c0 0000 0000 	moveb %d0,0x0
    2f10:	6030           	bras 0x2f42
    2f12:	102e fff7      	moveb %fp@(-9),%d0
    2f16:	0200 000f      	andib #15,%d0
    2f1a:	13c0 0000 0000 	moveb %d0,0x0
    2f20:	6020           	bras 0x2f42
    2f22:	102e fff7      	moveb %fp@(-9),%d0
    2f26:	0200 000f      	andib #15,%d0
    2f2a:	13c0 0000 0000 	moveb %d0,0x0
    2f30:	6010           	bras 0x2f42
    2f32:	102e fff7      	moveb %fp@(-9),%d0
    2f36:	0200 000f      	andib #15,%d0
    2f3a:	13c0 0000 0000 	moveb %d0,0x0
    2f40:	4e71           	nop
    2f42:	6000 fdba      	braw 0x2cfe
    2f46:	4a2e fff7      	tstb %fp@(-9)
    2f4a:	670a           	beqs 0x2f56
    2f4c:	102e fff7      	moveb %fp@(-9),%d0
    2f50:	13c0 0000 0000 	moveb %d0,0x0
    2f56:	4280           	clrl %d0
    2f58:	102e fff7      	moveb %fp@(-9),%d0
    2f5c:	7460           	moveq #96,%d2
    2f5e:	c082           	andl %d2,%d0
    2f60:	4a80           	tstl %d0
    2f62:	675e           	beqs 0x2fc2
    2f64:	4281           	clrl %d1
    2f66:	122e fff7      	moveb %fp@(-9),%d1
    2f6a:	1039 0000 0000 	moveb 0x0,%d0
    2f70:	49c0           	extbl %d0
    2f72:	ef88           	lsll #7,%d0
    2f74:	d280           	addl %d0,%d1
    2f76:	1039 0000 0000 	moveb 0x0,%d0
    2f7c:	49c0           	extbl %d0
    2f7e:	740b           	moveq #11,%d2
    2f80:	e5a8           	lsll %d2,%d0
    2f82:	d280           	addl %d0,%d1
    2f84:	1039 0000 0000 	moveb 0x0,%d0
    2f8a:	49c0           	extbl %d0
    2f8c:	4840           	swap %d0
    2f8e:	4240           	clrw %d0
    2f90:	d280           	addl %d0,%d1
    2f92:	1039 0000 0000 	moveb 0x0,%d0
    2f98:	49c0           	extbl %d0
    2f9a:	7414           	moveq #20,%d2
    2f9c:	e5a8           	lsll %d2,%d0
    2f9e:	d280           	addl %d0,%d1
    2fa0:	1039 0000 0000 	moveb 0x0,%d0
    2fa6:	49c0           	extbl %d0
    2fa8:	7418           	moveq #24,%d2
    2faa:	e5a8           	lsll %d2,%d0
    2fac:	d280           	addl %d0,%d1
    2fae:	1039 0000 0000 	moveb 0x0,%d0
    2fb4:	49c0           	extbl %d0
    2fb6:	741c           	moveq #28,%d2
    2fb8:	e5a8           	lsll %d2,%d0
    2fba:	d081           	addl %d1,%d0
    2fbc:	2d40 fffc      	movel %d0,%fp@(-4)
    2fc0:	6040           	bras 0x3002
    2fc2:	4280           	clrl %d0
    2fc4:	102e fff7      	moveb %fp@(-9),%d0
    2fc8:	2d40 fffc      	movel %d0,%fp@(-4)
    2fcc:	0c2e 000a fff7 	cmpib #10,%fp@(-9)
    2fd2:	662c           	bnes 0x3000
    2fd4:	203c 0000 0000 	movel #0,%d0
    2fda:	223c 0000 0000 	movel #0,%d1
    2fe0:	2041           	moveal %d1,%a0
    2fe2:	2240           	moveal %d0,%a1
    2fe4:	2091           	movel %a1@,%a0@
    2fe6:	5881           	addql #4,%d1
    2fe8:	5880           	addql #4,%d0
    2fea:	2041           	moveal %d1,%a0
    2fec:	2240           	moveal %d0,%a1
    2fee:	2091           	movel %a1@,%a0@
    2ff0:	5881           	addql #4,%d1
    2ff2:	5880           	addql #4,%d0
    2ff4:	2041           	moveal %d1,%a0
    2ff6:	2240           	moveal %d0,%a1
    2ff8:	2091           	movel %a1@,%a0@
    2ffa:	5881           	addql #4,%d1
    2ffc:	5880           	addql #4,%d0
    2ffe:	6002           	bras 0x3002
    3000:	4e71           	nop
    3002:	202e fffc      	movel %fp@(-4),%d0
    3006:	241f           	movel %sp@+,%d2
    3008:	4e5e           	unlk %fp
    300a:	4e75           	rts
    300c:	4e56 fffc      	linkw %fp,#-4
    3010:	42ae fffc      	clrl %fp@(-4)
    3014:	700c           	moveq #12,%d0
    3016:	d08e           	addl %fp,%d0
    3018:	220e           	movel %fp,%d1
    301a:	5981           	subql #4,%d1
    301c:	2f01           	movel %d1,%sp@-
    301e:	2f00           	movel %d0,%sp@-
    3020:	4eba fcce      	jsr %pc@(0x2cf0)
    3024:	508f           	addql #8,%sp
    3026:	2200           	movel %d0,%d1
    3028:	202e 0008      	movel %fp@(8),%d0
    302c:	2040           	moveal %d0,%a0
    302e:	2081           	movel %d1,%a0@
    3030:	202e fffc      	movel %fp@(-4),%d0
    3034:	b0ae 0010      	cmpl %fp@(16),%d0
    3038:	6206           	bhis 0x3040
    303a:	202e fffc      	movel %fp@(-4),%d0
    303e:	6002           	bras 0x3042
    3040:	70ff           	moveq #-1,%d0
    3042:	4e5e           	unlk %fp
    3044:	4e75           	rts
    3046:	4e56 fffc      	linkw %fp,#-4
    304a:	2f02           	movel %d2,%sp@-
    304c:	42ae fffc      	clrl %fp@(-4)
    3050:	202e 0008      	movel %fp@(8),%d0
    3054:	4a80           	tstl %d0
    3056:	6634           	bnes 0x308c
    3058:	203c 0000 0000 	movel #0,%d0
    305e:	223c 0000 0000 	movel #0,%d1
    3064:	2041           	moveal %d1,%a0
    3066:	2240           	moveal %d0,%a1
    3068:	2091           	movel %a1@,%a0@
    306a:	5881           	addql #4,%d1
    306c:	5880           	addql #4,%d0
    306e:	2041           	moveal %d1,%a0
    3070:	2240           	moveal %d0,%a1
    3072:	2091           	movel %a1@,%a0@
    3074:	5881           	addql #4,%d1
    3076:	5880           	addql #4,%d0
    3078:	2041           	moveal %d1,%a0
    307a:	2240           	moveal %d0,%a1
    307c:	2091           	movel %a1@,%a0@
    307e:	5881           	addql #4,%d1
    3080:	5880           	addql #4,%d0
    3082:	42b9 0000 0000 	clrl 0x0
    3088:	4280           	clrl %d0
    308a:	607c           	bras 0x3108
    308c:	2039 0000 0000 	movel 0x0,%d0
    3092:	4a80           	tstl %d0
    3094:	6704           	beqs 0x309a
    3096:	4280           	clrl %d0
    3098:	606e           	bras 0x3108
    309a:	202e 0008      	movel %fp@(8),%d0
    309e:	2040           	moveal %d0,%a0
    30a0:	1010           	moveb %a0@,%d0
    30a2:	49c0           	extbl %d0
    30a4:	720f           	moveq #15,%d1
    30a6:	4601           	notb %d1
    30a8:	c081           	andl %d1,%d0
    30aa:	0c80 0000 0080 	cmpil #128,%d0
    30b0:	6632           	bnes 0x30e4
    30b2:	600a           	bras 0x30be
    30b4:	202e fffc      	movel %fp@(-4),%d0
    30b8:	5280           	addql #1,%d0
    30ba:	2d40 fffc      	movel %d0,%fp@(-4)
    30be:	222e 0008      	movel %fp@(8),%d1
    30c2:	2041           	moveal %d1,%a0
    30c4:	1010           	moveb %a0@,%d0
    30c6:	49c0           	extbl %d0
    30c8:	740f           	moveq #15,%d2
    30ca:	4602           	notb %d2
    30cc:	c082           	andl %d2,%d0
    30ce:	0c80 0000 0080 	cmpil #128,%d0
    30d4:	57c0           	seq %d0
    30d6:	4400           	negb %d0
    30d8:	5281           	addql #1,%d1
    30da:	2d41 0008      	movel %d1,%fp@(8)
    30de:	4a00           	tstb %d0
    30e0:	66d2           	bnes 0x30b4
    30e2:	6012           	bras 0x30f6
    30e4:	200e           	movel %fp,%d0
    30e6:	5080           	addql #8,%d0
    30e8:	220e           	movel %fp,%d1
    30ea:	5981           	subql #4,%d1
    30ec:	2f01           	movel %d1,%sp@-
    30ee:	2f00           	movel %d0,%sp@-
    30f0:	4eba fbfe      	jsr %pc@(0x2cf0)
    30f4:	508f           	addql #8,%sp
    30f6:	202e fffc      	movel %fp@(-4),%d0
    30fa:	b0ae 000c      	cmpl %fp@(12),%d0
    30fe:	6206           	bhis 0x3106
    3100:	202e fffc      	movel %fp@(-4),%d0
    3104:	6002           	bras 0x3108
    3106:	70ff           	moveq #-1,%d0
    3108:	242e fff8      	movel %fp@(-8),%d2
    310c:	4e5e           	unlk %fp
    310e:	4e75           	rts
    3110:	4e56 fff4      	linkw %fp,#-12
    3114:	42ae fff4      	clrl %fp@(-12)
    3118:	7001           	moveq #1,%d0
    311a:	2d40 fff8      	movel %d0,%fp@(-8)
    311e:	202e 000c      	movel %fp@(12),%d0
    3122:	4a80           	tstl %d0
    3124:	6634           	bnes 0x315a
    3126:	203c 0000 0000 	movel #0,%d0
    312c:	223c 0000 0000 	movel #0,%d1
    3132:	2041           	moveal %d1,%a0
    3134:	2240           	moveal %d0,%a1
    3136:	2091           	movel %a1@,%a0@
    3138:	5881           	addql #4,%d1
    313a:	5880           	addql #4,%d0
    313c:	2041           	moveal %d1,%a0
    313e:	2240           	moveal %d0,%a1
    3140:	2091           	movel %a1@,%a0@
    3142:	5881           	addql #4,%d1
    3144:	5880           	addql #4,%d0
    3146:	2041           	moveal %d1,%a0
    3148:	2240           	moveal %d0,%a1
    314a:	2091           	movel %a1@,%a0@
    314c:	5881           	addql #4,%d1
    314e:	5880           	addql #4,%d0
    3150:	42b9 0000 0000 	clrl 0x0
    3156:	4280           	clrl %d0
    3158:	6066           	bras 0x31c0
    315a:	42ae fffc      	clrl %fp@(-4)
    315e:	6028           	bras 0x3188
    3160:	700c           	moveq #12,%d0
    3162:	d08e           	addl %fp,%d0
    3164:	72f4           	moveq #-12,%d1
    3166:	d28e           	addl %fp,%d1
    3168:	2f01           	movel %d1,%sp@-
    316a:	2f00           	movel %d0,%sp@-
    316c:	4eba fb82      	jsr %pc@(0x2cf0)
    3170:	508f           	addql #8,%sp
    3172:	2d40 fff8      	movel %d0,%fp@(-8)
    3176:	202e 0008      	movel %fp@(8),%d0
    317a:	2040           	moveal %d0,%a0
    317c:	20ae fff8      	movel %fp@(-8),%a0@
    3180:	58ae 0008      	addql #4,%fp@(8)
    3184:	52ae fffc      	addql #1,%fp@(-4)
    3188:	222e fffc      	movel %fp@(-4),%d1
    318c:	202e 0010      	movel %fp@(16),%d0
    3190:	5380           	subql #1,%d0
    3192:	b081           	cmpl %d1,%d0
    3194:	630c           	blss 0x31a2
    3196:	7000           	moveq #0,%d0
    3198:	4600           	notb %d0
    319a:	c0ae fff8      	andl %fp@(-8),%d0
    319e:	4a80           	tstl %d0
    31a0:	66be           	bnes 0x3160
    31a2:	222e fffc      	movel %fp@(-4),%d1
    31a6:	202e 0010      	movel %fp@(16),%d0
    31aa:	5380           	subql #1,%d0
    31ac:	b081           	cmpl %d1,%d0
    31ae:	630c           	blss 0x31bc
    31b0:	202e 0008      	movel %fp@(8),%d0
    31b4:	2240           	moveal %d0,%a1
    31b6:	4291           	clrl %a1@
    31b8:	58ae 0008      	addql #4,%fp@(8)
    31bc:	202e fffc      	movel %fp@(-4),%d0
    31c0:	4e5e           	unlk %fp
    31c2:	4e75           	rts
    31c4:	242f 000c      	movel %sp@(12),%d2
    31c8:	222f 0008      	movel %sp@(8),%d1
    31cc:	206f 0004      	moveal %sp@(4),%a0
    31d0:	b210           	cmpb %a0@,%d1
    31d2:	670e           	beqs 0x31e2
    31d4:	4a10           	tstb %a0@
    31d6:	6708           	beqs 0x31e0
    31d8:	5288           	addql #1,%a0
    31da:	5342           	subqw #1,%d2
    31dc:	6600 fff2      	bnew 0x31d0
    31e0:	4280           	clrl %d0
    31e2:	4e75           	rts
    31e4:	202f 000c      	movel %sp@(12),%d0
    31e8:	671a           	beqs 0x3204
    31ea:	226f 0008      	moveal %sp@(8),%a1
    31ee:	206f 0004      	moveal %sp@(4),%a0
    31f2:	1219           	moveb %a1@+,%d1
    31f4:	b210           	cmpb %a0@,%d1
    31f6:	6704           	beqs 0x31fc
    31f8:	650e           	bcss 0x3208
    31fa:	6212           	bhis 0x320e
    31fc:	5248           	addqw #1,%a0
    31fe:	5340           	subqw #1,%d0
    3200:	6600 fff0      	bnew 0x31f2
    3204:	4280           	clrl %d0
    3206:	4e75           	rts
    3208:	4280           	clrl %d0
    320a:	5240           	addqw #1,%d0
    320c:	4e75           	rts
    320e:	4280           	clrl %d0
    3210:	5340           	subqw #1,%d0
    3212:	4e75           	rts
    3214:	222f 000c      	movel %sp@(12),%d1
    3218:	226f 0008      	moveal %sp@(8),%a1
    321c:	206f 0004      	moveal %sp@(4),%a0
    3220:	2008           	movel %a0,%d0
    3222:	10d9           	moveb %a1@+,%a0@+
    3224:	5341           	subqw #1,%d1
    3226:	6600 fffa      	bnew 0x3222
    322a:	2040           	moveal %d0,%a0
    322c:	4e75           	rts
    322e:	4e71           	nop
    3230:	222f 000c      	movel %sp@(12),%d1
    3234:	226f 0008      	moveal %sp@(8),%a1
    3238:	206f 0004      	moveal %sp@(4),%a0
    323c:	2008           	movel %a0,%d0
    323e:	b1c9           	cmpal %a1,%a0
    3240:	6400 000e      	bccw 0x3250
    3244:	10d9           	moveb %a1@+,%a0@+
    3246:	5341           	subqw #1,%d1
    3248:	6600 fffa      	bnew 0x3244
    324c:	2040           	moveal %d0,%a0
    324e:	4e75           	rts
    3250:	d3c1           	addal %d1,%a1
    3252:	d1c1           	addal %d1,%a0
    3254:	1121           	moveb %a1@-,%a0@-
    3256:	5341           	subqw #1,%d1
    3258:	6600 fffa      	bnew 0x3254
    325c:	2040           	moveal %d0,%a0
    325e:	4e75           	rts
    3260:	222f 000c      	movel %sp@(12),%d1
    3264:	242f 0008      	movel %sp@(8),%d2
    3268:	206f 0004      	moveal %sp@(4),%a0
    326c:	2008           	movel %a0,%d0
    326e:	10c2           	moveb %d2,%a0@+
    3270:	5341           	subqw #1,%d1
    3272:	6600 fffa      	bnew 0x326e
    3276:	2040           	moveal %d0,%a0
    3278:	4e75           	rts
    327a:	4e71           	nop
    327c:	4e56 ffd8      	linkw %fp,#-40
    3280:	2f02           	movel %d2,%sp@-
    3282:	42ae fffc      	clrl %fp@(-4)
    3286:	202e 0008      	movel %fp@(8),%d0
    328a:	2200           	movel %d0,%d1
    328c:	70d8           	moveq #-40,%d0
    328e:	d08e           	addl %fp,%d0
    3290:	2040           	moveal %d0,%a0
    3292:	2241           	moveal %d1,%a1
    3294:	2091           	movel %a1@,%a0@
    3296:	5880           	addql #4,%d0
    3298:	5881           	addql #4,%d1
    329a:	2040           	moveal %d0,%a0
    329c:	2241           	moveal %d1,%a1
    329e:	2091           	movel %a1@,%a0@
    32a0:	5880           	addql #4,%d0
    32a2:	5881           	addql #4,%d1
    32a4:	2040           	moveal %d0,%a0
    32a6:	2241           	moveal %d1,%a1
    32a8:	2091           	movel %a1@,%a0@
    32aa:	5880           	addql #4,%d0
    32ac:	5881           	addql #4,%d1
    32ae:	2040           	moveal %d0,%a0
    32b0:	2241           	moveal %d1,%a1
    32b2:	2091           	movel %a1@,%a0@
    32b4:	5880           	addql #4,%d0
    32b6:	5881           	addql #4,%d1
    32b8:	2040           	moveal %d0,%a0
    32ba:	2241           	moveal %d1,%a1
    32bc:	2091           	movel %a1@,%a0@
    32be:	5880           	addql #4,%d0
    32c0:	5881           	addql #4,%d1
    32c2:	2040           	moveal %d0,%a0
    32c4:	2241           	moveal %d1,%a1
    32c6:	2091           	movel %a1@,%a0@
    32c8:	5880           	addql #4,%d0
    32ca:	5881           	addql #4,%d1
    32cc:	2040           	moveal %d0,%a0
    32ce:	2241           	moveal %d1,%a1
    32d0:	2091           	movel %a1@,%a0@
    32d2:	5880           	addql #4,%d0
    32d4:	5881           	addql #4,%d1
    32d6:	2040           	moveal %d0,%a0
    32d8:	2241           	moveal %d1,%a1
    32da:	2091           	movel %a1@,%a0@
    32dc:	5880           	addql #4,%d0
    32de:	5881           	addql #4,%d1
    32e0:	2040           	moveal %d0,%a0
    32e2:	2241           	moveal %d1,%a1
    32e4:	2091           	movel %a1@,%a0@
    32e6:	5880           	addql #4,%d0
    32e8:	5881           	addql #4,%d1
    32ea:	202e ffec      	movel %fp@(-20),%d0
    32ee:	0680 0000 07d0 	addil #2000,%d0
    32f4:	2d40 ffec      	movel %d0,%fp@(-20)
    32f8:	202e ffe0      	movel %fp@(-32),%d0
    32fc:	4a80           	tstl %d0
    32fe:	6c4c           	bges 0x334c
    3300:	7017           	moveq #23,%d0
    3302:	2d40 ffe0      	movel %d0,%fp@(-32)
    3306:	202e ffe4      	movel %fp@(-28),%d0
    330a:	5380           	subql #1,%d0
    330c:	2d40 ffe4      	movel %d0,%fp@(-28)
    3310:	202e ffe4      	movel %fp@(-28),%d0
    3314:	4a80           	tstl %d0
    3316:	6e34           	bgts 0x334c
    3318:	202e ffe8      	movel %fp@(-24),%d0
    331c:	5380           	subql #1,%d0
    331e:	2d40 ffe8      	movel %d0,%fp@(-24)
    3322:	202e ffe8      	movel %fp@(-24),%d0
    3326:	4a80           	tstl %d0
    3328:	6c10           	bges 0x333a
    332a:	720b           	moveq #11,%d1
    332c:	2d41 ffe8      	movel %d1,%fp@(-24)
    3330:	202e ffec      	movel %fp@(-20),%d0
    3334:	5380           	subql #1,%d0
    3336:	2d40 ffec      	movel %d0,%fp@(-20)
    333a:	202e ffe8      	movel %fp@(-24),%d0
    333e:	1030 09b0 0000 	moveb @(00000000,%d0:l),%d0
    3344:	0000 
    3346:	49c0           	extbl %d0
    3348:	2d40 ffe4      	movel %d0,%fp@(-28)
    334c:	202e ffec      	movel %fp@(-20),%d0
    3350:	0c80 0000 07b1 	cmpil #1969,%d0
    3356:	6f0c           	bles 0x3364
    3358:	202e ffec      	movel %fp@(-20),%d0
    335c:	0c80 0000 07f6 	cmpil #2038,%d0
    3362:	6f06           	bles 0x336a
    3364:	70ff           	moveq #-1,%d0
    3366:	6000 0142      	braw 0x34aa
    336a:	202e ffec      	movel %fp@(-20),%d0
    336e:	0680 ffff f84c 	addil #-1972,%d0
    3374:	7403           	moveq #3,%d2
    3376:	c082           	andl %d2,%d0
    3378:	4a80           	tstl %d0
    337a:	6616           	bnes 0x3392
    337c:	202e ffec      	movel %fp@(-20),%d0
    3380:	0c80 0000 07d0 	cmpil #2000,%d0
    3386:	670a           	beqs 0x3392
    3388:	13fc 001d 0000 	moveb #29,0x0
    338e:	0000 
    3390:	6008           	bras 0x339a
    3392:	13fc 001c 0000 	moveb #28,0x0
    3398:	0000 
    339a:	222e ffec      	movel %fp@(-20),%d1
    339e:	2001           	movel %d1,%d0
    33a0:	e788           	lsll #3,%d0
    33a2:	2400           	movel %d0,%d2
    33a4:	e78a           	lsll #3,%d2
    33a6:	2042           	moveal %d2,%a0
    33a8:	d088           	addl %a0,%d0
    33aa:	d081           	addl %d1,%d0
    33ac:	2200           	movel %d0,%d1
    33ae:	e589           	lsll #2,%d1
    33b0:	d081           	addl %d1,%d0
    33b2:	0680 fff5 0736 	addil #-719050,%d0
    33b8:	23c0 0000 0000 	movel %d0,0x0
    33be:	202e ffec      	movel %fp@(-20),%d0
    33c2:	0680 ffff f84f 	addil #-1969,%d0
    33c8:	4a80           	tstl %d0
    33ca:	6c02           	bges 0x33ce
    33cc:	5680           	addql #3,%d0
    33ce:	e480           	asrl #2,%d0
    33d0:	2200           	movel %d0,%d1
    33d2:	2039 0000 0000 	movel 0x0,%d0
    33d8:	d081           	addl %d1,%d0
    33da:	23c0 0000 0000 	movel %d0,0x0
    33e0:	42ae fffc      	clrl %fp@(-4)
    33e4:	6022           	bras 0x3408
    33e6:	202e fffc      	movel %fp@(-4),%d0
    33ea:	0680 0000 0000 	addil #0,%d0
    33f0:	2040           	moveal %d0,%a0
    33f2:	1010           	moveb %a0@,%d0
    33f4:	49c0           	extbl %d0
    33f6:	2239 0000 0000 	movel 0x0,%d1
    33fc:	d081           	addl %d1,%d0
    33fe:	23c0 0000 0000 	movel %d0,0x0
    3404:	52ae fffc      	addql #1,%fp@(-4)
    3408:	202e ffe8      	movel %fp@(-24),%d0
    340c:	b0ae fffc      	cmpl %fp@(-4),%d0
    3410:	6ed4           	bgts 0x33e6
    3412:	202e ffe4      	movel %fp@(-28),%d0
    3416:	5380           	subql #1,%d0
    3418:	2239 0000 0000 	movel 0x0,%d1
    341e:	d081           	addl %d1,%d0
    3420:	23c0 0000 0000 	movel %d0,0x0
    3426:	2039 0000 0000 	movel 0x0,%d0
    342c:	e788           	lsll #3,%d0
    342e:	2200           	movel %d0,%d1
    3430:	e589           	lsll #2,%d1
    3432:	2401           	movel %d1,%d2
    3434:	9480           	subl %d0,%d2
    3436:	2002           	movel %d2,%d0
    3438:	23c0 0000 0000 	movel %d0,0x0
    343e:	222e ffe0      	movel %fp@(-32),%d1
    3442:	2039 0000 0000 	movel 0x0,%d0
    3448:	d081           	addl %d1,%d0
    344a:	23c0 0000 0000 	movel %d0,0x0
    3450:	2039 0000 0000 	movel 0x0,%d0
    3456:	e588           	lsll #2,%d0
    3458:	2200           	movel %d0,%d1
    345a:	e989           	lsll #4,%d1
    345c:	2401           	movel %d1,%d2
    345e:	9480           	subl %d0,%d2
    3460:	2002           	movel %d2,%d0
    3462:	23c0 0000 0000 	movel %d0,0x0
    3468:	222e ffdc      	movel %fp@(-36),%d1
    346c:	2039 0000 0000 	movel 0x0,%d0
    3472:	d081           	addl %d1,%d0
    3474:	23c0 0000 0000 	movel %d0,0x0
    347a:	2039 0000 0000 	movel 0x0,%d0
    3480:	e588           	lsll #2,%d0
    3482:	2200           	movel %d0,%d1
    3484:	e989           	lsll #4,%d1
    3486:	2401           	movel %d1,%d2
    3488:	9480           	subl %d0,%d2
    348a:	2002           	movel %d2,%d0
    348c:	23c0 0000 0000 	movel %d0,0x0
    3492:	222e ffd8      	movel %fp@(-40),%d1
    3496:	2039 0000 0000 	movel 0x0,%d0
    349c:	d081           	addl %d1,%d0
    349e:	23c0 0000 0000 	movel %d0,0x0
    34a4:	2039 0000 0000 	movel 0x0,%d0
    34aa:	241f           	movel %sp@+,%d2
    34ac:	4e5e           	unlk %fp
    34ae:	4e75           	rts
    34b0:	4e56 fff8      	linkw %fp,#-8
    34b4:	2f02           	movel %d2,%sp@-
    34b6:	02ae 0000 07ff 	andil #2047,%fp@(8)
    34bc:	0008 
    34be:	202e 0008      	movel %fp@(8),%d0
    34c2:	e680           	asrl #3,%d0
    34c4:	2d40 fffc      	movel %d0,%fp@(-4)
    34c8:	7007           	moveq #7,%d0
    34ca:	c0ae 0008      	andl %fp@(8),%d0
    34ce:	727f           	moveq #127,%d1
    34d0:	4601           	notb %d1
    34d2:	2401           	movel %d1,%d2
    34d4:	e0a2           	asrl %d0,%d2
    34d6:	2002           	movel %d2,%d0
    34d8:	2d40 fff8      	movel %d0,%fp@(-8)
    34dc:	202e fffc      	movel %fp@(-4),%d0
    34e0:	0680 0000 0000 	addil #0,%d0
    34e6:	2040           	moveal %d0,%a0
    34e8:	1010           	moveb %a0@,%d0
    34ea:	1000           	moveb %d0,%d0
    34ec:	0280 0000 00ff 	andil #255,%d0
    34f2:	c0ae fff8      	andl %fp@(-8),%d0
    34f6:	4a80           	tstl %d0
    34f8:	56c0           	sne %d0
    34fa:	49c0           	extbl %d0
    34fc:	4480           	negl %d0
    34fe:	241f           	movel %sp@+,%d2
    3500:	4e5e           	unlk %fp
    3502:	4e75           	rts
    3504:	4e56 fff8      	linkw %fp,#-8
    3508:	2f02           	movel %d2,%sp@-
    350a:	02ae 0000 07ff 	andil #2047,%fp@(8)
    3510:	0008 
    3512:	202e 0008      	movel %fp@(8),%d0
    3516:	e680           	asrl #3,%d0
    3518:	2d40 fffc      	movel %d0,%fp@(-4)
    351c:	7007           	moveq #7,%d0
    351e:	c0ae 0008      	andl %fp@(8),%d0
    3522:	727f           	moveq #127,%d1
    3524:	4601           	notb %d1
    3526:	2401           	movel %d1,%d2
    3528:	e0a2           	asrl %d0,%d2
    352a:	2002           	movel %d2,%d0
    352c:	2d40 fff8      	movel %d0,%fp@(-8)
    3530:	202e fffc      	movel %fp@(-4),%d0
    3534:	0680 0000 0000 	addil #0,%d0
    353a:	2040           	moveal %d0,%a0
    353c:	1010           	moveb %a0@,%d0
    353e:	1000           	moveb %d0,%d0
    3540:	0280 0000 00ff 	andil #255,%d0
    3546:	c0ae fff8      	andl %fp@(-8),%d0
    354a:	4a80           	tstl %d0
    354c:	56c0           	sne %d0
    354e:	49c0           	extbl %d0
    3550:	4480           	negl %d0
    3552:	241f           	movel %sp@+,%d2
    3554:	4e5e           	unlk %fp
    3556:	4e75           	rts
    3558:	4e56 fff8      	linkw %fp,#-8
    355c:	2f02           	movel %d2,%sp@-
    355e:	02ae 0000 07ff 	andil #2047,%fp@(8)
    3564:	0008 
    3566:	202e 0008      	movel %fp@(8),%d0
    356a:	e680           	asrl #3,%d0
    356c:	2d40 fffc      	movel %d0,%fp@(-4)
    3570:	7007           	moveq #7,%d0
    3572:	c0ae 0008      	andl %fp@(8),%d0
    3576:	727f           	moveq #127,%d1
    3578:	4601           	notb %d1
    357a:	2401           	movel %d1,%d2
    357c:	e0a2           	asrl %d0,%d2
    357e:	2002           	movel %d2,%d0
    3580:	2d40 fff8      	movel %d0,%fp@(-8)
    3584:	202e fffc      	movel %fp@(-4),%d0
    3588:	0680 0000 0000 	addil #0,%d0
    358e:	2040           	moveal %d0,%a0
    3590:	1010           	moveb %a0@,%d0
    3592:	1000           	moveb %d0,%d0
    3594:	0280 0000 00ff 	andil #255,%d0
    359a:	c0ae fff8      	andl %fp@(-8),%d0
    359e:	4a80           	tstl %d0
    35a0:	56c0           	sne %d0
    35a2:	49c0           	extbl %d0
    35a4:	4480           	negl %d0
    35a6:	241f           	movel %sp@+,%d2
    35a8:	4e5e           	unlk %fp
    35aa:	4e75           	rts
    35ac:	4e56 fff8      	linkw %fp,#-8
    35b0:	2f02           	movel %d2,%sp@-
    35b2:	02ae 0000 07ff 	andil #2047,%fp@(8)
    35b8:	0008 
    35ba:	202e 0008      	movel %fp@(8),%d0
    35be:	e680           	asrl #3,%d0
    35c0:	2d40 fffc      	movel %d0,%fp@(-4)
    35c4:	7007           	moveq #7,%d0
    35c6:	c0ae 0008      	andl %fp@(8),%d0
    35ca:	727f           	moveq #127,%d1
    35cc:	4601           	notb %d1
    35ce:	2401           	movel %d1,%d2
    35d0:	e0a2           	asrl %d0,%d2
    35d2:	2002           	movel %d2,%d0
    35d4:	2d40 fff8      	movel %d0,%fp@(-8)
    35d8:	202e fffc      	movel %fp@(-4),%d0
    35dc:	0680 0000 0000 	addil #0,%d0
    35e2:	2040           	moveal %d0,%a0
    35e4:	1010           	moveb %a0@,%d0
    35e6:	1000           	moveb %d0,%d0
    35e8:	0280 0000 00ff 	andil #255,%d0
    35ee:	c0ae fff8      	andl %fp@(-8),%d0
    35f2:	4a80           	tstl %d0
    35f4:	56c0           	sne %d0
    35f6:	49c0           	extbl %d0
    35f8:	4480           	negl %d0
    35fa:	241f           	movel %sp@+,%d2
    35fc:	4e5e           	unlk %fp
    35fe:	4e75           	rts
    3600:	4e56 0000      	linkw %fp,#0
    3604:	2f2e 0008      	movel %fp@(8),%sp@-
    3608:	4eba fefa      	jsr %pc@(0x3504)
    360c:	588f           	addql #4,%sp
    360e:	4a80           	tstl %d0
    3610:	6712           	beqs 0x3624
    3612:	2f2e 0008      	movel %fp@(8),%sp@-
    3616:	4eba ff94      	jsr %pc@(0x35ac)
    361a:	588f           	addql #4,%sp
    361c:	4a80           	tstl %d0
    361e:	6604           	bnes 0x3624
    3620:	7001           	moveq #1,%d0
    3622:	6002           	bras 0x3626
    3624:	4280           	clrl %d0
    3626:	4e5e           	unlk %fp
    3628:	4e75           	rts
    362a:	4e56 0000      	linkw %fp,#0
    362e:	7001           	moveq #1,%d0
    3630:	4e5e           	unlk %fp
    3632:	4e75           	rts
    3634:	4e56 fff8      	linkw %fp,#-8
    3638:	2f02           	movel %d2,%sp@-
    363a:	02ae 0000 07ff 	andil #2047,%fp@(8)
    3640:	0008 
    3642:	202e 0008      	movel %fp@(8),%d0
    3646:	e680           	asrl #3,%d0
    3648:	2d40 fffc      	movel %d0,%fp@(-4)
    364c:	7007           	moveq #7,%d0
    364e:	c0ae 0008      	andl %fp@(8),%d0
    3652:	727f           	moveq #127,%d1
    3654:	4601           	notb %d1
    3656:	2401           	movel %d1,%d2
    3658:	e0a2           	asrl %d0,%d2
    365a:	2002           	movel %d2,%d0
    365c:	2d40 fff8      	movel %d0,%fp@(-8)
    3660:	202e fffc      	movel %fp@(-4),%d0
    3664:	0680 0000 0000 	addil #0,%d0
    366a:	2040           	moveal %d0,%a0
    366c:	1010           	moveb %a0@,%d0
    366e:	1000           	moveb %d0,%d0
    3670:	0280 0000 00ff 	andil #255,%d0
    3676:	c0ae fff8      	andl %fp@(-8),%d0
    367a:	4a80           	tstl %d0
    367c:	6704           	beqs 0x3682
    367e:	7001           	moveq #1,%d0
    3680:	6016           	bras 0x3698
    3682:	702f           	moveq #47,%d0
    3684:	b0ae 0008      	cmpl %fp@(8),%d0
    3688:	6c0c           	bges 0x3696
    368a:	7439           	moveq #57,%d2
    368c:	b4ae 0008      	cmpl %fp@(8),%d2
    3690:	6d04           	blts 0x3696
    3692:	7001           	moveq #1,%d0
    3694:	6002           	bras 0x3698
    3696:	4280           	clrl %d0
    3698:	241f           	movel %sp@+,%d2
    369a:	4e5e           	unlk %fp
    369c:	4e75           	rts
    369e:	4e56 0000      	linkw %fp,#0
    36a2:	2f2e 0008      	movel %fp@(8),%sp@-
    36a6:	4eba ff8c      	jsr %pc@(0x3634)
    36aa:	588f           	addql #4,%sp
    36ac:	4a80           	tstl %d0
    36ae:	661c           	bnes 0x36cc
    36b0:	2f2e 0008      	movel %fp@(8),%sp@-
    36b4:	4eba 0046      	jsr %pc@(0x36fc)
    36b8:	588f           	addql #4,%sp
    36ba:	4a80           	tstl %d0
    36bc:	660e           	bnes 0x36cc
    36be:	2f2e 0008      	movel %fp@(8),%sp@-
    36c2:	4eba fe94      	jsr %pc@(0x3558)
    36c6:	588f           	addql #4,%sp
    36c8:	4a80           	tstl %d0
    36ca:	6704           	beqs 0x36d0
    36cc:	7001           	moveq #1,%d0
    36ce:	6002           	bras 0x36d2
    36d0:	4280           	clrl %d0
    36d2:	4e5e           	unlk %fp
    36d4:	4e75           	rts
    36d6:	4e56 0000      	linkw %fp,#0
    36da:	02ae 0000 07ff 	andil #2047,%fp@(8)
    36e0:	0008 
    36e2:	702f           	moveq #47,%d0
    36e4:	b0ae 0008      	cmpl %fp@(8),%d0
    36e8:	6c0c           	bges 0x36f6
    36ea:	7039           	moveq #57,%d0
    36ec:	b0ae 0008      	cmpl %fp@(8),%d0
    36f0:	6d04           	blts 0x36f6
    36f2:	7001           	moveq #1,%d0
    36f4:	6002           	bras 0x36f8
    36f6:	4280           	clrl %d0
    36f8:	4e5e           	unlk %fp
    36fa:	4e75           	rts
    36fc:	4e56 0000      	linkw %fp,#0
    3700:	02ae 0000 07ff 	andil #2047,%fp@(8)
    3706:	0008 
    3708:	2f2e 0008      	movel %fp@(8),%sp@-
    370c:	4eba ffc8      	jsr %pc@(0x36d6)
    3710:	588f           	addql #4,%sp
    3712:	4a80           	tstl %d0
    3714:	6620           	bnes 0x3736
    3716:	7060           	moveq #96,%d0
    3718:	b0ae 0008      	cmpl %fp@(8),%d0
    371c:	6c08           	bges 0x3726
    371e:	7066           	moveq #102,%d0
    3720:	b0ae 0008      	cmpl %fp@(8),%d0
    3724:	6c10           	bges 0x3736
    3726:	7040           	moveq #64,%d0
    3728:	b0ae 0008      	cmpl %fp@(8),%d0
    372c:	6c0c           	bges 0x373a
    372e:	7046           	moveq #70,%d0
    3730:	b0ae 0008      	cmpl %fp@(8),%d0
    3734:	6d04           	blts 0x373a
    3736:	7001           	moveq #1,%d0
    3738:	6002           	bras 0x373c
    373a:	4280           	clrl %d0
    373c:	4e5e           	unlk %fp
    373e:	4e75           	rts
    3740:	4e56 0000      	linkw %fp,#0
    3744:	02ae 0000 07ff 	andil #2047,%fp@(8)
    374a:	0008 
    374c:	707f           	moveq #127,%d0
    374e:	b0ae 0008      	cmpl %fp@(8),%d0
    3752:	5cc0           	sge %d0
    3754:	49c0           	extbl %d0
    3756:	4480           	negl %d0
    3758:	4e5e           	unlk %fp
    375a:	4e75           	rts
    375c:	4e56 0000      	linkw %fp,#0
    3760:	02ae 0000 07ff 	andil #2047,%fp@(8)
    3766:	0008 
    3768:	707f           	moveq #127,%d0
    376a:	c0ae 0008      	andl %fp@(8),%d0
    376e:	721f           	moveq #31,%d1
    3770:	b280           	cmpl %d0,%d1
    3772:	5cc0           	sge %d0
    3774:	49c0           	extbl %d0
    3776:	4480           	negl %d0
    3778:	4e5e           	unlk %fp
    377a:	4e75           	rts
    377c:	4e56 0000      	linkw %fp,#0
    3780:	2f2e 0008      	movel %fp@(8),%sp@-
    3784:	4eba fe7a      	jsr %pc@(0x3600)
    3788:	588f           	addql #4,%sp
    378a:	4a80           	tstl %d0
    378c:	6708           	beqs 0x3796
    378e:	7020           	moveq #32,%d0
    3790:	d0ae 0008      	addl %fp@(8),%d0
    3794:	6004           	bras 0x379a
    3796:	202e 0008      	movel %fp@(8),%d0
    379a:	4e5e           	unlk %fp
    379c:	4e75           	rts
    379e:	4e56 0000      	linkw %fp,#0
    37a2:	2f2e 0008      	movel %fp@(8),%sp@-
    37a6:	4eba fe04      	jsr %pc@(0x35ac)
    37aa:	588f           	addql #4,%sp
    37ac:	4a80           	tstl %d0
    37ae:	6708           	beqs 0x37b8
    37b0:	70e0           	moveq #-32,%d0
    37b2:	d0ae 0008      	addl %fp@(8),%d0
    37b6:	6004           	bras 0x37bc
    37b8:	202e 0008      	movel %fp@(8),%d0
    37bc:	4e5e           	unlk %fp
    37be:	4e75           	rts
    37c0:	4e56 0000      	linkw %fp,#0
    37c4:	720c           	moveq #12,%d1
    37c6:	d28e           	addl %fp,%d1
    37c8:	206e 0008      	moveal %fp@(8),%a0
    37cc:	203c 0000 0000 	movel #0,%d0
    37d2:	5880           	addql #4,%d0
    37d4:	2240           	moveal %d0,%a1
    37d6:	2011           	movel %a1@,%d0
    37d8:	2f01           	movel %d1,%sp@-
    37da:	2f08           	movel %a0,%sp@-
    37dc:	2f00           	movel %d0,%sp@-
    37de:	4eb9 0000 0000 	jsr 0x0
    37e4:	4fef 000c      	lea %sp@(12),%sp
    37e8:	4e5e           	unlk %fp
    37ea:	4e75           	rts
    37ec:	4e56 0000      	linkw %fp,#0
    37f0:	2f2e 0008      	movel %fp@(8),%sp@-
    37f4:	4eb9 0000 0000 	jsr 0x0
    37fa:	588f           	addql #4,%sp
    37fc:	4e5e           	unlk %fp
    37fe:	4e75           	rts
    3800:	4e56 fffc      	linkw %fp,#-4
    3804:	202e 0008      	movel %fp@(8),%d0
    3808:	1000           	moveb %d0,%d0
    380a:	1d40 ffff      	moveb %d0,%fp@(-1)
    380e:	202e 000c      	movel %fp@(12),%d0
    3812:	2040           	moveal %d0,%a0
    3814:	2028 0004      	movel %a0@(4),%d0
    3818:	7240           	moveq #64,%d1
    381a:	c081           	andl %d1,%d0
    381c:	4a80           	tstl %d0
    381e:	6622           	bnes 0x3842
    3820:	700a           	moveq #10,%d0
    3822:	b0ae 0008      	cmpl %fp@(8),%d0
    3826:	661a           	bnes 0x3842
    3828:	2f2e 000c      	movel %fp@(12),%sp@-
    382c:	4878 000d      	pea 0xd
    3830:	4eba ffce      	jsr %pc@(0x3800)
    3834:	508f           	addql #8,%sp
    3836:	72ff           	moveq #-1,%d1
    3838:	b280           	cmpl %d0,%d1
    383a:	6606           	bnes 0x3842
    383c:	70ff           	moveq #-1,%d0
    383e:	6000 0102      	braw 0x3942
    3842:	202e 000c      	movel %fp@(12),%d0
    3846:	2040           	moveal %d0,%a0
    3848:	2028 000a      	movel %a0@(10),%d0
    384c:	4a80           	tstl %d0
    384e:	6700 00ac      	beqw 0x38fc
    3852:	2f2e 000c      	movel %fp@(12),%sp@-
    3856:	4eb9 0000 0000 	jsr 0x0
    385c:	588f           	addql #4,%sp
    385e:	4a80           	tstl %d0
    3860:	671e           	beqs 0x3880
    3862:	202e 000c      	movel %fp@(12),%d0
    3866:	2040           	moveal %d0,%a0
    3868:	2028 0004      	movel %a0@(4),%d0
    386c:	7210           	moveq #16,%d1
    386e:	8280           	orl %d0,%d1
    3870:	202e 000c      	movel %fp@(12),%d0
    3874:	2040           	moveal %d0,%a0
    3876:	2141 0004      	movel %d1,%a0@(4)
    387a:	70ff           	moveq #-1,%d0
    387c:	6000 00c4      	braw 0x3942
    3880:	202e 000c      	movel %fp@(12),%d0
    3884:	2040           	moveal %d0,%a0
    3886:	2028 0004      	movel %a0@(4),%d0
    388a:	2200           	movel %d0,%d1
    388c:	0041 0100      	oriw #256,%d1
    3890:	202e 000c      	movel %fp@(12),%d0
    3894:	2040           	moveal %d0,%a0
    3896:	2141 0004      	movel %d1,%a0@(4)
    389a:	202e 000c      	movel %fp@(12),%d0
    389e:	2040           	moveal %d0,%a0
    38a0:	2028 0012      	movel %a0@(18),%d0
    38a4:	222e 0008      	movel %fp@(8),%d1
    38a8:	1201           	moveb %d1,%d1
    38aa:	2040           	moveal %d0,%a0
    38ac:	1081           	moveb %d1,%a0@
    38ae:	2200           	movel %d0,%d1
    38b0:	5281           	addql #1,%d1
    38b2:	202e 000c      	movel %fp@(12),%d0
    38b6:	2040           	moveal %d0,%a0
    38b8:	2141 0012      	movel %d1,%a0@(18)
    38bc:	202e 000c      	movel %fp@(12),%d0
    38c0:	2040           	moveal %d0,%a0
    38c2:	2010           	movel %a0@,%d0
    38c4:	2200           	movel %d0,%d1
    38c6:	5281           	addql #1,%d1
    38c8:	202e 000c      	movel %fp@(12),%d0
    38cc:	2040           	moveal %d0,%a0
    38ce:	2081           	movel %d1,%a0@
    38d0:	700a           	moveq #10,%d0
    38d2:	b0ae 0008      	cmpl %fp@(8),%d0
    38d6:	661e           	bnes 0x38f6
    38d8:	202e 000c      	movel %fp@(12),%d0
    38dc:	2040           	moveal %d0,%a0
    38de:	2028 0004      	movel %a0@(4),%d0
    38e2:	7208           	moveq #8,%d1
    38e4:	c081           	andl %d1,%d0
    38e6:	4a80           	tstl %d0
    38e8:	670c           	beqs 0x38f6
    38ea:	2f2e 000c      	movel %fp@(12),%sp@-
    38ee:	4eb9 0000 0000 	jsr 0x0
    38f4:	588f           	addql #4,%sp
    38f6:	202e 0008      	movel %fp@(8),%d0
    38fa:	6046           	bras 0x3942
    38fc:	202e 000c      	movel %fp@(12),%d0
    3900:	2040           	moveal %d0,%a0
    3902:	1028 0008      	moveb %a0@(8),%d0
    3906:	49c0           	extbl %d0
    3908:	4878 0001      	pea 0x1
    390c:	220e           	movel %fp,%d1
    390e:	5381           	subql #1,%d1
    3910:	2f01           	movel %d1,%sp@-
    3912:	2f00           	movel %d0,%sp@-
    3914:	4eb9 0000 0000 	jsr 0x0
    391a:	4fef 000c      	lea %sp@(12),%sp
    391e:	4a80           	tstl %d0
    3920:	671c           	beqs 0x393e
    3922:	202e 000c      	movel %fp@(12),%d0
    3926:	2040           	moveal %d0,%a0
    3928:	2028 0004      	movel %a0@(4),%d0
    392c:	7210           	moveq #16,%d1
    392e:	8280           	orl %d0,%d1
    3930:	202e 000c      	movel %fp@(12),%d0
    3934:	2040           	moveal %d0,%a0
    3936:	2141 0004      	movel %d1,%a0@(4)
    393a:	70ff           	moveq #-1,%d0
    393c:	6004           	bras 0x3942
    393e:	202e 0008      	movel %fp@(8),%d0
    3942:	4e5e           	unlk %fp
    3944:	4e75           	rts
    3946:	4e56 fffc      	linkw %fp,#-4
    394a:	202e 0008      	movel %fp@(8),%d0
    394e:	2040           	moveal %d0,%a0
    3950:	2028 000a      	movel %a0@(10),%d0
    3954:	4a80           	tstl %d0
    3956:	6700 0186      	beqw 0x3ade
    395a:	2f2e 0008      	movel %fp@(8),%sp@-
    395e:	4eb9 0000 0000 	jsr 0x0
    3964:	588f           	addql #4,%sp
    3966:	4a80           	tstl %d0
    3968:	6706           	beqs 0x3970
    396a:	70ff           	moveq #-1,%d0
    396c:	6000 01e6      	braw 0x3b54
    3970:	202e 0008      	movel %fp@(8),%d0
    3974:	2240           	moveal %d0,%a1
    3976:	2029 0004      	movel %a1@(4),%d0
    397a:	7240           	moveq #64,%d1
    397c:	c081           	andl %d1,%d0
    397e:	4a80           	tstl %d0
    3980:	6600 0122      	bnew 0x3aa4
    3984:	202e 0008      	movel %fp@(8),%d0
    3988:	2040           	moveal %d0,%a0
    398a:	2028 0012      	movel %a0@(18),%d0
    398e:	2240           	moveal %d0,%a1
    3990:	1011           	moveb %a1@,%d0
    3992:	0c00 000d      	cmpib #13,%d0
    3996:	664c           	bnes 0x39e4
    3998:	202e 0008      	movel %fp@(8),%d0
    399c:	2040           	moveal %d0,%a0
    399e:	2028 0004      	movel %a0@(4),%d0
    39a2:	2200           	movel %d0,%d1
    39a4:	0041 0400      	oriw #1024,%d1
    39a8:	202e 0008      	movel %fp@(8),%d0
    39ac:	2240           	moveal %d0,%a1
    39ae:	2341 0004      	movel %d1,%a1@(4)
    39b2:	202e 0008      	movel %fp@(8),%d0
    39b6:	2040           	moveal %d0,%a0
    39b8:	2010           	movel %a0@,%d0
    39ba:	2200           	movel %d0,%d1
    39bc:	5381           	subql #1,%d1
    39be:	202e 0008      	movel %fp@(8),%d0
    39c2:	2240           	moveal %d0,%a1
    39c4:	2281           	movel %d1,%a1@
    39c6:	202e 0008      	movel %fp@(8),%d0
    39ca:	2040           	moveal %d0,%a0
    39cc:	2028 0012      	movel %a0@(18),%d0
    39d0:	2200           	movel %d0,%d1
    39d2:	5281           	addql #1,%d1
    39d4:	202e 0008      	movel %fp@(8),%d0
    39d8:	2240           	moveal %d0,%a1
    39da:	2341 0012      	movel %d1,%a1@(18)
    39de:	700a           	moveq #10,%d0
    39e0:	6000 0172      	braw 0x3b54
    39e4:	202e 0008      	movel %fp@(8),%d0
    39e8:	2040           	moveal %d0,%a0
    39ea:	2028 0012      	movel %a0@(18),%d0
    39ee:	2240           	moveal %d0,%a1
    39f0:	1011           	moveb %a1@,%d0
    39f2:	0c00 000a      	cmpib #10,%d0
    39f6:	6668           	bnes 0x3a60
    39f8:	202e 0008      	movel %fp@(8),%d0
    39fc:	2040           	moveal %d0,%a0
    39fe:	2028 0004      	movel %a0@(4),%d0
    3a02:	0280 0000 0400 	andil #1024,%d0
    3a08:	4a80           	tstl %d0
    3a0a:	6754           	beqs 0x3a60
    3a0c:	202e 0008      	movel %fp@(8),%d0
    3a10:	2240           	moveal %d0,%a1
    3a12:	2011           	movel %a1@,%d0
    3a14:	2200           	movel %d0,%d1
    3a16:	5381           	subql #1,%d1
    3a18:	202e 0008      	movel %fp@(8),%d0
    3a1c:	2040           	moveal %d0,%a0
    3a1e:	2081           	movel %d1,%a0@
    3a20:	202e 0008      	movel %fp@(8),%d0
    3a24:	2240           	moveal %d0,%a1
    3a26:	2029 0012      	movel %a1@(18),%d0
    3a2a:	2200           	movel %d0,%d1
    3a2c:	5281           	addql #1,%d1
    3a2e:	202e 0008      	movel %fp@(8),%d0
    3a32:	2040           	moveal %d0,%a0
    3a34:	2141 0012      	movel %d1,%a0@(18)
    3a38:	202e 0008      	movel %fp@(8),%d0
    3a3c:	2240           	moveal %d0,%a1
    3a3e:	2029 0004      	movel %a1@(4),%d0
    3a42:	2200           	movel %d0,%d1
    3a44:	0241 fbff      	andiw #-1025,%d1
    3a48:	202e 0008      	movel %fp@(8),%d0
    3a4c:	2040           	moveal %d0,%a0
    3a4e:	2141 0004      	movel %d1,%a0@(4)
    3a52:	2f2e 0008      	movel %fp@(8),%sp@-
    3a56:	4eba feee      	jsr %pc@(0x3946)
    3a5a:	588f           	addql #4,%sp
    3a5c:	6000 00f6      	braw 0x3b54
    3a60:	202e 0008      	movel %fp@(8),%d0
    3a64:	2240           	moveal %d0,%a1
    3a66:	2029 0012      	movel %a1@(18),%d0
    3a6a:	2040           	moveal %d0,%a0
    3a6c:	1010           	moveb %a0@,%d0
    3a6e:	4a00           	tstb %d0
    3a70:	6632           	bnes 0x3aa4
    3a72:	202e 0008      	movel %fp@(8),%d0
    3a76:	2240           	moveal %d0,%a1
    3a78:	2029 0004      	movel %a1@(4),%d0
    3a7c:	7220           	moveq #32,%d1
    3a7e:	8280           	orl %d0,%d1
    3a80:	202e 0008      	movel %fp@(8),%d0
    3a84:	2040           	moveal %d0,%a0
    3a86:	2141 0004      	movel %d1,%a0@(4)
    3a8a:	202e 0008      	movel %fp@(8),%d0
    3a8e:	2240           	moveal %d0,%a1
    3a90:	2011           	movel %a1@,%d0
    3a92:	2200           	movel %d0,%d1
    3a94:	5381           	subql #1,%d1
    3a96:	202e 0008      	movel %fp@(8),%d0
    3a9a:	2040           	moveal %d0,%a0
    3a9c:	2081           	movel %d1,%a0@
    3a9e:	70ff           	moveq #-1,%d0
    3aa0:	6000 00b2      	braw 0x3b54
    3aa4:	202e 0008      	movel %fp@(8),%d0
    3aa8:	2240           	moveal %d0,%a1
    3aaa:	2011           	movel %a1@,%d0
    3aac:	2200           	movel %d0,%d1
    3aae:	5381           	subql #1,%d1
    3ab0:	202e 0008      	movel %fp@(8),%d0
    3ab4:	2040           	moveal %d0,%a0
    3ab6:	2081           	movel %d1,%a0@
    3ab8:	202e 0008      	movel %fp@(8),%d0
    3abc:	2240           	moveal %d0,%a1
    3abe:	2229 0012      	movel %a1@(18),%d1
    3ac2:	2041           	moveal %d1,%a0
    3ac4:	1010           	moveb %a0@,%d0
    3ac6:	1000           	moveb %d0,%d0
    3ac8:	0280 0000 00ff 	andil #255,%d0
    3ace:	2041           	moveal %d1,%a0
    3ad0:	5288           	addql #1,%a0
    3ad2:	222e 0008      	movel %fp@(8),%d1
    3ad6:	2241           	moveal %d1,%a1
    3ad8:	2348 0012      	movel %a0,%a1@(18)
    3adc:	6076           	bras 0x3b54
    3ade:	202e 0008      	movel %fp@(8),%d0
    3ae2:	2040           	moveal %d0,%a0
    3ae4:	1028 0009      	moveb %a0@(9),%d0
    3ae8:	4a00           	tstb %d0
    3aea:	671a           	beqs 0x3b06
    3aec:	202e 0008      	movel %fp@(8),%d0
    3af0:	2240           	moveal %d0,%a1
    3af2:	1029 0009      	moveb %a1@(9),%d0
    3af6:	1d40 ffff      	moveb %d0,%fp@(-1)
    3afa:	202e 0008      	movel %fp@(8),%d0
    3afe:	2040           	moveal %d0,%a0
    3b00:	4228 0009      	clrb %a0@(9)
    3b04:	6042           	bras 0x3b48
    3b06:	202e 0008      	movel %fp@(8),%d0
    3b0a:	2240           	moveal %d0,%a1
    3b0c:	1029 0008      	moveb %a1@(8),%d0
    3b10:	49c0           	extbl %d0
    3b12:	4878 0001      	pea 0x1
    3b16:	220e           	movel %fp,%d1
    3b18:	5381           	subql #1,%d1
    3b1a:	2f01           	movel %d1,%sp@-
    3b1c:	2f00           	movel %d0,%sp@-
    3b1e:	4eb9 0000 0000 	jsr 0x0
    3b24:	4fef 000c      	lea %sp@(12),%sp
    3b28:	4a80           	tstl %d0
    3b2a:	661c           	bnes 0x3b48
    3b2c:	202e 0008      	movel %fp@(8),%d0
    3b30:	2040           	moveal %d0,%a0
    3b32:	2028 0004      	movel %a0@(4),%d0
    3b36:	7220           	moveq #32,%d1
    3b38:	8280           	orl %d0,%d1
    3b3a:	202e 0008      	movel %fp@(8),%d0
    3b3e:	2240           	moveal %d0,%a1
    3b40:	2341 0004      	movel %d1,%a1@(4)
    3b44:	70ff           	moveq #-1,%d0
    3b46:	600c           	bras 0x3b54
    3b48:	102e ffff      	moveb %fp@(-1),%d0
    3b4c:	1000           	moveb %d0,%d0
    3b4e:	0280 0000 00ff 	andil #255,%d0
    3b54:	4e5e           	unlk %fp
    3b56:	4e75           	rts
    3b58:	4e56 fffc      	linkw %fp,#-4
    3b5c:	203c 0000 0000 	movel #0,%d0
    3b62:	5880           	addql #4,%d0
    3b64:	2040           	moveal %d0,%a0
    3b66:	2010           	movel %a0@,%d0
    3b68:	2f00           	movel %d0,%sp@-
    3b6a:	2f2e 0008      	movel %fp@(8),%sp@-
    3b6e:	4eb9 0000 0000 	jsr 0x0
    3b74:	508f           	addql #8,%sp
    3b76:	2d40 fffc      	movel %d0,%fp@(-4)
    3b7a:	70ff           	moveq #-1,%d0
    3b7c:	b0ae fffc      	cmpl %fp@(-4),%d0
    3b80:	6604           	bnes 0x3b86
    3b82:	70ff           	moveq #-1,%d0
    3b84:	601a           	bras 0x3ba0
    3b86:	203c 0000 0000 	movel #0,%d0
    3b8c:	5880           	addql #4,%d0
    3b8e:	2040           	moveal %d0,%a0
    3b90:	2010           	movel %a0@,%d0
    3b92:	2f00           	movel %d0,%sp@-
    3b94:	4878 000a      	pea 0xa
    3b98:	4eb9 0000 0000 	jsr 0x0
    3b9e:	508f           	addql #8,%sp
    3ba0:	4e5e           	unlk %fp
    3ba2:	4e75           	rts
    3ba4:	4e56 ffec      	linkw %fp,#-20
    3ba8:	2f2e 0010      	movel %fp@(16),%sp@-
    3bac:	4eb9 0000 0000 	jsr 0x0
    3bb2:	588f           	addql #4,%sp
    3bb4:	2d48 ffec      	movel %a0,%fp@(-20)
    3bb8:	2d6e 0008 fff4 	movel %fp@(8),%fp@(-12)
    3bbe:	4aae ffec      	tstl %fp@(-20)
    3bc2:	6700 00ba      	beqw 0x3c7e
    3bc6:	42ae fffc      	clrl %fp@(-4)
    3bca:	6000 0094      	braw 0x3c60
    3bce:	202e fff4      	movel %fp@(-12),%d0
    3bd2:	d0ae 0010      	addl %fp@(16),%d0
    3bd6:	2d40 fff0      	movel %d0,%fp@(-16)
    3bda:	202e fffc      	movel %fp@(-4),%d0
    3bde:	5280           	addql #1,%d0
    3be0:	2d40 fff8      	movel %d0,%fp@(-8)
    3be4:	6064           	bras 0x3c4a
    3be6:	2f2e fff0      	movel %fp@(-16),%sp@-
    3bea:	2f2e fff4      	movel %fp@(-12),%sp@-
    3bee:	202e 0014      	movel %fp@(20),%d0
    3bf2:	2040           	moveal %d0,%a0
    3bf4:	4e90           	jsr %a0@
    3bf6:	508f           	addql #8,%sp
    3bf8:	4a80           	tstl %d0
    3bfa:	6f42           	bles 0x3c3e
    3bfc:	2f2e 0010      	movel %fp@(16),%sp@-
    3c00:	2f2e fff4      	movel %fp@(-12),%sp@-
    3c04:	2f2e ffec      	movel %fp@(-20),%sp@-
    3c08:	4eb9 0000 0000 	jsr 0x0
    3c0e:	4fef 000c      	lea %sp@(12),%sp
    3c12:	2f2e 0010      	movel %fp@(16),%sp@-
    3c16:	2f2e fff0      	movel %fp@(-16),%sp@-
    3c1a:	2f2e fff4      	movel %fp@(-12),%sp@-
    3c1e:	4eb9 0000 0000 	jsr 0x0
    3c24:	4fef 000c      	lea %sp@(12),%sp
    3c28:	2f2e 0010      	movel %fp@(16),%sp@-
    3c2c:	2f2e ffec      	movel %fp@(-20),%sp@-
    3c30:	2f2e fff0      	movel %fp@(-16),%sp@-
    3c34:	4eb9 0000 0000 	jsr 0x0
    3c3a:	4fef 000c      	lea %sp@(12),%sp
    3c3e:	202e 0010      	movel %fp@(16),%d0
    3c42:	d1ae fff0      	addl %d0,%fp@(-16)
    3c46:	52ae fff8      	addql #1,%fp@(-8)
    3c4a:	202e fff8      	movel %fp@(-8),%d0
    3c4e:	b0ae 000c      	cmpl %fp@(12),%d0
    3c52:	6592           	bcss 0x3be6
    3c54:	202e 0010      	movel %fp@(16),%d0
    3c58:	d1ae fff4      	addl %d0,%fp@(-12)
    3c5c:	52ae fffc      	addql #1,%fp@(-4)
    3c60:	222e fffc      	movel %fp@(-4),%d1
    3c64:	202e 000c      	movel %fp@(12),%d0
    3c68:	5380           	subql #1,%d0
    3c6a:	b081           	cmpl %d1,%d0
    3c6c:	6200 ff60      	bhiw 0x3bce
    3c70:	2f2e ffec      	movel %fp@(-20),%sp@-
    3c74:	4eb9 0000 0000 	jsr 0x0
    3c7a:	588f           	addql #4,%sp
    3c7c:	6002           	bras 0x3c80
    3c7e:	4e71           	nop
    3c80:	4e5e           	unlk %fp
    3c82:	4e75           	rts
    3c84:	4e56 fffc      	linkw %fp,#-4
    3c88:	202e 0008      	movel %fp@(8),%d0
    3c8c:	2040           	moveal %d0,%a0
    3c8e:	2028 0004      	movel %a0@(4),%d0
    3c92:	727f           	moveq #127,%d1
    3c94:	4601           	notb %d1
    3c96:	c081           	andl %d1,%d0
    3c98:	4a80           	tstl %d0
    3c9a:	670e           	beqs 0x3caa
    3c9c:	202e 0008      	movel %fp@(8),%d0
    3ca0:	2040           	moveal %d0,%a0
    3ca2:	2010           	movel %a0@,%d0
    3ca4:	4a80           	tstl %d0
    3ca6:	6600 0224      	bnew 0x3ecc
    3caa:	202e 0008      	movel %fp@(8),%d0
    3cae:	2240           	moveal %d0,%a1
    3cb0:	2029 0004      	movel %a1@(4),%d0
    3cb4:	0280 0000 0100 	andil #256,%d0
    3cba:	4a80           	tstl %d0
    3cbc:	6716           	beqs 0x3cd4
    3cbe:	2f2e 0008      	movel %fp@(8),%sp@-
    3cc2:	4eb9 0000 0000 	jsr 0x0
    3cc8:	588f           	addql #4,%sp
    3cca:	4a80           	tstl %d0
    3ccc:	6706           	beqs 0x3cd4
    3cce:	70ff           	moveq #-1,%d0
    3cd0:	6000 0224      	braw 0x3ef6
    3cd4:	202e 0008      	movel %fp@(8),%d0
    3cd8:	2040           	moveal %d0,%a0
    3cda:	2028 0004      	movel %a0@(4),%d0
    3cde:	2200           	movel %d0,%d1
    3ce0:	0241 feff      	andiw #-257,%d1
    3ce4:	202e 0008      	movel %fp@(8),%d0
    3ce8:	2240           	moveal %d0,%a1
    3cea:	2341 0004      	movel %d1,%a1@(4)
    3cee:	202e 0008      	movel %fp@(8),%d0
    3cf2:	2040           	moveal %d0,%a0
    3cf4:	2028 0004      	movel %a0@(4),%d0
    3cf8:	727f           	moveq #127,%d1
    3cfa:	4601           	notb %d1
    3cfc:	c081           	andl %d1,%d0
    3cfe:	4a80           	tstl %d0
    3d00:	6626           	bnes 0x3d28
    3d02:	202e 0008      	movel %fp@(8),%d0
    3d06:	2040           	moveal %d0,%a0
    3d08:	4290           	clrl %a0@
    3d0a:	202e 0008      	movel %fp@(8),%d0
    3d0e:	2240           	moveal %d0,%a1
    3d10:	2229 000e      	movel %a1@(14),%d1
    3d14:	202e 0008      	movel %fp@(8),%d0
    3d18:	2040           	moveal %d0,%a0
    3d1a:	2141 0012      	movel %d1,%a0@(18)
    3d1e:	202e 0008      	movel %fp@(8),%d0
    3d22:	2240           	moveal %d0,%a1
    3d24:	4229 0009      	clrb %a1@(9)
    3d28:	202e 0008      	movel %fp@(8),%d0
    3d2c:	2040           	moveal %d0,%a0
    3d2e:	2028 0004      	movel %a0@(4),%d0
    3d32:	727f           	moveq #127,%d1
    3d34:	4601           	notb %d1
    3d36:	8280           	orl %d0,%d1
    3d38:	202e 0008      	movel %fp@(8),%d0
    3d3c:	2240           	moveal %d0,%a1
    3d3e:	2341 0004      	movel %d1,%a1@(4)
    3d42:	202e 0008      	movel %fp@(8),%d0
    3d46:	2040           	moveal %d0,%a0
    3d48:	2010           	movel %a0@,%d0
    3d4a:	4a80           	tstl %d0
    3d4c:	6600 017e      	bnew 0x3ecc
    3d50:	202e 0008      	movel %fp@(8),%d0
    3d54:	2240           	moveal %d0,%a1
    3d56:	2229 000e      	movel %a1@(14),%d1
    3d5a:	202e 0008      	movel %fp@(8),%d0
    3d5e:	2040           	moveal %d0,%a0
    3d60:	2141 0012      	movel %d1,%a0@(18)
    3d64:	202e 0008      	movel %fp@(8),%d0
    3d68:	2240           	moveal %d0,%a1
    3d6a:	2029 0004      	movel %a1@(4),%d0
    3d6e:	7208           	moveq #8,%d1
    3d70:	c081           	andl %d1,%d0
    3d72:	4a80           	tstl %d0
    3d74:	6700 011a      	beqw 0x3e90
    3d78:	6000 00e4      	braw 0x3e5e
    3d7c:	202e 0008      	movel %fp@(8),%d0
    3d80:	2040           	moveal %d0,%a0
    3d82:	2228 0012      	movel %a0@(18),%d1
    3d86:	202e 0008      	movel %fp@(8),%d0
    3d8a:	2240           	moveal %d0,%a1
    3d8c:	1029 0008      	moveb %a1@(8),%d0
    3d90:	49c0           	extbl %d0
    3d92:	4878 0001      	pea 0x1
    3d96:	2f01           	movel %d1,%sp@-
    3d98:	2f00           	movel %d0,%sp@-
    3d9a:	4eb9 0000 0000 	jsr 0x0
    3da0:	4fef 000c      	lea %sp@(12),%sp
    3da4:	2d40 fffc      	movel %d0,%fp@(-4)
    3da8:	4aae fffc      	tstl %fp@(-4)
    3dac:	6700 00ca      	beqw 0x3e78
    3db0:	202e 0008      	movel %fp@(8),%d0
    3db4:	2040           	moveal %d0,%a0
    3db6:	2010           	movel %a0@,%d0
    3db8:	2200           	movel %d0,%d1
    3dba:	5281           	addql #1,%d1
    3dbc:	202e 0008      	movel %fp@(8),%d0
    3dc0:	2240           	moveal %d0,%a1
    3dc2:	2281           	movel %d1,%a1@
    3dc4:	202e 0008      	movel %fp@(8),%d0
    3dc8:	2040           	moveal %d0,%a0
    3dca:	2028 0012      	movel %a0@(18),%d0
    3dce:	2240           	moveal %d0,%a1
    3dd0:	1011           	moveb %a1@,%d0
    3dd2:	0c00 000a      	cmpib #10,%d0
    3dd6:	6700 00a2      	beqw 0x3e7a
    3dda:	202e 0008      	movel %fp@(8),%d0
    3dde:	2040           	moveal %d0,%a0
    3de0:	2028 0012      	movel %a0@(18),%d0
    3de4:	2240           	moveal %d0,%a1
    3de6:	1011           	moveb %a1@,%d0
    3de8:	0c00 000d      	cmpib #13,%d0
    3dec:	6700 008c      	beqw 0x3e7a
    3df0:	202e 0008      	movel %fp@(8),%d0
    3df4:	2040           	moveal %d0,%a0
    3df6:	2028 0012      	movel %a0@(18),%d0
    3dfa:	2240           	moveal %d0,%a1
    3dfc:	1011           	moveb %a1@,%d0
    3dfe:	4a00           	tstb %d0
    3e00:	6644           	bnes 0x3e46
    3e02:	202e 0008      	movel %fp@(8),%d0
    3e06:	2040           	moveal %d0,%a0
    3e08:	2028 0004      	movel %a0@(4),%d0
    3e0c:	7240           	moveq #64,%d1
    3e0e:	c081           	andl %d1,%d0
    3e10:	4a80           	tstl %d0
    3e12:	6632           	bnes 0x3e46
    3e14:	202e 0008      	movel %fp@(8),%d0
    3e18:	2040           	moveal %d0,%a0
    3e1a:	2028 0004      	movel %a0@(4),%d0
    3e1e:	7220           	moveq #32,%d1
    3e20:	8280           	orl %d0,%d1
    3e22:	202e 0008      	movel %fp@(8),%d0
    3e26:	2240           	moveal %d0,%a1
    3e28:	2341 0004      	movel %d1,%a1@(4)
    3e2c:	202e 0008      	movel %fp@(8),%d0
    3e30:	2040           	moveal %d0,%a0
    3e32:	2228 000e      	movel %a0@(14),%d1
    3e36:	202e 0008      	movel %fp@(8),%d0
    3e3a:	2240           	moveal %d0,%a1
    3e3c:	2341 0012      	movel %d1,%a1@(18)
    3e40:	70ff           	moveq #-1,%d0
    3e42:	6000 00b2      	braw 0x3ef6
    3e46:	202e 0008      	movel %fp@(8),%d0
    3e4a:	2040           	moveal %d0,%a0
    3e4c:	2028 0012      	movel %a0@(18),%d0
    3e50:	2200           	movel %d0,%d1
    3e52:	5281           	addql #1,%d1
    3e54:	202e 0008      	movel %fp@(8),%d0
    3e58:	2240           	moveal %d0,%a1
    3e5a:	2341 0012      	movel %d1,%a1@(18)
    3e5e:	202e 0008      	movel %fp@(8),%d0
    3e62:	2040           	moveal %d0,%a0
    3e64:	2210           	movel %a0@,%d1
    3e66:	202e 0008      	movel %fp@(8),%d0
    3e6a:	2240           	moveal %d0,%a1
    3e6c:	2029 000a      	movel %a1@(10),%d0
    3e70:	b081           	cmpl %d1,%d0
    3e72:	6e00 ff08      	bgtw 0x3d7c
    3e76:	6002           	bras 0x3e7a
    3e78:	4e71           	nop
    3e7a:	202e 0008      	movel %fp@(8),%d0
    3e7e:	2040           	moveal %d0,%a0
    3e80:	2228 000e      	movel %a0@(14),%d1
    3e84:	202e 0008      	movel %fp@(8),%d0
    3e88:	2240           	moveal %d0,%a1
    3e8a:	2341 0012      	movel %d1,%a1@(18)
    3e8e:	603c           	bras 0x3ecc
    3e90:	202e 0008      	movel %fp@(8),%d0
    3e94:	2040           	moveal %d0,%a0
    3e96:	2028 000a      	movel %a0@(10),%d0
    3e9a:	2040           	moveal %d0,%a0
    3e9c:	202e 0008      	movel %fp@(8),%d0
    3ea0:	2240           	moveal %d0,%a1
    3ea2:	2229 000e      	movel %a1@(14),%d1
    3ea6:	202e 0008      	movel %fp@(8),%d0
    3eaa:	2240           	moveal %d0,%a1
    3eac:	1029 0008      	moveb %a1@(8),%d0
    3eb0:	49c0           	extbl %d0
    3eb2:	2f08           	movel %a0,%sp@-
    3eb4:	2f01           	movel %d1,%sp@-
    3eb6:	2f00           	movel %d0,%sp@-
    3eb8:	4eb9 0000 0000 	jsr 0x0
    3ebe:	4fef 000c      	lea %sp@(12),%sp
    3ec2:	2200           	movel %d0,%d1
    3ec4:	202e 0008      	movel %fp@(8),%d0
    3ec8:	2040           	moveal %d0,%a0
    3eca:	2081           	movel %d1,%a0@
    3ecc:	202e 0008      	movel %fp@(8),%d0
    3ed0:	2240           	moveal %d0,%a1
    3ed2:	2011           	movel %a1@,%d0
    3ed4:	4a80           	tstl %d0
    3ed6:	661c           	bnes 0x3ef4
    3ed8:	202e 0008      	movel %fp@(8),%d0
    3edc:	2040           	moveal %d0,%a0
    3ede:	2028 0004      	movel %a0@(4),%d0
    3ee2:	7220           	moveq #32,%d1
    3ee4:	8280           	orl %d0,%d1
    3ee6:	202e 0008      	movel %fp@(8),%d0
    3eea:	2240           	moveal %d0,%a1
    3eec:	2341 0004      	movel %d1,%a1@(4)
    3ef0:	70ff           	moveq #-1,%d0
    3ef2:	6002           	bras 0x3ef6
    3ef4:	4280           	clrl %d0
    3ef6:	4e5e           	unlk %fp
    3ef8:	4e75           	rts
    3efa:	4e71           	nop
    3efc:	4e56 fffc      	linkw %fp,#-4
    3f00:	2f2e 000c      	movel %fp@(12),%sp@-
    3f04:	4eb9 0000 0000 	jsr 0x0
    3f0a:	588f           	addql #4,%sp
    3f0c:	2008           	movel %a0,%d0
    3f0e:	2d40 fffc      	movel %d0,%fp@(-4)
    3f12:	2f2e 000c      	movel %fp@(12),%sp@-
    3f16:	2f2e 0008      	movel %fp@(8),%sp@-
    3f1a:	2f2e fffc      	movel %fp@(-4),%sp@-
    3f1e:	4eb9 0000 0000 	jsr 0x0
    3f24:	4fef 000c      	lea %sp@(12),%sp
    3f28:	2f2e 0008      	movel %fp@(8),%sp@-
    3f2c:	4eb9 0000 0000 	jsr 0x0
    3f32:	588f           	addql #4,%sp
    3f34:	202e fffc      	movel %fp@(-4),%d0
    3f38:	2200           	movel %d0,%d1
    3f3a:	2041           	moveal %d1,%a0
    3f3c:	4e5e           	unlk %fp
    3f3e:	4e75           	rts
    3f40:	4e56 0000      	linkw %fp,#0
    3f44:	2f2e 0008      	movel %fp@(8),%sp@-
    3f48:	4eb9 0000 0000 	jsr 0x0
    3f4e:	588f           	addql #4,%sp
    3f50:	4e5e           	unlk %fp
    3f52:	4e75           	rts
    3f54:	4e56 0000      	linkw %fp,#0
    3f58:	2f2e 000c      	movel %fp@(12),%sp@-
    3f5c:	2f2e 0008      	movel %fp@(8),%sp@-
    3f60:	4eb9 0000 0000 	jsr 0x0
    3f66:	508f           	addql #8,%sp
    3f68:	4e5e           	unlk %fp
    3f6a:	4e75           	rts
    3f6c:	4e56 0000      	linkw %fp,#0
    3f70:	42a7           	clrl %sp@-
    3f72:	42a7           	clrl %sp@-
    3f74:	2f2e 0008      	movel %fp@(8),%sp@-
    3f78:	4eb9 0000 0000 	jsr 0x0
    3f7e:	4fef 000c      	lea %sp@(12),%sp
    3f82:	4e5e           	unlk %fp
    3f84:	4e75           	rts
    3f86:	4e71           	nop
    3f88:	4e56 fe00      	linkw %fp,#-512
    3f8c:	200e           	movel %fp,%d0
    3f8e:	0680 ffff fe00 	addil #-512,%d0
    3f94:	2f00           	movel %d0,%sp@-
    3f96:	4eb9 0000 0000 	jsr 0x0
    3f9c:	588f           	addql #4,%sp
    3f9e:	2008           	movel %a0,%d0
    3fa0:	4a80           	tstl %d0
    3fa2:	6604           	bnes 0x3fa8
    3fa4:	4280           	clrl %d0
    3fa6:	6020           	bras 0x3fc8
    3fa8:	700c           	moveq #12,%d0
    3faa:	d08e           	addl %fp,%d0
    3fac:	222e 0008      	movel %fp@(8),%d1
    3fb0:	2f00           	movel %d0,%sp@-
    3fb2:	2f01           	movel %d1,%sp@-
    3fb4:	200e           	movel %fp,%d0
    3fb6:	0680 ffff fe00 	addil #-512,%d0
    3fbc:	2f00           	movel %d0,%sp@-
    3fbe:	4eb9 0000 0000 	jsr 0x0
    3fc4:	4fef 000c      	lea %sp@(12),%sp
    3fc8:	4e5e           	unlk %fp
    3fca:	4e75           	rts
    3fcc:	4e56 0000      	linkw %fp,#0
    3fd0:	4aae 000c      	tstl %fp@(12)
    3fd4:	671c           	beqs 0x3ff2
    3fd6:	4878 0200      	pea 0x200
    3fda:	4878 0001      	pea 0x1
    3fde:	2f2e 000c      	movel %fp@(12),%sp@-
    3fe2:	2f2e 0008      	movel %fp@(8),%sp@-
    3fe6:	4eb9 0000 0000 	jsr 0x0
    3fec:	4fef 0010      	lea %sp@(16),%sp
    3ff0:	601a           	bras 0x400c
    3ff2:	4878 0200      	pea 0x200
    3ff6:	4878 0004      	pea 0x4
    3ffa:	2f2e 000c      	movel %fp@(12),%sp@-
    3ffe:	2f2e 0008      	movel %fp@(8),%sp@-
    4002:	4eb9 0000 0000 	jsr 0x0
    4008:	4fef 0010      	lea %sp@(16),%sp
    400c:	4e5e           	unlk %fp
    400e:	4e75           	rts
    4010:	41ef 0004      	lea %sp@(4),%a0
    4014:	2050           	moveal %a0@,%a0
    4016:	48d0 fefe      	moveml %d1-%d7/%a1-%sp,%a0@
    401a:	42e8 003b      	movew %ccr,%a0@(59)
    401e:	2157 003c      	movel %sp@,%a0@(60)
    4022:	4280           	clrl %d0
    4024:	4e75           	rts
    4026:	41ef 0004      	lea %sp@(4),%a0
    402a:	2028 0004      	movel %a0@(4),%d0
    402e:	2050           	moveal %a0@,%a0
    4030:	4cd0 fefe      	moveml %a0@,%d1-%d7/%a1-%sp
    4034:	584f           	addqw #4,%sp
    4036:	2ea8 003c      	movel %a0@(60),%sp@
    403a:	44e8 003b      	movew %a0@(59),%ccr
    403e:	4e75           	rts
    4040:	4e56 0000      	linkw %fp,#0
    4044:	202e 0008      	movel %fp@(8),%d0
    4048:	2040           	moveal %d0,%a0
    404a:	3028 001a      	movew %a0@(26),%d0
    404e:	0c40 444c      	cmpiw #17484,%d0
    4052:	6706           	beqs 0x405a
    4054:	7001           	moveq #1,%d0
    4056:	6000 00ea      	braw 0x4142
    405a:	7004           	moveq #4,%d0
    405c:	b0ae 0010      	cmpl %fp@(16),%d0
    4060:	6522           	bcss 0x4084
    4062:	7001           	moveq #1,%d0
    4064:	222e 0010      	movel %fp@(16),%d1
    4068:	e3a8           	lsll %d1,%d0
    406a:	7216           	moveq #22,%d1
    406c:	c081           	andl %d1,%d0
    406e:	4a80           	tstl %d0
    4070:	6712           	beqs 0x4084
    4072:	2f2e 0008      	movel %fp@(8),%sp@-
    4076:	4eb9 0000 0000 	jsr 0x0
    407c:	588f           	addql #4,%sp
    407e:	4a80           	tstl %d0
    4080:	6608           	bnes 0x408a
    4082:	600c           	bras 0x4090
    4084:	7001           	moveq #1,%d0
    4086:	6000 00ba      	braw 0x4142
    408a:	7001           	moveq #1,%d0
    408c:	6000 00b4      	braw 0x4142
    4090:	202e 0008      	movel %fp@(8),%d0
    4094:	2040           	moveal %d0,%a0
    4096:	2028 0004      	movel %a0@(4),%d0
    409a:	7204           	moveq #4,%d1
    409c:	c081           	andl %d1,%d0
    409e:	4a80           	tstl %d0
    40a0:	6714           	beqs 0x40b6
    40a2:	202e 0008      	movel %fp@(8),%d0
    40a6:	2040           	moveal %d0,%a0
    40a8:	2028 000e      	movel %a0@(14),%d0
    40ac:	2f00           	movel %d0,%sp@-
    40ae:	4eb9 0000 0000 	jsr 0x0
    40b4:	588f           	addql #4,%sp
    40b6:	202e 0008      	movel %fp@(8),%d0
    40ba:	2040           	moveal %d0,%a0
    40bc:	2028 0004      	movel %a0@(4),%d0
    40c0:	72f3           	moveq #-13,%d1
    40c2:	c280           	andl %d0,%d1
    40c4:	202e 0008      	movel %fp@(8),%d0
    40c8:	2040           	moveal %d0,%a0
    40ca:	2141 0004      	movel %d1,%a0@(4)
    40ce:	222e 000c      	movel %fp@(12),%d1
    40d2:	202e 0008      	movel %fp@(8),%d0
    40d6:	2040           	moveal %d0,%a0
    40d8:	2141 000e      	movel %d1,%a0@(14)
    40dc:	222e 0014      	movel %fp@(20),%d1
    40e0:	202e 0008      	movel %fp@(8),%d0
    40e4:	2040           	moveal %d0,%a0
    40e6:	2141 000a      	movel %d1,%a0@(10)
    40ea:	202e 0008      	movel %fp@(8),%d0
    40ee:	2040           	moveal %d0,%a0
    40f0:	4290           	clrl %a0@
    40f2:	202e 0010      	movel %fp@(16),%d0
    40f6:	7202           	moveq #2,%d1
    40f8:	b280           	cmpl %d0,%d1
    40fa:	670e           	beqs 0x410a
    40fc:	7204           	moveq #4,%d1
    40fe:	b280           	cmpl %d0,%d1
    4100:	6722           	beqs 0x4124
    4102:	7201           	moveq #1,%d1
    4104:	b280           	cmpl %d0,%d1
    4106:	6736           	beqs 0x413e
    4108:	6030           	bras 0x413a
    410a:	202e 0008      	movel %fp@(8),%d0
    410e:	2040           	moveal %d0,%a0
    4110:	2028 0004      	movel %a0@(4),%d0
    4114:	7208           	moveq #8,%d1
    4116:	8280           	orl %d0,%d1
    4118:	202e 0008      	movel %fp@(8),%d0
    411c:	2040           	moveal %d0,%a0
    411e:	2141 0004      	movel %d1,%a0@(4)
    4122:	601c           	bras 0x4140
    4124:	202e 0008      	movel %fp@(8),%d0
    4128:	2040           	moveal %d0,%a0
    412a:	42a8 000e      	clrl %a0@(14)
    412e:	202e 0008      	movel %fp@(8),%d0
    4132:	2040           	moveal %d0,%a0
    4134:	42a8 000a      	clrl %a0@(10)
    4138:	6006           	bras 0x4140
    413a:	7001           	moveq #1,%d0
    413c:	6004           	bras 0x4142
    413e:	4e71           	nop
    4140:	4280           	clrl %d0
    4142:	4e5e           	unlk %fp
    4144:	4e75           	rts
    4146:	4e71           	nop
    4148:	4e56 0000      	linkw %fp,#0
    414c:	4e5e           	unlk %fp
    414e:	4e75           	rts
    4150:	4e56 0000      	linkw %fp,#0
    4154:	4e5e           	unlk %fp
    4156:	4e75           	rts
    4158:	4e56 0000      	linkw %fp,#0
    415c:	203c 0000 0000 	movel #0,%d0
    4162:	5080           	addql #8,%d0
    4164:	2040           	moveal %d0,%a0
    4166:	2010           	movel %a0@,%d0
    4168:	4879 0000 0000 	pea 0x0
    416e:	2f00           	movel %d0,%sp@-
    4170:	4eb9 0000 0000 	jsr 0x0
    4176:	508f           	addql #8,%sp
    4178:	4878 0001      	pea 0x1
    417c:	4eb9 0000 0000 	jsr 0x0
    4182:	588f           	addql #4,%sp
    4184:	4e5e           	unlk %fp
    4186:	4e75           	rts
    4188:	4e56 0000      	linkw %fp,#0
    418c:	203c 0000 0000 	movel #0,%d0
    4192:	5080           	addql #8,%d0
    4194:	2040           	moveal %d0,%a0
    4196:	2010           	movel %a0@,%d0
    4198:	4879 0000 0000 	pea 0x0
    419e:	2f00           	movel %d0,%sp@-
    41a0:	4eb9 0000 0000 	jsr 0x0
    41a6:	508f           	addql #8,%sp
    41a8:	4878 0001      	pea 0x1
    41ac:	4eb9 0000 0000 	jsr 0x0
    41b2:	588f           	addql #4,%sp
    41b4:	4e5e           	unlk %fp
    41b6:	4e75           	rts
    41b8:	4e56 0000      	linkw %fp,#0
    41bc:	42a7           	clrl %sp@-
    41be:	4eb9 0000 0000 	jsr 0x0
    41c4:	588f           	addql #4,%sp
    41c6:	4e5e           	unlk %fp
    41c8:	4e75           	rts
    41ca:	4e56 0000      	linkw %fp,#0
    41ce:	4e5e           	unlk %fp
    41d0:	4e75           	rts
    41d2:	4e56 0000      	linkw %fp,#0
    41d6:	4e5e           	unlk %fp
    41d8:	4e75           	rts
    41da:	4e56 0000      	linkw %fp,#0
    41de:	4e5e           	unlk %fp
    41e0:	4e75           	rts
    41e2:	4e56 0000      	linkw %fp,#0
    41e6:	4e5e           	unlk %fp
    41e8:	4e75           	rts
    41ea:	4e56 0000      	linkw %fp,#0
    41ee:	4878 0001      	pea 0x1
    41f2:	4eb9 0000 0000 	jsr 0x0
    41f8:	588f           	addql #4,%sp
    41fa:	4e5e           	unlk %fp
    41fc:	4e75           	rts
    41fe:	4e56 0000      	linkw %fp,#0
    4202:	7001           	moveq #1,%d0
    4204:	23c0 0000 0000 	movel %d0,0x0
    420a:	4878 0001      	pea 0x1
    420e:	4eb9 0000 0000 	jsr 0x0
    4214:	588f           	addql #4,%sp
    4216:	4e5e           	unlk %fp
    4218:	4e75           	rts
    421a:	4e56 fffc      	linkw %fp,#-4
    421e:	7016           	moveq #22,%d0
    4220:	b0ae 0008      	cmpl %fp@(8),%d0
    4224:	6c04           	bges 0x422a
    4226:	70ff           	moveq #-1,%d0
    4228:	604e           	bras 0x4278
    422a:	202e 0008      	movel %fp@(8),%d0
    422e:	2d70 0db0 0000 	movel @(00000000,%d0:l:4),%fp@(-4)
    4234:	0000 fffc 
    4238:	70ff           	moveq #-1,%d0
    423a:	b0ae fffc      	cmpl %fp@(-4),%d0
    423e:	6604           	bnes 0x4244
    4240:	70ff           	moveq #-1,%d0
    4242:	6034           	bras 0x4278
    4244:	4aae fffc      	tstl %fp@(-4)
    4248:	661a           	bnes 0x4264
    424a:	202e 0008      	movel %fp@(8),%d0
    424e:	2230 0db0 0000 	movel @(00000000,%d0:l:4),%d1
    4254:	0000 
    4256:	202e 0008      	movel %fp@(8),%d0
    425a:	2181 0db0 0000 	movel %d1,@(00000000,%d0:l:4)
    4260:	0000 
    4262:	6010           	bras 0x4274
    4264:	222e 000c      	movel %fp@(12),%d1
    4268:	202e 0008      	movel %fp@(8),%d0
    426c:	2181 0db0 0000 	movel %d1,@(00000000,%d0:l:4)
    4272:	0000 
    4274:	202e fffc      	movel %fp@(-4),%d0
    4278:	2200           	movel %d0,%d1
    427a:	2041           	moveal %d1,%a0
    427c:	4e5e           	unlk %fp
    427e:	4e75           	rts
    4280:	4e56 fffc      	linkw %fp,#-4
    4284:	202e 0008      	movel %fp@(8),%d0
    4288:	2d70 0db0 0000 	movel @(00000000,%d0:l:4),%fp@(-4)
    428e:	0000 fffc 
    4292:	70ff           	moveq #-1,%d0
    4294:	b0ae fffc      	cmpl %fp@(-4),%d0
    4298:	6604           	bnes 0x429e
    429a:	7001           	moveq #1,%d0
    429c:	601c           	bras 0x42ba
    429e:	7001           	moveq #1,%d0
    42a0:	b0ae fffc      	cmpl %fp@(-4),%d0
    42a4:	6604           	bnes 0x42aa
    42a6:	4280           	clrl %d0
    42a8:	6010           	bras 0x42ba
    42aa:	2f2e 0008      	movel %fp@(8),%sp@-
    42ae:	202e fffc      	movel %fp@(-4),%d0
    42b2:	2040           	moveal %d0,%a0
    42b4:	4e90           	jsr %a0@
    42b6:	588f           	addql #4,%sp
    42b8:	4280           	clrl %d0
    42ba:	4e5e           	unlk %fp
    42bc:	4e75           	rts
    42be:	4e56 fffc      	linkw %fp,#-4
    42c2:	42ae fffc      	clrl %fp@(-4)
    42c6:	601c           	bras 0x42e4
    42c8:	202e fffc      	movel %fp@(-4),%d0
    42cc:	2230 0db0 0000 	movel @(00000000,%d0:l:4),%d1
    42d2:	0000 
    42d4:	202e fffc      	movel %fp@(-4),%d0
    42d8:	2181 0db0 0000 	movel %d1,@(00000000,%d0:l:4)
    42de:	0000 
    42e0:	52ae fffc      	addql #1,%fp@(-4)
    42e4:	7016           	moveq #22,%d0
    42e6:	b0ae fffc      	cmpl %fp@(-4),%d0
    42ea:	6cdc           	bges 0x42c8
    42ec:	4e5e           	unlk %fp
    42ee:	4e75           	rts
    42f0:	4e56 fff0      	linkw %fp,#-16
    42f4:	2d7c 0001 2345 	movel #74565,%fp@(-4)
    42fa:	fffc 
    42fc:	2d7c 0000 0314 	movel #788,%fp@(-8)
    4302:	fff8 
    4304:	202e fffc      	movel %fp@(-4),%d0
    4308:	4c6e 0801 fff8 	divsll %fp@(-8),%d1,%d0
    430e:	2d40 fff4      	movel %d0,%fp@(-12)
    4312:	2d6e fff4 fffc 	movel %fp@(-12),%fp@(-4)
    4318:	2039 0000 0000 	movel 0x0,%d0
    431e:	4a80           	tstl %d0
    4320:	6d22           	blts 0x4344
    4322:	2239 0000 0000 	movel 0x0,%d1
    4328:	2039 0000 0000 	movel 0x0,%d0
    432e:	b081           	cmpl %d1,%d0
    4330:	6e12           	bgts 0x4344
    4332:	2039 0000 0000 	movel 0x0,%d0
    4338:	5280           	addql #1,%d0
    433a:	23c0 0000 0000 	movel %d0,0x0
    4340:	6000 016a      	braw 0x44ac
    4344:	707e           	moveq #126,%d0
    4346:	b0ae 000c      	cmpl %fp@(12),%d0
    434a:	6c1e           	bges 0x436a
    434c:	2039 0000 0000 	movel 0x0,%d0
    4352:	5280           	addql #1,%d0
    4354:	23c0 0000 0000 	movel %d0,0x0
    435a:	23ee 000c 0000 	movel %fp@(12),0x0
    4360:	0000 
    4362:	723f           	moveq #63,%d1
    4364:	2d41 000c      	movel %d1,%fp@(12)
    4368:	6042           	bras 0x43ac
    436a:	701f           	moveq #31,%d0
    436c:	b0ae 000c      	cmpl %fp@(12),%d0
    4370:	6d3a           	blts 0x43ac
    4372:	720d           	moveq #13,%d1
    4374:	b2ae 000c      	cmpl %fp@(12),%d1
    4378:	6512           	bcss 0x438c
    437a:	7001           	moveq #1,%d0
    437c:	222e 000c      	movel %fp@(12),%d1
    4380:	e3a8           	lsll %d1,%d0
    4382:	0280 0000 240c 	andil #9228,%d0
    4388:	4a80           	tstl %d0
    438a:	661e           	bnes 0x43aa
    438c:	2039 0000 0000 	movel 0x0,%d0
    4392:	5280           	addql #1,%d0
    4394:	23c0 0000 0000 	movel %d0,0x0
    439a:	23ee 000c 0000 	movel %fp@(12),0x0
    43a0:	0000 
    43a2:	703f           	moveq #63,%d0
    43a4:	2d40 000c      	movel %d0,%fp@(12)
    43a8:	6002           	bras 0x43ac
    43aa:	4e71           	nop
    43ac:	4aae 0008      	tstl %fp@(8)
    43b0:	6700 00fa      	beqw 0x44ac
    43b4:	1039 0000 0000 	moveb 0x0,%d0
    43ba:	0c00 0001      	cmpib #1,%d0
    43be:	6600 00aa      	bnew 0x446a
    43c2:	2039 0000 0000 	movel 0x0,%d0
    43c8:	4a80           	tstl %d0
    43ca:	6710           	beqs 0x43dc
    43cc:	2039 0000 0000 	movel 0x0,%d0
    43d2:	0c80 0000 0200 	cmpil #512,%d0
    43d8:	6600 0090      	bnew 0x446a
    43dc:	2039 0000 0000 	movel 0x0,%d0
    43e2:	5280           	addql #1,%d0
    43e4:	23c0 0000 0000 	movel %d0,0x0
    43ea:	2039 0000 0000 	movel 0x0,%d0
    43f0:	7209           	moveq #9,%d1
    43f2:	e3a8           	lsll %d1,%d0
    43f4:	5280           	addql #1,%d0
    43f6:	2239 0000 0000 	movel 0x0,%d1
    43fc:	2f00           	movel %d0,%sp@-
    43fe:	2f01           	movel %d1,%sp@-
    4400:	4eb9 0000 0000 	jsr 0x0
    4406:	508f           	addql #8,%sp
    4408:	2d40 fff0      	movel %d0,%fp@(-16)
    440c:	4aae fff0      	tstl %fp@(-16)
    4410:	673a           	beqs 0x444c
    4412:	2039 0000 0000 	movel 0x0,%d0
    4418:	2040           	moveal %d0,%a0
    441a:	20ae fff0      	movel %fp@(-16),%a0@
    441e:	23ee fff0 0000 	movel %fp@(-16),0x0
    4424:	0000 
    4426:	2039 0000 0000 	movel 0x0,%d0
    442c:	7209           	moveq #9,%d1
    442e:	e3a8           	lsll %d1,%d0
    4430:	0680 ffff fe00 	addil #-512,%d0
    4436:	222e fff0      	movel %fp@(-16),%d1
    443a:	d280           	addl %d0,%d1
    443c:	202e 0008      	movel %fp@(8),%d0
    4440:	2040           	moveal %d0,%a0
    4442:	2081           	movel %d1,%a0@
    4444:	42b9 0000 0000 	clrl 0x0
    444a:	601e           	bras 0x446a
    444c:	2039 0000 0000 	movel 0x0,%d0
    4452:	5380           	subql #1,%d0
    4454:	23c0 0000 0000 	movel %d0,0x0
    445a:	2039 0000 0000 	movel 0x0,%d0
    4460:	5280           	addql #1,%d0
    4462:	23c0 0000 0000 	movel %d0,0x0
    4468:	6042           	bras 0x44ac
    446a:	202e 0008      	movel %fp@(8),%d0
    446e:	2040           	moveal %d0,%a0
    4470:	2010           	movel %a0@,%d0
    4472:	222e 000c      	movel %fp@(12),%d1
    4476:	1201           	moveb %d1,%d1
    4478:	2040           	moveal %d0,%a0
    447a:	1081           	moveb %d1,%a0@
    447c:	202e 0008      	movel %fp@(8),%d0
    4480:	2040           	moveal %d0,%a0
    4482:	2010           	movel %a0@,%d0
    4484:	2200           	movel %d0,%d1
    4486:	5281           	addql #1,%d1
    4488:	202e 0008      	movel %fp@(8),%d0
    448c:	2040           	moveal %d0,%a0
    448e:	2081           	movel %d1,%a0@
    4490:	2039 0000 0000 	movel 0x0,%d0
    4496:	5280           	addql #1,%d0
    4498:	23c0 0000 0000 	movel %d0,0x0
    449e:	2039 0000 0000 	movel 0x0,%d0
    44a4:	5280           	addql #1,%d0
    44a6:	23c0 0000 0000 	movel %d0,0x0
    44ac:	4e5e           	unlk %fp
    44ae:	4e75           	rts
    44b0:	4e56 ffc4      	linkw %fp,#-60
    44b4:	2f02           	movel %d2,%sp@-
    44b6:	4aae 0008      	tstl %fp@(8)
    44ba:	6706           	beqs 0x44c2
    44bc:	202e 0008      	movel %fp@(8),%d0
    44c0:	6006           	bras 0x44c8
    44c2:	203c 0000 0000 	movel #0,%d0
    44c8:	2d40 fffc      	movel %d0,%fp@(-4)
    44cc:	206e 000c      	moveal %fp@(12),%a0
    44d0:	226e 0010      	moveal %fp@(16),%a1
    44d4:	4280           	clrl %d0
    44d6:	4281           	clrl %d1
    44d8:	2f09           	movel %a1,%sp@-
    44da:	2f08           	movel %a0,%sp@-
    44dc:	f21f 5400      	fmoved %sp@+,%fp0
    44e0:	2f01           	movel %d1,%sp@-
    44e2:	2f00           	movel %d0,%sp@-
    44e4:	f21f 5480      	fmoved %sp@+,%fp1
    44e8:	f200 0438      	fcmpx %fp1,%fp0
    44ec:	f240 0014      	fslt %d0
    44f0:	4400           	negb %d0
    44f2:	4a00           	tstb %d0
    44f4:	671c           	beqs 0x4512
    44f6:	202e fffc      	movel %fp@(-4),%d0
    44fa:	2040           	moveal %d0,%a0
    44fc:	10bc 002d      	moveb #45,%a0@
    4500:	52ae fffc      	addql #1,%fp@(-4)
    4504:	f22e 541a 000c 	fnegd %fp@(12),%fp0
    450a:	f22e 7400 000c 	fmoved %fp0,%fp@(12)
    4510:	6018           	bras 0x452a
    4512:	2039 0000 0000 	movel 0x0,%d0
    4518:	4a80           	tstl %d0
    451a:	670e           	beqs 0x452a
    451c:	202e fffc      	movel %fp@(-4),%d0
    4520:	2040           	moveal %d0,%a0
    4522:	10bc 002b      	moveb #43,%a0@
    4526:	52ae fffc      	addql #1,%fp@(-4)
    452a:	7007           	moveq #7,%d0
    452c:	b0ae 0014      	cmpl %fp@(20),%d0
    4530:	6528           	bcss 0x455a
    4532:	202e 0014      	movel %fp@(20),%d0
    4536:	2230 0fb0 0000 	movel @(00000000,%d0:l:8),%d1
    453c:	0000 
    453e:	2030 0fb0 0000 	movel @(00000000,%d0:l:8),%d0
    4544:	0000 
    4546:	2f01           	movel %d1,%sp@-
    4548:	2f00           	movel %d0,%sp@-
    454a:	f21f 5400      	fmoved %sp@+,%fp0
    454e:	f22e 5422 000c 	faddd %fp@(12),%fp0
    4554:	f22e 7400 000c 	fmoved %fp0,%fp@(12)
    455a:	7001           	moveq #1,%d0
    455c:	2d40 fff8      	movel %d0,%fp@(-8)
    4560:	42ae fff4      	clrl %fp@(-12)
    4564:	6016           	bras 0x457c
    4566:	202e fff8      	movel %fp@(-8),%d0
    456a:	d080           	addl %d0,%d0
    456c:	2200           	movel %d0,%d1
    456e:	e589           	lsll #2,%d1
    4570:	2400           	movel %d0,%d2
    4572:	d481           	addl %d1,%d2
    4574:	2d42 fff8      	movel %d2,%fp@(-8)
    4578:	52ae fff4      	addql #1,%fp@(-12)
    457c:	206e fff4      	moveal %fp@(-12),%a0
    4580:	b1ee 0014      	cmpal %fp@(20),%a0
    4584:	65e0           	bcss 0x4566
    4586:	202e 000c      	movel %fp@(12),%d0
    458a:	222e 0010      	movel %fp@(16),%d1
    458e:	2f01           	movel %d1,%sp@-
    4590:	2f00           	movel %d0,%sp@-
    4592:	f21f 5400      	fmoved %sp@+,%fp0
    4596:	f23c 5438 41e0 	fcmpd #0e2.14748e+09,%fp0
    459c:	0000 0000 0000 
    45a2:	f293 0020      	fbge 0x45c4
    45a6:	f22e 5483 000c 	fintrzd %fp@(12),%fp1
    45ac:	f227 7480      	fmoved %fp1,%sp@-
    45b0:	201f           	movel %sp@+,%d0
    45b2:	221f           	movel %sp@+,%d1
    45b4:	2f01           	movel %d1,%sp@-
    45b6:	2f00           	movel %d0,%sp@-
    45b8:	f21f 5400      	fmoved %sp@+,%fp0
    45bc:	f22e 6000 fff0 	fmovel %fp0,%fp@(-16)
    45c2:	6042           	bras 0x4606
    45c4:	f22e 5480 000c 	fmoved %fp@(12),%fp1
    45ca:	f23c 54a8 41e0 	fsubd #0e2.14748e+09,%fp1
    45d0:	0000 0000 0000 
    45d6:	f227 7480      	fmoved %fp1,%sp@-
    45da:	201f           	movel %sp@+,%d0
    45dc:	221f           	movel %sp@+,%d1
    45de:	2f01           	movel %d1,%sp@-
    45e0:	2f00           	movel %d0,%sp@-
    45e2:	f21f 5400      	fmoved %sp@+,%fp0
    45e6:	f200 0003      	fintrzx %fp0,%fp0
    45ea:	f227 7400      	fmoved %fp0,%sp@-
    45ee:	201f           	movel %sp@+,%d0
    45f0:	221f           	movel %sp@+,%d1
    45f2:	2f01           	movel %d1,%sp@-
    45f4:	2f00           	movel %d0,%sp@-
    45f6:	f21f 5480      	fmoved %sp@+,%fp1
    45fa:	f22e 6080 fff0 	fmovel %fp1,%fp@(-16)
    4600:	086e 0007 fff0 	bchg #7,%fp@(-16)
    4606:	f22e 4000 fff0 	fmovel %fp@(-16),%fp0
    460c:	f227 7400      	fmoved %fp0,%sp@-
    4610:	201f           	movel %sp@+,%d0
    4612:	221f           	movel %sp@+,%d1
    4614:	4aae fff0      	tstl %fp@(-16)
    4618:	6c1c           	bges 0x4636
    461a:	2f01           	movel %d1,%sp@-
    461c:	2f00           	movel %d0,%sp@-
    461e:	f21f 5480      	fmoved %sp@+,%fp1
    4622:	f23c 54a2 41f0 	faddd #0e4.29497e+09,%fp1
    4628:	0000 0000 0000 
    462e:	f227 7480      	fmoved %fp1,%sp@-
    4632:	201f           	movel %sp@+,%d0
    4634:	221f           	movel %sp@+,%d1
    4636:	f22e 5400 000c 	fmoved %fp@(12),%fp0
    463c:	2f01           	movel %d1,%sp@-
    463e:	2f00           	movel %d0,%sp@-
    4640:	f21f 5480      	fmoved %sp@+,%fp1
    4644:	f200 0428      	fsubx %fp1,%fp0
    4648:	f227 7400      	fmoved %fp0,%sp@-
    464c:	205f           	moveal %sp@+,%a0
    464e:	225f           	moveal %sp@+,%a1
    4650:	f22e 4000 fff8 	fmovel %fp@(-8),%fp0
    4656:	f227 7400      	fmoved %fp0,%sp@-
    465a:	201f           	movel %sp@+,%d0
    465c:	221f           	movel %sp@+,%d1
    465e:	4aae fff8      	tstl %fp@(-8)
    4662:	6c1c           	bges 0x4680
    4664:	2f01           	movel %d1,%sp@-
    4666:	2f00           	movel %d0,%sp@-
    4668:	f21f 5480      	fmoved %sp@+,%fp1
    466c:	f23c 54a2 41f0 	faddd #0e4.29497e+09,%fp1
    4672:	0000 0000 0000 
    4678:	f227 7480      	fmoved %fp1,%sp@-
    467c:	201f           	movel %sp@+,%d0
    467e:	221f           	movel %sp@+,%d1
    4680:	2f09           	movel %a1,%sp@-
    4682:	2f08           	movel %a0,%sp@-
    4684:	f21f 5400      	fmoved %sp@+,%fp0
    4688:	2f01           	movel %d1,%sp@-
    468a:	2f00           	movel %d0,%sp@-
    468c:	f21f 5480      	fmoved %sp@+,%fp1
    4690:	f200 0423      	fmulx %fp1,%fp0
    4694:	f227 7400      	fmoved %fp0,%sp@-
    4698:	201f           	movel %sp@+,%d0
    469a:	221f           	movel %sp@+,%d1
    469c:	2f01           	movel %d1,%sp@-
    469e:	2f00           	movel %d0,%sp@-
    46a0:	f21f 5400      	fmoved %sp@+,%fp0
    46a4:	f23c 5438 41e0 	fcmpd #0e2.14748e+09,%fp0
    46aa:	0000 0000 0000 
    46b0:	f293 0026      	fbge 0x46d8
    46b4:	2f01           	movel %d1,%sp@-
    46b6:	2f00           	movel %d0,%sp@-
    46b8:	f21f 5480      	fmoved %sp@+,%fp1
    46bc:	f200 0483      	fintrzx %fp1,%fp1
    46c0:	f227 7480      	fmoved %fp1,%sp@-
    46c4:	201f           	movel %sp@+,%d0
    46c6:	221f           	movel %sp@+,%d1
    46c8:	2f01           	movel %d1,%sp@-
    46ca:	2f00           	movel %d0,%sp@-
    46cc:	f21f 5400      	fmoved %sp@+,%fp0
    46d0:	f22e 6000 ffec 	fmovel %fp0,%fp@(-20)
    46d6:	6044           	bras 0x471c
    46d8:	2f01           	movel %d1,%sp@-
    46da:	2f00           	movel %d0,%sp@-
    46dc:	f21f 5480      	fmoved %sp@+,%fp1
    46e0:	f23c 54a8 41e0 	fsubd #0e2.14748e+09,%fp1
    46e6:	0000 0000 0000 
    46ec:	f227 7480      	fmoved %fp1,%sp@-
    46f0:	201f           	movel %sp@+,%d0
    46f2:	221f           	movel %sp@+,%d1
    46f4:	2f01           	movel %d1,%sp@-
    46f6:	2f00           	movel %d0,%sp@-
    46f8:	f21f 5400      	fmoved %sp@+,%fp0
    46fc:	f200 0003      	fintrzx %fp0,%fp0
    4700:	f227 7400      	fmoved %fp0,%sp@-
    4704:	201f           	movel %sp@+,%d0
    4706:	221f           	movel %sp@+,%d1
    4708:	2f01           	movel %d1,%sp@-
    470a:	2f00           	movel %d0,%sp@-
    470c:	f21f 5480      	fmoved %sp@+,%fp1
    4710:	f22e 6080 ffec 	fmovel %fp1,%fp@(-20)
    4716:	086e 0007 ffec 	bchg #7,%fp@(-20)
    471c:	42ae fff4      	clrl %fp@(-12)
    4720:	604c           	bras 0x476e
    4722:	222e fff0      	movel %fp@(-16),%d1
    4726:	2401           	movel %d1,%d2
    4728:	4c3c 2400 cccc 	mulul #-858993459,%d0,%d2
    472e:	cccd 
    4730:	e688           	lsrl #3,%d0
    4732:	d080           	addl %d0,%d0
    4734:	2400           	movel %d0,%d2
    4736:	e58a           	lsll #2,%d2
    4738:	2042           	moveal %d2,%a0
    473a:	d088           	addl %a0,%d0
    473c:	2401           	movel %d1,%d2
    473e:	9480           	subl %d0,%d2
    4740:	2002           	movel %d2,%d0
    4742:	1000           	moveb %d0,%d0
    4744:	0600 0030      	addib #48,%d0
    4748:	1200           	moveb %d0,%d1
    474a:	70c4           	moveq #-60,%d0
    474c:	d08e           	addl %fp,%d0
    474e:	d0ae fff4      	addl %fp@(-12),%d0
    4752:	2040           	moveal %d0,%a0
    4754:	1081           	moveb %d1,%a0@
    4756:	52ae fff4      	addql #1,%fp@(-12)
    475a:	202e fff0      	movel %fp@(-16),%d0
    475e:	2200           	movel %d0,%d1
    4760:	4c3c 1400 cccc 	mulul #-858993459,%d0,%d1
    4766:	cccd 
    4768:	e688           	lsrl #3,%d0
    476a:	2d40 fff0      	movel %d0,%fp@(-16)
    476e:	4aae fff0      	tstl %fp@(-16)
    4772:	66ae           	bnes 0x4722
    4774:	4aae fff4      	tstl %fp@(-12)
    4778:	662a           	bnes 0x47a4
    477a:	202e fffc      	movel %fp@(-4),%d0
    477e:	2040           	moveal %d0,%a0
    4780:	10bc 0030      	moveb #48,%a0@
    4784:	52ae fffc      	addql #1,%fp@(-4)
    4788:	6020           	bras 0x47aa
    478a:	202e fff4      	movel %fp@(-12),%d0
    478e:	5380           	subql #1,%d0
    4790:	1236 08c4      	moveb %fp@(ffffffc4,%d0:l),%d1
    4794:	202e fffc      	movel %fp@(-4),%d0
    4798:	2040           	moveal %d0,%a0
    479a:	1081           	moveb %d1,%a0@
    479c:	52ae fffc      	addql #1,%fp@(-4)
    47a0:	53ae fff4      	subql #1,%fp@(-12)
    47a4:	4aae fff4      	tstl %fp@(-12)
    47a8:	66e0           	bnes 0x478a
    47aa:	4aae 0014      	tstl %fp@(20)
    47ae:	6700 00bc      	beqw 0x486c
    47b2:	202e fffc      	movel %fp@(-4),%d0
    47b6:	2040           	moveal %d0,%a0
    47b8:	10bc 002e      	moveb #46,%a0@
    47bc:	52ae fffc      	addql #1,%fp@(-4)
    47c0:	42ae fff4      	clrl %fp@(-12)
    47c4:	604c           	bras 0x4812
    47c6:	222e ffec      	movel %fp@(-20),%d1
    47ca:	2401           	movel %d1,%d2
    47cc:	4c3c 2400 cccc 	mulul #-858993459,%d0,%d2
    47d2:	cccd 
    47d4:	e688           	lsrl #3,%d0
    47d6:	d080           	addl %d0,%d0
    47d8:	2400           	movel %d0,%d2
    47da:	e58a           	lsll #2,%d2
    47dc:	2042           	moveal %d2,%a0
    47de:	d088           	addl %a0,%d0
    47e0:	2401           	movel %d1,%d2
    47e2:	9480           	subl %d0,%d2
    47e4:	2002           	movel %d2,%d0
    47e6:	1000           	moveb %d0,%d0
    47e8:	0600 0030      	addib #48,%d0
    47ec:	1200           	moveb %d0,%d1
    47ee:	70c4           	moveq #-60,%d0
    47f0:	d08e           	addl %fp,%d0
    47f2:	d0ae fff4      	addl %fp@(-12),%d0
    47f6:	2040           	moveal %d0,%a0
    47f8:	1081           	moveb %d1,%a0@
    47fa:	52ae fff4      	addql #1,%fp@(-12)
    47fe:	202e ffec      	movel %fp@(-20),%d0
    4802:	2200           	movel %d0,%d1
    4804:	4c3c 1400 cccc 	mulul #-858993459,%d0,%d1
    480a:	cccd 
    480c:	e688           	lsrl #3,%d0
    480e:	2d40 ffec      	movel %d0,%fp@(-20)
    4812:	4aae ffec      	tstl %fp@(-20)
    4816:	66ae           	bnes 0x47c6
    4818:	6012           	bras 0x482c
    481a:	70c4           	moveq #-60,%d0
    481c:	d08e           	addl %fp,%d0
    481e:	d0ae fff4      	addl %fp@(-12),%d0
    4822:	2040           	moveal %d0,%a0
    4824:	10bc 0030      	moveb #48,%a0@
    4828:	52ae fff4      	addql #1,%fp@(-12)
    482c:	202e fff4      	movel %fp@(-12),%d0
    4830:	b0ae 0014      	cmpl %fp@(20),%d0
    4834:	65e4           	bcss 0x481a
    4836:	4aae fff4      	tstl %fp@(-12)
    483a:	662a           	bnes 0x4866
    483c:	202e fffc      	movel %fp@(-4),%d0
    4840:	2040           	moveal %d0,%a0
    4842:	10bc 0030      	moveb #48,%a0@
    4846:	52ae fffc      	addql #1,%fp@(-4)
    484a:	6020           	bras 0x486c
    484c:	202e fff4      	movel %fp@(-12),%d0
    4850:	5380           	subql #1,%d0
    4852:	1236 08c4      	moveb %fp@(ffffffc4,%d0:l),%d1
    4856:	202e fffc      	movel %fp@(-4),%d0
    485a:	2040           	moveal %d0,%a0
    485c:	1081           	moveb %d1,%a0@
    485e:	52ae fffc      	addql #1,%fp@(-4)
    4862:	53ae fff4      	subql #1,%fp@(-12)
    4866:	4aae fff4      	tstl %fp@(-12)
    486a:	66e0           	bnes 0x484c
    486c:	202e fffc      	movel %fp@(-4),%d0
    4870:	2040           	moveal %d0,%a0
    4872:	4210           	clrb %a0@
    4874:	4aae 0008      	tstl %fp@(8)
    4878:	6706           	beqs 0x4880
    487a:	202e 0008      	movel %fp@(8),%d0
    487e:	6006           	bras 0x4886
    4880:	203c 0000 0000 	movel #0,%d0
    4886:	2d40 fffc      	movel %d0,%fp@(-4)
    488a:	2f2e fffc      	movel %fp@(-4),%sp@-
    488e:	4eb9 0000 0000 	jsr 0x0
    4894:	588f           	addql #4,%sp
    4896:	242e ffc0      	movel %fp@(-64),%d2
    489a:	4e5e           	unlk %fp
    489c:	4e75           	rts
    489e:	4e56 fff8      	linkw %fp,#-8
    48a2:	2f03           	movel %d3,%sp@-
    48a4:	2f02           	movel %d2,%sp@-
    48a6:	4282           	clrl %d2
    48a8:	7620           	moveq #32,%d3
    48aa:	4aae 0010      	tstl %fp@(16)
    48ae:	6f44           	bles 0x48f4
    48b0:	42ae fffc      	clrl %fp@(-4)
    48b4:	2d6e 000c fff8 	movel %fp@(12),%fp@(-8)
    48ba:	6008           	bras 0x48c4
    48bc:	52ae fffc      	addql #1,%fp@(-4)
    48c0:	52ae fff8      	addql #1,%fp@(-8)
    48c4:	202e fff8      	movel %fp@(-8),%d0
    48c8:	2040           	moveal %d0,%a0
    48ca:	1010           	moveb %a0@,%d0
    48cc:	4a00           	tstb %d0
    48ce:	66ec           	bnes 0x48bc
    48d0:	202e fffc      	movel %fp@(-4),%d0
    48d4:	b0ae 0010      	cmpl %fp@(16),%d0
    48d8:	6d06           	blts 0x48e0
    48da:	42ae 0010      	clrl %fp@(16)
    48de:	6008           	bras 0x48e8
    48e0:	202e fffc      	movel %fp@(-4),%d0
    48e4:	91ae 0010      	subl %d0,%fp@(16)
    48e8:	7002           	moveq #2,%d0
    48ea:	c0ae 0014      	andl %fp@(20),%d0
    48ee:	4a80           	tstl %d0
    48f0:	6702           	beqs 0x48f4
    48f2:	7630           	moveq #48,%d3
    48f4:	7001           	moveq #1,%d0
    48f6:	c0ae 0014      	andl %fp@(20),%d0
    48fa:	4a80           	tstl %d0
    48fc:	663a           	bnes 0x4938
    48fe:	6012           	bras 0x4912
    4900:	2f03           	movel %d3,%sp@-
    4902:	2f2e 0008      	movel %fp@(8),%sp@-
    4906:	4eba f9e8      	jsr %pc@(0x42f0)
    490a:	508f           	addql #8,%sp
    490c:	5282           	addql #1,%d2
    490e:	53ae 0010      	subql #1,%fp@(16)
    4912:	4aae 0010      	tstl %fp@(16)
    4916:	6ee8           	bgts 0x4900
    4918:	6020           	bras 0x493a
    491a:	202e 000c      	movel %fp@(12),%d0
    491e:	2040           	moveal %d0,%a0
    4920:	1010           	moveb %a0@,%d0
    4922:	49c0           	extbl %d0
    4924:	2f00           	movel %d0,%sp@-
    4926:	2f2e 0008      	movel %fp@(8),%sp@-
    492a:	4eba f9c4      	jsr %pc@(0x42f0)
    492e:	508f           	addql #8,%sp
    4930:	5282           	addql #1,%d2
    4932:	52ae 000c      	addql #1,%fp@(12)
    4936:	6002           	bras 0x493a
    4938:	4e71           	nop
    493a:	202e 000c      	movel %fp@(12),%d0
    493e:	2040           	moveal %d0,%a0
    4940:	1010           	moveb %a0@,%d0
    4942:	4a00           	tstb %d0
    4944:	66d4           	bnes 0x491a
    4946:	6012           	bras 0x495a
    4948:	2f03           	movel %d3,%sp@-
    494a:	2f2e 0008      	movel %fp@(8),%sp@-
    494e:	4eba f9a0      	jsr %pc@(0x42f0)
    4952:	508f           	addql #8,%sp
    4954:	5282           	addql #1,%d2
    4956:	53ae 0010      	subql #1,%fp@(16)
    495a:	4aae 0010      	tstl %fp@(16)
    495e:	6ee8           	bgts 0x4948
    4960:	2002           	movel %d2,%d0
    4962:	242e fff0      	movel %fp@(-16),%d2
    4966:	262e fff4      	movel %fp@(-12),%d3
    496a:	4e5e           	unlk %fp
    496c:	4e75           	rts
    496e:	4e56 ffe0      	linkw %fp,#-32
    4972:	42ae fff4      	clrl %fp@(-12)
    4976:	42ae fff0      	clrl %fp@(-16)
    497a:	2d6e 000c ffec 	movel %fp@(12),%fp@(-20)
    4980:	4aae 000c      	tstl %fp@(12)
    4984:	6628           	bnes 0x49ae
    4986:	1d7c 0030 ffe0 	moveb #48,%fp@(-32)
    498c:	422e ffe1      	clrb %fp@(-31)
    4990:	2f2e 001c      	movel %fp@(28),%sp@-
    4994:	2f2e 0018      	movel %fp@(24),%sp@-
    4998:	70e0           	moveq #-32,%d0
    499a:	d08e           	addl %fp,%d0
    499c:	2f00           	movel %d0,%sp@-
    499e:	2f2e 0008      	movel %fp@(8),%sp@-
    49a2:	4eba fefa      	jsr %pc@(0x489e)
    49a6:	4fef 0010      	lea %sp@(16),%sp
    49aa:	6000 00fc      	braw 0x4aa8
    49ae:	4aae 0014      	tstl %fp@(20)
    49b2:	671e           	beqs 0x49d2
    49b4:	700a           	moveq #10,%d0
    49b6:	b0ae 0010      	cmpl %fp@(16),%d0
    49ba:	6616           	bnes 0x49d2
    49bc:	4aae 000c      	tstl %fp@(12)
    49c0:	6c10           	bges 0x49d2
    49c2:	7201           	moveq #1,%d1
    49c4:	2d41 fff4      	movel %d1,%fp@(-12)
    49c8:	202e 000c      	movel %fp@(12),%d0
    49cc:	4480           	negl %d0
    49ce:	2d40 ffec      	movel %d0,%fp@(-20)
    49d2:	70e0           	moveq #-32,%d0
    49d4:	d08e           	addl %fp,%d0
    49d6:	720b           	moveq #11,%d1
    49d8:	d280           	addl %d0,%d1
    49da:	2d41 fffc      	movel %d1,%fp@(-4)
    49de:	202e fffc      	movel %fp@(-4),%d0
    49e2:	2040           	moveal %d0,%a0
    49e4:	4210           	clrb %a0@
    49e6:	6048           	bras 0x4a30
    49e8:	202e ffec      	movel %fp@(-20),%d0
    49ec:	2200           	movel %d0,%d1
    49ee:	4c6e 1000 0010 	divull %fp@(16),%d0,%d1
    49f4:	2d40 fff8      	movel %d0,%fp@(-8)
    49f8:	7009           	moveq #9,%d0
    49fa:	b0ae fff8      	cmpl %fp@(-8),%d0
    49fe:	6c0a           	bges 0x4a0a
    4a00:	70c6           	moveq #-58,%d0
    4a02:	d0ae 0020      	addl %fp@(32),%d0
    4a06:	d1ae fff8      	addl %d0,%fp@(-8)
    4a0a:	53ae fffc      	subql #1,%fp@(-4)
    4a0e:	202e fff8      	movel %fp@(-8),%d0
    4a12:	1000           	moveb %d0,%d0
    4a14:	0600 0030      	addib #48,%d0
    4a18:	1200           	moveb %d0,%d1
    4a1a:	202e fffc      	movel %fp@(-4),%d0
    4a1e:	2040           	moveal %d0,%a0
    4a20:	1081           	moveb %d1,%a0@
    4a22:	202e ffec      	movel %fp@(-20),%d0
    4a26:	4c6e 0001 0010 	divull %fp@(16),%d1,%d0
    4a2c:	2d40 ffec      	movel %d0,%fp@(-20)
    4a30:	4aae ffec      	tstl %fp@(-20)
    4a34:	66b2           	bnes 0x49e8
    4a36:	4aae fff4      	tstl %fp@(-12)
    4a3a:	6738           	beqs 0x4a74
    4a3c:	4aae 0018      	tstl %fp@(24)
    4a40:	6722           	beqs 0x4a64
    4a42:	7002           	moveq #2,%d0
    4a44:	c0ae 001c      	andl %fp@(28),%d0
    4a48:	4a80           	tstl %d0
    4a4a:	6718           	beqs 0x4a64
    4a4c:	4878 002d      	pea 0x2d
    4a50:	2f2e 0008      	movel %fp@(8),%sp@-
    4a54:	4eba f89a      	jsr %pc@(0x42f0)
    4a58:	508f           	addql #8,%sp
    4a5a:	52ae fff0      	addql #1,%fp@(-16)
    4a5e:	53ae 0018      	subql #1,%fp@(24)
    4a62:	6028           	bras 0x4a8c
    4a64:	53ae fffc      	subql #1,%fp@(-4)
    4a68:	202e fffc      	movel %fp@(-4),%d0
    4a6c:	2040           	moveal %d0,%a0
    4a6e:	10bc 002d      	moveb #45,%a0@
    4a72:	6018           	bras 0x4a8c
    4a74:	2039 0000 0000 	movel 0x0,%d0
    4a7a:	4a80           	tstl %d0
    4a7c:	670e           	beqs 0x4a8c
    4a7e:	53ae fffc      	subql #1,%fp@(-4)
    4a82:	202e fffc      	movel %fp@(-4),%d0
    4a86:	2040           	moveal %d0,%a0
    4a88:	10bc 002b      	moveb #43,%a0@
    4a8c:	2f2e 001c      	movel %fp@(28),%sp@-
    4a90:	2f2e 0018      	movel %fp@(24),%sp@-
    4a94:	2f2e fffc      	movel %fp@(-4),%sp@-
    4a98:	2f2e 0008      	movel %fp@(8),%sp@-
    4a9c:	4eba fe00      	jsr %pc@(0x489e)
    4aa0:	4fef 0010      	lea %sp@(16),%sp
    4aa4:	d0ae fff0      	addl %fp@(-16),%d0
    4aa8:	4e5e           	unlk %fp
    4aaa:	4e75           	rts
    4aac:	4e56 ffd0      	linkw %fp,#-48
    4ab0:	48e7 3c00      	moveml %d2-%d5,%sp@-
    4ab4:	42ae fff4      	clrl %fp@(-12)
    4ab8:	42ae fff0      	clrl %fp@(-16)
    4abc:	2d6e 000c ffe8 	movel %fp@(12),%fp@(-24)
    4ac2:	2d6e 0010 ffec 	movel %fp@(16),%fp@(-20)
    4ac8:	202e 000c      	movel %fp@(12),%d0
    4acc:	222e 0010      	movel %fp@(16),%d1
    4ad0:	4481           	negl %d1
    4ad2:	4080           	negxl %d0
    4ad4:	6628           	bnes 0x4afe
    4ad6:	1d7c 0030 ffd2 	moveb #48,%fp@(-46)
    4adc:	422e ffd3      	clrb %fp@(-45)
    4ae0:	2f2e 0020      	movel %fp@(32),%sp@-
    4ae4:	2f2e 001c      	movel %fp@(28),%sp@-
    4ae8:	70d2           	moveq #-46,%d0
    4aea:	d08e           	addl %fp,%d0
    4aec:	2f00           	movel %d0,%sp@-
    4aee:	2f2e 0008      	movel %fp@(8),%sp@-
    4af2:	4eba fdaa      	jsr %pc@(0x489e)
    4af6:	4fef 0010      	lea %sp@(16),%sp
    4afa:	6000 014a      	braw 0x4c46
    4afe:	4aae 0018      	tstl %fp@(24)
    4b02:	6730           	beqs 0x4b34
    4b04:	720a           	moveq #10,%d1
    4b06:	b2ae 0014      	cmpl %fp@(20),%d1
    4b0a:	6628           	bnes 0x4b34
    4b0c:	202e 000c      	movel %fp@(12),%d0
    4b10:	222e 0010      	movel %fp@(16),%d1
    4b14:	4481           	negl %d1
    4b16:	4080           	negxl %d0
    4b18:	6f1a           	bles 0x4b34
    4b1a:	7201           	moveq #1,%d1
    4b1c:	2d41 fff4      	movel %d1,%fp@(-12)
    4b20:	202e 000c      	movel %fp@(12),%d0
    4b24:	222e 0010      	movel %fp@(16),%d1
    4b28:	4481           	negl %d1
    4b2a:	4080           	negxl %d0
    4b2c:	2d40 ffe8      	movel %d0,%fp@(-24)
    4b30:	2d41 ffec      	movel %d1,%fp@(-20)
    4b34:	70d2           	moveq #-46,%d0
    4b36:	d08e           	addl %fp,%d0
    4b38:	7215           	moveq #21,%d1
    4b3a:	d280           	addl %d0,%d1
    4b3c:	2d41 fffc      	movel %d1,%fp@(-4)
    4b40:	202e fffc      	movel %fp@(-4),%d0
    4b44:	2040           	moveal %d0,%a0
    4b46:	4210           	clrb %a0@
    4b48:	607a           	bras 0x4bc4
    4b4a:	262e 0014      	movel %fp@(20),%d3
    4b4e:	4282           	clrl %d2
    4b50:	202e ffe8      	movel %fp@(-24),%d0
    4b54:	222e ffec      	movel %fp@(-20),%d1
    4b58:	2f03           	movel %d3,%sp@-
    4b5a:	2f02           	movel %d2,%sp@-
    4b5c:	2f01           	movel %d1,%sp@-
    4b5e:	2f00           	movel %d0,%sp@-
    4b60:	4eb9 0000 0000 	jsr 0x0
    4b66:	4fef 0010      	lea %sp@(16),%sp
    4b6a:	2040           	moveal %d0,%a0
    4b6c:	2241           	moveal %d1,%a1
    4b6e:	2008           	movel %a0,%d0
    4b70:	2209           	movel %a1,%d1
    4b72:	2d41 fff8      	movel %d1,%fp@(-8)
    4b76:	7009           	moveq #9,%d0
    4b78:	b0ae fff8      	cmpl %fp@(-8),%d0
    4b7c:	6c0a           	bges 0x4b88
    4b7e:	70c6           	moveq #-58,%d0
    4b80:	d0ae 0024      	addl %fp@(36),%d0
    4b84:	d1ae fff8      	addl %d0,%fp@(-8)
    4b88:	53ae fffc      	subql #1,%fp@(-4)
    4b8c:	202e fff8      	movel %fp@(-8),%d0
    4b90:	1000           	moveb %d0,%d0
    4b92:	0600 0030      	addib #48,%d0
    4b96:	1200           	moveb %d0,%d1
    4b98:	202e fffc      	movel %fp@(-4),%d0
    4b9c:	2040           	moveal %d0,%a0
    4b9e:	1081           	moveb %d1,%a0@
    4ba0:	2a2e 0014      	movel %fp@(20),%d5
    4ba4:	4284           	clrl %d4
    4ba6:	2f05           	movel %d5,%sp@-
    4ba8:	2f04           	movel %d4,%sp@-
    4baa:	2f2e ffec      	movel %fp@(-20),%sp@-
    4bae:	2f2e ffe8      	movel %fp@(-24),%sp@-
    4bb2:	4eb9 0000 0000 	jsr 0x0
    4bb8:	4fef 0010      	lea %sp@(16),%sp
    4bbc:	2d40 ffe8      	movel %d0,%fp@(-24)
    4bc0:	2d41 ffec      	movel %d1,%fp@(-20)
    4bc4:	202e ffe8      	movel %fp@(-24),%d0
    4bc8:	222e ffec      	movel %fp@(-20),%d1
    4bcc:	4481           	negl %d1
    4bce:	4080           	negxl %d0
    4bd0:	6600 ff78      	bnew 0x4b4a
    4bd4:	4aae fff4      	tstl %fp@(-12)
    4bd8:	6738           	beqs 0x4c12
    4bda:	4aae 001c      	tstl %fp@(28)
    4bde:	6722           	beqs 0x4c02
    4be0:	7002           	moveq #2,%d0
    4be2:	c0ae 0020      	andl %fp@(32),%d0
    4be6:	4a80           	tstl %d0
    4be8:	6718           	beqs 0x4c02
    4bea:	4878 002d      	pea 0x2d
    4bee:	2f2e 0008      	movel %fp@(8),%sp@-
    4bf2:	4eba f6fc      	jsr %pc@(0x42f0)
    4bf6:	508f           	addql #8,%sp
    4bf8:	52ae fff0      	addql #1,%fp@(-16)
    4bfc:	53ae 001c      	subql #1,%fp@(28)
    4c00:	6028           	bras 0x4c2a
    4c02:	53ae fffc      	subql #1,%fp@(-4)
    4c06:	202e fffc      	movel %fp@(-4),%d0
    4c0a:	2040           	moveal %d0,%a0
    4c0c:	10bc 002d      	moveb #45,%a0@
    4c10:	6018           	bras 0x4c2a
    4c12:	2039 0000 0000 	movel 0x0,%d0
    4c18:	4a80           	tstl %d0
    4c1a:	670e           	beqs 0x4c2a
    4c1c:	53ae fffc      	subql #1,%fp@(-4)
    4c20:	202e fffc      	movel %fp@(-4),%d0
    4c24:	2040           	moveal %d0,%a0
    4c26:	10bc 002b      	moveb #43,%a0@
    4c2a:	2f2e 0020      	movel %fp@(32),%sp@-
    4c2e:	2f2e 001c      	movel %fp@(28),%sp@-
    4c32:	2f2e fffc      	movel %fp@(-4),%sp@-
    4c36:	2f2e 0008      	movel %fp@(8),%sp@-
    4c3a:	4eba fc62      	jsr %pc@(0x489e)
    4c3e:	4fef 0010      	lea %sp@(16),%sp
    4c42:	d0ae fff0      	addl %fp@(-16),%d0
    4c46:	4cee 003c ffc0 	moveml %fp@(-64),%d2-%d5
    4c4c:	4e5e           	unlk %fp
    4c4e:	4e75           	rts
    4c50:	4e56 ff74      	linkw %fp,#-140
    4c54:	2f02           	movel %d2,%sp@-
    4c56:	7006           	moveq #6,%d0
    4c58:	2d40 fff0      	movel %d0,%fp@(-16)
    4c5c:	42ae ffec      	clrl %fp@(-20)
    4c60:	2d6e 0010 ffe8 	movel %fp@(16),%fp@(-24)
    4c66:	42b9 0000 0000 	clrl 0x0
    4c6c:	6000 05fe      	braw 0x526c
    4c70:	202e 000c      	movel %fp@(12),%d0
    4c74:	2040           	moveal %d0,%a0
    4c76:	1010           	moveb %a0@,%d0
    4c78:	0c00 0025      	cmpib #37,%d0
    4c7c:	6600 05d0      	bnew 0x524e
    4c80:	7006           	moveq #6,%d0
    4c82:	2d40 fff0      	movel %d0,%fp@(-16)
    4c86:	52ae 000c      	addql #1,%fp@(12)
    4c8a:	42ae fff4      	clrl %fp@(-12)
    4c8e:	2d6e fff4 fff8 	movel %fp@(-12),%fp@(-8)
    4c94:	202e 000c      	movel %fp@(12),%d0
    4c98:	2040           	moveal %d0,%a0
    4c9a:	1010           	moveb %a0@,%d0
    4c9c:	4a00           	tstb %d0
    4c9e:	6700 05dc      	beqw 0x527c
    4ca2:	202e 000c      	movel %fp@(12),%d0
    4ca6:	2040           	moveal %d0,%a0
    4ca8:	1010           	moveb %a0@,%d0
    4caa:	0c00 0025      	cmpib #37,%d0
    4cae:	6700 059c      	beqw 0x524c
    4cb2:	202e 000c      	movel %fp@(12),%d0
    4cb6:	2040           	moveal %d0,%a0
    4cb8:	1010           	moveb %a0@,%d0
    4cba:	0c00 002d      	cmpib #45,%d0
    4cbe:	660a           	bnes 0x4cca
    4cc0:	52ae 000c      	addql #1,%fp@(12)
    4cc4:	7001           	moveq #1,%d0
    4cc6:	2d40 fff4      	movel %d0,%fp@(-12)
    4cca:	202e 000c      	movel %fp@(12),%d0
    4cce:	2040           	moveal %d0,%a0
    4cd0:	1010           	moveb %a0@,%d0
    4cd2:	0c00 002b      	cmpib #43,%d0
    4cd6:	661a           	bnes 0x4cf2
    4cd8:	52ae 000c      	addql #1,%fp@(12)
    4cdc:	7001           	moveq #1,%d0
    4cde:	23c0 0000 0000 	movel %d0,0x0
    4ce4:	600e           	bras 0x4cf4
    4ce6:	52ae 000c      	addql #1,%fp@(12)
    4cea:	7202           	moveq #2,%d1
    4cec:	83ae fff4      	orl %d1,%fp@(-12)
    4cf0:	6002           	bras 0x4cf4
    4cf2:	4e71           	nop
    4cf4:	202e 000c      	movel %fp@(12),%d0
    4cf8:	2040           	moveal %d0,%a0
    4cfa:	1010           	moveb %a0@,%d0
    4cfc:	0c00 0030      	cmpib #48,%d0
    4d00:	67e4           	beqs 0x4ce6
    4d02:	42ae fffc      	clrl %fp@(-4)
    4d06:	202e 000c      	movel %fp@(12),%d0
    4d0a:	2040           	moveal %d0,%a0
    4d0c:	1010           	moveb %a0@,%d0
    4d0e:	0c00 002e      	cmpib #46,%d0
    4d12:	6720           	beqs 0x4d34
    4d14:	202e 000c      	movel %fp@(12),%d0
    4d18:	2040           	moveal %d0,%a0
    4d1a:	1010           	moveb %a0@,%d0
    4d1c:	0c00 002f      	cmpib #47,%d0
    4d20:	6f00 00aa      	blew 0x4dcc
    4d24:	202e 000c      	movel %fp@(12),%d0
    4d28:	2040           	moveal %d0,%a0
    4d2a:	1010           	moveb %a0@,%d0
    4d2c:	0c00 0039      	cmpib #57,%d0
    4d30:	6e00 009a      	bgtw 0x4dcc
    4d34:	202e 000c      	movel %fp@(12),%d0
    4d38:	2040           	moveal %d0,%a0
    4d3a:	1010           	moveb %a0@,%d0
    4d3c:	0c00 002e      	cmpib #46,%d0
    4d40:	6610           	bnes 0x4d52
    4d42:	7001           	moveq #1,%d0
    4d44:	2d40 fffc      	movel %d0,%fp@(-4)
    4d48:	42ae fff0      	clrl %fp@(-16)
    4d4c:	52ae 000c      	addql #1,%fp@(12)
    4d50:	60e2           	bras 0x4d34
    4d52:	202e 000c      	movel %fp@(12),%d0
    4d56:	2040           	moveal %d0,%a0
    4d58:	1010           	moveb %a0@,%d0
    4d5a:	0c00 002f      	cmpib #47,%d0
    4d5e:	6f6c           	bles 0x4dcc
    4d60:	202e 000c      	movel %fp@(12),%d0
    4d64:	2040           	moveal %d0,%a0
    4d66:	1010           	moveb %a0@,%d0
    4d68:	0c00 0039      	cmpib #57,%d0
    4d6c:	6e5e           	bgts 0x4dcc
    4d6e:	4aae fffc      	tstl %fp@(-4)
    4d72:	672c           	beqs 0x4da0
    4d74:	202e fff0      	movel %fp@(-16),%d0
    4d78:	d080           	addl %d0,%d0
    4d7a:	2200           	movel %d0,%d1
    4d7c:	e589           	lsll #2,%d1
    4d7e:	2400           	movel %d0,%d2
    4d80:	d481           	addl %d1,%d2
    4d82:	2d42 fff0      	movel %d2,%fp@(-16)
    4d86:	202e 000c      	movel %fp@(12),%d0
    4d8a:	2040           	moveal %d0,%a0
    4d8c:	1010           	moveb %a0@,%d0
    4d8e:	0600 ffd0      	addib #-48,%d0
    4d92:	1000           	moveb %d0,%d0
    4d94:	0280 0000 00ff 	andil #255,%d0
    4d9a:	d1ae fff0      	addl %d0,%fp@(-16)
    4d9e:	6024           	bras 0x4dc4
    4da0:	202e fff8      	movel %fp@(-8),%d0
    4da4:	d080           	addl %d0,%d0
    4da6:	2200           	movel %d0,%d1
    4da8:	e589           	lsll #2,%d1
    4daa:	2400           	movel %d0,%d2
    4dac:	d481           	addl %d1,%d2
    4dae:	2d42 fff8      	movel %d2,%fp@(-8)
    4db2:	202e 000c      	movel %fp@(12),%d0
    4db6:	2040           	moveal %d0,%a0
    4db8:	1010           	moveb %a0@,%d0
    4dba:	49c0           	extbl %d0
    4dbc:	72d0           	moveq #-48,%d1
    4dbe:	d081           	addl %d1,%d0
    4dc0:	d1ae fff8      	addl %d0,%fp@(-8)
    4dc4:	52ae 000c      	addql #1,%fp@(12)
    4dc8:	6000 ff6a      	braw 0x4d34
    4dcc:	42ae ffe4      	clrl %fp@(-28)
    4dd0:	202e 000c      	movel %fp@(12),%d0
    4dd4:	2040           	moveal %d0,%a0
    4dd6:	1010           	moveb %a0@,%d0
    4dd8:	0c00 006c      	cmpib #108,%d0
    4ddc:	661c           	bnes 0x4dfa
    4dde:	52ae 000c      	addql #1,%fp@(12)
    4de2:	202e 000c      	movel %fp@(12),%d0
    4de6:	2040           	moveal %d0,%a0
    4de8:	1010           	moveb %a0@,%d0
    4dea:	0c00 006c      	cmpib #108,%d0
    4dee:	660a           	bnes 0x4dfa
    4df0:	52ae 000c      	addql #1,%fp@(12)
    4df4:	7001           	moveq #1,%d0
    4df6:	2d40 ffe4      	movel %d0,%fp@(-28)
    4dfa:	202e 000c      	movel %fp@(12),%d0
    4dfe:	2040           	moveal %d0,%a0
    4e00:	1010           	moveb %a0@,%d0
    4e02:	49c0           	extbl %d0
    4e04:	72a8           	moveq #-88,%d1
    4e06:	d081           	addl %d1,%d0
    4e08:	7420           	moveq #32,%d2
    4e0a:	b480           	cmpl %d0,%d2
    4e0c:	6500 0412      	bcsw 0x5220
    4e10:	303b 0a06      	movew %pc@(0x4e18,%d0:l:2),%d0
    4e14:	4efb 0002      	jmp %pc@(0x4e18,%d0:w)
    4e18:	023c 0408      	andib #8,%ccr
    4e1c:	0408           	.short 0x0408
    4e1e:	0408           	.short 0x0408
    4e20:	0408           	.short 0x0408
    4e22:	0408           	.short 0x0408
    4e24:	0408           	.short 0x0408
    4e26:	0408           	.short 0x0408
    4e28:	0408           	.short 0x0408
    4e2a:	0408           	.short 0x0408
    4e2c:	0408           	.short 0x0408
    4e2e:	035c           	bchg %d1,%a4@+
    4e30:	0088 0408 039a 	oril #67634074,%d0
    4e36:	0408           	.short 0x0408
    4e38:	0408           	.short 0x0408
    4e3a:	0408           	.short 0x0408
    4e3c:	0408           	.short 0x0408
    4e3e:	0408           	.short 0x0408
    4e40:	0408           	.short 0x0408
    4e42:	0408           	.short 0x0408
    4e44:	0408           	.short 0x0408
    4e46:	01ac 02cc      	bclr %d0,%a4@(716)
    4e4a:	0408           	.short 0x0408
    4e4c:	0408           	.short 0x0408
    4e4e:	0042 0408      	oriw #1032,%d2
    4e52:	02cc           	.short 0x02cc
    4e54:	0408           	.short 0x0408
    4e56:	0408           	.short 0x0408
    4e58:	011c           	btst %d0,%a4@+
    4e5a:	202e ffe8      	movel %fp@(-24),%d0
    4e5e:	2040           	moveal %d0,%a0
    4e60:	2010           	movel %a0@,%d0
    4e62:	2d40 ffe0      	movel %d0,%fp@(-32)
    4e66:	58ae ffe8      	addql #4,%fp@(-24)
    4e6a:	4aae ffe0      	tstl %fp@(-32)
    4e6e:	6706           	beqs 0x4e76
    4e70:	202e ffe0      	movel %fp@(-32),%d0
    4e74:	6006           	bras 0x4e7c
    4e76:	203c 0000 0000 	movel #0,%d0
    4e7c:	2f2e fff4      	movel %fp@(-12),%sp@-
    4e80:	2f2e fff8      	movel %fp@(-8),%sp@-
    4e84:	2f00           	movel %d0,%sp@-
    4e86:	2f2e 0008      	movel %fp@(8),%sp@-
    4e8a:	4eba fa12      	jsr %pc@(0x489e)
    4e8e:	4fef 0010      	lea %sp@(16),%sp
    4e92:	d1ae ffec      	addl %d0,%fp@(-20)
    4e96:	42b9 0000 0000 	clrl 0x0
    4e9c:	6000 03ca      	braw 0x5268
    4ea0:	4aae ffe4      	tstl %fp@(-28)
    4ea4:	6752           	beqs 0x4ef8
    4ea6:	2d6e ffe8 ffdc 	movel %fp@(-24),%fp@(-36)
    4eac:	202e ffdc      	movel %fp@(-36),%d0
    4eb0:	2040           	moveal %d0,%a0
    4eb2:	2210           	movel %a0@,%d1
    4eb4:	2428 0004      	movel %a0@(4),%d2
    4eb8:	2d41 ffd4      	movel %d1,%fp@(-44)
    4ebc:	2d42 ffd8      	movel %d2,%fp@(-40)
    4ec0:	50ae ffdc      	addql #8,%fp@(-36)
    4ec4:	2d6e ffdc ffe8 	movel %fp@(-36),%fp@(-24)
    4eca:	4878 0061      	pea 0x61
    4ece:	2f2e fff4      	movel %fp@(-12),%sp@-
    4ed2:	2f2e fff8      	movel %fp@(-8),%sp@-
    4ed6:	4878 0001      	pea 0x1
    4eda:	4878 000a      	pea 0xa
    4ede:	2f2e ffd8      	movel %fp@(-40),%sp@-
    4ee2:	2f2e ffd4      	movel %fp@(-44),%sp@-
    4ee6:	2f2e 0008      	movel %fp@(8),%sp@-
    4eea:	4eba fbc0      	jsr %pc@(0x4aac)
    4eee:	4fef 0020      	lea %sp@(32),%sp
    4ef2:	d1ae ffec      	addl %d0,%fp@(-20)
    4ef6:	6032           	bras 0x4f2a
    4ef8:	202e ffe8      	movel %fp@(-24),%d0
    4efc:	2040           	moveal %d0,%a0
    4efe:	2010           	movel %a0@,%d0
    4f00:	58ae ffe8      	addql #4,%fp@(-24)
    4f04:	4878 0061      	pea 0x61
    4f08:	2f2e fff4      	movel %fp@(-12),%sp@-
    4f0c:	2f2e fff8      	movel %fp@(-8),%sp@-
    4f10:	4878 0001      	pea 0x1
    4f14:	4878 000a      	pea 0xa
    4f18:	2f00           	movel %d0,%sp@-
    4f1a:	2f2e 0008      	movel %fp@(8),%sp@-
    4f1e:	4eba fa4e      	jsr %pc@(0x496e)
    4f22:	4fef 001c      	lea %sp@(28),%sp
    4f26:	d1ae ffec      	addl %d0,%fp@(-20)
    4f2a:	42b9 0000 0000 	clrl 0x0
    4f30:	6000 0336      	braw 0x5268
    4f34:	4aae ffe4      	tstl %fp@(-28)
    4f38:	6750           	beqs 0x4f8a
    4f3a:	2d6e ffe8 ffdc 	movel %fp@(-24),%fp@(-36)
    4f40:	202e ffdc      	movel %fp@(-36),%d0
    4f44:	2040           	moveal %d0,%a0
    4f46:	2210           	movel %a0@,%d1
    4f48:	2428 0004      	movel %a0@(4),%d2
    4f4c:	2d41 ffd4      	movel %d1,%fp@(-44)
    4f50:	2d42 ffd8      	movel %d2,%fp@(-40)
    4f54:	50ae ffdc      	addql #8,%fp@(-36)
    4f58:	2d6e ffdc ffe8 	movel %fp@(-36),%fp@(-24)
    4f5e:	4878 0061      	pea 0x61
    4f62:	2f2e fff4      	movel %fp@(-12),%sp@-
    4f66:	2f2e fff8      	movel %fp@(-8),%sp@-
    4f6a:	42a7           	clrl %sp@-
    4f6c:	4878 0010      	pea 0x10
    4f70:	2f2e ffd8      	movel %fp@(-40),%sp@-
    4f74:	2f2e ffd4      	movel %fp@(-44),%sp@-
    4f78:	2f2e 0008      	movel %fp@(8),%sp@-
    4f7c:	4eba fb2e      	jsr %pc@(0x4aac)
    4f80:	4fef 0020      	lea %sp@(32),%sp
    4f84:	d1ae ffec      	addl %d0,%fp@(-20)
    4f88:	6030           	bras 0x4fba
    4f8a:	202e ffe8      	movel %fp@(-24),%d0
    4f8e:	2040           	moveal %d0,%a0
    4f90:	2010           	movel %a0@,%d0
    4f92:	58ae ffe8      	addql #4,%fp@(-24)
    4f96:	4878 0061      	pea 0x61
    4f9a:	2f2e fff4      	movel %fp@(-12),%sp@-
    4f9e:	2f2e fff8      	movel %fp@(-8),%sp@-
    4fa2:	42a7           	clrl %sp@-
    4fa4:	4878 0010      	pea 0x10
    4fa8:	2f00           	movel %d0,%sp@-
    4faa:	2f2e 0008      	movel %fp@(8),%sp@-
    4fae:	4eba f9be      	jsr %pc@(0x496e)
    4fb2:	4fef 001c      	lea %sp@(28),%sp
    4fb6:	d1ae ffec      	addl %d0,%fp@(-20)
    4fba:	42b9 0000 0000 	clrl 0x0
    4fc0:	6000 02a6      	braw 0x5268
    4fc4:	4aae ffe4      	tstl %fp@(-28)
    4fc8:	6750           	beqs 0x501a
    4fca:	2d6e ffe8 ffdc 	movel %fp@(-24),%fp@(-36)
    4fd0:	202e ffdc      	movel %fp@(-36),%d0
    4fd4:	2040           	moveal %d0,%a0
    4fd6:	2210           	movel %a0@,%d1
    4fd8:	2428 0004      	movel %a0@(4),%d2
    4fdc:	2d41 ffd4      	movel %d1,%fp@(-44)
    4fe0:	2d42 ffd8      	movel %d2,%fp@(-40)
    4fe4:	50ae ffdc      	addql #8,%fp@(-36)
    4fe8:	2d6e ffdc ffe8 	movel %fp@(-36),%fp@(-24)
    4fee:	4878 0061      	pea 0x61
    4ff2:	2f2e fff4      	movel %fp@(-12),%sp@-
    4ff6:	2f2e fff8      	movel %fp@(-8),%sp@-
    4ffa:	42a7           	clrl %sp@-
    4ffc:	4878 0008      	pea 0x8
    5000:	2f2e ffd8      	movel %fp@(-40),%sp@-
    5004:	2f2e ffd4      	movel %fp@(-44),%sp@-
    5008:	2f2e 0008      	movel %fp@(8),%sp@-
    500c:	4eba fa9e      	jsr %pc@(0x4aac)
    5010:	4fef 0020      	lea %sp@(32),%sp
    5014:	d1ae ffec      	addl %d0,%fp@(-20)
    5018:	6030           	bras 0x504a
    501a:	202e ffe8      	movel %fp@(-24),%d0
    501e:	2040           	moveal %d0,%a0
    5020:	2010           	movel %a0@,%d0
    5022:	58ae ffe8      	addql #4,%fp@(-24)
    5026:	4878 0061      	pea 0x61
    502a:	2f2e fff4      	movel %fp@(-12),%sp@-
    502e:	2f2e fff8      	movel %fp@(-8),%sp@-
    5032:	42a7           	clrl %sp@-
    5034:	4878 0008      	pea 0x8
    5038:	2f00           	movel %d0,%sp@-
    503a:	2f2e 0008      	movel %fp@(8),%sp@-
    503e:	4eba f92e      	jsr %pc@(0x496e)
    5042:	4fef 001c      	lea %sp@(28),%sp
    5046:	d1ae ffec      	addl %d0,%fp@(-20)
    504a:	42b9 0000 0000 	clrl 0x0
    5050:	6000 0216      	braw 0x5268
    5054:	4aae ffe4      	tstl %fp@(-28)
    5058:	6750           	beqs 0x50aa
    505a:	2d6e ffe8 ffdc 	movel %fp@(-24),%fp@(-36)
    5060:	202e ffdc      	movel %fp@(-36),%d0
    5064:	2040           	moveal %d0,%a0
    5066:	2210           	movel %a0@,%d1
    5068:	2428 0004      	movel %a0@(4),%d2
    506c:	2d41 ffd4      	movel %d1,%fp@(-44)
    5070:	2d42 ffd8      	movel %d2,%fp@(-40)
    5074:	50ae ffdc      	addql #8,%fp@(-36)
    5078:	2d6e ffdc ffe8 	movel %fp@(-36),%fp@(-24)
    507e:	4878 0041      	pea 0x41
    5082:	2f2e fff4      	movel %fp@(-12),%sp@-
    5086:	2f2e fff8      	movel %fp@(-8),%sp@-
    508a:	42a7           	clrl %sp@-
    508c:	4878 0010      	pea 0x10
    5090:	2f2e ffd8      	movel %fp@(-40),%sp@-
    5094:	2f2e ffd4      	movel %fp@(-44),%sp@-
    5098:	2f2e 0008      	movel %fp@(8),%sp@-
    509c:	4eba fa0e      	jsr %pc@(0x4aac)
    50a0:	4fef 0020      	lea %sp@(32),%sp
    50a4:	d1ae ffec      	addl %d0,%fp@(-20)
    50a8:	6030           	bras 0x50da
    50aa:	202e ffe8      	movel %fp@(-24),%d0
    50ae:	2040           	moveal %d0,%a0
    50b0:	2010           	movel %a0@,%d0
    50b2:	58ae ffe8      	addql #4,%fp@(-24)
    50b6:	4878 0041      	pea 0x41
    50ba:	2f2e fff4      	movel %fp@(-12),%sp@-
    50be:	2f2e fff8      	movel %fp@(-8),%sp@-
    50c2:	42a7           	clrl %sp@-
    50c4:	4878 0010      	pea 0x10
    50c8:	2f00           	movel %d0,%sp@-
    50ca:	2f2e 0008      	movel %fp@(8),%sp@-
    50ce:	4eba f89e      	jsr %pc@(0x496e)
    50d2:	4fef 001c      	lea %sp@(28),%sp
    50d6:	d1ae ffec      	addl %d0,%fp@(-20)
    50da:	42b9 0000 0000 	clrl 0x0
    50e0:	6000 0186      	braw 0x5268
    50e4:	4aae ffe4      	tstl %fp@(-28)
    50e8:	6750           	beqs 0x513a
    50ea:	2d6e ffe8 ffdc 	movel %fp@(-24),%fp@(-36)
    50f0:	202e ffdc      	movel %fp@(-36),%d0
    50f4:	2040           	moveal %d0,%a0
    50f6:	2210           	movel %a0@,%d1
    50f8:	2428 0004      	movel %a0@(4),%d2
    50fc:	2d41 ffd4      	movel %d1,%fp@(-44)
    5100:	2d42 ffd8      	movel %d2,%fp@(-40)
    5104:	50ae ffdc      	addql #8,%fp@(-36)
    5108:	2d6e ffdc ffe8 	movel %fp@(-36),%fp@(-24)
    510e:	4878 0061      	pea 0x61
    5112:	2f2e fff4      	movel %fp@(-12),%sp@-
    5116:	2f2e fff8      	movel %fp@(-8),%sp@-
    511a:	42a7           	clrl %sp@-
    511c:	4878 000a      	pea 0xa
    5120:	2f2e ffd8      	movel %fp@(-40),%sp@-
    5124:	2f2e ffd4      	movel %fp@(-44),%sp@-
    5128:	2f2e 0008      	movel %fp@(8),%sp@-
    512c:	4eba f97e      	jsr %pc@(0x4aac)
    5130:	4fef 0020      	lea %sp@(32),%sp
    5134:	d1ae ffec      	addl %d0,%fp@(-20)
    5138:	6030           	bras 0x516a
    513a:	202e ffe8      	movel %fp@(-24),%d0
    513e:	2040           	moveal %d0,%a0
    5140:	2010           	movel %a0@,%d0
    5142:	58ae ffe8      	addql #4,%fp@(-24)
    5146:	4878 0061      	pea 0x61
    514a:	2f2e fff4      	movel %fp@(-12),%sp@-
    514e:	2f2e fff8      	movel %fp@(-8),%sp@-
    5152:	42a7           	clrl %sp@-
    5154:	4878 000a      	pea 0xa
    5158:	2f00           	movel %d0,%sp@-
    515a:	2f2e 0008      	movel %fp@(8),%sp@-
    515e:	4eba f80e      	jsr %pc@(0x496e)
    5162:	4fef 001c      	lea %sp@(28),%sp
    5166:	d1ae ffec      	addl %d0,%fp@(-20)
    516a:	42b9 0000 0000 	clrl 0x0
    5170:	6000 00f6      	braw 0x5268
    5174:	202e ffe8      	movel %fp@(-24),%d0
    5178:	2040           	moveal %d0,%a0
    517a:	2010           	movel %a0@,%d0
    517c:	1000           	moveb %d0,%d0
    517e:	1d40 ffc6      	moveb %d0,%fp@(-58)
    5182:	58ae ffe8      	addql #4,%fp@(-24)
    5186:	422e ffc7      	clrb %fp@(-57)
    518a:	2f2e fff4      	movel %fp@(-12),%sp@-
    518e:	2f2e fff8      	movel %fp@(-8),%sp@-
    5192:	70c6           	moveq #-58,%d0
    5194:	d08e           	addl %fp,%d0
    5196:	2f00           	movel %d0,%sp@-
    5198:	2f2e 0008      	movel %fp@(8),%sp@-
    519c:	4eba f700      	jsr %pc@(0x489e)
    51a0:	4fef 0010      	lea %sp@(16),%sp
    51a4:	d1ae ffec      	addl %d0,%fp@(-20)
    51a8:	42b9 0000 0000 	clrl 0x0
    51ae:	6000 00b8      	braw 0x5268
    51b2:	2d6e ffe8 ffd0 	movel %fp@(-24),%fp@(-48)
    51b8:	202e ffd0      	movel %fp@(-48),%d0
    51bc:	2040           	moveal %d0,%a0
    51be:	2210           	movel %a0@,%d1
    51c0:	2428 0004      	movel %a0@(4),%d2
    51c4:	2d41 ffc8      	movel %d1,%fp@(-56)
    51c8:	2d42 ffcc      	movel %d2,%fp@(-52)
    51cc:	50ae ffd0      	addql #8,%fp@(-48)
    51d0:	2d6e ffd0 ffe8 	movel %fp@(-48),%fp@(-24)
    51d6:	2f2e fff0      	movel %fp@(-16),%sp@-
    51da:	2f2e ffcc      	movel %fp@(-52),%sp@-
    51de:	2f2e ffc8      	movel %fp@(-56),%sp@-
    51e2:	200e           	movel %fp,%d0
    51e4:	0680 ffff ff75 	addil #-139,%d0
    51ea:	2f00           	movel %d0,%sp@-
    51ec:	4eba f2c2      	jsr %pc@(0x44b0)
    51f0:	4fef 0010      	lea %sp@(16),%sp
    51f4:	2f2e fff4      	movel %fp@(-12),%sp@-
    51f8:	2f2e fff8      	movel %fp@(-8),%sp@-
    51fc:	200e           	movel %fp,%d0
    51fe:	0680 ffff ff75 	addil #-139,%d0
    5204:	2f00           	movel %d0,%sp@-
    5206:	2f2e 0008      	movel %fp@(8),%sp@-
    520a:	4eba f692      	jsr %pc@(0x489e)
    520e:	4fef 0010      	lea %sp@(16),%sp
    5212:	d1ae ffec      	addl %d0,%fp@(-20)
    5216:	42b9 0000 0000 	clrl 0x0
    521c:	4e71           	nop
    521e:	6048           	bras 0x5268
    5220:	4878 0025      	pea 0x25
    5224:	2f2e 0008      	movel %fp@(8),%sp@-
    5228:	4eba f0c6      	jsr %pc@(0x42f0)
    522c:	508f           	addql #8,%sp
    522e:	202e 000c      	movel %fp@(12),%d0
    5232:	2040           	moveal %d0,%a0
    5234:	1010           	moveb %a0@,%d0
    5236:	49c0           	extbl %d0
    5238:	2f00           	movel %d0,%sp@-
    523a:	2f2e 0008      	movel %fp@(8),%sp@-
    523e:	4eba f0b0      	jsr %pc@(0x42f0)
    5242:	508f           	addql #8,%sp
    5244:	42b9 0000 0000 	clrl 0x0
    524a:	601c           	bras 0x5268
    524c:	4e71           	nop
    524e:	202e 000c      	movel %fp@(12),%d0
    5252:	2040           	moveal %d0,%a0
    5254:	1010           	moveb %a0@,%d0
    5256:	49c0           	extbl %d0
    5258:	2f00           	movel %d0,%sp@-
    525a:	2f2e 0008      	movel %fp@(8),%sp@-
    525e:	4eba f090      	jsr %pc@(0x42f0)
    5262:	508f           	addql #8,%sp
    5264:	52ae ffec      	addql #1,%fp@(-20)
    5268:	52ae 000c      	addql #1,%fp@(12)
    526c:	202e 000c      	movel %fp@(12),%d0
    5270:	2040           	moveal %d0,%a0
    5272:	1010           	moveb %a0@,%d0
    5274:	4a00           	tstb %d0
    5276:	6600 f9f8      	bnew 0x4c70
    527a:	6002           	bras 0x527e
    527c:	4e71           	nop
    527e:	4aae 0008      	tstl %fp@(8)
    5282:	670c           	beqs 0x5290
    5284:	202e 0008      	movel %fp@(8),%d0
    5288:	2040           	moveal %d0,%a0
    528a:	2010           	movel %a0@,%d0
    528c:	2040           	moveal %d0,%a0
    528e:	4210           	clrb %a0@
    5290:	202e ffec      	movel %fp@(-20),%d0
    5294:	242e ff70      	movel %fp@(-144),%d2
    5298:	4e5e           	unlk %fp
    529a:	4e75           	rts
    529c:	4e56 fffc      	linkw %fp,#-4
    52a0:	70ff           	moveq #-1,%d0
    52a2:	23c0 0000 0000 	movel %d0,0x0
    52a8:	42b9 0000 0000 	clrl 0x0
    52ae:	42b9 0000 0000 	clrl 0x0
    52b4:	42b9 0000 0000 	clrl 0x0
    52ba:	23ee 0008 0000 	movel %fp@(8),0x0
    52c0:	0000 
    52c2:	202e 0008      	movel %fp@(8),%d0
    52c6:	2040           	moveal %d0,%a0
    52c8:	2010           	movel %a0@,%d0
    52ca:	23c0 0000 0000 	movel %d0,0x0
    52d0:	2f2e 0010      	movel %fp@(16),%sp@-
    52d4:	2f2e 000c      	movel %fp@(12),%sp@-
    52d8:	2f2e 0008      	movel %fp@(8),%sp@-
    52dc:	4eba f972      	jsr %pc@(0x4c50)
    52e0:	4fef 000c      	lea %sp@(12),%sp
    52e4:	2d40 fffc      	movel %d0,%fp@(-4)
    52e8:	2239 0000 0000 	movel 0x0,%d1
    52ee:	202e 0008      	movel %fp@(8),%d0
    52f2:	2040           	moveal %d0,%a0
    52f4:	2081           	movel %d1,%a0@
    52f6:	13fc 0001 0000 	moveb #1,0x0
    52fc:	0000 
    52fe:	202e fffc      	movel %fp@(-4),%d0
    5302:	4e5e           	unlk %fp
    5304:	4e75           	rts
    5306:	4e56 0000      	linkw %fp,#0
    530a:	4239 0000 0000 	clrb 0x0
    5310:	700c           	moveq #12,%d0
    5312:	d08e           	addl %fp,%d0
    5314:	5880           	addql #4,%d0
    5316:	222e 000c      	movel %fp@(12),%d1
    531a:	2f00           	movel %d0,%sp@-
    531c:	2f01           	movel %d1,%sp@-
    531e:	200e           	movel %fp,%d0
    5320:	5080           	addql #8,%d0
    5322:	2f00           	movel %d0,%sp@-
    5324:	4eba ff76      	jsr %pc@(0x529c)
    5328:	4fef 000c      	lea %sp@(12),%sp
    532c:	4e5e           	unlk %fp
    532e:	4e75           	rts
    5330:	4e56 fffc      	linkw %fp,#-4
    5334:	202e 0010      	movel %fp@(16),%d0
    5338:	2040           	moveal %d0,%a0
    533a:	4290           	clrl %a0@
    533c:	202e 000c      	movel %fp@(12),%d0
    5340:	2040           	moveal %d0,%a0
    5342:	2010           	movel %a0@,%d0
    5344:	4a80           	tstl %d0
    5346:	662c           	bnes 0x5374
    5348:	6004           	bras 0x534e
    534a:	52ae 0008      	addql #1,%fp@(8)
    534e:	202e 0008      	movel %fp@(8),%d0
    5352:	2040           	moveal %d0,%a0
    5354:	1010           	moveb %a0@,%d0
    5356:	49c0           	extbl %d0
    5358:	1030 09b0 0000 	moveb @(00000000,%d0:l),%d0
    535e:	0000 
    5360:	1000           	moveb %d0,%d0
    5362:	0280 0000 00ff 	andil #255,%d0
    5368:	7201           	moveq #1,%d1
    536a:	c081           	andl %d1,%d0
    536c:	1000           	moveb %d0,%d0
    536e:	4a00           	tstb %d0
    5370:	66d8           	bnes 0x534a
    5372:	605c           	bras 0x53d0
    5374:	202e 000c      	movel %fp@(12),%d0
    5378:	2040           	moveal %d0,%a0
    537a:	2d50 fffc      	movel %a0@,%fp@(-4)
    537e:	6008           	bras 0x5388
    5380:	52ae 0008      	addql #1,%fp@(8)
    5384:	53ae fffc      	subql #1,%fp@(-4)
    5388:	4aae fffc      	tstl %fp@(-4)
    538c:	6d24           	blts 0x53b2
    538e:	202e 0008      	movel %fp@(8),%d0
    5392:	2040           	moveal %d0,%a0
    5394:	1010           	moveb %a0@,%d0
    5396:	49c0           	extbl %d0
    5398:	1030 09b0 0000 	moveb @(00000000,%d0:l),%d0
    539e:	0000 
    53a0:	1000           	moveb %d0,%d0
    53a2:	0280 0000 00ff 	andil #255,%d0
    53a8:	7201           	moveq #1,%d1
    53aa:	c081           	andl %d1,%d0
    53ac:	1000           	moveb %d0,%d0
    53ae:	4a00           	tstb %d0
    53b0:	66ce           	bnes 0x5380
    53b2:	4aae fffc      	tstl %fp@(-4)
    53b6:	6c0e           	bges 0x53c6
    53b8:	42ae fffc      	clrl %fp@(-4)
    53bc:	202e 0010      	movel %fp@(16),%d0
    53c0:	7201           	moveq #1,%d1
    53c2:	2040           	moveal %d0,%a0
    53c4:	2081           	movel %d1,%a0@
    53c6:	202e 000c      	movel %fp@(12),%d0
    53ca:	2040           	moveal %d0,%a0
    53cc:	20ae fffc      	movel %fp@(-4),%a0@
    53d0:	202e 0008      	movel %fp@(8),%d0
    53d4:	2200           	movel %d0,%d1
    53d6:	2041           	moveal %d1,%a0
    53d8:	4e5e           	unlk %fp
    53da:	4e75           	rts
    53dc:	4e56 ff54      	linkw %fp,#-172
    53e0:	2f02           	movel %d2,%sp@-
    53e2:	42ae fffc      	clrl %fp@(-4)
    53e6:	42ae ffdc      	clrl %fp@(-36)
    53ea:	42ae fff8      	clrl %fp@(-8)
    53ee:	42ae fff4      	clrl %fp@(-12)
    53f2:	42ae ffd8      	clrl %fp@(-40)
    53f6:	42ae ffec      	clrl %fp@(-20)
    53fa:	422e ff54      	clrb %fp@(-172)
    53fe:	202e 000c      	movel %fp@(12),%d0
    5402:	2040           	moveal %d0,%a0
    5404:	1010           	moveb %a0@,%d0
    5406:	0c00 002a      	cmpib #42,%d0
    540a:	660a           	bnes 0x5416
    540c:	7001           	moveq #1,%d0
    540e:	2d40 fffc      	movel %d0,%fp@(-4)
    5412:	52ae 000c      	addql #1,%fp@(12)
    5416:	202e 000c      	movel %fp@(12),%d0
    541a:	2040           	moveal %d0,%a0
    541c:	1010           	moveb %a0@,%d0
    541e:	49c0           	extbl %d0
    5420:	1030 09b0 0000 	moveb @(00000000,%d0:l),%d0
    5426:	0000 
    5428:	1000           	moveb %d0,%d0
    542a:	0280 0000 00ff 	andil #255,%d0
    5430:	7202           	moveq #2,%d1
    5432:	c081           	andl %d1,%d0
    5434:	4a80           	tstl %d0
    5436:	6748           	beqs 0x5480
    5438:	6024           	bras 0x545e
    543a:	202e ffdc      	movel %fp@(-36),%d0
    543e:	d080           	addl %d0,%d0
    5440:	2200           	movel %d0,%d1
    5442:	e589           	lsll #2,%d1
    5444:	d280           	addl %d0,%d1
    5446:	202e 000c      	movel %fp@(12),%d0
    544a:	2040           	moveal %d0,%a0
    544c:	1010           	moveb %a0@,%d0
    544e:	49c0           	extbl %d0
    5450:	d081           	addl %d1,%d0
    5452:	72d0           	moveq #-48,%d1
    5454:	d081           	addl %d1,%d0
    5456:	2d40 ffdc      	movel %d0,%fp@(-36)
    545a:	52ae 000c      	addql #1,%fp@(12)
    545e:	202e 000c      	movel %fp@(12),%d0
    5462:	2040           	moveal %d0,%a0
    5464:	1010           	moveb %a0@,%d0
    5466:	49c0           	extbl %d0
    5468:	1030 09b0 0000 	moveb @(00000000,%d0:l),%d0
    546e:	0000 
    5470:	1000           	moveb %d0,%d0
    5472:	0280 0000 00ff 	andil #255,%d0
    5478:	7202           	moveq #2,%d1
    547a:	c081           	andl %d1,%d0
    547c:	4a80           	tstl %d0
    547e:	66ba           	bnes 0x543a
    5480:	202e 000c      	movel %fp@(12),%d0
    5484:	2040           	moveal %d0,%a0
    5486:	1010           	moveb %a0@,%d0
    5488:	0c00 0068      	cmpib #104,%d0
    548c:	671c           	beqs 0x54aa
    548e:	202e 000c      	movel %fp@(12),%d0
    5492:	2240           	moveal %d0,%a1
    5494:	1011           	moveb %a1@,%d0
    5496:	0c00 006c      	cmpib #108,%d0
    549a:	670e           	beqs 0x54aa
    549c:	202e 000c      	movel %fp@(12),%d0
    54a0:	2040           	moveal %d0,%a0
    54a2:	1010           	moveb %a0@,%d0
    54a4:	0c00 004c      	cmpib #76,%d0
    54a8:	6614           	bnes 0x54be
    54aa:	202e 000c      	movel %fp@(12),%d0
    54ae:	2240           	moveal %d0,%a1
    54b0:	1011           	moveb %a1@,%d0
    54b2:	1200           	moveb %d0,%d1
    54b4:	49c1           	extbl %d1
    54b6:	2d41 fff8      	movel %d1,%fp@(-8)
    54ba:	52ae 000c      	addql #1,%fp@(12)
    54be:	202e 000c      	movel %fp@(12),%d0
    54c2:	2040           	moveal %d0,%a0
    54c4:	1010           	moveb %a0@,%d0
    54c6:	49c0           	extbl %d0
    54c8:	52ae 000c      	addql #1,%fp@(12)
    54cc:	72db           	moveq #-37,%d1
    54ce:	d081           	addl %d1,%d0
    54d0:	7453           	moveq #83,%d2
    54d2:	b480           	cmpl %d0,%d2
    54d4:	6500 0d42      	bcsw 0x6218
    54d8:	303b 0a06      	movew %pc@(0x54e0,%d0:l:2),%d0
    54dc:	4efb 0002      	jmp %pc@(0x54e0,%d0:w)
    54e0:	0d0c 0d38      	movepw %a4@(3384),%d6
    54e4:	0d38 0d38      	btst %d6,0xd38
    54e8:	0d38 0d38      	btst %d6,0xd38
    54ec:	0d38 0d38      	btst %d6,0xd38
    54f0:	0d38 0d38      	btst %d6,0xd38
    54f4:	0d38 0d38      	btst %d6,0xd38
    54f8:	0d38 0d38      	btst %d6,0xd38
    54fc:	0d38 0d38      	btst %d6,0xd38
    5500:	0d38 0d38      	btst %d6,0xd38
    5504:	0d38 0d38      	btst %d6,0xd38
    5508:	0d38 0d38      	btst %d6,0xd38
    550c:	0d38 0d38      	btst %d6,0xd38
    5510:	0d38 0d38      	btst %d6,0xd38
    5514:	0d38 0d38      	btst %d6,0xd38
    5518:	0d38 0d38      	btst %d6,0xd38
    551c:	0d38 0d38      	btst %d6,0xd38
    5520:	0d38 0d38      	btst %d6,0xd38
    5524:	0d38 0d38      	btst %d6,0xd38
    5528:	0d38 0d38      	btst %d6,0xd38
    552c:	0d38 0d38      	btst %d6,0xd38
    5530:	0d38 0d38      	btst %d6,0xd38
    5534:	0d38 0d38      	btst %d6,0xd38
    5538:	0d38 0d38      	btst %d6,0xd38
    553c:	0d38 0d38      	btst %d6,0xd38
    5540:	0d38 0d38      	btst %d6,0xd38
    5544:	0d38 0d38      	btst %d6,0xd38
    5548:	0d38 0d38      	btst %d6,0xd38
    554c:	05d0           	bset %d2,%a0@
    554e:	0d38 0d38      	btst %d6,0xd38
    5552:	0d38 0d38      	btst %d6,0xd38
    5556:	0d38 0d38      	btst %d6,0xd38
    555a:	0d38 00a8      	btst %d6,0xa8
    555e:	012a 039c      	btst %d0,%a2@(924)
    5562:	039c           	bclr %d1,%a4@+
    5564:	039c           	bclr %d1,%a4@+
    5566:	0d38 012a      	btst %d6,0x12a
    556a:	0d38 0d38      	btst %d6,0xd38
    556e:	0d38 0d38      	btst %d6,0xd38
    5572:	03bc           	.short 0x03bc
    5574:	03dc           	bset %d1,%a4@+
    5576:	0a72 0d38 0d38 	eoriw #3384,%a2@(06200d38,%d0:l:4)
    557c:	0620 0d38 
    5580:	08a2 0d38      	bclr #56,%a2@-
    5584:	0d38 0a72      	btst %d6,0xa72
    5588:	202e 0018      	movel %fp@(24),%d0
    558c:	2040           	moveal %d0,%a0
    558e:	2010           	movel %a0@,%d0
    5590:	2200           	movel %d0,%d1
    5592:	5281           	addql #1,%d1
    5594:	202e 0018      	movel %fp@(24),%d0
    5598:	2240           	moveal %d0,%a1
    559a:	2281           	movel %d1,%a1@
    559c:	202e 0008      	movel %fp@(8),%d0
    55a0:	2040           	moveal %d0,%a0
    55a2:	2010           	movel %a0@,%d0
    55a4:	2240           	moveal %d0,%a1
    55a6:	1211           	moveb %a1@,%d1
    55a8:	1401           	moveb %d1,%d2
    55aa:	49c2           	extbl %d2
    55ac:	2d42 fff0      	movel %d2,%fp@(-16)
    55b0:	2200           	movel %d0,%d1
    55b2:	5281           	addql #1,%d1
    55b4:	202e 0008      	movel %fp@(8),%d0
    55b8:	2040           	moveal %d0,%a0
    55ba:	2081           	movel %d1,%a0@
    55bc:	202e 0018      	movel %fp@(24),%d0
    55c0:	2240           	moveal %d0,%a1
    55c2:	2011           	movel %a1@,%d0
    55c4:	2200           	movel %d0,%d1
    55c6:	5281           	addql #1,%d1
    55c8:	202e 0018      	movel %fp@(24),%d0
    55cc:	2040           	moveal %d0,%a0
    55ce:	2081           	movel %d1,%a0@
    55d0:	4aae fff0      	tstl %fp@(-16)
    55d4:	6606           	bnes 0x55dc
    55d6:	4280           	clrl %d0
    55d8:	6000 0c5e      	braw 0x6238
    55dc:	4aae fffc      	tstl %fp@(-4)
    55e0:	6600 0c3c      	bnew 0x621e
    55e4:	202e 0014      	movel %fp@(20),%d0
    55e8:	2240           	moveal %d0,%a1
    55ea:	2011           	movel %a1@,%d0
    55ec:	2200           	movel %d0,%d1
    55ee:	5281           	addql #1,%d1
    55f0:	202e 0014      	movel %fp@(20),%d0
    55f4:	2040           	moveal %d0,%a0
    55f6:	2081           	movel %d1,%a0@
    55f8:	202e 0010      	movel %fp@(16),%d0
    55fc:	222e fff0      	movel %fp@(-16),%d1
    5600:	1201           	moveb %d1,%d1
    5602:	2240           	moveal %d0,%a1
    5604:	1281           	moveb %d1,%a1@
    5606:	6000 0c2c      	braw 0x6234
    560a:	202e 0008      	movel %fp@(8),%d0
    560e:	2040           	moveal %d0,%a0
    5610:	2210           	movel %a0@,%d1
    5612:	70d8           	moveq #-40,%d0
    5614:	d08e           	addl %fp,%d0
    5616:	2f00           	movel %d0,%sp@-
    5618:	70dc           	moveq #-36,%d0
    561a:	d08e           	addl %fp,%d0
    561c:	2f00           	movel %d0,%sp@-
    561e:	2f01           	movel %d1,%sp@-
    5620:	4eba fd0e      	jsr %pc@(0x5330)
    5624:	4fef 000c      	lea %sp@(12),%sp
    5628:	2208           	movel %a0,%d1
    562a:	202e 0008      	movel %fp@(8),%d0
    562e:	2240           	moveal %d0,%a1
    5630:	2281           	movel %d1,%a1@
    5632:	42ae fff0      	clrl %fp@(-16)
    5636:	202e ffd8      	movel %fp@(-40),%d0
    563a:	4a80           	tstl %d0
    563c:	6600 01f8      	bnew 0x5836
    5640:	202e 0008      	movel %fp@(8),%d0
    5644:	2040           	moveal %d0,%a0
    5646:	2010           	movel %a0@,%d0
    5648:	2240           	moveal %d0,%a1
    564a:	1011           	moveb %a1@,%d0
    564c:	0c00 002d      	cmpib #45,%d0
    5650:	6642           	bnes 0x5694
    5652:	7001           	moveq #1,%d0
    5654:	2d40 fff4      	movel %d0,%fp@(-12)
    5658:	202e ffdc      	movel %fp@(-36),%d0
    565c:	4a80           	tstl %d0
    565e:	670a           	beqs 0x566a
    5660:	202e ffdc      	movel %fp@(-36),%d0
    5664:	5380           	subql #1,%d0
    5666:	2d40 ffdc      	movel %d0,%fp@(-36)
    566a:	202e 0008      	movel %fp@(8),%d0
    566e:	2040           	moveal %d0,%a0
    5670:	2010           	movel %a0@,%d0
    5672:	2200           	movel %d0,%d1
    5674:	5281           	addql #1,%d1
    5676:	202e 0008      	movel %fp@(8),%d0
    567a:	2240           	moveal %d0,%a1
    567c:	2281           	movel %d1,%a1@
    567e:	202e 0018      	movel %fp@(24),%d0
    5682:	2040           	moveal %d0,%a0
    5684:	2010           	movel %a0@,%d0
    5686:	2200           	movel %d0,%d1
    5688:	5281           	addql #1,%d1
    568a:	202e 0018      	movel %fp@(24),%d0
    568e:	2240           	moveal %d0,%a1
    5690:	2281           	movel %d1,%a1@
    5692:	604c           	bras 0x56e0
    5694:	202e 0008      	movel %fp@(8),%d0
    5698:	2040           	moveal %d0,%a0
    569a:	2010           	movel %a0@,%d0
    569c:	2240           	moveal %d0,%a1
    569e:	1011           	moveb %a1@,%d0
    56a0:	0c00 002b      	cmpib #43,%d0
    56a4:	663a           	bnes 0x56e0
    56a6:	202e 0008      	movel %fp@(8),%d0
    56aa:	2040           	moveal %d0,%a0
    56ac:	2010           	movel %a0@,%d0
    56ae:	2200           	movel %d0,%d1
    56b0:	5281           	addql #1,%d1
    56b2:	202e 0008      	movel %fp@(8),%d0
    56b6:	2240           	moveal %d0,%a1
    56b8:	2281           	movel %d1,%a1@
    56ba:	202e ffdc      	movel %fp@(-36),%d0
    56be:	4a80           	tstl %d0
    56c0:	670a           	beqs 0x56cc
    56c2:	202e ffdc      	movel %fp@(-36),%d0
    56c6:	5380           	subql #1,%d0
    56c8:	2d40 ffdc      	movel %d0,%fp@(-36)
    56cc:	202e 0018      	movel %fp@(24),%d0
    56d0:	2040           	moveal %d0,%a0
    56d2:	2010           	movel %a0@,%d0
    56d4:	2200           	movel %d0,%d1
    56d6:	5281           	addql #1,%d1
    56d8:	202e 0018      	movel %fp@(24),%d0
    56dc:	2240           	moveal %d0,%a1
    56de:	2281           	movel %d1,%a1@
    56e0:	202e ffdc      	movel %fp@(-36),%d0
    56e4:	4a80           	tstl %d0
    56e6:	6700 011c      	beqw 0x5804
    56ea:	6058           	bras 0x5744
    56ec:	7001           	moveq #1,%d0
    56ee:	2d40 ffec      	movel %d0,%fp@(-20)
    56f2:	202e ffdc      	movel %fp@(-36),%d0
    56f6:	5380           	subql #1,%d0
    56f8:	2d40 ffdc      	movel %d0,%fp@(-36)
    56fc:	202e fff0      	movel %fp@(-16),%d0
    5700:	d080           	addl %d0,%d0
    5702:	2200           	movel %d0,%d1
    5704:	e589           	lsll #2,%d1
    5706:	2400           	movel %d0,%d2
    5708:	d481           	addl %d1,%d2
    570a:	2d42 fff0      	movel %d2,%fp@(-16)
    570e:	202e 0018      	movel %fp@(24),%d0
    5712:	2040           	moveal %d0,%a0
    5714:	2010           	movel %a0@,%d0
    5716:	2200           	movel %d0,%d1
    5718:	5281           	addql #1,%d1
    571a:	202e 0018      	movel %fp@(24),%d0
    571e:	2240           	moveal %d0,%a1
    5720:	2281           	movel %d1,%a1@
    5722:	202e 0008      	movel %fp@(8),%d0
    5726:	2040           	moveal %d0,%a0
    5728:	2010           	movel %a0@,%d0
    572a:	2240           	moveal %d0,%a1
    572c:	1211           	moveb %a1@,%d1
    572e:	49c1           	extbl %d1
    5730:	74d0           	moveq #-48,%d2
    5732:	d282           	addl %d2,%d1
    5734:	d3ae fff0      	addl %d1,%fp@(-16)
    5738:	2200           	movel %d0,%d1
    573a:	5281           	addql #1,%d1
    573c:	202e 0008      	movel %fp@(8),%d0
    5740:	2040           	moveal %d0,%a0
    5742:	2081           	movel %d1,%a0@
    5744:	202e ffdc      	movel %fp@(-36),%d0
    5748:	4a80           	tstl %d0
    574a:	674a           	beqs 0x5796
    574c:	202e 0008      	movel %fp@(8),%d0
    5750:	2240           	moveal %d0,%a1
    5752:	2011           	movel %a1@,%d0
    5754:	2040           	moveal %d0,%a0
    5756:	1010           	moveb %a0@,%d0
    5758:	49c0           	extbl %d0
    575a:	1030 09b0 0000 	moveb @(00000000,%d0:l),%d0
    5760:	0000 
    5762:	1000           	moveb %d0,%d0
    5764:	0280 0000 00ff 	andil #255,%d0
    576a:	7202           	moveq #2,%d1
    576c:	c081           	andl %d1,%d0
    576e:	4a80           	tstl %d0
    5770:	6600 ff7a      	bnew 0x56ec
    5774:	6022           	bras 0x5798
    5776:	202e 0008      	movel %fp@(8),%d0
    577a:	2040           	moveal %d0,%a0
    577c:	2010           	movel %a0@,%d0
    577e:	2200           	movel %d0,%d1
    5780:	5281           	addql #1,%d1
    5782:	202e 0008      	movel %fp@(8),%d0
    5786:	2240           	moveal %d0,%a1
    5788:	2281           	movel %d1,%a1@
    578a:	202e ffdc      	movel %fp@(-36),%d0
    578e:	5380           	subql #1,%d0
    5790:	2d40 ffdc      	movel %d0,%fp@(-36)
    5794:	6002           	bras 0x5798
    5796:	4e71           	nop
    5798:	202e ffdc      	movel %fp@(-36),%d0
    579c:	4a80           	tstl %d0
    579e:	6700 008c      	beqw 0x582c
    57a2:	202e 0008      	movel %fp@(8),%d0
    57a6:	2040           	moveal %d0,%a0
    57a8:	2010           	movel %a0@,%d0
    57aa:	2240           	moveal %d0,%a1
    57ac:	1011           	moveb %a1@,%d0
    57ae:	4a00           	tstb %d0
    57b0:	66c4           	bnes 0x5776
    57b2:	6078           	bras 0x582c
    57b4:	7001           	moveq #1,%d0
    57b6:	2d40 ffec      	movel %d0,%fp@(-20)
    57ba:	202e fff0      	movel %fp@(-16),%d0
    57be:	d080           	addl %d0,%d0
    57c0:	2200           	movel %d0,%d1
    57c2:	e589           	lsll #2,%d1
    57c4:	2400           	movel %d0,%d2
    57c6:	d481           	addl %d1,%d2
    57c8:	2d42 fff0      	movel %d2,%fp@(-16)
    57cc:	202e 0018      	movel %fp@(24),%d0
    57d0:	2040           	moveal %d0,%a0
    57d2:	2010           	movel %a0@,%d0
    57d4:	2200           	movel %d0,%d1
    57d6:	5281           	addql #1,%d1
    57d8:	202e 0018      	movel %fp@(24),%d0
    57dc:	2240           	moveal %d0,%a1
    57de:	2281           	movel %d1,%a1@
    57e0:	202e 0008      	movel %fp@(8),%d0
    57e4:	2040           	moveal %d0,%a0
    57e6:	2010           	movel %a0@,%d0
    57e8:	2240           	moveal %d0,%a1
    57ea:	1211           	moveb %a1@,%d1
    57ec:	49c1           	extbl %d1
    57ee:	74d0           	moveq #-48,%d2
    57f0:	d282           	addl %d2,%d1
    57f2:	d3ae fff0      	addl %d1,%fp@(-16)
    57f6:	2200           	movel %d0,%d1
    57f8:	5281           	addql #1,%d1
    57fa:	202e 0008      	movel %fp@(8),%d0
    57fe:	2040           	moveal %d0,%a0
    5800:	2081           	movel %d1,%a0@
    5802:	6002           	bras 0x5806
    5804:	4e71           	nop
    5806:	202e 0008      	movel %fp@(8),%d0
    580a:	2240           	moveal %d0,%a1
    580c:	2011           	movel %a1@,%d0
    580e:	2040           	moveal %d0,%a0
    5810:	1010           	moveb %a0@,%d0
    5812:	49c0           	extbl %d0
    5814:	1030 09b0 0000 	moveb @(00000000,%d0:l),%d0
    581a:	0000 
    581c:	1000           	moveb %d0,%d0
    581e:	0280 0000 00ff 	andil #255,%d0
    5824:	7202           	moveq #2,%d1
    5826:	c081           	andl %d1,%d0
    5828:	4a80           	tstl %d0
    582a:	6688           	bnes 0x57b4
    582c:	4aae fff4      	tstl %fp@(-12)
    5830:	6704           	beqs 0x5836
    5832:	44ae fff0      	negl %fp@(-16)
    5836:	4aae fffc      	tstl %fp@(-4)
    583a:	6600 09e6      	bnew 0x6222
    583e:	202e 0014      	movel %fp@(20),%d0
    5842:	2040           	moveal %d0,%a0
    5844:	2010           	movel %a0@,%d0
    5846:	2200           	movel %d0,%d1
    5848:	d2ae ffec      	addl %fp@(-20),%d1
    584c:	202e 0014      	movel %fp@(20),%d0
    5850:	2240           	moveal %d0,%a1
    5852:	2281           	movel %d1,%a1@
    5854:	7068           	moveq #104,%d0
    5856:	b0ae fff8      	cmpl %fp@(-8),%d0
    585a:	6612           	bnes 0x586e
    585c:	202e 0010      	movel %fp@(16),%d0
    5860:	222e fff0      	movel %fp@(-16),%d1
    5864:	3201           	movew %d1,%d1
    5866:	2040           	moveal %d0,%a0
    5868:	3081           	movew %d1,%a0@
    586a:	6000 09c8      	braw 0x6234
    586e:	202e 0010      	movel %fp@(16),%d0
    5872:	2240           	moveal %d0,%a1
    5874:	22ae fff0      	movel %fp@(-16),%a1@
    5878:	6000 09ba      	braw 0x6234
    587c:	4aae fffc      	tstl %fp@(-4)
    5880:	6600 09a4      	bnew 0x6226
    5884:	202e 0014      	movel %fp@(20),%d0
    5888:	2040           	moveal %d0,%a0
    588a:	2010           	movel %a0@,%d0
    588c:	2200           	movel %d0,%d1
    588e:	5281           	addql #1,%d1
    5890:	202e 0014      	movel %fp@(20),%d0
    5894:	2240           	moveal %d0,%a1
    5896:	2281           	movel %d1,%a1@
    5898:	6000 099a      	braw 0x6234
    589c:	222e 0010      	movel %fp@(16),%d1
    58a0:	202e 0014      	movel %fp@(20),%d0
    58a4:	2040           	moveal %d0,%a0
    58a6:	2010           	movel %a0@,%d0
    58a8:	2241           	moveal %d1,%a1
    58aa:	2280           	movel %d0,%a1@
    58ac:	2200           	movel %d0,%d1
    58ae:	5281           	addql #1,%d1
    58b0:	202e 0014      	movel %fp@(20),%d0
    58b4:	2040           	moveal %d0,%a0
    58b6:	2081           	movel %d1,%a0@
    58b8:	6000 097a      	braw 0x6234
    58bc:	202e 0008      	movel %fp@(8),%d0
    58c0:	2240           	moveal %d0,%a1
    58c2:	2211           	movel %a1@,%d1
    58c4:	70d8           	moveq #-40,%d0
    58c6:	d08e           	addl %fp,%d0
    58c8:	2f00           	movel %d0,%sp@-
    58ca:	70dc           	moveq #-36,%d0
    58cc:	d08e           	addl %fp,%d0
    58ce:	2f00           	movel %d0,%sp@-
    58d0:	2f01           	movel %d1,%sp@-
    58d2:	4eba fa5c      	jsr %pc@(0x5330)
    58d6:	4fef 000c      	lea %sp@(12),%sp
    58da:	2208           	movel %a0,%d1
    58dc:	202e 0008      	movel %fp@(8),%d0
    58e0:	2040           	moveal %d0,%a0
    58e2:	2081           	movel %d1,%a0@
    58e4:	42ae ffe8      	clrl %fp@(-24)
    58e8:	202e ffd8      	movel %fp@(-40),%d0
    58ec:	4a80           	tstl %d0
    58ee:	6600 017a      	bnew 0x5a6a
    58f2:	202e ffdc      	movel %fp@(-36),%d0
    58f6:	4a80           	tstl %d0
    58f8:	6700 0134      	beqw 0x5a2e
    58fc:	6054           	bras 0x5952
    58fe:	7001           	moveq #1,%d0
    5900:	2d40 ffec      	movel %d0,%fp@(-20)
    5904:	202e ffdc      	movel %fp@(-36),%d0
    5908:	5380           	subql #1,%d0
    590a:	2d40 ffdc      	movel %d0,%fp@(-36)
    590e:	202e ffe8      	movel %fp@(-24),%d0
    5912:	e788           	lsll #3,%d0
    5914:	2d40 ffe8      	movel %d0,%fp@(-24)
    5918:	202e 0018      	movel %fp@(24),%d0
    591c:	2040           	moveal %d0,%a0
    591e:	2010           	movel %a0@,%d0
    5920:	2200           	movel %d0,%d1
    5922:	5281           	addql #1,%d1
    5924:	202e 0018      	movel %fp@(24),%d0
    5928:	2240           	moveal %d0,%a1
    592a:	2281           	movel %d1,%a1@
    592c:	202e 0008      	movel %fp@(8),%d0
    5930:	2040           	moveal %d0,%a0
    5932:	2010           	movel %a0@,%d0
    5934:	2240           	moveal %d0,%a1
    5936:	1211           	moveb %a1@,%d1
    5938:	49c1           	extbl %d1
    593a:	d2ae ffe8      	addl %fp@(-24),%d1
    593e:	74d0           	moveq #-48,%d2
    5940:	d481           	addl %d1,%d2
    5942:	2d42 ffe8      	movel %d2,%fp@(-24)
    5946:	2200           	movel %d0,%d1
    5948:	5281           	addql #1,%d1
    594a:	202e 0008      	movel %fp@(8),%d0
    594e:	2040           	moveal %d0,%a0
    5950:	2081           	movel %d1,%a0@
    5952:	202e ffdc      	movel %fp@(-36),%d0
    5956:	4a80           	tstl %d0
    5958:	675c           	beqs 0x59b6
    595a:	202e 0008      	movel %fp@(8),%d0
    595e:	2240           	moveal %d0,%a1
    5960:	2011           	movel %a1@,%d0
    5962:	2040           	moveal %d0,%a0
    5964:	1010           	moveb %a0@,%d0
    5966:	49c0           	extbl %d0
    5968:	1030 09b0 0000 	moveb @(00000000,%d0:l),%d0
    596e:	0000 
    5970:	1000           	moveb %d0,%d0
    5972:	0280 0000 00ff 	andil #255,%d0
    5978:	7202           	moveq #2,%d1
    597a:	c081           	andl %d1,%d0
    597c:	4a80           	tstl %d0
    597e:	673a           	beqs 0x59ba
    5980:	202e 0008      	movel %fp@(8),%d0
    5984:	2040           	moveal %d0,%a0
    5986:	2010           	movel %a0@,%d0
    5988:	2240           	moveal %d0,%a1
    598a:	1011           	moveb %a1@,%d0
    598c:	0c00 0037      	cmpib #55,%d0
    5990:	6f00 ff6c      	blew 0x58fe
    5994:	6026           	bras 0x59bc
    5996:	202e 0008      	movel %fp@(8),%d0
    599a:	2040           	moveal %d0,%a0
    599c:	2010           	movel %a0@,%d0
    599e:	2200           	movel %d0,%d1
    59a0:	5281           	addql #1,%d1
    59a2:	202e 0008      	movel %fp@(8),%d0
    59a6:	2240           	moveal %d0,%a1
    59a8:	2281           	movel %d1,%a1@
    59aa:	202e ffdc      	movel %fp@(-36),%d0
    59ae:	5380           	subql #1,%d0
    59b0:	2d40 ffdc      	movel %d0,%fp@(-36)
    59b4:	6006           	bras 0x59bc
    59b6:	4e71           	nop
    59b8:	6002           	bras 0x59bc
    59ba:	4e71           	nop
    59bc:	202e ffdc      	movel %fp@(-36),%d0
    59c0:	4a80           	tstl %d0
    59c2:	6700 00a6      	beqw 0x5a6a
    59c6:	202e 0008      	movel %fp@(8),%d0
    59ca:	2040           	moveal %d0,%a0
    59cc:	2010           	movel %a0@,%d0
    59ce:	2240           	moveal %d0,%a1
    59d0:	1011           	moveb %a1@,%d0
    59d2:	4a00           	tstb %d0
    59d4:	66c0           	bnes 0x5996
    59d6:	6000 0092      	braw 0x5a6a
    59da:	7001           	moveq #1,%d0
    59dc:	2d40 ffec      	movel %d0,%fp@(-20)
    59e0:	202e ffe8      	movel %fp@(-24),%d0
    59e4:	d080           	addl %d0,%d0
    59e6:	2200           	movel %d0,%d1
    59e8:	e589           	lsll #2,%d1
    59ea:	2400           	movel %d0,%d2
    59ec:	d481           	addl %d1,%d2
    59ee:	2d42 ffe8      	movel %d2,%fp@(-24)
    59f2:	202e 0018      	movel %fp@(24),%d0
    59f6:	2040           	moveal %d0,%a0
    59f8:	2010           	movel %a0@,%d0
    59fa:	2200           	movel %d0,%d1
    59fc:	5281           	addql #1,%d1
    59fe:	202e 0018      	movel %fp@(24),%d0
    5a02:	2240           	moveal %d0,%a1
    5a04:	2281           	movel %d1,%a1@
    5a06:	202e 0008      	movel %fp@(8),%d0
    5a0a:	2040           	moveal %d0,%a0
    5a0c:	2010           	movel %a0@,%d0
    5a0e:	2240           	moveal %d0,%a1
    5a10:	1211           	moveb %a1@,%d1
    5a12:	49c1           	extbl %d1
    5a14:	d2ae ffe8      	addl %fp@(-24),%d1
    5a18:	74d0           	moveq #-48,%d2
    5a1a:	d481           	addl %d1,%d2
    5a1c:	2d42 ffe8      	movel %d2,%fp@(-24)
    5a20:	2200           	movel %d0,%d1
    5a22:	5281           	addql #1,%d1
    5a24:	202e 0008      	movel %fp@(8),%d0
    5a28:	2040           	moveal %d0,%a0
    5a2a:	2081           	movel %d1,%a0@
    5a2c:	6002           	bras 0x5a30
    5a2e:	4e71           	nop
    5a30:	202e 0008      	movel %fp@(8),%d0
    5a34:	2240           	moveal %d0,%a1
    5a36:	2011           	movel %a1@,%d0
    5a38:	2040           	moveal %d0,%a0
    5a3a:	1010           	moveb %a0@,%d0
    5a3c:	49c0           	extbl %d0
    5a3e:	1030 09b0 0000 	moveb @(00000000,%d0:l),%d0
    5a44:	0000 
    5a46:	1000           	moveb %d0,%d0
    5a48:	0280 0000 00ff 	andil #255,%d0
    5a4e:	7202           	moveq #2,%d1
    5a50:	c081           	andl %d1,%d0
    5a52:	4a80           	tstl %d0
    5a54:	6714           	beqs 0x5a6a
    5a56:	202e 0008      	movel %fp@(8),%d0
    5a5a:	2040           	moveal %d0,%a0
    5a5c:	2010           	movel %a0@,%d0
    5a5e:	2240           	moveal %d0,%a1
    5a60:	1011           	moveb %a1@,%d0
    5a62:	0c00 0037      	cmpib #55,%d0
    5a66:	6f00 ff72      	blew 0x59da
    5a6a:	4aae fffc      	tstl %fp@(-4)
    5a6e:	6600 07ba      	bnew 0x622a
    5a72:	202e 0014      	movel %fp@(20),%d0
    5a76:	2040           	moveal %d0,%a0
    5a78:	2010           	movel %a0@,%d0
    5a7a:	2200           	movel %d0,%d1
    5a7c:	d2ae ffec      	addl %fp@(-20),%d1
    5a80:	202e 0014      	movel %fp@(20),%d0
    5a84:	2240           	moveal %d0,%a1
    5a86:	2281           	movel %d1,%a1@
    5a88:	7068           	moveq #104,%d0
    5a8a:	b0ae fff8      	cmpl %fp@(-8),%d0
    5a8e:	6612           	bnes 0x5aa2
    5a90:	202e 0010      	movel %fp@(16),%d0
    5a94:	222e ffe8      	movel %fp@(-24),%d1
    5a98:	3201           	movew %d1,%d1
    5a9a:	2040           	moveal %d0,%a0
    5a9c:	3081           	movew %d1,%a0@
    5a9e:	6000 0794      	braw 0x6234
    5aa2:	202e 0010      	movel %fp@(16),%d0
    5aa6:	2240           	moveal %d0,%a1
    5aa8:	22ae ffe8      	movel %fp@(-24),%a1@
    5aac:	6000 0786      	braw 0x6234
    5ab0:	42ae ffe0      	clrl %fp@(-32)
    5ab4:	6020           	bras 0x5ad6
    5ab6:	202e 000c      	movel %fp@(12),%d0
    5aba:	2040           	moveal %d0,%a0
    5abc:	1210           	moveb %a0@,%d1
    5abe:	200e           	movel %fp,%d0
    5ac0:	0680 ffff ff54 	addil #-172,%d0
    5ac6:	d0ae ffe0      	addl %fp@(-32),%d0
    5aca:	2240           	moveal %d0,%a1
    5acc:	1281           	moveb %d1,%a1@
    5ace:	52ae ffe0      	addql #1,%fp@(-32)
    5ad2:	52ae 000c      	addql #1,%fp@(12)
    5ad6:	202e 000c      	movel %fp@(12),%d0
    5ada:	2040           	moveal %d0,%a0
    5adc:	1010           	moveb %a0@,%d0
    5ade:	4a00           	tstb %d0
    5ae0:	670e           	beqs 0x5af0
    5ae2:	202e 000c      	movel %fp@(12),%d0
    5ae6:	2240           	moveal %d0,%a1
    5ae8:	1011           	moveb %a1@,%d0
    5aea:	0c00 005d      	cmpib #93,%d0
    5aee:	66c6           	bnes 0x5ab6
    5af0:	200e           	movel %fp,%d0
    5af2:	0680 ffff ff54 	addil #-172,%d0
    5af8:	d0ae ffe0      	addl %fp@(-32),%d0
    5afc:	2040           	moveal %d0,%a0
    5afe:	4210           	clrb %a0@
    5b00:	2d6e 0010 ffe4 	movel %fp@(16),%fp@(-28)
    5b06:	202e ffdc      	movel %fp@(-36),%d0
    5b0a:	2d40 ffd8      	movel %d0,%fp@(-40)
    5b0e:	102e ff54      	moveb %fp@(-172),%d0
    5b12:	49c0           	extbl %d0
    5b14:	4a80           	tstl %d0
    5b16:	6770           	beqs 0x5b88
    5b18:	725e           	moveq #94,%d1
    5b1a:	b280           	cmpl %d0,%d1
    5b1c:	6700 0118      	beqw 0x5c36
    5b20:	6000 01ec      	braw 0x5d0e
    5b24:	4aae fffc      	tstl %fp@(-4)
    5b28:	662a           	bnes 0x5b54
    5b2a:	202e 0008      	movel %fp@(8),%d0
    5b2e:	2040           	moveal %d0,%a0
    5b30:	2010           	movel %a0@,%d0
    5b32:	2240           	moveal %d0,%a1
    5b34:	1211           	moveb %a1@,%d1
    5b36:	3041           	moveaw %d1,%a0
    5b38:	222e ffe4      	movel %fp@(-28),%d1
    5b3c:	3408           	movew %a0,%d2
    5b3e:	2241           	moveal %d1,%a1
    5b40:	1282           	moveb %d2,%a1@
    5b42:	52ae ffe4      	addql #1,%fp@(-28)
    5b46:	2200           	movel %d0,%d1
    5b48:	5281           	addql #1,%d1
    5b4a:	202e 0008      	movel %fp@(8),%d0
    5b4e:	2040           	moveal %d0,%a0
    5b50:	2081           	movel %d1,%a0@
    5b52:	6014           	bras 0x5b68
    5b54:	202e 0008      	movel %fp@(8),%d0
    5b58:	2240           	moveal %d0,%a1
    5b5a:	2011           	movel %a1@,%d0
    5b5c:	2200           	movel %d0,%d1
    5b5e:	5281           	addql #1,%d1
    5b60:	202e 0008      	movel %fp@(8),%d0
    5b64:	2040           	moveal %d0,%a0
    5b66:	2081           	movel %d1,%a0@
    5b68:	202e ffdc      	movel %fp@(-36),%d0
    5b6c:	5380           	subql #1,%d0
    5b6e:	2d40 ffdc      	movel %d0,%fp@(-36)
    5b72:	202e 0018      	movel %fp@(24),%d0
    5b76:	2240           	moveal %d0,%a1
    5b78:	2011           	movel %a1@,%d0
    5b7a:	2200           	movel %d0,%d1
    5b7c:	5281           	addql #1,%d1
    5b7e:	202e 0018      	movel %fp@(24),%d0
    5b82:	2040           	moveal %d0,%a0
    5b84:	2081           	movel %d1,%a0@
    5b86:	6002           	bras 0x5b8a
    5b88:	4e71           	nop
    5b8a:	202e 0008      	movel %fp@(8),%d0
    5b8e:	2240           	moveal %d0,%a1
    5b90:	2011           	movel %a1@,%d0
    5b92:	2040           	moveal %d0,%a0
    5b94:	1010           	moveb %a0@,%d0
    5b96:	4a00           	tstb %d0
    5b98:	6712           	beqs 0x5bac
    5b9a:	202e ffdc      	movel %fp@(-36),%d0
    5b9e:	4a80           	tstl %d0
    5ba0:	6682           	bnes 0x5b24
    5ba2:	202e ffd8      	movel %fp@(-40),%d0
    5ba6:	4a80           	tstl %d0
    5ba8:	6700 ff7a      	beqw 0x5b24
    5bac:	4aae fffc      	tstl %fp@(-4)
    5bb0:	661c           	bnes 0x5bce
    5bb2:	202e ffe4      	movel %fp@(-28),%d0
    5bb6:	2240           	moveal %d0,%a1
    5bb8:	4211           	clrb %a1@
    5bba:	202e 0014      	movel %fp@(20),%d0
    5bbe:	2040           	moveal %d0,%a0
    5bc0:	2010           	movel %a0@,%d0
    5bc2:	2200           	movel %d0,%d1
    5bc4:	5281           	addql #1,%d1
    5bc6:	202e 0014      	movel %fp@(20),%d0
    5bca:	2240           	moveal %d0,%a1
    5bcc:	2281           	movel %d1,%a1@
    5bce:	6000 01ae      	braw 0x5d7e
    5bd2:	4aae fffc      	tstl %fp@(-4)
    5bd6:	662a           	bnes 0x5c02
    5bd8:	202e 0008      	movel %fp@(8),%d0
    5bdc:	2040           	moveal %d0,%a0
    5bde:	2010           	movel %a0@,%d0
    5be0:	2240           	moveal %d0,%a1
    5be2:	1211           	moveb %a1@,%d1
    5be4:	3041           	moveaw %d1,%a0
    5be6:	222e ffe4      	movel %fp@(-28),%d1
    5bea:	3408           	movew %a0,%d2
    5bec:	2241           	moveal %d1,%a1
    5bee:	1282           	moveb %d2,%a1@
    5bf0:	52ae ffe4      	addql #1,%fp@(-28)
    5bf4:	2200           	movel %d0,%d1
    5bf6:	5281           	addql #1,%d1
    5bf8:	202e 0008      	movel %fp@(8),%d0
    5bfc:	2040           	moveal %d0,%a0
    5bfe:	2081           	movel %d1,%a0@
    5c00:	6014           	bras 0x5c16
    5c02:	202e 0008      	movel %fp@(8),%d0
    5c06:	2240           	moveal %d0,%a1
    5c08:	2011           	movel %a1@,%d0
    5c0a:	2200           	movel %d0,%d1
    5c0c:	5281           	addql #1,%d1
    5c0e:	202e 0008      	movel %fp@(8),%d0
    5c12:	2040           	moveal %d0,%a0
    5c14:	2081           	movel %d1,%a0@
    5c16:	202e ffdc      	movel %fp@(-36),%d0
    5c1a:	5380           	subql #1,%d0
    5c1c:	2d40 ffdc      	movel %d0,%fp@(-36)
    5c20:	202e 0018      	movel %fp@(24),%d0
    5c24:	2240           	moveal %d0,%a1
    5c26:	2011           	movel %a1@,%d0
    5c28:	2200           	movel %d0,%d1
    5c2a:	5281           	addql #1,%d1
    5c2c:	202e 0018      	movel %fp@(24),%d0
    5c30:	2040           	moveal %d0,%a0
    5c32:	2081           	movel %d1,%a0@
    5c34:	6002           	bras 0x5c38
    5c36:	4e71           	nop
    5c38:	202e 0008      	movel %fp@(8),%d0
    5c3c:	2240           	moveal %d0,%a1
    5c3e:	2011           	movel %a1@,%d0
    5c40:	2040           	moveal %d0,%a0
    5c42:	1010           	moveb %a0@,%d0
    5c44:	49c0           	extbl %d0
    5c46:	2f00           	movel %d0,%sp@-
    5c48:	200e           	movel %fp,%d0
    5c4a:	0680 ffff ff54 	addil #-172,%d0
    5c50:	5280           	addql #1,%d0
    5c52:	2f00           	movel %d0,%sp@-
    5c54:	4eb9 0000 0000 	jsr 0x0
    5c5a:	508f           	addql #8,%sp
    5c5c:	2008           	movel %a0,%d0
    5c5e:	4a80           	tstl %d0
    5c60:	6624           	bnes 0x5c86
    5c62:	202e 0008      	movel %fp@(8),%d0
    5c66:	2240           	moveal %d0,%a1
    5c68:	2011           	movel %a1@,%d0
    5c6a:	2040           	moveal %d0,%a0
    5c6c:	1010           	moveb %a0@,%d0
    5c6e:	4a00           	tstb %d0
    5c70:	6714           	beqs 0x5c86
    5c72:	202e ffdc      	movel %fp@(-36),%d0
    5c76:	4a80           	tstl %d0
    5c78:	6600 ff58      	bnew 0x5bd2
    5c7c:	202e ffd8      	movel %fp@(-40),%d0
    5c80:	4a80           	tstl %d0
    5c82:	6700 ff4e      	beqw 0x5bd2
    5c86:	4aae fffc      	tstl %fp@(-4)
    5c8a:	661c           	bnes 0x5ca8
    5c8c:	202e ffe4      	movel %fp@(-28),%d0
    5c90:	2240           	moveal %d0,%a1
    5c92:	4211           	clrb %a1@
    5c94:	202e 0014      	movel %fp@(20),%d0
    5c98:	2040           	moveal %d0,%a0
    5c9a:	2010           	movel %a0@,%d0
    5c9c:	2200           	movel %d0,%d1
    5c9e:	5281           	addql #1,%d1
    5ca0:	202e 0014      	movel %fp@(20),%d0
    5ca4:	2240           	moveal %d0,%a1
    5ca6:	2281           	movel %d1,%a1@
    5ca8:	6000 00d4      	braw 0x5d7e
    5cac:	4aae fffc      	tstl %fp@(-4)
    5cb0:	662a           	bnes 0x5cdc
    5cb2:	202e 0008      	movel %fp@(8),%d0
    5cb6:	2040           	moveal %d0,%a0
    5cb8:	2010           	movel %a0@,%d0
    5cba:	2240           	moveal %d0,%a1
    5cbc:	1211           	moveb %a1@,%d1
    5cbe:	3041           	moveaw %d1,%a0
    5cc0:	222e ffe4      	movel %fp@(-28),%d1
    5cc4:	3408           	movew %a0,%d2
    5cc6:	2241           	moveal %d1,%a1
    5cc8:	1282           	moveb %d2,%a1@
    5cca:	52ae ffe4      	addql #1,%fp@(-28)
    5cce:	2200           	movel %d0,%d1
    5cd0:	5281           	addql #1,%d1
    5cd2:	202e 0008      	movel %fp@(8),%d0
    5cd6:	2040           	moveal %d0,%a0
    5cd8:	2081           	movel %d1,%a0@
    5cda:	6014           	bras 0x5cf0
    5cdc:	202e 0008      	movel %fp@(8),%d0
    5ce0:	2240           	moveal %d0,%a1
    5ce2:	2011           	movel %a1@,%d0
    5ce4:	2200           	movel %d0,%d1
    5ce6:	5281           	addql #1,%d1
    5ce8:	202e 0008      	movel %fp@(8),%d0
    5cec:	2040           	moveal %d0,%a0
    5cee:	2081           	movel %d1,%a0@
    5cf0:	202e ffdc      	movel %fp@(-36),%d0
    5cf4:	5380           	subql #1,%d0
    5cf6:	2d40 ffdc      	movel %d0,%fp@(-36)
    5cfa:	202e 0018      	movel %fp@(24),%d0
    5cfe:	2240           	moveal %d0,%a1
    5d00:	2011           	movel %a1@,%d0
    5d02:	2200           	movel %d0,%d1
    5d04:	5281           	addql #1,%d1
    5d06:	202e 0018      	movel %fp@(24),%d0
    5d0a:	2040           	moveal %d0,%a0
    5d0c:	2081           	movel %d1,%a0@
    5d0e:	202e 0008      	movel %fp@(8),%d0
    5d12:	2240           	moveal %d0,%a1
    5d14:	2011           	movel %a1@,%d0
    5d16:	2040           	moveal %d0,%a0
    5d18:	1010           	moveb %a0@,%d0
    5d1a:	49c0           	extbl %d0
    5d1c:	2f00           	movel %d0,%sp@-
    5d1e:	200e           	movel %fp,%d0
    5d20:	0680 ffff ff54 	addil #-172,%d0
    5d26:	2f00           	movel %d0,%sp@-
    5d28:	4eb9 0000 0000 	jsr 0x0
    5d2e:	508f           	addql #8,%sp
    5d30:	2008           	movel %a0,%d0
    5d32:	4a80           	tstl %d0
    5d34:	6724           	beqs 0x5d5a
    5d36:	202e 0008      	movel %fp@(8),%d0
    5d3a:	2240           	moveal %d0,%a1
    5d3c:	2011           	movel %a1@,%d0
    5d3e:	2040           	moveal %d0,%a0
    5d40:	1010           	moveb %a0@,%d0
    5d42:	4a00           	tstb %d0
    5d44:	6714           	beqs 0x5d5a
    5d46:	202e ffdc      	movel %fp@(-36),%d0
    5d4a:	4a80           	tstl %d0
    5d4c:	6600 ff5e      	bnew 0x5cac
    5d50:	202e ffd8      	movel %fp@(-40),%d0
    5d54:	4a80           	tstl %d0
    5d56:	6700 ff54      	beqw 0x5cac
    5d5a:	4aae fffc      	tstl %fp@(-4)
    5d5e:	661c           	bnes 0x5d7c
    5d60:	202e ffe4      	movel %fp@(-28),%d0
    5d64:	2240           	moveal %d0,%a1
    5d66:	4211           	clrb %a1@
    5d68:	202e 0014      	movel %fp@(20),%d0
    5d6c:	2040           	moveal %d0,%a0
    5d6e:	2010           	movel %a0@,%d0
    5d70:	2200           	movel %d0,%d1
    5d72:	5281           	addql #1,%d1
    5d74:	202e 0014      	movel %fp@(20),%d0
    5d78:	2240           	moveal %d0,%a1
    5d7a:	2281           	movel %d1,%a1@
    5d7c:	4e71           	nop
    5d7e:	6000 04b4      	braw 0x6234
    5d82:	202e 0008      	movel %fp@(8),%d0
    5d86:	2040           	moveal %d0,%a0
    5d88:	2210           	movel %a0@,%d1
    5d8a:	70d8           	moveq #-40,%d0
    5d8c:	d08e           	addl %fp,%d0
    5d8e:	2f00           	movel %d0,%sp@-
    5d90:	70dc           	moveq #-36,%d0
    5d92:	d08e           	addl %fp,%d0
    5d94:	2f00           	movel %d0,%sp@-
    5d96:	2f01           	movel %d1,%sp@-
    5d98:	4eba f596      	jsr %pc@(0x5330)
    5d9c:	4fef 000c      	lea %sp@(12),%sp
    5da0:	2208           	movel %a0,%d1
    5da2:	202e 0008      	movel %fp@(8),%d0
    5da6:	2240           	moveal %d0,%a1
    5da8:	2281           	movel %d1,%a1@
    5daa:	202e ffd8      	movel %fp@(-40),%d0
    5dae:	4a80           	tstl %d0
    5db0:	6600 015a      	bnew 0x5f0c
    5db4:	42ae ffe8      	clrl %fp@(-24)
    5db8:	202e ffdc      	movel %fp@(-36),%d0
    5dbc:	4a80           	tstl %d0
    5dbe:	6700 0124      	beqw 0x5ee4
    5dc2:	605c           	bras 0x5e20
    5dc4:	7001           	moveq #1,%d0
    5dc6:	2d40 ffec      	movel %d0,%fp@(-20)
    5dca:	202e ffdc      	movel %fp@(-36),%d0
    5dce:	5380           	subql #1,%d0
    5dd0:	2d40 ffdc      	movel %d0,%fp@(-36)
    5dd4:	202e ffe8      	movel %fp@(-24),%d0
    5dd8:	d080           	addl %d0,%d0
    5dda:	2200           	movel %d0,%d1
    5ddc:	e589           	lsll #2,%d1
    5dde:	2400           	movel %d0,%d2
    5de0:	d481           	addl %d1,%d2
    5de2:	2d42 ffe8      	movel %d2,%fp@(-24)
    5de6:	202e 0018      	movel %fp@(24),%d0
    5dea:	2040           	moveal %d0,%a0
    5dec:	2010           	movel %a0@,%d0
    5dee:	2200           	movel %d0,%d1
    5df0:	5281           	addql #1,%d1
    5df2:	202e 0018      	movel %fp@(24),%d0
    5df6:	2240           	moveal %d0,%a1
    5df8:	2281           	movel %d1,%a1@
    5dfa:	202e 0008      	movel %fp@(8),%d0
    5dfe:	2040           	moveal %d0,%a0
    5e00:	2010           	movel %a0@,%d0
    5e02:	2240           	moveal %d0,%a1
    5e04:	1211           	moveb %a1@,%d1
    5e06:	49c1           	extbl %d1
    5e08:	d2ae ffe8      	addl %fp@(-24),%d1
    5e0c:	74d0           	moveq #-48,%d2
    5e0e:	d481           	addl %d1,%d2
    5e10:	2d42 ffe8      	movel %d2,%fp@(-24)
    5e14:	2200           	movel %d0,%d1
    5e16:	5281           	addql #1,%d1
    5e18:	202e 0008      	movel %fp@(8),%d0
    5e1c:	2040           	moveal %d0,%a0
    5e1e:	2081           	movel %d1,%a0@
    5e20:	202e ffdc      	movel %fp@(-36),%d0
    5e24:	4a80           	tstl %d0
    5e26:	674a           	beqs 0x5e72
    5e28:	202e 0008      	movel %fp@(8),%d0
    5e2c:	2240           	moveal %d0,%a1
    5e2e:	2011           	movel %a1@,%d0
    5e30:	2040           	moveal %d0,%a0
    5e32:	1010           	moveb %a0@,%d0
    5e34:	49c0           	extbl %d0
    5e36:	1030 09b0 0000 	moveb @(00000000,%d0:l),%d0
    5e3c:	0000 
    5e3e:	1000           	moveb %d0,%d0
    5e40:	0280 0000 00ff 	andil #255,%d0
    5e46:	7202           	moveq #2,%d1
    5e48:	c081           	andl %d1,%d0
    5e4a:	4a80           	tstl %d0
    5e4c:	6600 ff76      	bnew 0x5dc4
    5e50:	6022           	bras 0x5e74
    5e52:	202e 0008      	movel %fp@(8),%d0
    5e56:	2040           	moveal %d0,%a0
    5e58:	2010           	movel %a0@,%d0
    5e5a:	2200           	movel %d0,%d1
    5e5c:	5281           	addql #1,%d1
    5e5e:	202e 0008      	movel %fp@(8),%d0
    5e62:	2240           	moveal %d0,%a1
    5e64:	2281           	movel %d1,%a1@
    5e66:	202e ffdc      	movel %fp@(-36),%d0
    5e6a:	5380           	subql #1,%d0
    5e6c:	2d40 ffdc      	movel %d0,%fp@(-36)
    5e70:	6002           	bras 0x5e74
    5e72:	4e71           	nop
    5e74:	202e ffdc      	movel %fp@(-36),%d0
    5e78:	4a80           	tstl %d0
    5e7a:	6700 0090      	beqw 0x5f0c
    5e7e:	202e 0008      	movel %fp@(8),%d0
    5e82:	2040           	moveal %d0,%a0
    5e84:	2010           	movel %a0@,%d0
    5e86:	2240           	moveal %d0,%a1
    5e88:	1011           	moveb %a1@,%d0
    5e8a:	4a00           	tstb %d0
    5e8c:	66c4           	bnes 0x5e52
    5e8e:	607c           	bras 0x5f0c
    5e90:	7001           	moveq #1,%d0
    5e92:	2d40 ffec      	movel %d0,%fp@(-20)
    5e96:	202e ffe8      	movel %fp@(-24),%d0
    5e9a:	d080           	addl %d0,%d0
    5e9c:	2200           	movel %d0,%d1
    5e9e:	e589           	lsll #2,%d1
    5ea0:	2400           	movel %d0,%d2
    5ea2:	d481           	addl %d1,%d2
    5ea4:	2d42 ffe8      	movel %d2,%fp@(-24)
    5ea8:	202e 0018      	movel %fp@(24),%d0
    5eac:	2040           	moveal %d0,%a0
    5eae:	2010           	movel %a0@,%d0
    5eb0:	2200           	movel %d0,%d1
    5eb2:	5281           	addql #1,%d1
    5eb4:	202e 0018      	movel %fp@(24),%d0
    5eb8:	2240           	moveal %d0,%a1
    5eba:	2281           	movel %d1,%a1@
    5ebc:	202e 0008      	movel %fp@(8),%d0
    5ec0:	2040           	moveal %d0,%a0
    5ec2:	2010           	movel %a0@,%d0
    5ec4:	2240           	moveal %d0,%a1
    5ec6:	1211           	moveb %a1@,%d1
    5ec8:	49c1           	extbl %d1
    5eca:	d2ae ffe8      	addl %fp@(-24),%d1
    5ece:	74d0           	moveq #-48,%d2
    5ed0:	d481           	addl %d1,%d2
    5ed2:	2d42 ffe8      	movel %d2,%fp@(-24)
    5ed6:	2200           	movel %d0,%d1
    5ed8:	5281           	addql #1,%d1
    5eda:	202e 0008      	movel %fp@(8),%d0
    5ede:	2040           	moveal %d0,%a0
    5ee0:	2081           	movel %d1,%a0@
    5ee2:	6002           	bras 0x5ee6
    5ee4:	4e71           	nop
    5ee6:	202e 0008      	movel %fp@(8),%d0
    5eea:	2240           	moveal %d0,%a1
    5eec:	2011           	movel %a1@,%d0
    5eee:	2040           	moveal %d0,%a0
    5ef0:	1010           	moveb %a0@,%d0
    5ef2:	49c0           	extbl %d0
    5ef4:	1030 09b0 0000 	moveb @(00000000,%d0:l),%d0
    5efa:	0000 
    5efc:	1000           	moveb %d0,%d0
    5efe:	0280 0000 00ff 	andil #255,%d0
    5f04:	7202           	moveq #2,%d1
    5f06:	c081           	andl %d1,%d0
    5f08:	4a80           	tstl %d0
    5f0a:	6684           	bnes 0x5e90
    5f0c:	4aae fffc      	tstl %fp@(-4)
    5f10:	6600 031c      	bnew 0x622e
    5f14:	202e 0014      	movel %fp@(20),%d0
    5f18:	2040           	moveal %d0,%a0
    5f1a:	2010           	movel %a0@,%d0
    5f1c:	2200           	movel %d0,%d1
    5f1e:	d2ae ffec      	addl %fp@(-20),%d1
    5f22:	202e 0014      	movel %fp@(20),%d0
    5f26:	2240           	moveal %d0,%a1
    5f28:	2281           	movel %d1,%a1@
    5f2a:	7068           	moveq #104,%d0
    5f2c:	b0ae fff8      	cmpl %fp@(-8),%d0
    5f30:	6612           	bnes 0x5f44
    5f32:	202e 0010      	movel %fp@(16),%d0
    5f36:	222e ffe8      	movel %fp@(-24),%d1
    5f3a:	3201           	movew %d1,%d1
    5f3c:	2040           	moveal %d0,%a0
    5f3e:	3081           	movew %d1,%a0@
    5f40:	6000 02f2      	braw 0x6234
    5f44:	202e 0010      	movel %fp@(16),%d0
    5f48:	2240           	moveal %d0,%a1
    5f4a:	22ae ffe8      	movel %fp@(-24),%a1@
    5f4e:	6000 02e4      	braw 0x6234
    5f52:	42ae ffe8      	clrl %fp@(-24)
    5f56:	202e 0008      	movel %fp@(8),%d0
    5f5a:	2040           	moveal %d0,%a0
    5f5c:	2210           	movel %a0@,%d1
    5f5e:	70d8           	moveq #-40,%d0
    5f60:	d08e           	addl %fp,%d0
    5f62:	2f00           	movel %d0,%sp@-
    5f64:	70dc           	moveq #-36,%d0
    5f66:	d08e           	addl %fp,%d0
    5f68:	2f00           	movel %d0,%sp@-
    5f6a:	2f01           	movel %d1,%sp@-
    5f6c:	4eba f3c2      	jsr %pc@(0x5330)
    5f70:	4fef 000c      	lea %sp@(12),%sp
    5f74:	2208           	movel %a0,%d1
    5f76:	202e 0008      	movel %fp@(8),%d0
    5f7a:	2240           	moveal %d0,%a1
    5f7c:	2281           	movel %d1,%a1@
    5f7e:	202e ffd8      	movel %fp@(-40),%d0
    5f82:	4a80           	tstl %d0
    5f84:	6600 0224      	bnew 0x61aa
    5f88:	202e 0008      	movel %fp@(8),%d0
    5f8c:	2040           	moveal %d0,%a0
    5f8e:	2010           	movel %a0@,%d0
    5f90:	2240           	moveal %d0,%a1
    5f92:	1011           	moveb %a1@,%d0
    5f94:	0c00 0030      	cmpib #48,%d0
    5f98:	666c           	bnes 0x6006
    5f9a:	202e 0008      	movel %fp@(8),%d0
    5f9e:	2040           	moveal %d0,%a0
    5fa0:	2010           	movel %a0@,%d0
    5fa2:	5280           	addql #1,%d0
    5fa4:	2240           	moveal %d0,%a1
    5fa6:	1011           	moveb %a1@,%d0
    5fa8:	0c00 0058      	cmpib #88,%d0
    5fac:	6714           	beqs 0x5fc2
    5fae:	202e 0008      	movel %fp@(8),%d0
    5fb2:	2040           	moveal %d0,%a0
    5fb4:	2010           	movel %a0@,%d0
    5fb6:	5280           	addql #1,%d0
    5fb8:	2240           	moveal %d0,%a1
    5fba:	1011           	moveb %a1@,%d0
    5fbc:	0c00 0078      	cmpib #120,%d0
    5fc0:	6644           	bnes 0x6006
    5fc2:	202e 0018      	movel %fp@(24),%d0
    5fc6:	2040           	moveal %d0,%a0
    5fc8:	2010           	movel %a0@,%d0
    5fca:	2200           	movel %d0,%d1
    5fcc:	5481           	addql #2,%d1
    5fce:	202e 0018      	movel %fp@(24),%d0
    5fd2:	2240           	moveal %d0,%a1
    5fd4:	2281           	movel %d1,%a1@
    5fd6:	202e 0008      	movel %fp@(8),%d0
    5fda:	2040           	moveal %d0,%a0
    5fdc:	2010           	movel %a0@,%d0
    5fde:	2200           	movel %d0,%d1
    5fe0:	5481           	addql #2,%d1
    5fe2:	202e 0008      	movel %fp@(8),%d0
    5fe6:	2240           	moveal %d0,%a1
    5fe8:	2281           	movel %d1,%a1@
    5fea:	202e ffdc      	movel %fp@(-36),%d0
    5fee:	4a80           	tstl %d0
    5ff0:	6714           	beqs 0x6006
    5ff2:	202e ffdc      	movel %fp@(-36),%d0
    5ff6:	5580           	subql #2,%d0
    5ff8:	2d40 ffdc      	movel %d0,%fp@(-36)
    5ffc:	202e ffdc      	movel %fp@(-36),%d0
    6000:	4a80           	tstl %d0
    6002:	6700 01a4      	beqw 0x61a8
    6006:	202e ffdc      	movel %fp@(-36),%d0
    600a:	4a80           	tstl %d0
    600c:	6700 016e      	beqw 0x617c
    6010:	6076           	bras 0x6088
    6012:	7001           	moveq #1,%d0
    6014:	2d40 ffec      	movel %d0,%fp@(-20)
    6018:	202e ffdc      	movel %fp@(-36),%d0
    601c:	5380           	subql #1,%d0
    601e:	2d40 ffdc      	movel %d0,%fp@(-36)
    6022:	202e ffe8      	movel %fp@(-24),%d0
    6026:	e988           	lsll #4,%d0
    6028:	2d40 ffe8      	movel %d0,%fp@(-24)
    602c:	202e 0018      	movel %fp@(24),%d0
    6030:	2040           	moveal %d0,%a0
    6032:	2010           	movel %a0@,%d0
    6034:	2200           	movel %d0,%d1
    6036:	5281           	addql #1,%d1
    6038:	202e 0018      	movel %fp@(24),%d0
    603c:	2240           	moveal %d0,%a1
    603e:	2281           	movel %d1,%a1@
    6040:	202e 0008      	movel %fp@(8),%d0
    6044:	2040           	moveal %d0,%a0
    6046:	2010           	movel %a0@,%d0
    6048:	2240           	moveal %d0,%a1
    604a:	1011           	moveb %a1@,%d0
    604c:	49c0           	extbl %d0
    604e:	d0ae ffe8      	addl %fp@(-24),%d0
    6052:	72d0           	moveq #-48,%d1
    6054:	d280           	addl %d0,%d1
    6056:	2d41 ffe8      	movel %d1,%fp@(-24)
    605a:	202e 0008      	movel %fp@(8),%d0
    605e:	2040           	moveal %d0,%a0
    6060:	2010           	movel %a0@,%d0
    6062:	2240           	moveal %d0,%a1
    6064:	1011           	moveb %a1@,%d0
    6066:	0c00 0060      	cmpib #96,%d0
    606a:	6f06           	bles 0x6072
    606c:	70e0           	moveq #-32,%d0
    606e:	d1ae ffe8      	addl %d0,%fp@(-24)
    6072:	202e 0008      	movel %fp@(8),%d0
    6076:	2040           	moveal %d0,%a0
    6078:	2010           	movel %a0@,%d0
    607a:	2240           	moveal %d0,%a1
    607c:	1011           	moveb %a1@,%d0
    607e:	0c00 0040      	cmpib #64,%d0
    6082:	6f04           	bles 0x6088
    6084:	5fae ffe8      	subql #7,%fp@(-24)
    6088:	202e ffdc      	movel %fp@(-36),%d0
    608c:	4a80           	tstl %d0
    608e:	674a           	beqs 0x60da
    6090:	202e 0008      	movel %fp@(8),%d0
    6094:	2040           	moveal %d0,%a0
    6096:	2010           	movel %a0@,%d0
    6098:	2240           	moveal %d0,%a1
    609a:	1011           	moveb %a1@,%d0
    609c:	49c0           	extbl %d0
    609e:	1030 09b0 0000 	moveb @(00000000,%d0:l),%d0
    60a4:	0000 
    60a6:	1000           	moveb %d0,%d0
    60a8:	0280 0000 00ff 	andil #255,%d0
    60ae:	7210           	moveq #16,%d1
    60b0:	c081           	andl %d1,%d0
    60b2:	4a80           	tstl %d0
    60b4:	6600 ff5c      	bnew 0x6012
    60b8:	6022           	bras 0x60dc
    60ba:	202e 0008      	movel %fp@(8),%d0
    60be:	2040           	moveal %d0,%a0
    60c0:	2010           	movel %a0@,%d0
    60c2:	2200           	movel %d0,%d1
    60c4:	5281           	addql #1,%d1
    60c6:	202e 0008      	movel %fp@(8),%d0
    60ca:	2240           	moveal %d0,%a1
    60cc:	2281           	movel %d1,%a1@
    60ce:	202e ffdc      	movel %fp@(-36),%d0
    60d2:	5380           	subql #1,%d0
    60d4:	2d40 ffdc      	movel %d0,%fp@(-36)
    60d8:	6002           	bras 0x60dc
    60da:	4e71           	nop
    60dc:	202e ffdc      	movel %fp@(-36),%d0
    60e0:	4a80           	tstl %d0
    60e2:	6700 00c6      	beqw 0x61aa
    60e6:	202e 0008      	movel %fp@(8),%d0
    60ea:	2040           	moveal %d0,%a0
    60ec:	2010           	movel %a0@,%d0
    60ee:	2240           	moveal %d0,%a1
    60f0:	1011           	moveb %a1@,%d0
    60f2:	4a00           	tstb %d0
    60f4:	66c4           	bnes 0x60ba
    60f6:	6000 00b2      	braw 0x61aa
    60fa:	7001           	moveq #1,%d0
    60fc:	2d40 ffec      	movel %d0,%fp@(-20)
    6100:	202e ffe8      	movel %fp@(-24),%d0
    6104:	e988           	lsll #4,%d0
    6106:	2d40 ffe8      	movel %d0,%fp@(-24)
    610a:	202e 0018      	movel %fp@(24),%d0
    610e:	2040           	moveal %d0,%a0
    6110:	2010           	movel %a0@,%d0
    6112:	2200           	movel %d0,%d1
    6114:	5281           	addql #1,%d1
    6116:	202e 0018      	movel %fp@(24),%d0
    611a:	2240           	moveal %d0,%a1
    611c:	2281           	movel %d1,%a1@
    611e:	202e 0008      	movel %fp@(8),%d0
    6122:	2040           	moveal %d0,%a0
    6124:	2010           	movel %a0@,%d0
    6126:	2240           	moveal %d0,%a1
    6128:	1011           	moveb %a1@,%d0
    612a:	49c0           	extbl %d0
    612c:	d0ae ffe8      	addl %fp@(-24),%d0
    6130:	72d0           	moveq #-48,%d1
    6132:	d280           	addl %d0,%d1
    6134:	2d41 ffe8      	movel %d1,%fp@(-24)
    6138:	202e 0008      	movel %fp@(8),%d0
    613c:	2040           	moveal %d0,%a0
    613e:	2010           	movel %a0@,%d0
    6140:	2240           	moveal %d0,%a1
    6142:	1011           	moveb %a1@,%d0
    6144:	0c00 0060      	cmpib #96,%d0
    6148:	6f06           	bles 0x6150
    614a:	70e0           	moveq #-32,%d0
    614c:	d1ae ffe8      	addl %d0,%fp@(-24)
    6150:	202e 0008      	movel %fp@(8),%d0
    6154:	2040           	moveal %d0,%a0
    6156:	2010           	movel %a0@,%d0
    6158:	2240           	moveal %d0,%a1
    615a:	1011           	moveb %a1@,%d0
    615c:	0c00 0040      	cmpib #64,%d0
    6160:	6f04           	bles 0x6166
    6162:	5fae ffe8      	subql #7,%fp@(-24)
    6166:	202e 0008      	movel %fp@(8),%d0
    616a:	2040           	moveal %d0,%a0
    616c:	2010           	movel %a0@,%d0
    616e:	2200           	movel %d0,%d1
    6170:	5281           	addql #1,%d1
    6172:	202e 0008      	movel %fp@(8),%d0
    6176:	2240           	moveal %d0,%a1
    6178:	2281           	movel %d1,%a1@
    617a:	6002           	bras 0x617e
    617c:	4e71           	nop
    617e:	202e 0008      	movel %fp@(8),%d0
    6182:	2040           	moveal %d0,%a0
    6184:	2010           	movel %a0@,%d0
    6186:	2240           	moveal %d0,%a1
    6188:	1011           	moveb %a1@,%d0
    618a:	49c0           	extbl %d0
    618c:	1030 09b0 0000 	moveb @(00000000,%d0:l),%d0
    6192:	0000 
    6194:	1000           	moveb %d0,%d0
    6196:	0280 0000 00ff 	andil #255,%d0
    619c:	7210           	moveq #16,%d1
    619e:	c081           	andl %d1,%d0
    61a0:	4a80           	tstl %d0
    61a2:	6600 ff56      	bnew 0x60fa
    61a6:	6002           	bras 0x61aa
    61a8:	4e71           	nop
    61aa:	4aae fffc      	tstl %fp@(-4)
    61ae:	6600 0082      	bnew 0x6232
    61b2:	202e 0014      	movel %fp@(20),%d0
    61b6:	2040           	moveal %d0,%a0
    61b8:	2010           	movel %a0@,%d0
    61ba:	2200           	movel %d0,%d1
    61bc:	d2ae ffec      	addl %fp@(-20),%d1
    61c0:	202e 0014      	movel %fp@(20),%d0
    61c4:	2240           	moveal %d0,%a1
    61c6:	2281           	movel %d1,%a1@
    61c8:	7068           	moveq #104,%d0
    61ca:	b0ae fff8      	cmpl %fp@(-8),%d0
    61ce:	6610           	bnes 0x61e0
    61d0:	202e 0010      	movel %fp@(16),%d0
    61d4:	222e ffe8      	movel %fp@(-24),%d1
    61d8:	3201           	movew %d1,%d1
    61da:	2040           	moveal %d0,%a0
    61dc:	3081           	movew %d1,%a0@
    61de:	6054           	bras 0x6234
    61e0:	202e 0010      	movel %fp@(16),%d0
    61e4:	2240           	moveal %d0,%a1
    61e6:	22ae ffe8      	movel %fp@(-24),%a1@
    61ea:	6048           	bras 0x6234
    61ec:	202e 000c      	movel %fp@(12),%d0
    61f0:	2040           	moveal %d0,%a0
    61f2:	1210           	moveb %a0@,%d1
    61f4:	202e 0008      	movel %fp@(8),%d0
    61f8:	2240           	moveal %d0,%a1
    61fa:	2011           	movel %a1@,%d0
    61fc:	2040           	moveal %d0,%a0
    61fe:	1010           	moveb %a0@,%d0
    6200:	b001           	cmpb %d1,%d0
    6202:	6614           	bnes 0x6218
    6204:	202e 0008      	movel %fp@(8),%d0
    6208:	2240           	moveal %d0,%a1
    620a:	2011           	movel %a1@,%d0
    620c:	2200           	movel %d0,%d1
    620e:	5281           	addql #1,%d1
    6210:	202e 0008      	movel %fp@(8),%d0
    6214:	2040           	moveal %d0,%a0
    6216:	2081           	movel %d1,%a0@
    6218:	52ae 000c      	addql #1,%fp@(12)
    621c:	6016           	bras 0x6234
    621e:	4e71           	nop
    6220:	6012           	bras 0x6234
    6222:	4e71           	nop
    6224:	600e           	bras 0x6234
    6226:	4e71           	nop
    6228:	600a           	bras 0x6234
    622a:	4e71           	nop
    622c:	6006           	bras 0x6234
    622e:	4e71           	nop
    6230:	6002           	bras 0x6234
    6232:	4e71           	nop
    6234:	202e 000c      	movel %fp@(12),%d0
    6238:	2200           	movel %d0,%d1
    623a:	2041           	moveal %d1,%a0
    623c:	242e ff50      	movel %fp@(-176),%d2
    6240:	4e5e           	unlk %fp
    6242:	4e75           	rts
    6244:	4e56 fff4      	linkw %fp,#-12
    6248:	42ae fff8      	clrl %fp@(-8)
    624c:	42ae fff4      	clrl %fp@(-12)
    6250:	7001           	moveq #1,%d0
    6252:	2d40 fffc      	movel %d0,%fp@(-4)
    6256:	6000 0130      	braw 0x6388
    625a:	202e 000c      	movel %fp@(12),%d0
    625e:	2040           	moveal %d0,%a0
    6260:	1010           	moveb %a0@,%d0
    6262:	49c0           	extbl %d0
    6264:	1030 09b0 0000 	moveb @(00000000,%d0:l),%d0
    626a:	0000 
    626c:	1000           	moveb %d0,%d0
    626e:	0280 0000 00ff 	andil #255,%d0
    6274:	7201           	moveq #1,%d1
    6276:	c081           	andl %d1,%d0
    6278:	1000           	moveb %d0,%d0
    627a:	4a00           	tstb %d0
    627c:	675a           	beqs 0x62d8
    627e:	4aae fffc      	tstl %fp@(-4)
    6282:	6778           	beqs 0x62fc
    6284:	6028           	bras 0x62ae
    6286:	202e 0008      	movel %fp@(8),%d0
    628a:	5280           	addql #1,%d0
    628c:	2d40 0008      	movel %d0,%fp@(8)
    6290:	202e 0008      	movel %fp@(8),%d0
    6294:	2040           	moveal %d0,%a0
    6296:	1010           	moveb %a0@,%d0
    6298:	4a00           	tstb %d0
    629a:	6608           	bnes 0x62a4
    629c:	202e fff8      	movel %fp@(-8),%d0
    62a0:	6000 00fe      	braw 0x63a0
    62a4:	202e fff4      	movel %fp@(-12),%d0
    62a8:	5280           	addql #1,%d0
    62aa:	2d40 fff4      	movel %d0,%fp@(-12)
    62ae:	202e 0008      	movel %fp@(8),%d0
    62b2:	2040           	moveal %d0,%a0
    62b4:	1010           	moveb %a0@,%d0
    62b6:	49c0           	extbl %d0
    62b8:	1030 09b0 0000 	moveb @(00000000,%d0:l),%d0
    62be:	0000 
    62c0:	1000           	moveb %d0,%d0
    62c2:	0280 0000 00ff 	andil #255,%d0
    62c8:	7201           	moveq #1,%d1
    62ca:	c081           	andl %d1,%d0
    62cc:	1000           	moveb %d0,%d0
    62ce:	4a00           	tstb %d0
    62d0:	66b4           	bnes 0x6286
    62d2:	42ae fffc      	clrl %fp@(-4)
    62d6:	6024           	bras 0x62fc
    62d8:	202e 000c      	movel %fp@(12),%d0
    62dc:	2040           	moveal %d0,%a0
    62de:	1210           	moveb %a0@,%d1
    62e0:	202e 0008      	movel %fp@(8),%d0
    62e4:	2040           	moveal %d0,%a0
    62e6:	1010           	moveb %a0@,%d0
    62e8:	b001           	cmpb %d1,%d0
    62ea:	660a           	bnes 0x62f6
    62ec:	202e 0008      	movel %fp@(8),%d0
    62f0:	5280           	addql #1,%d0
    62f2:	2d40 0008      	movel %d0,%fp@(8)
    62f6:	7001           	moveq #1,%d0
    62f8:	2d40 fffc      	movel %d0,%fp@(-4)
    62fc:	52ae 000c      	addql #1,%fp@(12)
    6300:	6002           	bras 0x6304
    6302:	4e71           	nop
    6304:	202e 000c      	movel %fp@(12),%d0
    6308:	2040           	moveal %d0,%a0
    630a:	1010           	moveb %a0@,%d0
    630c:	0c00 0025      	cmpib #37,%d0
    6310:	670e           	beqs 0x6320
    6312:	202e 000c      	movel %fp@(12),%d0
    6316:	2040           	moveal %d0,%a0
    6318:	1010           	moveb %a0@,%d0
    631a:	4a00           	tstb %d0
    631c:	6600 ff3c      	bnew 0x625a
    6320:	7001           	moveq #1,%d0
    6322:	2d40 fffc      	movel %d0,%fp@(-4)
    6326:	202e 000c      	movel %fp@(12),%d0
    632a:	2040           	moveal %d0,%a0
    632c:	1010           	moveb %a0@,%d0
    632e:	4a00           	tstb %d0
    6330:	6744           	beqs 0x6376
    6332:	52ae 000c      	addql #1,%fp@(12)
    6336:	202e 000c      	movel %fp@(12),%d0
    633a:	2040           	moveal %d0,%a0
    633c:	1010           	moveb %a0@,%d0
    633e:	4a00           	tstb %d0
    6340:	6734           	beqs 0x6376
    6342:	222e 0010      	movel %fp@(16),%d1
    6346:	202e fff8      	movel %fp@(-8),%d0
    634a:	e588           	lsll #2,%d0
    634c:	d081           	addl %d1,%d0
    634e:	2040           	moveal %d0,%a0
    6350:	2210           	movel %a0@,%d1
    6352:	70f4           	moveq #-12,%d0
    6354:	d08e           	addl %fp,%d0
    6356:	2f00           	movel %d0,%sp@-
    6358:	200e           	movel %fp,%d0
    635a:	5180           	subql #8,%d0
    635c:	2f00           	movel %d0,%sp@-
    635e:	2f01           	movel %d1,%sp@-
    6360:	2f2e 000c      	movel %fp@(12),%sp@-
    6364:	200e           	movel %fp,%d0
    6366:	5080           	addql #8,%d0
    6368:	2f00           	movel %d0,%sp@-
    636a:	4eba f070      	jsr %pc@(0x53dc)
    636e:	4fef 0014      	lea %sp@(20),%sp
    6372:	2d48 000c      	movel %a0,%fp@(12)
    6376:	202e 0008      	movel %fp@(8),%d0
    637a:	2040           	moveal %d0,%a0
    637c:	1010           	moveb %a0@,%d0
    637e:	4a00           	tstb %d0
    6380:	6606           	bnes 0x6388
    6382:	202e fff8      	movel %fp@(-8),%d0
    6386:	6018           	bras 0x63a0
    6388:	4aae 000c      	tstl %fp@(12)
    638c:	670e           	beqs 0x639c
    638e:	202e 000c      	movel %fp@(12),%d0
    6392:	2040           	moveal %d0,%a0
    6394:	1010           	moveb %a0@,%d0
    6396:	4a00           	tstb %d0
    6398:	6600 ff68      	bnew 0x6302
    639c:	202e fff8      	movel %fp@(-8),%d0
    63a0:	4e5e           	unlk %fp
    63a2:	4e75           	rts
    63a4:	4e56 0000      	linkw %fp,#0
    63a8:	700c           	moveq #12,%d0
    63aa:	d08e           	addl %fp,%d0
    63ac:	5880           	addql #4,%d0
    63ae:	222e 000c      	movel %fp@(12),%d1
    63b2:	2f00           	movel %d0,%sp@-
    63b4:	2f01           	movel %d1,%sp@-
    63b6:	2f2e 0008      	movel %fp@(8),%sp@-
    63ba:	4eba fe88      	jsr %pc@(0x6244)
    63be:	4fef 000c      	lea %sp@(12),%sp
    63c2:	4e5e           	unlk %fp
    63c4:	4e75           	rts
    63c6:	4e71           	nop
    63c8:	41ef 0004      	lea %sp@(4),%a0
    63cc:	2f0a           	movel %a2,%sp@-
    63ce:	2268 0004      	moveal %a0@(4),%a1
    63d2:	2450           	moveal %a0@,%a2
    63d4:	4280           	clrl %d0
    63d6:	4a12           	tstb %a2@
    63d8:	6710           	beqs 0x63ea
    63da:	121a           	moveb %a2@+,%d1
    63dc:	2049           	moveal %a1,%a0
    63de:	4a10           	tstb %a0@
    63e0:	67f4           	beqs 0x63d6
    63e2:	b218           	cmpb %a0@+,%d1
    63e4:	66f8           	bnes 0x63de
    63e6:	200a           	movel %a2,%d0
    63e8:	5340           	subqw #1,%d0
    63ea:	245f           	moveal %sp@+,%a2
    63ec:	2040           	moveal %d0,%a0
    63ee:	4e75           	rts
    63f0:	226f 0008      	moveal %sp@(8),%a1
    63f4:	206f 0004      	moveal %sp@(4),%a0
    63f8:	2008           	movel %a0,%d0
    63fa:	4a18           	tstb %a0@+
    63fc:	6600 fffc      	bnew 0x63fa
    6400:	5348           	subqw #1,%a0
    6402:	10d9           	moveb %a1@+,%a0@+
    6404:	6600 fffc      	bnew 0x6402
    6408:	3040           	moveaw %d0,%a0
    640a:	4e75           	rts
    640c:	202f 0008      	movel %sp@(8),%d0
    6410:	206f 0004      	moveal %sp@(4),%a0
    6414:	4a10           	tstb %a0@
    6416:	670a           	beqs 0x6422
    6418:	b018           	cmpb %a0@+,%d0
    641a:	6600 fff8      	bnew 0x6414
    641e:	5388           	subql #1,%a0
    6420:	4e75           	rts
    6422:	207c 0000 0000 	moveal #0,%a0
    6428:	4e75           	rts
    642a:	4e71           	nop
    642c:	226f 0008      	moveal %sp@(8),%a1
    6430:	206f 0004      	moveal %sp@(4),%a0
    6434:	1219           	moveb %a1@+,%d1
    6436:	6714           	beqs 0x644c
    6438:	4a10           	tstb %a0@
    643a:	671c           	beqs 0x6458
    643c:	b218           	cmpb %a0@+,%d1
    643e:	67f4           	beqs 0x6434
    6440:	6416           	bccs 0x6458
    6442:	650e           	bcss 0x6452
    6444:	6000 ffee      	braw 0x6434
    6448:	4280           	clrl %d0
    644a:	4e75           	rts
    644c:	4a10           	tstb %a0@
    644e:	6700 fff8      	beqw 0x6448
    6452:	4280           	clrl %d0
    6454:	5240           	addqw #1,%d0
    6456:	4e75           	rts
    6458:	4280           	clrl %d0
    645a:	5340           	subqw #1,%d0
    645c:	4e75           	rts
    645e:	4e71           	nop
    6460:	226f 0008      	moveal %sp@(8),%a1
    6464:	206f 0004      	moveal %sp@(4),%a0
    6468:	2008           	movel %a0,%d0
    646a:	10d9           	moveb %a1@+,%a0@+
    646c:	66fc           	bnes 0x646a
    646e:	2040           	moveal %d0,%a0
    6470:	4e75           	rts
    6472:	4e71           	nop
    6474:	41ef 0004      	lea %sp@(4),%a0
    6478:	2f0a           	movel %a2,%sp@-
    647a:	2268 0004      	moveal %a0@(4),%a1
    647e:	2450           	moveal %a0@,%a2
    6480:	4280           	clrl %d0
    6482:	5240           	addqw #1,%d0
    6484:	4a12           	tstb %a2@
    6486:	670e           	beqs 0x6496
    6488:	121a           	moveb %a2@+,%d1
    648a:	2049           	moveal %a1,%a0
    648c:	4a10           	tstb %a0@
    648e:	6706           	beqs 0x6496
    6490:	b218           	cmpb %a0@+,%d1
    6492:	66f8           	bnes 0x648c
    6494:	60ec           	bras 0x6482
    6496:	5340           	subqw #1,%d0
    6498:	245f           	moveal %sp@+,%a2
    649a:	4e75           	rts
    649c:	4e56 fffc      	linkw %fp,#-4
    64a0:	2f2e 0008      	movel %fp@(8),%sp@-
    64a4:	4eb9 0000 0000 	jsr 0x0
    64aa:	588f           	addql #4,%sp
    64ac:	5280           	addql #1,%d0
    64ae:	2f00           	movel %d0,%sp@-
    64b0:	4eb9 0000 0000 	jsr 0x0
    64b6:	588f           	addql #4,%sp
    64b8:	2008           	movel %a0,%d0
    64ba:	2d40 fffc      	movel %d0,%fp@(-4)
    64be:	2f2e 0008      	movel %fp@(8),%sp@-
    64c2:	2f2e fffc      	movel %fp@(-4),%sp@-
    64c6:	4eb9 0000 0000 	jsr 0x0
    64cc:	508f           	addql #8,%sp
    64ce:	202e fffc      	movel %fp@(-4),%d0
    64d2:	2200           	movel %d0,%d1
    64d4:	2041           	moveal %d1,%a0
    64d6:	4e5e           	unlk %fp
    64d8:	4e75           	rts
    64da:	4e71           	nop
    64dc:	4e56 0000      	linkw %fp,#0
    64e0:	203c 0000 0000 	movel #0,%d0
    64e6:	2200           	movel %d0,%d1
    64e8:	2041           	moveal %d1,%a0
    64ea:	4e5e           	unlk %fp
    64ec:	4e75           	rts
    64ee:	4e71           	nop
    64f0:	4e56 fffc      	linkw %fp,#-4
    64f4:	202e 0014      	movel %fp@(20),%d0
    64f8:	2040           	moveal %d0,%a0
    64fa:	2010           	movel %a0@,%d0
    64fc:	b0ae 0010      	cmpl %fp@(16),%d0
    6500:	6f04           	bles 0x6506
    6502:	7001           	moveq #1,%d0
    6504:	607a           	bras 0x6580
    6506:	2f2e 000c      	movel %fp@(12),%sp@-
    650a:	4eb9 0000 0000 	jsr 0x0
    6510:	588f           	addql #4,%sp
    6512:	2d40 fffc      	movel %d0,%fp@(-4)
    6516:	202e 0014      	movel %fp@(20),%d0
    651a:	2040           	moveal %d0,%a0
    651c:	2010           	movel %a0@,%d0
    651e:	d1ae 0008      	addl %d0,%fp@(8)
    6522:	6030           	bras 0x6554
    6524:	202e 000c      	movel %fp@(12),%d0
    6528:	2040           	moveal %d0,%a0
    652a:	1210           	moveb %a0@,%d1
    652c:	202e 0008      	movel %fp@(8),%d0
    6530:	2040           	moveal %d0,%a0
    6532:	1081           	moveb %d1,%a0@
    6534:	52ae 0008      	addql #1,%fp@(8)
    6538:	52ae 000c      	addql #1,%fp@(12)
    653c:	202e 0014      	movel %fp@(20),%d0
    6540:	2040           	moveal %d0,%a0
    6542:	2010           	movel %a0@,%d0
    6544:	2200           	movel %d0,%d1
    6546:	5281           	addql #1,%d1
    6548:	202e 0014      	movel %fp@(20),%d0
    654c:	2040           	moveal %d0,%a0
    654e:	2081           	movel %d1,%a0@
    6550:	53ae fffc      	subql #1,%fp@(-4)
    6554:	202e 0014      	movel %fp@(20),%d0
    6558:	2040           	moveal %d0,%a0
    655a:	2210           	movel %a0@,%d1
    655c:	202e 0010      	movel %fp@(16),%d0
    6560:	5380           	subql #1,%d0
    6562:	b081           	cmpl %d1,%d0
    6564:	6f06           	bles 0x656c
    6566:	4aae fffc      	tstl %fp@(-4)
    656a:	66b8           	bnes 0x6524
    656c:	202e 0008      	movel %fp@(8),%d0
    6570:	2040           	moveal %d0,%a0
    6572:	4210           	clrb %a0@
    6574:	4aae fffc      	tstl %fp@(-4)
    6578:	6704           	beqs 0x657e
    657a:	7001           	moveq #1,%d0
    657c:	6002           	bras 0x6580
    657e:	4280           	clrl %d0
    6580:	4e5e           	unlk %fp
    6582:	4e75           	rts
    6584:	4e56 fffc      	linkw %fp,#-4
    6588:	202e 000c      	movel %fp@(12),%d0
    658c:	1d40 fffe      	moveb %d0,%fp@(-2)
    6590:	202e 0014      	movel %fp@(20),%d0
    6594:	2040           	moveal %d0,%a0
    6596:	2010           	movel %a0@,%d0
    6598:	b0ae 0010      	cmpl %fp@(16),%d0
    659c:	6f04           	bles 0x65a2
    659e:	7001           	moveq #1,%d0
    65a0:	6038           	bras 0x65da
    65a2:	202e 0014      	movel %fp@(20),%d0
    65a6:	2040           	moveal %d0,%a0
    65a8:	2010           	movel %a0@,%d0
    65aa:	d1ae 0008      	addl %d0,%fp@(8)
    65ae:	202e 0008      	movel %fp@(8),%d0
    65b2:	2040           	moveal %d0,%a0
    65b4:	10ae fffe      	moveb %fp@(-2),%a0@
    65b8:	52ae 0008      	addql #1,%fp@(8)
    65bc:	202e 0014      	movel %fp@(20),%d0
    65c0:	2040           	moveal %d0,%a0
    65c2:	2010           	movel %a0@,%d0
    65c4:	2200           	movel %d0,%d1
    65c6:	5281           	addql #1,%d1
    65c8:	202e 0014      	movel %fp@(20),%d0
    65cc:	2040           	moveal %d0,%a0
    65ce:	2081           	movel %d1,%a0@
    65d0:	202e 0008      	movel %fp@(8),%d0
    65d4:	2040           	moveal %d0,%a0
    65d6:	4210           	clrb %a0@
    65d8:	4280           	clrl %d0
    65da:	4e5e           	unlk %fp
    65dc:	4e75           	rts
    65de:	4e56 ffec      	linkw %fp,#-20
    65e2:	2f02           	movel %d2,%sp@-
    65e4:	70ed           	moveq #-19,%d0
    65e6:	d08e           	addl %fp,%d0
    65e8:	7209           	moveq #9,%d1
    65ea:	d280           	addl %d0,%d1
    65ec:	2d41 fffc      	movel %d1,%fp@(-4)
    65f0:	42ae fff8      	clrl %fp@(-8)
    65f4:	6012           	bras 0x6608
    65f6:	70ed           	moveq #-19,%d0
    65f8:	d08e           	addl %fp,%d0
    65fa:	d0ae fff8      	addl %fp@(-8),%d0
    65fe:	2040           	moveal %d0,%a0
    6600:	10bc 0030      	moveb #48,%a0@
    6604:	52ae fff8      	addql #1,%fp@(-8)
    6608:	7009           	moveq #9,%d0
    660a:	b0ae fff8      	cmpl %fp@(-8),%d0
    660e:	6ce6           	bges 0x65f6
    6610:	422e fff7      	clrb %fp@(-9)
    6614:	605c           	bras 0x6672
    6616:	222e 000c      	movel %fp@(12),%d1
    661a:	2401           	movel %d1,%d2
    661c:	4c3c 2c00 6666 	mulsl #1717986919,%d0,%d2
    6622:	6667 
    6624:	e480           	asrl #2,%d0
    6626:	2401           	movel %d1,%d2
    6628:	d482           	addl %d2,%d2
    662a:	9582           	subxl %d2,%d2
    662c:	2042           	moveal %d2,%a0
    662e:	9088           	subl %a0,%d0
    6630:	d080           	addl %d0,%d0
    6632:	2400           	movel %d0,%d2
    6634:	e58a           	lsll #2,%d2
    6636:	2042           	moveal %d2,%a0
    6638:	d088           	addl %a0,%d0
    663a:	2401           	movel %d1,%d2
    663c:	9480           	subl %d0,%d2
    663e:	2002           	movel %d2,%d0
    6640:	1000           	moveb %d0,%d0
    6642:	0600 0030      	addib #48,%d0
    6646:	1200           	moveb %d0,%d1
    6648:	202e fffc      	movel %fp@(-4),%d0
    664c:	2040           	moveal %d0,%a0
    664e:	1081           	moveb %d1,%a0@
    6650:	53ae fffc      	subql #1,%fp@(-4)
    6654:	202e 000c      	movel %fp@(12),%d0
    6658:	2400           	movel %d0,%d2
    665a:	4c3c 2c01 6666 	mulsl #1717986919,%d1,%d2
    6660:	6667 
    6662:	e481           	asrl #2,%d1
    6664:	d080           	addl %d0,%d0
    6666:	9180           	subxl %d0,%d0
    6668:	2401           	movel %d1,%d2
    666a:	9480           	subl %d0,%d2
    666c:	2002           	movel %d2,%d0
    666e:	2d40 000c      	movel %d0,%fp@(12)
    6672:	4aae 000c      	tstl %fp@(12)
    6676:	669e           	bnes 0x6616
    6678:	202e 0010      	movel %fp@(16),%d0
    667c:	720a           	moveq #10,%d1
    667e:	9280           	subl %d0,%d1
    6680:	2001           	movel %d1,%d0
    6682:	72ed           	moveq #-19,%d1
    6684:	d28e           	addl %fp,%d1
    6686:	d081           	addl %d1,%d0
    6688:	2f2e 0018      	movel %fp@(24),%sp@-
    668c:	2f2e 0014      	movel %fp@(20),%sp@-
    6690:	2f00           	movel %d0,%sp@-
    6692:	2f2e 0008      	movel %fp@(8),%sp@-
    6696:	4eba fe58      	jsr %pc@(0x64f0)
    669a:	4fef 0010      	lea %sp@(16),%sp
    669e:	242e ffe8      	movel %fp@(-24),%d2
    66a2:	4e5e           	unlk %fp
    66a4:	4e75           	rts
    66a6:	4e56 fff8      	linkw %fp,#-8
    66aa:	2f02           	movel %d2,%sp@-
    66ac:	42ae fff8      	clrl %fp@(-8)
    66b0:	42ae fffc      	clrl %fp@(-4)
    66b4:	6000 0908      	braw 0x6fbe
    66b8:	202e fffc      	movel %fp@(-4),%d0
    66bc:	d0ae 0010      	addl %fp@(16),%d0
    66c0:	2040           	moveal %d0,%a0
    66c2:	1010           	moveb %a0@,%d0
    66c4:	0c00 0025      	cmpib #37,%d0
    66c8:	6600 086a      	bnew 0x6f34
    66cc:	52ae fffc      	addql #1,%fp@(-4)
    66d0:	202e fffc      	movel %fp@(-4),%d0
    66d4:	d0ae 0010      	addl %fp@(16),%d0
    66d8:	2240           	moveal %d0,%a1
    66da:	1011           	moveb %a1@,%d0
    66dc:	49c0           	extbl %d0
    66de:	72bf           	moveq #-65,%d1
    66e0:	d081           	addl %d1,%d0
    66e2:	7439           	moveq #57,%d2
    66e4:	b480           	cmpl %d0,%d2
    66e6:	6500 0818      	bcsw 0x6f00
    66ea:	303b 0a06      	movew %pc@(0x66f2,%d0:l:2),%d0
    66ee:	4efb 0002      	jmp %pc@(0x66f2,%d0:w)
    66f2:	00ac 011c 080e 	oril #18614286,%a4@(2062)
    66f8:	080e 
    66fa:	080e           	.short 0x080e
    66fc:	080e           	.short 0x080e
    66fe:	080e           	.short 0x080e
    6700:	0328 080e      	btst %d1,%a0@(2062)
    6704:	080e           	.short 0x080e
    6706:	080e           	.short 0x080e
    6708:	080e           	.short 0x080e
    670a:	0422 080e      	subib #14,%a2@-
    670e:	080e           	.short 0x080e
    6710:	0456 080e      	subiw #2062,%fp@
    6714:	080e           	.short 0x080e
    6716:	04a4 080e 04d6 	subil #135136470,%a4@-
    671c:	080e           	.short 0x080e
    671e:	056c 0662      	bchg %d2,%a4@(1634)
    6722:	07aa 080e      	bclr %d3,%a2@(2062)
    6726:	080e           	.short 0x080e
    6728:	080e           	.short 0x080e
    672a:	080e           	.short 0x080e
    672c:	080e           	.short 0x080e
    672e:	080e           	.short 0x080e
    6730:	080e           	.short 0x080e
    6732:	0074 00e4 0154 	oriw #228,%a4@(00000000)@(00000000)
    6738:	02f4           	.short 0x02f4
    673a:	080e           	.short 0x080e
    673c:	080e           	.short 0x080e
    673e:	080e           	.short 0x080e
    6740:	080e           	.short 0x080e
    6742:	035c           	bchg %d1,%a4@+
    6744:	03ba           	.short 0x03ba
    6746:	080e           	.short 0x080e
    6748:	080e           	.short 0x080e
    674a:	03ee 080e      	bset %d1,%fp@(2062)
    674e:	080e           	.short 0x080e
    6750:	080e           	.short 0x080e
    6752:	080e           	.short 0x080e
    6754:	080e           	.short 0x080e
    6756:	080e           	.short 0x080e
    6758:	080e           	.short 0x080e
    675a:	080e           	.short 0x080e
    675c:	080e           	.short 0x080e
    675e:	0538 05ce      	btst %d2,0x5ce
    6762:	0748 07e4      	movepl %a0@(2020),%d3
    6766:	206e 000c      	moveal %fp@(12),%a0
    676a:	202e 0014      	movel %fp@(20),%d0
    676e:	2240           	moveal %d0,%a1
    6770:	2029 0018      	movel %a1@(24),%d0
    6774:	2230 0db0 0000 	movel @(00000000,%d0:l:4),%d1
    677a:	0000 
    677c:	200e           	movel %fp,%d0
    677e:	5180           	subql #8,%d0
    6780:	2f00           	movel %d0,%sp@-
    6782:	2f08           	movel %a0,%sp@-
    6784:	2f01           	movel %d1,%sp@-
    6786:	2f2e 0008      	movel %fp@(8),%sp@-
    678a:	4eba fd64      	jsr %pc@(0x64f0)
    678e:	4fef 0010      	lea %sp@(16),%sp
    6792:	4a80           	tstl %d0
    6794:	6700 07ce      	beqw 0x6f64
    6798:	4280           	clrl %d0
    679a:	6000 083c      	braw 0x6fd8
    679e:	206e 000c      	moveal %fp@(12),%a0
    67a2:	202e 0014      	movel %fp@(20),%d0
    67a6:	2240           	moveal %d0,%a1
    67a8:	2029 0018      	movel %a1@(24),%d0
    67ac:	2230 0db0 0000 	movel @(00000000,%d0:l:4),%d1
    67b2:	0000 
    67b4:	200e           	movel %fp,%d0
    67b6:	5180           	subql #8,%d0
    67b8:	2f00           	movel %d0,%sp@-
    67ba:	2f08           	movel %a0,%sp@-
    67bc:	2f01           	movel %d1,%sp@-
    67be:	2f2e 0008      	movel %fp@(8),%sp@-
    67c2:	4eba fd2c      	jsr %pc@(0x64f0)
    67c6:	4fef 0010      	lea %sp@(16),%sp
    67ca:	4a80           	tstl %d0
    67cc:	6700 079a      	beqw 0x6f68
    67d0:	4280           	clrl %d0
    67d2:	6000 0804      	braw 0x6fd8
    67d6:	206e 000c      	moveal %fp@(12),%a0
    67da:	202e 0014      	movel %fp@(20),%d0
    67de:	2240           	moveal %d0,%a1
    67e0:	2029 0010      	movel %a1@(16),%d0
    67e4:	2230 0db0 0000 	movel @(00000000,%d0:l:4),%d1
    67ea:	0000 
    67ec:	200e           	movel %fp,%d0
    67ee:	5180           	subql #8,%d0
    67f0:	2f00           	movel %d0,%sp@-
    67f2:	2f08           	movel %a0,%sp@-
    67f4:	2f01           	movel %d1,%sp@-
    67f6:	2f2e 0008      	movel %fp@(8),%sp@-
    67fa:	4eba fcf4      	jsr %pc@(0x64f0)
    67fe:	4fef 0010      	lea %sp@(16),%sp
    6802:	4a80           	tstl %d0
    6804:	6700 0766      	beqw 0x6f6c
    6808:	4280           	clrl %d0
    680a:	6000 07cc      	braw 0x6fd8
    680e:	206e 000c      	moveal %fp@(12),%a0
    6812:	202e 0014      	movel %fp@(20),%d0
    6816:	2240           	moveal %d0,%a1
    6818:	2029 0010      	movel %a1@(16),%d0
    681c:	2230 0db0 0000 	movel @(00000000,%d0:l:4),%d1
    6822:	0000 
    6824:	200e           	movel %fp,%d0
    6826:	5180           	subql #8,%d0
    6828:	2f00           	movel %d0,%sp@-
    682a:	2f08           	movel %a0,%sp@-
    682c:	2f01           	movel %d1,%sp@-
    682e:	2f2e 0008      	movel %fp@(8),%sp@-
    6832:	4eba fcbc      	jsr %pc@(0x64f0)
    6836:	4fef 0010      	lea %sp@(16),%sp
    683a:	4a80           	tstl %d0
    683c:	6700 0732      	beqw 0x6f70
    6840:	4280           	clrl %d0
    6842:	6000 0794      	braw 0x6fd8
    6846:	206e 000c      	moveal %fp@(12),%a0
    684a:	202e 0014      	movel %fp@(20),%d0
    684e:	2240           	moveal %d0,%a1
    6850:	2229 000c      	movel %a1@(12),%d1
    6854:	200e           	movel %fp,%d0
    6856:	5180           	subql #8,%d0
    6858:	2f00           	movel %d0,%sp@-
    685a:	2f08           	movel %a0,%sp@-
    685c:	4878 0002      	pea 0x2
    6860:	2f01           	movel %d1,%sp@-
    6862:	2f2e 0008      	movel %fp@(8),%sp@-
    6866:	4eba fd76      	jsr %pc@(0x65de)
    686a:	4fef 0014      	lea %sp@(20),%sp
    686e:	4a80           	tstl %d0
    6870:	6706           	beqs 0x6878
    6872:	4280           	clrl %d0
    6874:	6000 0762      	braw 0x6fd8
    6878:	222e 000c      	movel %fp@(12),%d1
    687c:	200e           	movel %fp,%d0
    687e:	5180           	subql #8,%d0
    6880:	2f00           	movel %d0,%sp@-
    6882:	2f01           	movel %d1,%sp@-
    6884:	4879 0000 0000 	pea 0x0
    688a:	2f2e 0008      	movel %fp@(8),%sp@-
    688e:	4eba fc60      	jsr %pc@(0x64f0)
    6892:	4fef 0010      	lea %sp@(16),%sp
    6896:	4a80           	tstl %d0
    6898:	6706           	beqs 0x68a0
    689a:	4280           	clrl %d0
    689c:	6000 073a      	braw 0x6fd8
    68a0:	206e 000c      	moveal %fp@(12),%a0
    68a4:	202e 0014      	movel %fp@(20),%d0
    68a8:	2240           	moveal %d0,%a1
    68aa:	2229 0008      	movel %a1@(8),%d1
    68ae:	200e           	movel %fp,%d0
    68b0:	5180           	subql #8,%d0
    68b2:	2f00           	movel %d0,%sp@-
    68b4:	2f08           	movel %a0,%sp@-
    68b6:	4878 0002      	pea 0x2
    68ba:	2f01           	movel %d1,%sp@-
    68bc:	2f2e 0008      	movel %fp@(8),%sp@-
    68c0:	4eba fd1c      	jsr %pc@(0x65de)
    68c4:	4fef 0014      	lea %sp@(20),%sp
    68c8:	4a80           	tstl %d0
    68ca:	6706           	beqs 0x68d2
    68cc:	4280           	clrl %d0
    68ce:	6000 0708      	braw 0x6fd8
    68d2:	222e 000c      	movel %fp@(12),%d1
    68d6:	200e           	movel %fp,%d0
    68d8:	5180           	subql #8,%d0
    68da:	2f00           	movel %d0,%sp@-
    68dc:	2f01           	movel %d1,%sp@-
    68de:	4879 0000 0000 	pea 0x0
    68e4:	2f2e 0008      	movel %fp@(8),%sp@-
    68e8:	4eba fc06      	jsr %pc@(0x64f0)
    68ec:	4fef 0010      	lea %sp@(16),%sp
    68f0:	4a80           	tstl %d0
    68f2:	6706           	beqs 0x68fa
    68f4:	4280           	clrl %d0
    68f6:	6000 06e0      	braw 0x6fd8
    68fa:	206e 000c      	moveal %fp@(12),%a0
    68fe:	202e 0014      	movel %fp@(20),%d0
    6902:	2240           	moveal %d0,%a1
    6904:	2229 0004      	movel %a1@(4),%d1
    6908:	200e           	movel %fp,%d0
    690a:	5180           	subql #8,%d0
    690c:	2f00           	movel %d0,%sp@-
    690e:	2f08           	movel %a0,%sp@-
    6910:	4878 0002      	pea 0x2
    6914:	2f01           	movel %d1,%sp@-
    6916:	2f2e 0008      	movel %fp@(8),%sp@-
    691a:	4eba fcc2      	jsr %pc@(0x65de)
    691e:	4fef 0014      	lea %sp@(20),%sp
    6922:	4a80           	tstl %d0
    6924:	6706           	beqs 0x692c
    6926:	4280           	clrl %d0
    6928:	6000 06ae      	braw 0x6fd8
    692c:	222e 000c      	movel %fp@(12),%d1
    6930:	200e           	movel %fp,%d0
    6932:	5180           	subql #8,%d0
    6934:	2f00           	movel %d0,%sp@-
    6936:	2f01           	movel %d1,%sp@-
    6938:	4879 0000 0000 	pea 0x0
    693e:	2f2e 0008      	movel %fp@(8),%sp@-
    6942:	4eba fbac      	jsr %pc@(0x64f0)
    6946:	4fef 0010      	lea %sp@(16),%sp
    694a:	4a80           	tstl %d0
    694c:	6706           	beqs 0x6954
    694e:	4280           	clrl %d0
    6950:	6000 0686      	braw 0x6fd8
    6954:	206e 000c      	moveal %fp@(12),%a0
    6958:	202e 0014      	movel %fp@(20),%d0
    695c:	2240           	moveal %d0,%a1
    695e:	2211           	movel %a1@,%d1
    6960:	200e           	movel %fp,%d0
    6962:	5180           	subql #8,%d0
    6964:	2f00           	movel %d0,%sp@-
    6966:	2f08           	movel %a0,%sp@-
    6968:	4878 0002      	pea 0x2
    696c:	2f01           	movel %d1,%sp@-
    696e:	2f2e 0008      	movel %fp@(8),%sp@-
    6972:	4eba fc6a      	jsr %pc@(0x65de)
    6976:	4fef 0014      	lea %sp@(20),%sp
    697a:	4a80           	tstl %d0
    697c:	6706           	beqs 0x6984
    697e:	4280           	clrl %d0
    6980:	6000 0656      	braw 0x6fd8
    6984:	222e 000c      	movel %fp@(12),%d1
    6988:	200e           	movel %fp,%d0
    698a:	5180           	subql #8,%d0
    698c:	2f00           	movel %d0,%sp@-
    698e:	2f01           	movel %d1,%sp@-
    6990:	4879 0000 0000 	pea 0x0
    6996:	2f2e 0008      	movel %fp@(8),%sp@-
    699a:	4eba fb54      	jsr %pc@(0x64f0)
    699e:	4fef 0010      	lea %sp@(16),%sp
    69a2:	4a80           	tstl %d0
    69a4:	6706           	beqs 0x69ac
    69a6:	4280           	clrl %d0
    69a8:	6000 062e      	braw 0x6fd8
    69ac:	206e 000c      	moveal %fp@(12),%a0
    69b0:	202e 0014      	movel %fp@(20),%d0
    69b4:	2240           	moveal %d0,%a1
    69b6:	2029 0014      	movel %a1@(20),%d0
    69ba:	0680 0000 076c 	addil #1900,%d0
    69c0:	220e           	movel %fp,%d1
    69c2:	5181           	subql #8,%d1
    69c4:	2f01           	movel %d1,%sp@-
    69c6:	2f08           	movel %a0,%sp@-
    69c8:	4878 0004      	pea 0x4
    69cc:	2f00           	movel %d0,%sp@-
    69ce:	2f2e 0008      	movel %fp@(8),%sp@-
    69d2:	4eba fc0a      	jsr %pc@(0x65de)
    69d6:	4fef 0014      	lea %sp@(20),%sp
    69da:	4a80           	tstl %d0
    69dc:	6700 0596      	beqw 0x6f74
    69e0:	4280           	clrl %d0
    69e2:	6000 05f4      	braw 0x6fd8
    69e6:	206e 000c      	moveal %fp@(12),%a0
    69ea:	202e 0014      	movel %fp@(20),%d0
    69ee:	2240           	moveal %d0,%a1
    69f0:	2229 000c      	movel %a1@(12),%d1
    69f4:	200e           	movel %fp,%d0
    69f6:	5180           	subql #8,%d0
    69f8:	2f00           	movel %d0,%sp@-
    69fa:	2f08           	movel %a0,%sp@-
    69fc:	4878 0002      	pea 0x2
    6a00:	2f01           	movel %d1,%sp@-
    6a02:	2f2e 0008      	movel %fp@(8),%sp@-
    6a06:	4eba fbd6      	jsr %pc@(0x65de)
    6a0a:	4fef 0014      	lea %sp@(20),%sp
    6a0e:	4a80           	tstl %d0
    6a10:	6700 0566      	beqw 0x6f78
    6a14:	4280           	clrl %d0
    6a16:	6000 05c0      	braw 0x6fd8
    6a1a:	206e 000c      	moveal %fp@(12),%a0
    6a1e:	202e 0014      	movel %fp@(20),%d0
    6a22:	2240           	moveal %d0,%a1
    6a24:	2229 0008      	movel %a1@(8),%d1
    6a28:	200e           	movel %fp,%d0
    6a2a:	5180           	subql #8,%d0
    6a2c:	2f00           	movel %d0,%sp@-
    6a2e:	2f08           	movel %a0,%sp@-
    6a30:	4878 0002      	pea 0x2
    6a34:	2f01           	movel %d1,%sp@-
    6a36:	2f2e 0008      	movel %fp@(8),%sp@-
    6a3a:	4eba fba2      	jsr %pc@(0x65de)
    6a3e:	4fef 0014      	lea %sp@(20),%sp
    6a42:	4a80           	tstl %d0
    6a44:	6700 0536      	beqw 0x6f7c
    6a48:	4280           	clrl %d0
    6a4a:	6000 058c      	braw 0x6fd8
    6a4e:	226e 000c      	moveal %fp@(12),%a1
    6a52:	202e 0014      	movel %fp@(20),%d0
    6a56:	2040           	moveal %d0,%a0
    6a58:	2228 0008      	movel %a0@(8),%d1
    6a5c:	2401           	movel %d1,%d2
    6a5e:	4c3c 2c00 2aaa 	mulsl #715827883,%d0,%d2
    6a64:	aaab 
    6a66:	e280           	asrl #1,%d0
    6a68:	2401           	movel %d1,%d2
    6a6a:	d482           	addl %d2,%d2
    6a6c:	9582           	subxl %d2,%d2
    6a6e:	2042           	moveal %d2,%a0
    6a70:	9088           	subl %a0,%d0
    6a72:	2400           	movel %d0,%d2
    6a74:	e58a           	lsll #2,%d2
    6a76:	2042           	moveal %d2,%a0
    6a78:	2008           	movel %a0,%d0
    6a7a:	e588           	lsll #2,%d0
    6a7c:	9088           	subl %a0,%d0
    6a7e:	2401           	movel %d1,%d2
    6a80:	9480           	subl %d0,%d2
    6a82:	2002           	movel %d2,%d0
    6a84:	5280           	addql #1,%d0
    6a86:	220e           	movel %fp,%d1
    6a88:	5181           	subql #8,%d1
    6a8a:	2f01           	movel %d1,%sp@-
    6a8c:	2f09           	movel %a1,%sp@-
    6a8e:	4878 0002      	pea 0x2
    6a92:	2f00           	movel %d0,%sp@-
    6a94:	2f2e 0008      	movel %fp@(8),%sp@-
    6a98:	4eba fb44      	jsr %pc@(0x65de)
    6a9c:	4fef 0014      	lea %sp@(20),%sp
    6aa0:	4a80           	tstl %d0
    6aa2:	6700 04dc      	beqw 0x6f80
    6aa6:	4280           	clrl %d0
    6aa8:	6000 052e      	braw 0x6fd8
    6aac:	206e 000c      	moveal %fp@(12),%a0
    6ab0:	202e 0014      	movel %fp@(20),%d0
    6ab4:	2240           	moveal %d0,%a1
    6ab6:	2229 001c      	movel %a1@(28),%d1
    6aba:	200e           	movel %fp,%d0
    6abc:	5180           	subql #8,%d0
    6abe:	2f00           	movel %d0,%sp@-
    6ac0:	2f08           	movel %a0,%sp@-
    6ac2:	4878 0003      	pea 0x3
    6ac6:	2f01           	movel %d1,%sp@-
    6ac8:	2f2e 0008      	movel %fp@(8),%sp@-
    6acc:	4eba fb10      	jsr %pc@(0x65de)
    6ad0:	4fef 0014      	lea %sp@(20),%sp
    6ad4:	4a80           	tstl %d0
    6ad6:	6700 04ac      	beqw 0x6f84
    6ada:	4280           	clrl %d0
    6adc:	6000 04fa      	braw 0x6fd8
    6ae0:	206e 000c      	moveal %fp@(12),%a0
    6ae4:	202e 0014      	movel %fp@(20),%d0
    6ae8:	2240           	moveal %d0,%a1
    6aea:	2229 0010      	movel %a1@(16),%d1
    6aee:	200e           	movel %fp,%d0
    6af0:	5180           	subql #8,%d0
    6af2:	2f00           	movel %d0,%sp@-
    6af4:	2f08           	movel %a0,%sp@-
    6af6:	4878 0002      	pea 0x2
    6afa:	2f01           	movel %d1,%sp@-
    6afc:	2f2e 0008      	movel %fp@(8),%sp@-
    6b00:	4eba fadc      	jsr %pc@(0x65de)
    6b04:	4fef 0014      	lea %sp@(20),%sp
    6b08:	4a80           	tstl %d0
    6b0a:	6700 047c      	beqw 0x6f88
    6b0e:	4280           	clrl %d0
    6b10:	6000 04c6      	braw 0x6fd8
    6b14:	206e 000c      	moveal %fp@(12),%a0
    6b18:	202e 0014      	movel %fp@(20),%d0
    6b1c:	2240           	moveal %d0,%a1
    6b1e:	2229 0004      	movel %a1@(4),%d1
    6b22:	200e           	movel %fp,%d0
    6b24:	5180           	subql #8,%d0
    6b26:	2f00           	movel %d0,%sp@-
    6b28:	2f08           	movel %a0,%sp@-
    6b2a:	4878 0002      	pea 0x2
    6b2e:	2f01           	movel %d1,%sp@-
    6b30:	2f2e 0008      	movel %fp@(8),%sp@-
    6b34:	4eba faa8      	jsr %pc@(0x65de)
    6b38:	4fef 0014      	lea %sp@(20),%sp
    6b3c:	4a80           	tstl %d0
    6b3e:	6700 044c      	beqw 0x6f8c
    6b42:	4280           	clrl %d0
    6b44:	6000 0492      	braw 0x6fd8
    6b48:	206e 000c      	moveal %fp@(12),%a0
    6b4c:	202e 0014      	movel %fp@(20),%d0
    6b50:	2240           	moveal %d0,%a1
    6b52:	2029 0008      	movel %a1@(8),%d0
    6b56:	2400           	movel %d0,%d2
    6b58:	4c3c 2c01 2aaa 	mulsl #715827883,%d1,%d2
    6b5e:	aaab 
    6b60:	e281           	asrl #1,%d1
    6b62:	d080           	addl %d0,%d0
    6b64:	9180           	subxl %d0,%d0
    6b66:	2401           	movel %d1,%d2
    6b68:	9480           	subl %d0,%d2
    6b6a:	2002           	movel %d2,%d0
    6b6c:	2230 0db0 0000 	movel @(00000000,%d0:l:4),%d1
    6b72:	0000 
    6b74:	200e           	movel %fp,%d0
    6b76:	5180           	subql #8,%d0
    6b78:	2f00           	movel %d0,%sp@-
    6b7a:	2f08           	movel %a0,%sp@-
    6b7c:	2f01           	movel %d1,%sp@-
    6b7e:	2f2e 0008      	movel %fp@(8),%sp@-
    6b82:	4eba f96c      	jsr %pc@(0x64f0)
    6b86:	4fef 0010      	lea %sp@(16),%sp
    6b8a:	4a80           	tstl %d0
    6b8c:	6700 0402      	beqw 0x6f90
    6b90:	4280           	clrl %d0
    6b92:	6000 0444      	braw 0x6fd8
    6b96:	206e 000c      	moveal %fp@(12),%a0
    6b9a:	202e 0014      	movel %fp@(20),%d0
    6b9e:	2240           	moveal %d0,%a1
    6ba0:	2211           	movel %a1@,%d1
    6ba2:	200e           	movel %fp,%d0
    6ba4:	5180           	subql #8,%d0
    6ba6:	2f00           	movel %d0,%sp@-
    6ba8:	2f08           	movel %a0,%sp@-
    6baa:	4878 0002      	pea 0x2
    6bae:	2f01           	movel %d1,%sp@-
    6bb0:	2f2e 0008      	movel %fp@(8),%sp@-
    6bb4:	4eba fa28      	jsr %pc@(0x65de)
    6bb8:	4fef 0014      	lea %sp@(20),%sp
    6bbc:	4a80           	tstl %d0
    6bbe:	6700 03d4      	beqw 0x6f94
    6bc2:	4280           	clrl %d0
    6bc4:	6000 0412      	braw 0x6fd8
    6bc8:	206e 000c      	moveal %fp@(12),%a0
    6bcc:	202e 0014      	movel %fp@(20),%d0
    6bd0:	2240           	moveal %d0,%a1
    6bd2:	2029 001c      	movel %a1@(28),%d0
    6bd6:	2200           	movel %d0,%d1
    6bd8:	5381           	subql #1,%d1
    6bda:	202e 0014      	movel %fp@(20),%d0
    6bde:	2240           	moveal %d0,%a1
    6be0:	2029 0018      	movel %a1@(24),%d0
    6be4:	7407           	moveq #7,%d2
    6be6:	9480           	subl %d0,%d2
    6be8:	2002           	movel %d2,%d0
    6bea:	d081           	addl %d1,%d0
    6bec:	2400           	movel %d0,%d2
    6bee:	4c3c 2c01 9249 	mulsl #-1840700269,%d1,%d2
    6bf4:	2493 
    6bf6:	d280           	addl %d0,%d1
    6bf8:	e481           	asrl #2,%d1
    6bfa:	d080           	addl %d0,%d0
    6bfc:	9180           	subxl %d0,%d0
    6bfe:	2401           	movel %d1,%d2
    6c00:	9480           	subl %d0,%d2
    6c02:	2002           	movel %d2,%d0
    6c04:	220e           	movel %fp,%d1
    6c06:	5181           	subql #8,%d1
    6c08:	2f01           	movel %d1,%sp@-
    6c0a:	2f08           	movel %a0,%sp@-
    6c0c:	4878 0002      	pea 0x2
    6c10:	2f00           	movel %d0,%sp@-
    6c12:	2f2e 0008      	movel %fp@(8),%sp@-
    6c16:	4eba f9c6      	jsr %pc@(0x65de)
    6c1a:	4fef 0014      	lea %sp@(20),%sp
    6c1e:	4a80           	tstl %d0
    6c20:	6700 0376      	beqw 0x6f98
    6c24:	4280           	clrl %d0
    6c26:	6000 03b0      	braw 0x6fd8
    6c2a:	206e 000c      	moveal %fp@(12),%a0
    6c2e:	202e 0014      	movel %fp@(20),%d0
    6c32:	2240           	moveal %d0,%a1
    6c34:	2229 0018      	movel %a1@(24),%d1
    6c38:	200e           	movel %fp,%d0
    6c3a:	5180           	subql #8,%d0
    6c3c:	2f00           	movel %d0,%sp@-
    6c3e:	2f08           	movel %a0,%sp@-
    6c40:	4878 0001      	pea 0x1
    6c44:	2f01           	movel %d1,%sp@-
    6c46:	2f2e 0008      	movel %fp@(8),%sp@-
    6c4a:	4eba f992      	jsr %pc@(0x65de)
    6c4e:	4fef 0014      	lea %sp@(20),%sp
    6c52:	4a80           	tstl %d0
    6c54:	6700 0346      	beqw 0x6f9c
    6c58:	4280           	clrl %d0
    6c5a:	6000 037c      	braw 0x6fd8
    6c5e:	206e 000c      	moveal %fp@(12),%a0
    6c62:	202e 0014      	movel %fp@(20),%d0
    6c66:	2240           	moveal %d0,%a1
    6c68:	2029 001c      	movel %a1@(28),%d0
    6c6c:	2200           	movel %d0,%d1
    6c6e:	5381           	subql #1,%d1
    6c70:	202e 0014      	movel %fp@(20),%d0
    6c74:	2240           	moveal %d0,%a1
    6c76:	2029 0018      	movel %a1@(24),%d0
    6c7a:	7407           	moveq #7,%d2
    6c7c:	9480           	subl %d0,%d2
    6c7e:	2002           	movel %d2,%d0
    6c80:	d081           	addl %d1,%d0
    6c82:	2400           	movel %d0,%d2
    6c84:	4c3c 2c01 9249 	mulsl #-1840700269,%d1,%d2
    6c8a:	2493 
    6c8c:	d280           	addl %d0,%d1
    6c8e:	e481           	asrl #2,%d1
    6c90:	d080           	addl %d0,%d0
    6c92:	9180           	subxl %d0,%d0
    6c94:	2401           	movel %d1,%d2
    6c96:	9480           	subl %d0,%d2
    6c98:	2002           	movel %d2,%d0
    6c9a:	220e           	movel %fp,%d1
    6c9c:	5181           	subql #8,%d1
    6c9e:	2f01           	movel %d1,%sp@-
    6ca0:	2f08           	movel %a0,%sp@-
    6ca2:	4878 0002      	pea 0x2
    6ca6:	2f00           	movel %d0,%sp@-
    6ca8:	2f2e 0008      	movel %fp@(8),%sp@-
    6cac:	4eba f930      	jsr %pc@(0x65de)
    6cb0:	4fef 0014      	lea %sp@(20),%sp
    6cb4:	4a80           	tstl %d0
    6cb6:	6700 02e8      	beqw 0x6fa0
    6cba:	4280           	clrl %d0
    6cbc:	6000 031a      	braw 0x6fd8
    6cc0:	206e 000c      	moveal %fp@(12),%a0
    6cc4:	202e 0014      	movel %fp@(20),%d0
    6cc8:	2240           	moveal %d0,%a1
    6cca:	2229 000c      	movel %a1@(12),%d1
    6cce:	200e           	movel %fp,%d0
    6cd0:	5180           	subql #8,%d0
    6cd2:	2f00           	movel %d0,%sp@-
    6cd4:	2f08           	movel %a0,%sp@-
    6cd6:	4878 0002      	pea 0x2
    6cda:	2f01           	movel %d1,%sp@-
    6cdc:	2f2e 0008      	movel %fp@(8),%sp@-
    6ce0:	4eba f8fc      	jsr %pc@(0x65de)
    6ce4:	4fef 0014      	lea %sp@(20),%sp
    6ce8:	4a80           	tstl %d0
    6cea:	6706           	beqs 0x6cf2
    6cec:	4280           	clrl %d0
    6cee:	6000 02e8      	braw 0x6fd8
    6cf2:	222e 000c      	movel %fp@(12),%d1
    6cf6:	200e           	movel %fp,%d0
    6cf8:	5180           	subql #8,%d0
    6cfa:	2f00           	movel %d0,%sp@-
    6cfc:	2f01           	movel %d1,%sp@-
    6cfe:	4879 0000 0000 	pea 0x0
    6d04:	2f2e 0008      	movel %fp@(8),%sp@-
    6d08:	4eba f7e6      	jsr %pc@(0x64f0)
    6d0c:	4fef 0010      	lea %sp@(16),%sp
    6d10:	4a80           	tstl %d0
    6d12:	6706           	beqs 0x6d1a
    6d14:	4280           	clrl %d0
    6d16:	6000 02c0      	braw 0x6fd8
    6d1a:	206e 000c      	moveal %fp@(12),%a0
    6d1e:	202e 0014      	movel %fp@(20),%d0
    6d22:	2240           	moveal %d0,%a1
    6d24:	2029 0014      	movel %a1@(20),%d0
    6d28:	0680 0000 076c 	addil #1900,%d0
    6d2e:	220e           	movel %fp,%d1
    6d30:	5181           	subql #8,%d1
    6d32:	2f01           	movel %d1,%sp@-
    6d34:	2f08           	movel %a0,%sp@-
    6d36:	4878 0004      	pea 0x4
    6d3a:	2f00           	movel %d0,%sp@-
    6d3c:	2f2e 0008      	movel %fp@(8),%sp@-
    6d40:	4eba f89c      	jsr %pc@(0x65de)
    6d44:	4fef 0014      	lea %sp@(20),%sp
    6d48:	4a80           	tstl %d0
    6d4a:	6700 0258      	beqw 0x6fa4
    6d4e:	4280           	clrl %d0
    6d50:	6000 0286      	braw 0x6fd8
    6d54:	206e 000c      	moveal %fp@(12),%a0
    6d58:	202e 0014      	movel %fp@(20),%d0
    6d5c:	2240           	moveal %d0,%a1
    6d5e:	2229 0008      	movel %a1@(8),%d1
    6d62:	200e           	movel %fp,%d0
    6d64:	5180           	subql #8,%d0
    6d66:	2f00           	movel %d0,%sp@-
    6d68:	2f08           	movel %a0,%sp@-
    6d6a:	4878 0002      	pea 0x2
    6d6e:	2f01           	movel %d1,%sp@-
    6d70:	2f2e 0008      	movel %fp@(8),%sp@-
    6d74:	4eba f868      	jsr %pc@(0x65de)
    6d78:	4fef 0014      	lea %sp@(20),%sp
    6d7c:	4a80           	tstl %d0
    6d7e:	6706           	beqs 0x6d86
    6d80:	4280           	clrl %d0
    6d82:	6000 0254      	braw 0x6fd8
    6d86:	222e 000c      	movel %fp@(12),%d1
    6d8a:	200e           	movel %fp,%d0
    6d8c:	5180           	subql #8,%d0
    6d8e:	2f00           	movel %d0,%sp@-
    6d90:	2f01           	movel %d1,%sp@-
    6d92:	4879 0000 0000 	pea 0x0
    6d98:	2f2e 0008      	movel %fp@(8),%sp@-
    6d9c:	4eba f752      	jsr %pc@(0x64f0)
    6da0:	4fef 0010      	lea %sp@(16),%sp
    6da4:	4a80           	tstl %d0
    6da6:	6706           	beqs 0x6dae
    6da8:	4280           	clrl %d0
    6daa:	6000 022c      	braw 0x6fd8
    6dae:	206e 000c      	moveal %fp@(12),%a0
    6db2:	202e 0014      	movel %fp@(20),%d0
    6db6:	2240           	moveal %d0,%a1
    6db8:	2229 0004      	movel %a1@(4),%d1
    6dbc:	200e           	movel %fp,%d0
    6dbe:	5180           	subql #8,%d0
    6dc0:	2f00           	movel %d0,%sp@-
    6dc2:	2f08           	movel %a0,%sp@-
    6dc4:	4878 0002      	pea 0x2
    6dc8:	2f01           	movel %d1,%sp@-
    6dca:	2f2e 0008      	movel %fp@(8),%sp@-
    6dce:	4eba f80e      	jsr %pc@(0x65de)
    6dd2:	4fef 0014      	lea %sp@(20),%sp
    6dd6:	4a80           	tstl %d0
    6dd8:	6706           	beqs 0x6de0
    6dda:	4280           	clrl %d0
    6ddc:	6000 01fa      	braw 0x6fd8
    6de0:	222e 000c      	movel %fp@(12),%d1
    6de4:	200e           	movel %fp,%d0
    6de6:	5180           	subql #8,%d0
    6de8:	2f00           	movel %d0,%sp@-
    6dea:	2f01           	movel %d1,%sp@-
    6dec:	4879 0000 0000 	pea 0x0
    6df2:	2f2e 0008      	movel %fp@(8),%sp@-
    6df6:	4eba f6f8      	jsr %pc@(0x64f0)
    6dfa:	4fef 0010      	lea %sp@(16),%sp
    6dfe:	4a80           	tstl %d0
    6e00:	6706           	beqs 0x6e08
    6e02:	4280           	clrl %d0
    6e04:	6000 01d2      	braw 0x6fd8
    6e08:	206e 000c      	moveal %fp@(12),%a0
    6e0c:	202e 0014      	movel %fp@(20),%d0
    6e10:	2240           	moveal %d0,%a1
    6e12:	2211           	movel %a1@,%d1
    6e14:	200e           	movel %fp,%d0
    6e16:	5180           	subql #8,%d0
    6e18:	2f00           	movel %d0,%sp@-
    6e1a:	2f08           	movel %a0,%sp@-
    6e1c:	4878 0002      	pea 0x2
    6e20:	2f01           	movel %d1,%sp@-
    6e22:	2f2e 0008      	movel %fp@(8),%sp@-
    6e26:	4eba f7b6      	jsr %pc@(0x65de)
    6e2a:	4fef 0014      	lea %sp@(20),%sp
    6e2e:	4a80           	tstl %d0
    6e30:	6700 0176      	beqw 0x6fa8
    6e34:	4280           	clrl %d0
    6e36:	6000 01a0      	braw 0x6fd8
    6e3a:	226e 000c      	moveal %fp@(12),%a1
    6e3e:	202e 0014      	movel %fp@(20),%d0
    6e42:	2040           	moveal %d0,%a0
    6e44:	2228 0014      	movel %a0@(20),%d1
    6e48:	2401           	movel %d1,%d2
    6e4a:	4c3c 2c00 51eb 	mulsl #1374389535,%d0,%d2
    6e50:	851f 
    6e52:	ea80           	asrl #5,%d0
    6e54:	2401           	movel %d1,%d2
    6e56:	d482           	addl %d2,%d2
    6e58:	9582           	subxl %d2,%d2
    6e5a:	2042           	moveal %d2,%a0
    6e5c:	9088           	subl %a0,%d0
    6e5e:	e588           	lsll #2,%d0
    6e60:	2400           	movel %d0,%d2
    6e62:	e58a           	lsll #2,%d2
    6e64:	2042           	moveal %d2,%a0
    6e66:	d088           	addl %a0,%d0
    6e68:	2400           	movel %d0,%d2
    6e6a:	e58a           	lsll #2,%d2
    6e6c:	2042           	moveal %d2,%a0
    6e6e:	d088           	addl %a0,%d0
    6e70:	2401           	movel %d1,%d2
    6e72:	9480           	subl %d0,%d2
    6e74:	2002           	movel %d2,%d0
    6e76:	220e           	movel %fp,%d1
    6e78:	5181           	subql #8,%d1
    6e7a:	2f01           	movel %d1,%sp@-
    6e7c:	2f09           	movel %a1,%sp@-
    6e7e:	4878 0002      	pea 0x2
    6e82:	2f00           	movel %d0,%sp@-
    6e84:	2f2e 0008      	movel %fp@(8),%sp@-
    6e88:	4eba f754      	jsr %pc@(0x65de)
    6e8c:	4fef 0014      	lea %sp@(20),%sp
    6e90:	4a80           	tstl %d0
    6e92:	6700 0118      	beqw 0x6fac
    6e96:	4280           	clrl %d0
    6e98:	6000 013e      	braw 0x6fd8
    6e9c:	206e 000c      	moveal %fp@(12),%a0
    6ea0:	202e 0014      	movel %fp@(20),%d0
    6ea4:	2240           	moveal %d0,%a1
    6ea6:	2029 0014      	movel %a1@(20),%d0
    6eaa:	0680 0000 076c 	addil #1900,%d0
    6eb0:	220e           	movel %fp,%d1
    6eb2:	5181           	subql #8,%d1
    6eb4:	2f01           	movel %d1,%sp@-
    6eb6:	2f08           	movel %a0,%sp@-
    6eb8:	4878 0004      	pea 0x4
    6ebc:	2f00           	movel %d0,%sp@-
    6ebe:	2f2e 0008      	movel %fp@(8),%sp@-
    6ec2:	4eba f71a      	jsr %pc@(0x65de)
    6ec6:	4fef 0014      	lea %sp@(20),%sp
    6eca:	4a80           	tstl %d0
    6ecc:	6700 00e2      	beqw 0x6fb0
    6ed0:	4280           	clrl %d0
    6ed2:	6000 0104      	braw 0x6fd8
    6ed6:	222e 000c      	movel %fp@(12),%d1
    6eda:	200e           	movel %fp,%d0
    6edc:	5180           	subql #8,%d0
    6ede:	2f00           	movel %d0,%sp@-
    6ee0:	2f01           	movel %d1,%sp@-
    6ee2:	4879 0000 0000 	pea 0x0
    6ee8:	2f2e 0008      	movel %fp@(8),%sp@-
    6eec:	4eba f602      	jsr %pc@(0x64f0)
    6ef0:	4fef 0010      	lea %sp@(16),%sp
    6ef4:	4a80           	tstl %d0
    6ef6:	6700 00bc      	beqw 0x6fb4
    6efa:	4280           	clrl %d0
    6efc:	6000 00da      	braw 0x6fd8
    6f00:	206e 000c      	moveal %fp@(12),%a0
    6f04:	202e fffc      	movel %fp@(-4),%d0
    6f08:	d0ae 0010      	addl %fp@(16),%d0
    6f0c:	2240           	moveal %d0,%a1
    6f0e:	1011           	moveb %a1@,%d0
    6f10:	49c0           	extbl %d0
    6f12:	220e           	movel %fp,%d1
    6f14:	5181           	subql #8,%d1
    6f16:	2f01           	movel %d1,%sp@-
    6f18:	2f08           	movel %a0,%sp@-
    6f1a:	2f00           	movel %d0,%sp@-
    6f1c:	2f2e 0008      	movel %fp@(8),%sp@-
    6f20:	4eba f662      	jsr %pc@(0x6584)
    6f24:	4fef 0010      	lea %sp@(16),%sp
    6f28:	4a80           	tstl %d0
    6f2a:	6700 008c      	beqw 0x6fb8
    6f2e:	4280           	clrl %d0
    6f30:	6000 00a6      	braw 0x6fd8
    6f34:	206e 000c      	moveal %fp@(12),%a0
    6f38:	202e fffc      	movel %fp@(-4),%d0
    6f3c:	d0ae 0010      	addl %fp@(16),%d0
    6f40:	2240           	moveal %d0,%a1
    6f42:	1011           	moveb %a1@,%d0
    6f44:	49c0           	extbl %d0
    6f46:	220e           	movel %fp,%d1
    6f48:	5181           	subql #8,%d1
    6f4a:	2f01           	movel %d1,%sp@-
    6f4c:	2f08           	movel %a0,%sp@-
    6f4e:	2f00           	movel %d0,%sp@-
    6f50:	2f2e 0008      	movel %fp@(8),%sp@-
    6f54:	4eba f62e      	jsr %pc@(0x6584)
    6f58:	4fef 0010      	lea %sp@(16),%sp
    6f5c:	4a80           	tstl %d0
    6f5e:	675a           	beqs 0x6fba
    6f60:	4280           	clrl %d0
    6f62:	6074           	bras 0x6fd8
    6f64:	4e71           	nop
    6f66:	6052           	bras 0x6fba
    6f68:	4e71           	nop
    6f6a:	604e           	bras 0x6fba
    6f6c:	4e71           	nop
    6f6e:	604a           	bras 0x6fba
    6f70:	4e71           	nop
    6f72:	6046           	bras 0x6fba
    6f74:	4e71           	nop
    6f76:	6042           	bras 0x6fba
    6f78:	4e71           	nop
    6f7a:	603e           	bras 0x6fba
    6f7c:	4e71           	nop
    6f7e:	603a           	bras 0x6fba
    6f80:	4e71           	nop
    6f82:	6036           	bras 0x6fba
    6f84:	4e71           	nop
    6f86:	6032           	bras 0x6fba
    6f88:	4e71           	nop
    6f8a:	602e           	bras 0x6fba
    6f8c:	4e71           	nop
    6f8e:	602a           	bras 0x6fba
    6f90:	4e71           	nop
    6f92:	6026           	bras 0x6fba
    6f94:	4e71           	nop
    6f96:	6022           	bras 0x6fba
    6f98:	4e71           	nop
    6f9a:	601e           	bras 0x6fba
    6f9c:	4e71           	nop
    6f9e:	601a           	bras 0x6fba
    6fa0:	4e71           	nop
    6fa2:	6016           	bras 0x6fba
    6fa4:	4e71           	nop
    6fa6:	6012           	bras 0x6fba
    6fa8:	4e71           	nop
    6faa:	600e           	bras 0x6fba
    6fac:	4e71           	nop
    6fae:	600a           	bras 0x6fba
    6fb0:	4e71           	nop
    6fb2:	6006           	bras 0x6fba
    6fb4:	4e71           	nop
    6fb6:	6002           	bras 0x6fba
    6fb8:	4e71           	nop
    6fba:	52ae fffc      	addql #1,%fp@(-4)
    6fbe:	242e fffc      	movel %fp@(-4),%d2
    6fc2:	2f2e 0010      	movel %fp@(16),%sp@-
    6fc6:	4eb9 0000 0000 	jsr 0x0
    6fcc:	588f           	addql #4,%sp
    6fce:	b082           	cmpl %d2,%d0
    6fd0:	6200 f6e6      	bhiw 0x66b8
    6fd4:	202e fff8      	movel %fp@(-8),%d0
    6fd8:	242e fff4      	movel %fp@(-12),%d2
    6fdc:	4e5e           	unlk %fp
    6fde:	4e75           	rts
    6fe0:	206f 0004      	moveal %sp@(4),%a0
    6fe4:	4280           	clrl %d0
    6fe6:	5280           	addql #1,%d0
    6fe8:	4a18           	tstb %a0@+
    6fea:	66fa           	bnes 0x6fe6
    6fec:	5380           	subql #1,%d0
    6fee:	4e75           	rts
    6ff0:	222f 000c      	movel %sp@(12),%d1
    6ff4:	226f 0008      	moveal %sp@(8),%a1
    6ff8:	206f 0004      	moveal %sp@(4),%a0
    6ffc:	2008           	movel %a0,%d0
    6ffe:	4a18           	tstb %a0@+
    7000:	6600 fffc      	bnew 0x6ffe
    7004:	5348           	subqw #1,%a0
    7006:	10d1           	moveb %a1@,%a0@+
    7008:	5341           	subqw #1,%d1
    700a:	670a           	beqs 0x7016
    700c:	4a19           	tstb %a1@+
    700e:	6600 fff6      	bnew 0x7006
    7012:	2040           	moveal %d0,%a0
    7014:	4e75           	rts
    7016:	4210           	clrb %a0@
    7018:	2040           	moveal %d0,%a0
    701a:	4e75           	rts
    701c:	202f 000c      	movel %sp@(12),%d0
    7020:	671e           	beqs 0x7040
    7022:	226f 0008      	moveal %sp@(8),%a1
    7026:	206f 0004      	moveal %sp@(4),%a0
    702a:	1219           	moveb %a1@+,%d1
    702c:	6716           	beqs 0x7044
    702e:	4a10           	tstb %a0@
    7030:	671e           	beqs 0x7050
    7032:	b218           	cmpb %a0@+,%d1
    7034:	6704           	beqs 0x703a
    7036:	6418           	bccs 0x7050
    7038:	650a           	bcss 0x7044
    703a:	5340           	subqw #1,%d0
    703c:	6600 ffec      	bnew 0x702a
    7040:	4280           	clrl %d0
    7042:	4e75           	rts
    7044:	4a10           	tstb %a0@
    7046:	6700 fff8      	beqw 0x7040
    704a:	4280           	clrl %d0
    704c:	5240           	addqw #1,%d0
    704e:	4e75           	rts
    7050:	4280           	clrl %d0
    7052:	5340           	subqw #1,%d0
    7054:	4e75           	rts
    7056:	4e71           	nop
    7058:	222f 000c      	movel %sp@(12),%d1
    705c:	226f 0008      	moveal %sp@(8),%a1
    7060:	206f 0004      	moveal %sp@(4),%a0
    7064:	2008           	movel %a0,%d0
    7066:	10d9           	moveb %a1@+,%a0@+
    7068:	670a           	beqs 0x7074
    706a:	5341           	subqw #1,%d1
    706c:	6600 fff8      	bnew 0x7066
    7070:	2040           	moveal %d0,%a0
    7072:	4e75           	rts
    7074:	5341           	subqw #1,%d1
    7076:	67f8           	beqs 0x7070
    7078:	10fc 0000      	moveb #0,%a0@+
    707c:	6000 fff6      	braw 0x7074
    7080:	222f 0008      	movel %sp@(8),%d1
    7084:	206f 0004      	moveal %sp@(4),%a0
    7088:	2248           	moveal %a0,%a1
    708a:	4280           	clrl %d0
    708c:	4a18           	tstb %a0@+
    708e:	66fc           	bnes 0x708c
    7090:	b3c8           	cmpal %a0,%a1
    7092:	6706           	beqs 0x709a
    7094:	b220           	cmpb %a0@-,%d1
    7096:	66f8           	bnes 0x7090
    7098:	2008           	movel %a0,%d0
    709a:	2040           	moveal %d0,%a0
    709c:	4e75           	rts
    709e:	4e71           	nop
    70a0:	226f 0008      	moveal %sp@(8),%a1
    70a4:	206f 0004      	moveal %sp@(4),%a0
    70a8:	4281           	clrl %d1
    70aa:	2f09           	movel %a1,%sp@-
    70ac:	5241           	addqw #1,%d1
    70ae:	4a19           	tstb %a1@+
    70b0:	66fa           	bnes 0x70ac
    70b2:	5341           	subqw #1,%d1
    70b4:	672c           	beqs 0x70e2
    70b6:	225f           	moveal %sp@+,%a1
    70b8:	1018           	moveb %a0@+,%d0
    70ba:	6726           	beqs 0x70e2
    70bc:	b011           	cmpb %a1@,%d0
    70be:	66f8           	bnes 0x70b8
    70c0:	5348           	subqw #1,%a0
    70c2:	48a7 40c0      	movemw %d1/%a0-%a1,%sp@-
    70c6:	1018           	moveb %a0@+,%d0
    70c8:	b019           	cmpb %a1@+,%d0
    70ca:	660c           	bnes 0x70d8
    70cc:	5341           	subqw #1,%d1
    70ce:	6600 fff6      	bnew 0x70c6
    70d2:	4c9f 0302      	movemw %sp@+,%d1/%a0-%a1
    70d6:	4e75           	rts
    70d8:	4c9f 0302      	movemw %sp@+,%d1/%a0-%a1
    70dc:	5248           	addqw #1,%a0
    70de:	6000 ffd8      	braw 0x70b8
    70e2:	207c 0000 0000 	moveal #0,%a0
    70e8:	4e75           	rts
    70ea:	4e71           	nop
    70ec:	4e56 0000      	linkw %fp,#0
    70f0:	4aae 0008      	tstl %fp@(8)
    70f4:	6612           	bnes 0x7108
    70f6:	2d79 0000 0000 	movel 0x0,%fp@(8)
    70fc:	0008 
    70fe:	4aae 0008      	tstl %fp@(8)
    7102:	6604           	bnes 0x7108
    7104:	4280           	clrl %d0
    7106:	6056           	bras 0x715e
    7108:	4aae 0008      	tstl %fp@(8)
    710c:	670c           	beqs 0x711a
    710e:	202e 0008      	movel %fp@(8),%d0
    7112:	2040           	moveal %d0,%a0
    7114:	1010           	moveb %a0@,%d0
    7116:	4a00           	tstb %d0
    7118:	6604           	bnes 0x711e
    711a:	4280           	clrl %d0
    711c:	6040           	bras 0x715e
    711e:	2f2e 000c      	movel %fp@(12),%sp@-
    7122:	2f2e 0008      	movel %fp@(8),%sp@-
    7126:	4eb9 0000 0000 	jsr 0x0
    712c:	508f           	addql #8,%sp
    712e:	2008           	movel %a0,%d0
    7130:	23c0 0000 0000 	movel %d0,0x0
    7136:	2039 0000 0000 	movel 0x0,%d0
    713c:	2040           	moveal %d0,%a0
    713e:	1010           	moveb %a0@,%d0
    7140:	4a00           	tstb %d0
    7142:	6604           	bnes 0x7148
    7144:	4280           	clrl %d0
    7146:	6016           	bras 0x715e
    7148:	2039 0000 0000 	movel 0x0,%d0
    714e:	2040           	moveal %d0,%a0
    7150:	4210           	clrb %a0@
    7152:	5280           	addql #1,%d0
    7154:	23c0 0000 0000 	movel %d0,0x0
    715a:	202e 0008      	movel %fp@(8),%d0
    715e:	2200           	movel %d0,%d1
    7160:	2041           	moveal %d1,%a0
    7162:	4e5e           	unlk %fp
    7164:	4e75           	rts
    7166:	4e71           	nop
    7168:	4e56 fff8      	linkw %fp,#-8
    716c:	42ae fffc      	clrl %fp@(-4)
    7170:	6004           	bras 0x7176
    7172:	52ae 0008      	addql #1,%fp@(8)
    7176:	202e 0008      	movel %fp@(8),%d0
    717a:	2040           	moveal %d0,%a0
    717c:	1010           	moveb %a0@,%d0
    717e:	49c0           	extbl %d0
    7180:	1030 09b0 0000 	moveb @(00000000,%d0:l),%d0
    7186:	0000 
    7188:	1000           	moveb %d0,%d0
    718a:	0280 0000 00ff 	andil #255,%d0
    7190:	7201           	moveq #1,%d1
    7192:	c081           	andl %d1,%d0
    7194:	1000           	moveb %d0,%d0
    7196:	4a00           	tstb %d0
    7198:	66d8           	bnes 0x7172
    719a:	202e 0008      	movel %fp@(8),%d0
    719e:	2040           	moveal %d0,%a0
    71a0:	1010           	moveb %a0@,%d0
    71a2:	0c00 0030      	cmpib #48,%d0
    71a6:	6600 008c      	bnew 0x7234
    71aa:	7008           	moveq #8,%d0
    71ac:	2d40 0010      	movel %d0,%fp@(16)
    71b0:	52ae 0008      	addql #1,%fp@(8)
    71b4:	202e 0008      	movel %fp@(8),%d0
    71b8:	2040           	moveal %d0,%a0
    71ba:	1010           	moveb %a0@,%d0
    71bc:	0c00 0078      	cmpib #120,%d0
    71c0:	670e           	beqs 0x71d0
    71c2:	202e 0008      	movel %fp@(8),%d0
    71c6:	2040           	moveal %d0,%a0
    71c8:	1010           	moveb %a0@,%d0
    71ca:	0c00 0058      	cmpib #88,%d0
    71ce:	6668           	bnes 0x7238
    71d0:	7010           	moveq #16,%d0
    71d2:	2d40 0010      	movel %d0,%fp@(16)
    71d6:	52ae 0008      	addql #1,%fp@(8)
    71da:	605e           	bras 0x723a
    71dc:	202e 0008      	movel %fp@(8),%d0
    71e0:	2040           	moveal %d0,%a0
    71e2:	1010           	moveb %a0@,%d0
    71e4:	49c0           	extbl %d0
    71e6:	52ae 0008      	addql #1,%fp@(8)
    71ea:	2f00           	movel %d0,%sp@-
    71ec:	4eb9 0000 0000 	jsr 0x0
    71f2:	588f           	addql #4,%sp
    71f4:	72d0           	moveq #-48,%d1
    71f6:	d081           	addl %d1,%d0
    71f8:	2d40 fff8      	movel %d0,%fp@(-8)
    71fc:	7009           	moveq #9,%d0
    71fe:	b0ae fff8      	cmpl %fp@(-8),%d0
    7202:	6404           	bccs 0x7208
    7204:	5fae fff8      	subql #7,%fp@(-8)
    7208:	202e 0010      	movel %fp@(16),%d0
    720c:	b0ae fff8      	cmpl %fp@(-8),%d0
    7210:	6206           	bhis 0x7218
    7212:	53ae 0008      	subql #1,%fp@(8)
    7216:	6044           	bras 0x725c
    7218:	222e fffc      	movel %fp@(-4),%d1
    721c:	4c2e 1800 0010 	mulsl %fp@(16),%d1
    7222:	2d41 fffc      	movel %d1,%fp@(-4)
    7226:	202e fffc      	movel %fp@(-4),%d0
    722a:	d0ae fff8      	addl %fp@(-8),%d0
    722e:	2d40 fffc      	movel %d0,%fp@(-4)
    7232:	6006           	bras 0x723a
    7234:	4e71           	nop
    7236:	6002           	bras 0x723a
    7238:	4e71           	nop
    723a:	202e 0008      	movel %fp@(8),%d0
    723e:	2040           	moveal %d0,%a0
    7240:	1010           	moveb %a0@,%d0
    7242:	49c0           	extbl %d0
    7244:	1030 09b0 0000 	moveb @(00000000,%d0:l),%d0
    724a:	0000 
    724c:	1000           	moveb %d0,%d0
    724e:	0280 0000 00ff 	andil #255,%d0
    7254:	720e           	moveq #14,%d1
    7256:	c081           	andl %d1,%d0
    7258:	4a80           	tstl %d0
    725a:	6680           	bnes 0x71dc
    725c:	4aae 000c      	tstl %fp@(12)
    7260:	670a           	beqs 0x726c
    7262:	202e 000c      	movel %fp@(12),%d0
    7266:	2040           	moveal %d0,%a0
    7268:	20ae 0008      	movel %fp@(8),%a0@
    726c:	202e fffc      	movel %fp@(-4),%d0
    7270:	4e5e           	unlk %fp
    7272:	4e75           	rts
    7274:	4e56 0000      	linkw %fp,#0
    7278:	2f2e 0008      	movel %fp@(8),%sp@-
    727c:	4eb9 0000 0000 	jsr 0x0
    7282:	588f           	addql #4,%sp
    7284:	4e5e           	unlk %fp
    7286:	4e75           	rts
    7288:	4e56 ffd8      	linkw %fp,#-40
    728c:	70d8           	moveq #-40,%d0
    728e:	d08e           	addl %fp,%d0
    7290:	2f00           	movel %d0,%sp@-
    7292:	4eb9 0000 0000 	jsr 0x0
    7298:	588f           	addql #4,%sp
    729a:	70d8           	moveq #-40,%d0
    729c:	d08e           	addl %fp,%d0
    729e:	2f00           	movel %d0,%sp@-
    72a0:	4eb9 0000 0000 	jsr 0x0
    72a6:	588f           	addql #4,%sp
    72a8:	2d40 fffc      	movel %d0,%fp@(-4)
    72ac:	4aae 0008      	tstl %fp@(8)
    72b0:	670a           	beqs 0x72bc
    72b2:	202e 0008      	movel %fp@(8),%d0
    72b6:	2040           	moveal %d0,%a0
    72b8:	20ae fffc      	movel %fp@(-4),%a0@
    72bc:	202e fffc      	movel %fp@(-4),%d0
    72c0:	4e5e           	unlk %fp
    72c2:	4e75           	rts
    72c4:	4e56 ffe8      	linkw %fp,#-24
    72c8:	2f02           	movel %d2,%sp@-
    72ca:	42ae fff8      	clrl %fp@(-8)
    72ce:	70e8           	moveq #-24,%d0
    72d0:	d08e           	addl %fp,%d0
    72d2:	2f00           	movel %d0,%sp@-
    72d4:	4eb9 0000 0000 	jsr 0x0
    72da:	588f           	addql #4,%sp
    72dc:	70e8           	moveq #-24,%d0
    72de:	d08e           	addl %fp,%d0
    72e0:	2f00           	movel %d0,%sp@-
    72e2:	4eb9 0000 0000 	jsr 0x0
    72e8:	588f           	addql #4,%sp
    72ea:	2d48 fff4      	movel %a0,%fp@(-12)
    72ee:	4eb9 0000 0000 	jsr 0x0
    72f4:	2d40 fff0      	movel %d0,%fp@(-16)
    72f8:	202e fff4      	movel %fp@(-12),%d0
    72fc:	2240           	moveal %d0,%a1
    72fe:	2069 0014      	moveal %a1@(20),%a0
    7302:	2208           	movel %a0,%d1
    7304:	4c3c 1c00 4ec4 	mulsl #1321528399,%d0,%d1
    730a:	ec4f 
    730c:	e680           	asrl #3,%d0
    730e:	2208           	movel %a0,%d1
    7310:	d281           	addl %d1,%d1
    7312:	9381           	subxl %d1,%d1
    7314:	2400           	movel %d0,%d2
    7316:	9481           	subl %d1,%d2
    7318:	2202           	movel %d2,%d1
    731a:	2001           	movel %d1,%d0
    731c:	2400           	movel %d0,%d2
    731e:	e58a           	lsll #2,%d2
    7320:	2242           	moveal %d2,%a1
    7322:	2009           	movel %a1,%d0
    7324:	e588           	lsll #2,%d0
    7326:	9089           	subl %a1,%d0
    7328:	d081           	addl %d1,%d0
    732a:	d080           	addl %d0,%d0
    732c:	2208           	movel %a0,%d1
    732e:	9280           	subl %d0,%d1
    7330:	1001           	moveb %d1,%d0
    7332:	13c0 0000 0000 	moveb %d0,0x0
    7338:	202e fff4      	movel %fp@(-12),%d0
    733c:	2040           	moveal %d0,%a0
    733e:	2028 0008      	movel %a0@(8),%d0
    7342:	1000           	moveb %d0,%d0
    7344:	13c0 0000 0000 	moveb %d0,0x0
    734a:	202e fff4      	movel %fp@(-12),%d0
    734e:	2240           	moveal %d0,%a1
    7350:	2029 0004      	movel %a1@(4),%d0
    7354:	2400           	movel %d0,%d2
    7356:	4c3c 2c01 38e3 	mulsl #954437177,%d1,%d2
    735c:	8e39 
    735e:	e681           	asrl #3,%d1
    7360:	d080           	addl %d0,%d0
    7362:	9180           	subxl %d0,%d0
    7364:	2401           	movel %d1,%d2
    7366:	9480           	subl %d0,%d2
    7368:	2002           	movel %d2,%d0
    736a:	1000           	moveb %d0,%d0
    736c:	13c0 0000 0000 	moveb %d0,0x0
    7372:	202e fff4      	movel %fp@(-12),%d0
    7376:	2040           	moveal %d0,%a0
    7378:	2228 0004      	movel %a0@(4),%d1
    737c:	2401           	movel %d1,%d2
    737e:	4c3c 2c00 38e3 	mulsl #954437177,%d0,%d2
    7384:	8e39 
    7386:	e680           	asrl #3,%d0
    7388:	2401           	movel %d1,%d2
    738a:	d482           	addl %d2,%d2
    738c:	9582           	subxl %d2,%d2
    738e:	2042           	moveal %d2,%a0
    7390:	9088           	subl %a0,%d0
    7392:	e588           	lsll #2,%d0
    7394:	2400           	movel %d0,%d2
    7396:	e78a           	lsll #3,%d2
    7398:	2042           	moveal %d2,%a0
    739a:	d088           	addl %a0,%d0
    739c:	2401           	movel %d1,%d2
    739e:	9480           	subl %d0,%d2
    73a0:	2002           	movel %d2,%d0
    73a2:	1000           	moveb %d0,%d0
    73a4:	13c0 0000 0000 	moveb %d0,0x0
    73aa:	202e fff4      	movel %fp@(-12),%d0
    73ae:	2040           	moveal %d0,%a0
    73b0:	2010           	movel %a0@,%d0
    73b2:	2400           	movel %d0,%d2
    73b4:	4c3c 2c01 38e3 	mulsl #954437177,%d1,%d2
    73ba:	8e39 
    73bc:	e681           	asrl #3,%d1
    73be:	d080           	addl %d0,%d0
    73c0:	9180           	subxl %d0,%d0
    73c2:	2401           	movel %d1,%d2
    73c4:	9480           	subl %d0,%d2
    73c6:	2002           	movel %d2,%d0
    73c8:	1000           	moveb %d0,%d0
    73ca:	13c0 0000 0000 	moveb %d0,0x0
    73d0:	202e fff4      	movel %fp@(-12),%d0
    73d4:	2040           	moveal %d0,%a0
    73d6:	2210           	movel %a0@,%d1
    73d8:	2401           	movel %d1,%d2
    73da:	4c3c 2c00 38e3 	mulsl #954437177,%d0,%d2
    73e0:	8e39 
    73e2:	e680           	asrl #3,%d0
    73e4:	2401           	movel %d1,%d2
    73e6:	d482           	addl %d2,%d2
    73e8:	9582           	subxl %d2,%d2
    73ea:	2042           	moveal %d2,%a0
    73ec:	9088           	subl %a0,%d0
    73ee:	e588           	lsll #2,%d0
    73f0:	2400           	movel %d0,%d2
    73f2:	e78a           	lsll #3,%d2
    73f4:	2042           	moveal %d2,%a0
    73f6:	d088           	addl %a0,%d0
    73f8:	2401           	movel %d1,%d2
    73fa:	9480           	subl %d0,%d2
    73fc:	2002           	movel %d2,%d0
    73fe:	1000           	moveb %d0,%d0
    7400:	13c0 0000 0000 	moveb %d0,0x0
    7406:	202e fff0      	movel %fp@(-16),%d0
    740a:	2400           	movel %d0,%d2
    740c:	4c3c 2c01 38e3 	mulsl #954437177,%d1,%d2
    7412:	8e39 
    7414:	e681           	asrl #3,%d1
    7416:	d080           	addl %d0,%d0
    7418:	9180           	subxl %d0,%d0
    741a:	2401           	movel %d1,%d2
    741c:	9480           	subl %d0,%d2
    741e:	2002           	movel %d2,%d0
    7420:	1000           	moveb %d0,%d0
    7422:	13c0 0000 0000 	moveb %d0,0x0
    7428:	222e fff0      	movel %fp@(-16),%d1
    742c:	2401           	movel %d1,%d2
    742e:	4c3c 2c00 38e3 	mulsl #954437177,%d0,%d2
    7434:	8e39 
    7436:	e680           	asrl #3,%d0
    7438:	2401           	movel %d1,%d2
    743a:	d482           	addl %d2,%d2
    743c:	9582           	subxl %d2,%d2
    743e:	2042           	moveal %d2,%a0
    7440:	9088           	subl %a0,%d0
    7442:	e588           	lsll #2,%d0
    7444:	2400           	movel %d0,%d2
    7446:	e78a           	lsll #3,%d2
    7448:	2042           	moveal %d2,%a0
    744a:	d088           	addl %a0,%d0
    744c:	2401           	movel %d1,%d2
    744e:	9480           	subl %d0,%d2
    7450:	2002           	movel %d2,%d0
    7452:	1000           	moveb %d0,%d0
    7454:	13c0 0000 0000 	moveb %d0,0x0
    745a:	13fc 002e 0000 	moveb #46,0x0
    7460:	0000 
    7462:	13fc 0054 0000 	moveb #84,0x0
    7468:	0000 
    746a:	13fc 004d 0000 	moveb #77,0x0
    7470:	0000 
    7472:	13fc 0050 0000 	moveb #80,0x0
    7478:	0000 
    747a:	4239 0000 0000 	clrb 0x0
    7480:	42ae fffc      	clrl %fp@(-4)
    7484:	605c           	bras 0x74e2
    7486:	202e fffc      	movel %fp@(-4),%d0
    748a:	0680 0000 0000 	addil #0,%d0
    7490:	2040           	moveal %d0,%a0
    7492:	1010           	moveb %a0@,%d0
    7494:	0600 0041      	addib #65,%d0
    7498:	1200           	moveb %d0,%d1
    749a:	202e fffc      	movel %fp@(-4),%d0
    749e:	0680 0000 0000 	addil #0,%d0
    74a4:	2240           	moveal %d0,%a1
    74a6:	1281           	moveb %d1,%a1@
    74a8:	202e fffc      	movel %fp@(-4),%d0
    74ac:	0680 0000 0000 	addil #0,%d0
    74b2:	2040           	moveal %d0,%a0
    74b4:	1010           	moveb %a0@,%d0
    74b6:	0c00 005a      	cmpib #90,%d0
    74ba:	6f22           	bles 0x74de
    74bc:	202e fffc      	movel %fp@(-4),%d0
    74c0:	0680 0000 0000 	addil #0,%d0
    74c6:	2240           	moveal %d0,%a1
    74c8:	1011           	moveb %a1@,%d0
    74ca:	0600 ffef      	addib #-17,%d0
    74ce:	1200           	moveb %d0,%d1
    74d0:	202e fffc      	movel %fp@(-4),%d0
    74d4:	0680 0000 0000 	addil #0,%d0
    74da:	2040           	moveal %d0,%a0
    74dc:	1081           	moveb %d1,%a0@
    74de:	52ae fffc      	addql #1,%fp@(-4)
    74e2:	7007           	moveq #7,%d0
    74e4:	b0ae fffc      	cmpl %fp@(-4),%d0
    74e8:	6c9c           	bges 0x7486
    74ea:	4879 0000 0000 	pea 0x0
    74f0:	4879 0000 0000 	pea 0x0
    74f6:	4eb9 0000 0000 	jsr 0x0
    74fc:	508f           	addql #8,%sp
    74fe:	2d48 ffec      	movel %a0,%fp@(-20)
    7502:	4aae ffec      	tstl %fp@(-20)
    7506:	6608           	bnes 0x7510
    7508:	4aae 0008      	tstl %fp@(8)
    750c:	6612           	bnes 0x7520
    750e:	6028           	bras 0x7538
    7510:	2f2e ffec      	movel %fp@(-20),%sp@-
    7514:	4eb9 0000 0000 	jsr 0x0
    751a:	588f           	addql #4,%sp
    751c:	6000 fdda      	braw 0x72f8
    7520:	4879 0000 0000 	pea 0x0
    7526:	2f2e 0008      	movel %fp@(8),%sp@-
    752a:	4eb9 0000 0000 	jsr 0x0
    7530:	508f           	addql #8,%sp
    7532:	202e 0008      	movel %fp@(8),%d0
    7536:	6006           	bras 0x753e
    7538:	203c 0000 0000 	movel #0,%d0
    753e:	2200           	movel %d0,%d1
    7540:	2041           	moveal %d1,%a0
    7542:	242e ffe4      	movel %fp@(-28),%d2
    7546:	4e5e           	unlk %fp
    7548:	4e75           	rts
    754a:	4e56 ffe8      	linkw %fp,#-24
    754e:	70e8           	moveq #-24,%d0
    7550:	d08e           	addl %fp,%d0
    7552:	2f00           	movel %d0,%sp@-
    7554:	4eba fd6e      	jsr %pc@(0x72c4)
    7558:	588f           	addql #4,%sp
    755a:	2008           	movel %a0,%d0
    755c:	4879 0000 0000 	pea 0x0
    7562:	2f00           	movel %d0,%sp@-
    7564:	4eb9 0000 0000 	jsr 0x0
    756a:	508f           	addql #8,%sp
    756c:	2d48 fffc      	movel %a0,%fp@(-4)
    7570:	4aae fffc      	tstl %fp@(-4)
    7574:	670c           	beqs 0x7582
    7576:	202e fffc      	movel %fp@(-4),%d0
    757a:	7201           	moveq #1,%d1
    757c:	2040           	moveal %d0,%a0
    757e:	2141 0016      	movel %d1,%a0@(22)
    7582:	202e fffc      	movel %fp@(-4),%d0
    7586:	2200           	movel %d0,%d1
    7588:	2041           	moveal %d1,%a0
    758a:	4e5e           	unlk %fp
    758c:	4e75           	rts
    758e:	4e71           	nop
    7590:	4e56 0000      	linkw %fp,#0
    7594:	202e 000c      	movel %fp@(12),%d0
    7598:	2040           	moveal %d0,%a0
    759a:	3028 001a      	movew %a0@(26),%d0
    759e:	0c40 444c      	cmpiw #17484,%d0
    75a2:	6706           	beqs 0x75aa
    75a4:	70ff           	moveq #-1,%d0
    75a6:	6000 0130      	braw 0x76d8
    75aa:	202e 000c      	movel %fp@(12),%d0
    75ae:	2040           	moveal %d0,%a0
    75b0:	2028 000e      	movel %a0@(14),%d0
    75b4:	4a80           	tstl %d0
    75b6:	6700 00fa      	beqw 0x76b2
    75ba:	202e 000c      	movel %fp@(12),%d0
    75be:	2040           	moveal %d0,%a0
    75c0:	2028 0004      	movel %a0@(4),%d0
    75c4:	727f           	moveq #127,%d1
    75c6:	4601           	notb %d1
    75c8:	c081           	andl %d1,%d0
    75ca:	4a80           	tstl %d0
    75cc:	675c           	beqs 0x762a
    75ce:	202e 000c      	movel %fp@(12),%d0
    75d2:	2040           	moveal %d0,%a0
    75d4:	2228 0012      	movel %a0@(18),%d1
    75d8:	202e 000c      	movel %fp@(12),%d0
    75dc:	2040           	moveal %d0,%a0
    75de:	2028 000e      	movel %a0@(14),%d0
    75e2:	b081           	cmpl %d1,%d0
    75e4:	6744           	beqs 0x762a
    75e6:	202e 000c      	movel %fp@(12),%d0
    75ea:	2040           	moveal %d0,%a0
    75ec:	2010           	movel %a0@,%d0
    75ee:	2200           	movel %d0,%d1
    75f0:	5281           	addql #1,%d1
    75f2:	202e 000c      	movel %fp@(12),%d0
    75f6:	2040           	moveal %d0,%a0
    75f8:	2081           	movel %d1,%a0@
    75fa:	202e 000c      	movel %fp@(12),%d0
    75fe:	2040           	moveal %d0,%a0
    7600:	2028 0012      	movel %a0@(18),%d0
    7604:	2200           	movel %d0,%d1
    7606:	5381           	subql #1,%d1
    7608:	202e 000c      	movel %fp@(12),%d0
    760c:	2040           	moveal %d0,%a0
    760e:	2141 0012      	movel %d1,%a0@(18)
    7612:	202e 000c      	movel %fp@(12),%d0
    7616:	2040           	moveal %d0,%a0
    7618:	2028 0012      	movel %a0@(18),%d0
    761c:	222e 0008      	movel %fp@(8),%d1
    7620:	1201           	moveb %d1,%d1
    7622:	2040           	moveal %d0,%a0
    7624:	1081           	moveb %d1,%a0@
    7626:	6000 00ac      	braw 0x76d4
    762a:	2f2e 000c      	movel %fp@(12),%sp@-
    762e:	4eb9 0000 0000 	jsr 0x0
    7634:	588f           	addql #4,%sp
    7636:	4a80           	tstl %d0
    7638:	6706           	beqs 0x7640
    763a:	70ff           	moveq #-1,%d0
    763c:	6000 009a      	braw 0x76d8
    7640:	202e 000c      	movel %fp@(12),%d0
    7644:	2040           	moveal %d0,%a0
    7646:	2028 0004      	movel %a0@(4),%d0
    764a:	727f           	moveq #127,%d1
    764c:	4601           	notb %d1
    764e:	8280           	orl %d0,%d1
    7650:	202e 000c      	movel %fp@(12),%d0
    7654:	2040           	moveal %d0,%a0
    7656:	2141 0004      	movel %d1,%a0@(4)
    765a:	202e 000c      	movel %fp@(12),%d0
    765e:	7201           	moveq #1,%d1
    7660:	2040           	moveal %d0,%a0
    7662:	2081           	movel %d1,%a0@
    7664:	202e 000c      	movel %fp@(12),%d0
    7668:	2040           	moveal %d0,%a0
    766a:	2228 000e      	movel %a0@(14),%d1
    766e:	202e 000c      	movel %fp@(12),%d0
    7672:	2040           	moveal %d0,%a0
    7674:	2028 000a      	movel %a0@(10),%d0
    7678:	d280           	addl %d0,%d1
    767a:	202e 000c      	movel %fp@(12),%d0
    767e:	2040           	moveal %d0,%a0
    7680:	2141 0012      	movel %d1,%a0@(18)
    7684:	202e 000c      	movel %fp@(12),%d0
    7688:	2040           	moveal %d0,%a0
    768a:	2028 0012      	movel %a0@(18),%d0
    768e:	2200           	movel %d0,%d1
    7690:	5381           	subql #1,%d1
    7692:	202e 000c      	movel %fp@(12),%d0
    7696:	2040           	moveal %d0,%a0
    7698:	2141 0012      	movel %d1,%a0@(18)
    769c:	202e 000c      	movel %fp@(12),%d0
    76a0:	2040           	moveal %d0,%a0
    76a2:	2028 0012      	movel %a0@(18),%d0
    76a6:	222e 0008      	movel %fp@(8),%d1
    76aa:	1201           	moveb %d1,%d1
    76ac:	2040           	moveal %d0,%a0
    76ae:	1081           	moveb %d1,%a0@
    76b0:	6022           	bras 0x76d4
    76b2:	202e 000c      	movel %fp@(12),%d0
    76b6:	2040           	moveal %d0,%a0
    76b8:	1028 0009      	moveb %a0@(9),%d0
    76bc:	4a00           	tstb %d0
    76be:	6704           	beqs 0x76c4
    76c0:	70ff           	moveq #-1,%d0
    76c2:	6014           	bras 0x76d8
    76c4:	202e 0008      	movel %fp@(8),%d0
    76c8:	1200           	moveb %d0,%d1
    76ca:	202e 000c      	movel %fp@(12),%d0
    76ce:	2040           	moveal %d0,%a0
    76d0:	1141 0009      	moveb %d1,%a0@(9)
    76d4:	202e 0008      	movel %fp@(8),%d0
    76d8:	4e5e           	unlk %fp
    76da:	4e75           	rts
    76dc:	4e56 0000      	linkw %fp,#0
    76e0:	203c 0000 0000 	movel #0,%d0
    76e6:	223c 0000 0000 	movel #0,%d1
    76ec:	2041           	moveal %d1,%a0
    76ee:	2240           	moveal %d0,%a1
    76f0:	2091           	movel %a1@,%a0@
    76f2:	5881           	addql #4,%d1
    76f4:	5880           	addql #4,%d0
    76f6:	2041           	moveal %d1,%a0
    76f8:	2240           	moveal %d0,%a1
    76fa:	2091           	movel %a1@,%a0@
    76fc:	5881           	addql #4,%d1
    76fe:	5880           	addql #4,%d0
    7700:	2041           	moveal %d1,%a0
    7702:	2240           	moveal %d0,%a1
    7704:	2091           	movel %a1@,%a0@
    7706:	5881           	addql #4,%d1
    7708:	5880           	addql #4,%d0
    770a:	4e5e           	unlk %fp
    770c:	4e75           	rts
    770e:	4e56 0000      	linkw %fp,#0
    7712:	1239 0000 0000 	moveb 0x0,%d1
    7718:	1039 0000 0000 	moveb 0x0,%d0
    771e:	b001           	cmpb %d1,%d0
    7720:	671a           	beqs 0x773c
    7722:	202e 000c      	movel %fp@(12),%d0
    7726:	d0ae 0008      	addl %fp@(8),%d0
    772a:	1239 0000 0000 	moveb 0x0,%d1
    7730:	0601 fff0      	addib #-16,%d1
    7734:	2040           	moveal %d0,%a0
    7736:	1081           	moveb %d1,%a0@
    7738:	52ae 000c      	addql #1,%fp@(12)
    773c:	1239 0000 0000 	moveb 0x0,%d1
    7742:	1039 0000 0000 	moveb 0x0,%d0
    7748:	b001           	cmpb %d1,%d0
    774a:	671a           	beqs 0x7766
    774c:	202e 000c      	movel %fp@(12),%d0
    7750:	d0ae 0008      	addl %fp@(8),%d0
    7754:	1239 0000 0000 	moveb 0x0,%d1
    775a:	0601 ffe0      	addib #-32,%d1
    775e:	2240           	moveal %d0,%a1
    7760:	1281           	moveb %d1,%a1@
    7762:	52ae 000c      	addql #1,%fp@(12)
    7766:	1239 0000 0000 	moveb 0x0,%d1
    776c:	1039 0000 0000 	moveb 0x0,%d0
    7772:	b001           	cmpb %d1,%d0
    7774:	671a           	beqs 0x7790
    7776:	202e 000c      	movel %fp@(12),%d0
    777a:	d0ae 0008      	addl %fp@(8),%d0
    777e:	1239 0000 0000 	moveb 0x0,%d1
    7784:	0601 ffd0      	addib #-48,%d1
    7788:	2040           	moveal %d0,%a0
    778a:	1081           	moveb %d1,%a0@
    778c:	52ae 000c      	addql #1,%fp@(12)
    7790:	1239 0000 0000 	moveb 0x0,%d1
    7796:	1039 0000 0000 	moveb 0x0,%d0
    779c:	b001           	cmpb %d1,%d0
    779e:	671a           	beqs 0x77ba
    77a0:	202e 000c      	movel %fp@(12),%d0
    77a4:	d0ae 0008      	addl %fp@(8),%d0
    77a8:	1239 0000 0000 	moveb 0x0,%d1
    77ae:	0601 ffc0      	addib #-64,%d1
    77b2:	2240           	moveal %d0,%a1
    77b4:	1281           	moveb %d1,%a1@
    77b6:	52ae 000c      	addql #1,%fp@(12)
    77ba:	1239 0000 0000 	moveb 0x0,%d1
    77c0:	1039 0000 0000 	moveb 0x0,%d0
    77c6:	b001           	cmpb %d1,%d0
    77c8:	671a           	beqs 0x77e4
    77ca:	202e 000c      	movel %fp@(12),%d0
    77ce:	d0ae 0008      	addl %fp@(8),%d0
    77d2:	1239 0000 0000 	moveb 0x0,%d1
    77d8:	0601 ffa0      	addib #-96,%d1
    77dc:	2040           	moveal %d0,%a0
    77de:	1081           	moveb %d1,%a0@
    77e0:	52ae 000c      	addql #1,%fp@(12)
    77e4:	1239 0000 0000 	moveb 0x0,%d1
    77ea:	1039 0000 0000 	moveb 0x0,%d0
    77f0:	b001           	cmpb %d1,%d0
    77f2:	671a           	beqs 0x780e
    77f4:	202e 000c      	movel %fp@(12),%d0
    77f8:	d0ae 0008      	addl %fp@(8),%d0
    77fc:	1239 0000 0000 	moveb 0x0,%d1
    7802:	0601 ff90      	addib #-112,%d1
    7806:	2240           	moveal %d0,%a1
    7808:	1281           	moveb %d1,%a1@
    780a:	52ae 000c      	addql #1,%fp@(12)
    780e:	202e 000c      	movel %fp@(12),%d0
    7812:	d0ae 0008      	addl %fp@(8),%d0
    7816:	2040           	moveal %d0,%a0
    7818:	4210           	clrb %a0@
    781a:	52ae 000c      	addql #1,%fp@(12)
    781e:	203c 0000 0000 	movel #0,%d0
    7824:	223c 0000 0000 	movel #0,%d1
    782a:	2241           	moveal %d1,%a1
    782c:	2040           	moveal %d0,%a0
    782e:	2290           	movel %a0@,%a1@
    7830:	5881           	addql #4,%d1
    7832:	5880           	addql #4,%d0
    7834:	2241           	moveal %d1,%a1
    7836:	2040           	moveal %d0,%a0
    7838:	2290           	movel %a0@,%a1@
    783a:	5881           	addql #4,%d1
    783c:	5880           	addql #4,%d0
    783e:	2241           	moveal %d1,%a1
    7840:	2040           	moveal %d0,%a0
    7842:	2290           	movel %a0@,%a1@
    7844:	5881           	addql #4,%d1
    7846:	5880           	addql #4,%d0
    7848:	202e 000c      	movel %fp@(12),%d0
    784c:	4e5e           	unlk %fp
    784e:	4e75           	rts
    7850:	4e56 fff0      	linkw %fp,#-16
    7854:	42ae fffc      	clrl %fp@(-4)
    7858:	202e 0010      	movel %fp@(16),%d0
    785c:	d1ae 000c      	addl %d0,%fp@(12)
    7860:	223c 0000 0000 	movel #0,%d1
    7866:	70f0           	moveq #-16,%d0
    7868:	d08e           	addl %fp,%d0
    786a:	2040           	moveal %d0,%a0
    786c:	2241           	moveal %d1,%a1
    786e:	2091           	movel %a1@,%a0@
    7870:	5880           	addql #4,%d0
    7872:	5881           	addql #4,%d1
    7874:	2040           	moveal %d0,%a0
    7876:	2241           	moveal %d1,%a1
    7878:	2091           	movel %a1@,%a0@
    787a:	5880           	addql #4,%d0
    787c:	5881           	addql #4,%d1
    787e:	2040           	moveal %d0,%a0
    7880:	2241           	moveal %d1,%a1
    7882:	2091           	movel %a1@,%a0@
    7884:	5880           	addql #4,%d0
    7886:	5881           	addql #4,%d1
    7888:	202e 0008      	movel %fp@(8),%d0
    788c:	1000           	moveb %d0,%d0
    788e:	0200 007f      	andib #127,%d0
    7892:	1d40 fff6      	moveb %d0,%fp@(-10)
    7896:	102e fff6      	moveb %fp@(-10),%d0
    789a:	0c00 001f      	cmpib #31,%d0
    789e:	6f00 014c      	blew 0x79ec
    78a2:	202e 0008      	movel %fp@(8),%d0
    78a6:	721c           	moveq #28,%d1
    78a8:	e2a8           	lsrl %d1,%d0
    78aa:	1000           	moveb %d0,%d0
    78ac:	1d40 fff0      	moveb %d0,%fp@(-16)
    78b0:	202e 0008      	movel %fp@(8),%d0
    78b4:	7218           	moveq #24,%d1
    78b6:	e2a8           	lsrl %d1,%d0
    78b8:	1000           	moveb %d0,%d0
    78ba:	0200 000f      	andib #15,%d0
    78be:	1d40 fff1      	moveb %d0,%fp@(-15)
    78c2:	202e 0008      	movel %fp@(8),%d0
    78c6:	7214           	moveq #20,%d1
    78c8:	e2a8           	lsrl %d1,%d0
    78ca:	1000           	moveb %d0,%d0
    78cc:	0200 000f      	andib #15,%d0
    78d0:	1d40 fff3      	moveb %d0,%fp@(-13)
    78d4:	202e 0008      	movel %fp@(8),%d0
    78d8:	4240           	clrw %d0
    78da:	4840           	swap %d0
    78dc:	1000           	moveb %d0,%d0
    78de:	0200 000f      	andib #15,%d0
    78e2:	1d40 fff2      	moveb %d0,%fp@(-14)
    78e6:	202e 0008      	movel %fp@(8),%d0
    78ea:	720b           	moveq #11,%d1
    78ec:	e2a8           	lsrl %d1,%d0
    78ee:	1000           	moveb %d0,%d0
    78f0:	0200 001f      	andib #31,%d0
    78f4:	1d40 fff4      	moveb %d0,%fp@(-12)
    78f8:	202e 0008      	movel %fp@(8),%d0
    78fc:	ee88           	lsrl #7,%d0
    78fe:	1000           	moveb %d0,%d0
    7900:	0200 000f      	andib #15,%d0
    7904:	1d40 fff5      	moveb %d0,%fp@(-11)
    7908:	122e fff0      	moveb %fp@(-16),%d1
    790c:	1039 0000 0000 	moveb 0x0,%d0
    7912:	b001           	cmpb %d1,%d0
    7914:	6718           	beqs 0x792e
    7916:	202e fffc      	movel %fp@(-4),%d0
    791a:	d0ae 000c      	addl %fp@(12),%d0
    791e:	122e fff0      	moveb %fp@(-16),%d1
    7922:	0601 fff0      	addib #-16,%d1
    7926:	2040           	moveal %d0,%a0
    7928:	1081           	moveb %d1,%a0@
    792a:	52ae fffc      	addql #1,%fp@(-4)
    792e:	122e fff1      	moveb %fp@(-15),%d1
    7932:	1039 0000 0000 	moveb 0x0,%d0
    7938:	b001           	cmpb %d1,%d0
    793a:	6718           	beqs 0x7954
    793c:	202e fffc      	movel %fp@(-4),%d0
    7940:	d0ae 000c      	addl %fp@(12),%d0
    7944:	122e fff1      	moveb %fp@(-15),%d1
    7948:	0601 ffe0      	addib #-32,%d1
    794c:	2240           	moveal %d0,%a1
    794e:	1281           	moveb %d1,%a1@
    7950:	52ae fffc      	addql #1,%fp@(-4)
    7954:	122e fff2      	moveb %fp@(-14),%d1
    7958:	1039 0000 0000 	moveb 0x0,%d0
    795e:	b001           	cmpb %d1,%d0
    7960:	6718           	beqs 0x797a
    7962:	202e fffc      	movel %fp@(-4),%d0
    7966:	d0ae 000c      	addl %fp@(12),%d0
    796a:	122e fff2      	moveb %fp@(-14),%d1
    796e:	0601 ffd0      	addib #-48,%d1
    7972:	2040           	moveal %d0,%a0
    7974:	1081           	moveb %d1,%a0@
    7976:	52ae fffc      	addql #1,%fp@(-4)
    797a:	122e fff3      	moveb %fp@(-13),%d1
    797e:	1039 0000 0000 	moveb 0x0,%d0
    7984:	b001           	cmpb %d1,%d0
    7986:	6718           	beqs 0x79a0
    7988:	202e fffc      	movel %fp@(-4),%d0
    798c:	d0ae 000c      	addl %fp@(12),%d0
    7990:	122e fff3      	moveb %fp@(-13),%d1
    7994:	0601 ffc0      	addib #-64,%d1
    7998:	2240           	moveal %d0,%a1
    799a:	1281           	moveb %d1,%a1@
    799c:	52ae fffc      	addql #1,%fp@(-4)
    79a0:	122e fff4      	moveb %fp@(-12),%d1
    79a4:	1039 0000 0000 	moveb 0x0,%d0
    79aa:	b001           	cmpb %d1,%d0
    79ac:	6718           	beqs 0x79c6
    79ae:	202e fffc      	movel %fp@(-4),%d0
    79b2:	d0ae 000c      	addl %fp@(12),%d0
    79b6:	122e fff4      	moveb %fp@(-12),%d1
    79ba:	0601 ffa0      	addib #-96,%d1
    79be:	2040           	moveal %d0,%a0
    79c0:	1081           	moveb %d1,%a0@
    79c2:	52ae fffc      	addql #1,%fp@(-4)
    79c6:	122e fff5      	moveb %fp@(-11),%d1
    79ca:	1039 0000 0000 	moveb 0x0,%d0
    79d0:	b001           	cmpb %d1,%d0
    79d2:	6718           	beqs 0x79ec
    79d4:	202e fffc      	movel %fp@(-4),%d0
    79d8:	d0ae 000c      	addl %fp@(12),%d0
    79dc:	122e fff5      	moveb %fp@(-11),%d1
    79e0:	0601 ff90      	addib #-112,%d1
    79e4:	2240           	moveal %d0,%a1
    79e6:	1281           	moveb %d1,%a1@
    79e8:	52ae fffc      	addql #1,%fp@(-4)
    79ec:	122e fff6      	moveb %fp@(-10),%d1
    79f0:	1039 0000 0000 	moveb 0x0,%d0
    79f6:	b001           	cmpb %d1,%d0
    79f8:	6606           	bnes 0x7a00
    79fa:	4aae fffc      	tstl %fp@(-4)
    79fe:	671e           	beqs 0x7a1e
    7a00:	202e fffc      	movel %fp@(-4),%d0
    7a04:	d0ae 000c      	addl %fp@(12),%d0
    7a08:	122e fff6      	moveb %fp@(-10),%d1
    7a0c:	2040           	moveal %d0,%a0
    7a0e:	1081           	moveb %d1,%a0@
    7a10:	52ae fffc      	addql #1,%fp@(-4)
    7a14:	7001           	moveq #1,%d0
    7a16:	2d40 fff8      	movel %d0,%fp@(-8)
    7a1a:	6000 0180      	braw 0x7b9c
    7a1e:	202e fff8      	movel %fp@(-8),%d0
    7a22:	5280           	addql #1,%d0
    7a24:	2d40 fff8      	movel %d0,%fp@(-8)
    7a28:	202e fff8      	movel %fp@(-8),%d0
    7a2c:	7202           	moveq #2,%d1
    7a2e:	b280           	cmpl %d0,%d1
    7a30:	6618           	bnes 0x7a4a
    7a32:	202e fffc      	movel %fp@(-4),%d0
    7a36:	d0ae 000c      	addl %fp@(12),%d0
    7a3a:	122e fff6      	moveb %fp@(-10),%d1
    7a3e:	2040           	moveal %d0,%a0
    7a40:	1081           	moveb %d1,%a0@
    7a42:	52ae fffc      	addql #1,%fp@(-4)
    7a46:	6000 0154      	braw 0x7b9c
    7a4a:	202e fff8      	movel %fp@(-8),%d0
    7a4e:	7203           	moveq #3,%d1
    7a50:	b280           	cmpl %d0,%d1
    7a52:	6610           	bnes 0x7a64
    7a54:	202e 000c      	movel %fp@(12),%d0
    7a58:	5380           	subql #1,%d0
    7a5a:	2040           	moveal %d0,%a0
    7a5c:	10bc ff80      	moveb #-128,%a0@
    7a60:	6000 013a      	braw 0x7b9c
    7a64:	202e fff8      	movel %fp@(-8),%d0
    7a68:	7213           	moveq #19,%d1
    7a6a:	b280           	cmpl %d0,%d1
    7a6c:	6622           	bnes 0x7a90
    7a6e:	202e fffc      	movel %fp@(-4),%d0
    7a72:	d0ae 000c      	addl %fp@(12),%d0
    7a76:	2040           	moveal %d0,%a0
    7a78:	10bc ff80      	moveb #-128,%a0@
    7a7c:	52ae fffc      	addql #1,%fp@(-4)
    7a80:	202e 000c      	movel %fp@(12),%d0
    7a84:	5380           	subql #1,%d0
    7a86:	2240           	moveal %d0,%a1
    7a88:	12bc ff8f      	moveb #-113,%a1@
    7a8c:	6000 010e      	braw 0x7b9c
    7a90:	202e fff8      	movel %fp@(-8),%d0
    7a94:	0c80 0000 0104 	cmpil #260,%d0
    7a9a:	662e           	bnes 0x7aca
    7a9c:	202e 000c      	movel %fp@(12),%d0
    7aa0:	5580           	subql #2,%d0
    7aa2:	2040           	moveal %d0,%a0
    7aa4:	10bc ff8f      	moveb #-113,%a0@
    7aa8:	202e 000c      	movel %fp@(12),%d0
    7aac:	5380           	subql #1,%d0
    7aae:	2240           	moveal %d0,%a1
    7ab0:	12bc ff8f      	moveb #-113,%a1@
    7ab4:	202e fffc      	movel %fp@(-4),%d0
    7ab8:	d0ae 000c      	addl %fp@(12),%d0
    7abc:	2040           	moveal %d0,%a0
    7abe:	10bc ff80      	moveb #-128,%a0@
    7ac2:	52ae fffc      	addql #1,%fp@(-4)
    7ac6:	6000 00d4      	braw 0x7b9c
    7aca:	202e fff8      	movel %fp@(-8),%d0
    7ace:	7212           	moveq #18,%d1
    7ad0:	b280           	cmpl %d0,%d1
    7ad2:	6d14           	blts 0x7ae8
    7ad4:	202e 000c      	movel %fp@(12),%d0
    7ad8:	5380           	subql #1,%d0
    7ada:	2040           	moveal %d0,%a0
    7adc:	1210           	moveb %a0@,%d1
    7ade:	5201           	addqb #1,%d1
    7ae0:	2240           	moveal %d0,%a1
    7ae2:	1281           	moveb %d1,%a1@
    7ae4:	6000 00b6      	braw 0x7b9c
    7ae8:	202e fff8      	movel %fp@(-8),%d0
    7aec:	0c80 0000 0103 	cmpil #259,%d0
    7af2:	6e40           	bgts 0x7b34
    7af4:	202e 000c      	movel %fp@(12),%d0
    7af8:	5580           	subql #2,%d0
    7afa:	2040           	moveal %d0,%a0
    7afc:	1210           	moveb %a0@,%d1
    7afe:	5201           	addqb #1,%d1
    7b00:	2240           	moveal %d0,%a1
    7b02:	1281           	moveb %d1,%a1@
    7b04:	202e 000c      	movel %fp@(12),%d0
    7b08:	5580           	subql #2,%d0
    7b0a:	2040           	moveal %d0,%a0
    7b0c:	1010           	moveb %a0@,%d0
    7b0e:	0c00 ff90      	cmpib #-112,%d0
    7b12:	6600 0088      	bnew 0x7b9c
    7b16:	202e 000c      	movel %fp@(12),%d0
    7b1a:	5580           	subql #2,%d0
    7b1c:	2240           	moveal %d0,%a1
    7b1e:	12bc ff80      	moveb #-128,%a1@
    7b22:	202e 000c      	movel %fp@(12),%d0
    7b26:	5380           	subql #1,%d0
    7b28:	2040           	moveal %d0,%a0
    7b2a:	1210           	moveb %a0@,%d1
    7b2c:	5201           	addqb #1,%d1
    7b2e:	2240           	moveal %d0,%a1
    7b30:	1281           	moveb %d1,%a1@
    7b32:	6068           	bras 0x7b9c
    7b34:	202e 000c      	movel %fp@(12),%d0
    7b38:	5780           	subql #3,%d0
    7b3a:	2040           	moveal %d0,%a0
    7b3c:	1210           	moveb %a0@,%d1
    7b3e:	5201           	addqb #1,%d1
    7b40:	2240           	moveal %d0,%a1
    7b42:	1281           	moveb %d1,%a1@
    7b44:	202e 000c      	movel %fp@(12),%d0
    7b48:	5780           	subql #3,%d0
    7b4a:	2040           	moveal %d0,%a0
    7b4c:	1010           	moveb %a0@,%d0
    7b4e:	0c00 ff90      	cmpib #-112,%d0
    7b52:	6648           	bnes 0x7b9c
    7b54:	202e 000c      	movel %fp@(12),%d0
    7b58:	5780           	subql #3,%d0
    7b5a:	2240           	moveal %d0,%a1
    7b5c:	12bc ff80      	moveb #-128,%a1@
    7b60:	202e 000c      	movel %fp@(12),%d0
    7b64:	5580           	subql #2,%d0
    7b66:	2040           	moveal %d0,%a0
    7b68:	1210           	moveb %a0@,%d1
    7b6a:	5201           	addqb #1,%d1
    7b6c:	2240           	moveal %d0,%a1
    7b6e:	1281           	moveb %d1,%a1@
    7b70:	202e 000c      	movel %fp@(12),%d0
    7b74:	5580           	subql #2,%d0
    7b76:	2040           	moveal %d0,%a0
    7b78:	1010           	moveb %a0@,%d0
    7b7a:	0c00 ff90      	cmpib #-112,%d0
    7b7e:	661c           	bnes 0x7b9c
    7b80:	202e 000c      	movel %fp@(12),%d0
    7b84:	5580           	subql #2,%d0
    7b86:	2240           	moveal %d0,%a1
    7b88:	12bc ff80      	moveb #-128,%a1@
    7b8c:	202e 000c      	movel %fp@(12),%d0
    7b90:	5380           	subql #1,%d0
    7b92:	2040           	moveal %d0,%a0
    7b94:	1210           	moveb %a0@,%d1
    7b96:	5201           	addqb #1,%d1
    7b98:	2240           	moveal %d0,%a1
    7b9a:	1281           	moveb %d1,%a1@
    7b9c:	102e fff6      	moveb %fp@(-10),%d0
    7ba0:	0c00 000a      	cmpib #10,%d0
    7ba4:	662c           	bnes 0x7bd2
    7ba6:	203c 0000 0000 	movel #0,%d0
    7bac:	223c 0000 0000 	movel #0,%d1
    7bb2:	2041           	moveal %d1,%a0
    7bb4:	2240           	moveal %d0,%a1
    7bb6:	2091           	movel %a1@,%a0@
    7bb8:	5881           	addql #4,%d1
    7bba:	5880           	addql #4,%d0
    7bbc:	2041           	moveal %d1,%a0
    7bbe:	2240           	moveal %d0,%a1
    7bc0:	2091           	movel %a1@,%a0@
    7bc2:	5881           	addql #4,%d1
    7bc4:	5880           	addql #4,%d0
    7bc6:	2041           	moveal %d1,%a0
    7bc8:	2240           	moveal %d0,%a1
    7bca:	2091           	movel %a1@,%a0@
    7bcc:	5881           	addql #4,%d1
    7bce:	5880           	addql #4,%d0
    7bd0:	6028           	bras 0x7bfa
    7bd2:	70f0           	moveq #-16,%d0
    7bd4:	d08e           	addl %fp,%d0
    7bd6:	223c 0000 0000 	movel #0,%d1
    7bdc:	2041           	moveal %d1,%a0
    7bde:	2240           	moveal %d0,%a1
    7be0:	2091           	movel %a1@,%a0@
    7be2:	5881           	addql #4,%d1
    7be4:	5880           	addql #4,%d0
    7be6:	2041           	moveal %d1,%a0
    7be8:	2240           	moveal %d0,%a1
    7bea:	2091           	movel %a1@,%a0@
    7bec:	5881           	addql #4,%d1
    7bee:	5880           	addql #4,%d0
    7bf0:	2041           	moveal %d1,%a0
    7bf2:	2240           	moveal %d0,%a1
    7bf4:	2091           	movel %a1@,%a0@
    7bf6:	5881           	addql #4,%d1
    7bf8:	5880           	addql #4,%d0
    7bfa:	202e fffc      	movel %fp@(-4),%d0
    7bfe:	4e5e           	unlk %fp
    7c00:	4e75           	rts
    7c02:	4e56 0000      	linkw %fp,#0
    7c06:	4aae 0008      	tstl %fp@(8)
    7c0a:	6710           	beqs 0x7c1c
    7c0c:	42a7           	clrl %sp@-
    7c0e:	2f2e 0008      	movel %fp@(8),%sp@-
    7c12:	4eba fafa      	jsr %pc@(0x770e)
    7c16:	508f           	addql #8,%sp
    7c18:	5380           	subql #1,%d0
    7c1a:	6002           	bras 0x7c1e
    7c1c:	4280           	clrl %d0
    7c1e:	4e5e           	unlk %fp
    7c20:	4e75           	rts
    7c22:	4e56 fffc      	linkw %fp,#-4
    7c26:	42ae fffc      	clrl %fp@(-4)
    7c2a:	4aae 0008      	tstl %fp@(8)
    7c2e:	662e           	bnes 0x7c5e
    7c30:	203c 0000 0000 	movel #0,%d0
    7c36:	223c 0000 0000 	movel #0,%d1
    7c3c:	2041           	moveal %d1,%a0
    7c3e:	2240           	moveal %d0,%a1
    7c40:	2091           	movel %a1@,%a0@
    7c42:	5881           	addql #4,%d1
    7c44:	5880           	addql #4,%d0
    7c46:	2041           	moveal %d1,%a0
    7c48:	2240           	moveal %d0,%a1
    7c4a:	2091           	movel %a1@,%a0@
    7c4c:	5881           	addql #4,%d1
    7c4e:	5880           	addql #4,%d0
    7c50:	2041           	moveal %d1,%a0
    7c52:	2240           	moveal %d0,%a1
    7c54:	2091           	movel %a1@,%a0@
    7c56:	5881           	addql #4,%d1
    7c58:	5880           	addql #4,%d0
    7c5a:	4280           	clrl %d0
    7c5c:	601e           	bras 0x7c7c
    7c5e:	202e 0008      	movel %fp@(8),%d0
    7c62:	2f2e fffc      	movel %fp@(-4),%sp@-
    7c66:	2f00           	movel %d0,%sp@-
    7c68:	2f2e 000c      	movel %fp@(12),%sp@-
    7c6c:	4eba fbe2      	jsr %pc@(0x7850)
    7c70:	4fef 000c      	lea %sp@(12),%sp
    7c74:	d1ae fffc      	addl %d0,%fp@(-4)
    7c78:	202e fffc      	movel %fp@(-4),%d0
    7c7c:	4e5e           	unlk %fp
    7c7e:	4e75           	rts
    7c80:	4e56 fff8      	linkw %fp,#-8
    7c84:	42ae fffc      	clrl %fp@(-4)
    7c88:	42ae fff8      	clrl %fp@(-8)
    7c8c:	4aae 0008      	tstl %fp@(8)
    7c90:	665a           	bnes 0x7cec
    7c92:	203c 0000 0000 	movel #0,%d0
    7c98:	223c 0000 0000 	movel #0,%d1
    7c9e:	2041           	moveal %d1,%a0
    7ca0:	2240           	moveal %d0,%a1
    7ca2:	2091           	movel %a1@,%a0@
    7ca4:	5881           	addql #4,%d1
    7ca6:	5880           	addql #4,%d0
    7ca8:	2041           	moveal %d1,%a0
    7caa:	2240           	moveal %d0,%a1
    7cac:	2091           	movel %a1@,%a0@
    7cae:	5881           	addql #4,%d1
    7cb0:	5880           	addql #4,%d0
    7cb2:	2041           	moveal %d1,%a0
    7cb4:	2240           	moveal %d0,%a1
    7cb6:	2091           	movel %a1@,%a0@
    7cb8:	5881           	addql #4,%d1
    7cba:	5880           	addql #4,%d0
    7cbc:	4280           	clrl %d0
    7cbe:	6048           	bras 0x7d08
    7cc0:	222e 0008      	movel %fp@(8),%d1
    7cc4:	202e fff8      	movel %fp@(-8),%d0
    7cc8:	e588           	lsll #2,%d0
    7cca:	d0ae 000c      	addl %fp@(12),%d0
    7cce:	2040           	moveal %d0,%a0
    7cd0:	2010           	movel %a0@,%d0
    7cd2:	52ae fff8      	addql #1,%fp@(-8)
    7cd6:	2f2e fffc      	movel %fp@(-4),%sp@-
    7cda:	2f01           	movel %d1,%sp@-
    7cdc:	2f00           	movel %d0,%sp@-
    7cde:	4eba fb70      	jsr %pc@(0x7850)
    7ce2:	4fef 000c      	lea %sp@(12),%sp
    7ce6:	d1ae fffc      	addl %d0,%fp@(-4)
    7cea:	6002           	bras 0x7cee
    7cec:	4e71           	nop
    7cee:	202e fff8      	movel %fp@(-8),%d0
    7cf2:	b0ae 0010      	cmpl %fp@(16),%d0
    7cf6:	65c8           	bcss 0x7cc0
    7cf8:	2f2e fffc      	movel %fp@(-4),%sp@-
    7cfc:	2f2e 0008      	movel %fp@(8),%sp@-
    7d00:	4eba fa0c      	jsr %pc@(0x770e)
    7d04:	508f           	addql #8,%sp
    7d06:	5380           	subql #1,%d0
    7d08:	4e5e           	unlk %fp
    7d0a:	4e75           	rts
    7d0c:	4e56 0000      	linkw %fp,#0
    7d10:	202e 0008      	movel %fp@(8),%d0
    7d14:	2040           	moveal %d0,%a0
    7d16:	2028 0004      	movel %a0@(4),%d0
    7d1a:	727f           	moveq #127,%d1
    7d1c:	4601           	notb %d1
    7d1e:	c081           	andl %d1,%d0
    7d20:	4a80           	tstl %d0
    7d22:	6638           	bnes 0x7d5c
    7d24:	202e 0008      	movel %fp@(8),%d0
    7d28:	2040           	moveal %d0,%a0
    7d2a:	2028 0004      	movel %a0@(4),%d0
    7d2e:	0280 0000 0100 	andil #256,%d0
    7d34:	4a80           	tstl %d0
    7d36:	6738           	beqs 0x7d70
    7d38:	202e 0008      	movel %fp@(8),%d0
    7d3c:	2240           	moveal %d0,%a1
    7d3e:	2229 0012      	movel %a1@(18),%d1
    7d42:	202e 0008      	movel %fp@(8),%d0
    7d46:	2240           	moveal %d0,%a1
    7d48:	2069 000e      	moveal %a1@(14),%a0
    7d4c:	202e 0008      	movel %fp@(8),%d0
    7d50:	2240           	moveal %d0,%a1
    7d52:	2029 000a      	movel %a1@(10),%d0
    7d56:	d088           	addl %a0,%d0
    7d58:	b081           	cmpl %d1,%d0
    7d5a:	6214           	bhis 0x7d70
    7d5c:	2f2e 0008      	movel %fp@(8),%sp@-
    7d60:	4eb9 0000 0000 	jsr 0x0
    7d66:	588f           	addql #4,%sp
    7d68:	4a80           	tstl %d0
    7d6a:	671a           	beqs 0x7d86
    7d6c:	70ff           	moveq #-1,%d0
    7d6e:	6050           	bras 0x7dc0
    7d70:	202e 0008      	movel %fp@(8),%d0
    7d74:	2040           	moveal %d0,%a0
    7d76:	2028 0004      	movel %a0@(4),%d0
    7d7a:	0280 0000 0100 	andil #256,%d0
    7d80:	4a80           	tstl %d0
    7d82:	663a           	bnes 0x7dbe
    7d84:	6002           	bras 0x7d88
    7d86:	4e71           	nop
    7d88:	202e 0008      	movel %fp@(8),%d0
    7d8c:	2240           	moveal %d0,%a1
    7d8e:	2029 0004      	movel %a1@(4),%d0
    7d92:	2200           	movel %d0,%d1
    7d94:	0241 fe7f      	andiw #-385,%d1
    7d98:	202e 0008      	movel %fp@(8),%d0
    7d9c:	2040           	moveal %d0,%a0
    7d9e:	2141 0004      	movel %d1,%a0@(4)
    7da2:	202e 0008      	movel %fp@(8),%d0
    7da6:	2240           	moveal %d0,%a1
    7da8:	4291           	clrl %a1@
    7daa:	202e 0008      	movel %fp@(8),%d0
    7dae:	2040           	moveal %d0,%a0
    7db0:	2228 000e      	movel %a0@(14),%d1
    7db4:	202e 0008      	movel %fp@(8),%d0
    7db8:	2240           	moveal %d0,%a1
    7dba:	2341 0012      	movel %d1,%a1@(18)
    7dbe:	4280           	clrl %d0
    7dc0:	4e5e           	unlk %fp
    7dc2:	4e75           	rts
    7dc4:	4e56 fff0      	linkw %fp,#-16
    7dc8:	48e7 2000      	moveml %d2,%sp@-
    7dcc:	206e 0008      	moveal %fp@(8),%a0
    7dd0:	2d50 fff0      	movel %a0@,%fp@(-16)
    7dd4:	2d68 0004 fff4 	movel %a0@(4),%fp@(-12)
    7dda:	2d6e fff0 fffc 	movel %fp@(-16),%fp@(-4)
    7de0:	4aae fffc      	tstl %fp@(-4)
    7de4:	6718           	beqs 0x7dfe
    7de6:	202e fff0      	movel %fp@(-16),%d0
    7dea:	222e fffc      	movel %fp@(-4),%d1
    7dee:	242e 000c      	movel %fp@(12),%d2
    7df2:	4c42 0001      	divull %d2,%d1,%d0
    7df6:	2d40 fff0      	movel %d0,%fp@(-16)
    7dfa:	2d41 fffc      	movel %d1,%fp@(-4)
    7dfe:	202e fff4      	movel %fp@(-12),%d0
    7e02:	222e fffc      	movel %fp@(-4),%d1
    7e06:	242e 000c      	movel %fp@(12),%d2
    7e0a:	4c42 0401      	divul %d2,%d1,%d0
    7e0e:	2d40 fff4      	movel %d0,%fp@(-12)
    7e12:	2d41 fff8      	movel %d1,%fp@(-8)
    7e16:	20ae fff0      	movel %fp@(-16),%a0@
    7e1a:	216e fff4 0004 	movel %fp@(-12),%a0@(4)
    7e20:	202e fff8      	movel %fp@(-8),%d0
    7e24:	4cdf 0004      	moveml %sp@+,%d2
    7e28:	4e5e           	unlk %fp
    7e2a:	4e75           	rts
    7e2c:	4e56 0000      	linkw %fp,#0
    7e30:	206e 0008      	moveal %fp@(8),%a0
    7e34:	2010           	movel %a0@,%d0
    7e36:	222e 000c      	movel %fp@(12),%d1
    7e3a:	6118           	bsrs 0x7e54
    7e3c:	2081           	movel %d1,%a0@
    7e3e:	4e5e           	unlk %fp
    7e40:	4e75           	rts
    7e42:	4e56 0000      	linkw %fp,#0
    7e46:	222e 0008      	movel %fp@(8),%d1
    7e4a:	202e 000c      	movel %fp@(12),%d0
    7e4e:	6104           	bsrs 0x7e54
    7e50:	4e5e           	unlk %fp
    7e52:	4e75           	rts
    7e54:	4c40 1000      	divull %d0,%d0,%d1
    7e58:	4e75           	rts
    7e5a:	41ef 0004      	lea %sp@(4),%a0
    7e5e:	2f28 0004      	movel %a0@(4),%sp@-
    7e62:	2f10           	movel %a0@,%sp@-
    7e64:	6100 ffdc      	bsrw 0x7e42
    7e68:	508f           	addql #8,%sp
    7e6a:	2f00           	movel %d0,%sp@-
    7e6c:	2f01           	movel %d1,%sp@-
    7e6e:	201f           	movel %sp@+,%d0
    7e70:	221f           	movel %sp@+,%d1
    7e72:	4e75           	rts
    7e74:	4e56 0000      	linkw %fp,#0
    7e78:	23ee 0008 0000 	movel %fp@(8),0x0
    7e7e:	0000 
    7e80:	4e5e           	unlk %fp
    7e82:	4e75           	rts
    7e84:	4e56 0000      	linkw %fp,#0
    7e88:	2039 0000 0000 	movel 0x0,%d0
    7e8e:	4c3c 0800 015a 	mulsl #22695477,%d0
    7e94:	4e35 
    7e96:	5280           	addql #1,%d0
    7e98:	23c0 0000 0000 	movel %d0,0x0
    7e9e:	2039 0000 0000 	movel 0x0,%d0
    7ea4:	4240           	clrw %d0
    7ea6:	4840           	swap %d0
    7ea8:	0280 0000 7fff 	andil #32767,%d0
    7eae:	4e5e           	unlk %fp
    7eb0:	4e75           	rts
    7eb2:	4e71           	nop
    7eb4:	4e56 0000      	linkw %fp,#0
    7eb8:	4aae 0008      	tstl %fp@(8)
    7ebc:	6c08           	bges 0x7ec6
    7ebe:	202e 0008      	movel %fp@(8),%d0
    7ec2:	4480           	negl %d0
    7ec4:	6004           	bras 0x7eca
    7ec6:	202e 0008      	movel %fp@(8),%d0
    7eca:	4e5e           	unlk %fp
    7ecc:	4e75           	rts
    7ece:	4e56 0000      	linkw %fp,#0
    7ed2:	4aae 0008      	tstl %fp@(8)
    7ed6:	6c08           	bges 0x7ee0
    7ed8:	202e 0008      	movel %fp@(8),%d0
    7edc:	4480           	negl %d0
    7ede:	6004           	bras 0x7ee4
    7ee0:	202e 0008      	movel %fp@(8),%d0
    7ee4:	4e5e           	unlk %fp
    7ee6:	4e75           	rts
    7ee8:	4e56 0000      	linkw %fp,#0
    7eec:	4aae 0008      	tstl %fp@(8)
    7ef0:	6c08           	bges 0x7efa
    7ef2:	202e 0008      	movel %fp@(8),%d0
    7ef6:	4480           	negl %d0
    7ef8:	6004           	bras 0x7efe
    7efa:	202e 0008      	movel %fp@(8),%d0
    7efe:	4e5e           	unlk %fp
    7f00:	4e75           	rts
    7f02:	4e71           	nop
    7f04:	4e56 fff8      	linkw %fp,#-8
    7f08:	2f02           	movel %d2,%sp@-
    7f0a:	202e 000c      	movel %fp@(12),%d0
    7f0e:	2040           	moveal %d0,%a0
    7f10:	4210           	clrb %a0@
    7f12:	202e 0010      	movel %fp@(16),%d0
    7f16:	2040           	moveal %d0,%a0
    7f18:	4210           	clrb %a0@
    7f1a:	202e 0014      	movel %fp@(20),%d0
    7f1e:	2040           	moveal %d0,%a0
    7f20:	4210           	clrb %a0@
    7f22:	202e 0018      	movel %fp@(24),%d0
    7f26:	2040           	moveal %d0,%a0
    7f28:	4210           	clrb %a0@
    7f2a:	2d6e 0008 fffc 	movel %fp@(8),%fp@(-4)
    7f30:	4878 003a      	pea 0x3a
    7f34:	2f2e fffc      	movel %fp@(-4),%sp@-
    7f38:	4eb9 0000 0000 	jsr 0x0
    7f3e:	508f           	addql #8,%sp
    7f40:	2008           	movel %a0,%d0
    7f42:	222e fffc      	movel %fp@(-4),%d1
    7f46:	2400           	movel %d0,%d2
    7f48:	9481           	subl %d1,%d2
    7f4a:	2d42 fff8      	movel %d2,%fp@(-8)
    7f4e:	4aae fff8      	tstl %fp@(-8)
    7f52:	6f2e           	bles 0x7f82
    7f54:	202e fff8      	movel %fp@(-8),%d0
    7f58:	2f00           	movel %d0,%sp@-
    7f5a:	2f2e fffc      	movel %fp@(-4),%sp@-
    7f5e:	2f2e 000c      	movel %fp@(12),%sp@-
    7f62:	4eb9 0000 0000 	jsr 0x0
    7f68:	4fef 000c      	lea %sp@(12),%sp
    7f6c:	202e fff8      	movel %fp@(-8),%d0
    7f70:	d0ae 000c      	addl %fp@(12),%d0
    7f74:	2040           	moveal %d0,%a0
    7f76:	4210           	clrb %a0@
    7f78:	202e fff8      	movel %fp@(-8),%d0
    7f7c:	5280           	addql #1,%d0
    7f7e:	d1ae fffc      	addl %d0,%fp@(-4)
    7f82:	4878 002f      	pea 0x2f
    7f86:	2f2e fffc      	movel %fp@(-4),%sp@-
    7f8a:	4eb9 0000 0000 	jsr 0x0
    7f90:	508f           	addql #8,%sp
    7f92:	2008           	movel %a0,%d0
    7f94:	222e fffc      	movel %fp@(-4),%d1
    7f98:	2400           	movel %d0,%d2
    7f9a:	9481           	subl %d1,%d2
    7f9c:	2d42 fff8      	movel %d2,%fp@(-8)
    7fa0:	4aae fff8      	tstl %fp@(-8)
    7fa4:	6d30           	blts 0x7fd6
    7fa6:	52ae fff8      	addql #1,%fp@(-8)
    7faa:	202e fff8      	movel %fp@(-8),%d0
    7fae:	2f00           	movel %d0,%sp@-
    7fb0:	2f2e fffc      	movel %fp@(-4),%sp@-
    7fb4:	2f2e 0010      	movel %fp@(16),%sp@-
    7fb8:	4eb9 0000 0000 	jsr 0x0
    7fbe:	4fef 000c      	lea %sp@(12),%sp
    7fc2:	202e fff8      	movel %fp@(-8),%d0
    7fc6:	d0ae 0010      	addl %fp@(16),%d0
    7fca:	2040           	moveal %d0,%a0
    7fcc:	4210           	clrb %a0@
    7fce:	202e fff8      	movel %fp@(-8),%d0
    7fd2:	d1ae fffc      	addl %d0,%fp@(-4)
    7fd6:	4878 002e      	pea 0x2e
    7fda:	2f2e fffc      	movel %fp@(-4),%sp@-
    7fde:	4eb9 0000 0000 	jsr 0x0
    7fe4:	508f           	addql #8,%sp
    7fe6:	2008           	movel %a0,%d0
    7fe8:	222e fffc      	movel %fp@(-4),%d1
    7fec:	2400           	movel %d0,%d2
    7fee:	9481           	subl %d1,%d2
    7ff0:	2d42 fff8      	movel %d2,%fp@(-8)
    7ff4:	4aae fff8      	tstl %fp@(-8)
    7ff8:	6f2e           	bles 0x8028
    7ffa:	202e fff8      	movel %fp@(-8),%d0
    7ffe:	2f00           	movel %d0,%sp@-
    8000:	2f2e fffc      	movel %fp@(-4),%sp@-
    8004:	2f2e 0014      	movel %fp@(20),%sp@-
    8008:	4eb9 0000 0000 	jsr 0x0
    800e:	4fef 000c      	lea %sp@(12),%sp
    8012:	202e fff8      	movel %fp@(-8),%d0
    8016:	d0ae 0014      	addl %fp@(20),%d0
    801a:	2040           	moveal %d0,%a0
    801c:	4210           	clrb %a0@
    801e:	202e fff8      	movel %fp@(-8),%d0
    8022:	5280           	addql #1,%d0
    8024:	d1ae fffc      	addl %d0,%fp@(-4)
    8028:	2f2e fffc      	movel %fp@(-4),%sp@-
    802c:	4eb9 0000 0000 	jsr 0x0
    8032:	588f           	addql #4,%sp
    8034:	2f00           	movel %d0,%sp@-
    8036:	2f2e fffc      	movel %fp@(-4),%sp@-
    803a:	2f2e 0018      	movel %fp@(24),%sp@-
    803e:	4eb9 0000 0000 	jsr 0x0
    8044:	4fef 000c      	lea %sp@(12),%sp
    8048:	2f2e fffc      	movel %fp@(-4),%sp@-
    804c:	4eb9 0000 0000 	jsr 0x0
    8052:	588f           	addql #4,%sp
    8054:	d0ae 0018      	addl %fp@(24),%d0
    8058:	2040           	moveal %d0,%a0
    805a:	4210           	clrb %a0@
    805c:	242e fff4      	movel %fp@(-12),%d2
    8060:	4e5e           	unlk %fp
    8062:	4e75           	rts
    8064:	4e56 fffc      	linkw %fp,#-4
    8068:	700a           	moveq #10,%d0
    806a:	2d40 fffc      	movel %d0,%fp@(-4)
    806e:	602a           	bras 0x809a
    8070:	202e fffc      	movel %fp@(-4),%d0
    8074:	0680 0000 0000 	addil #0,%d0
    807a:	2040           	moveal %d0,%a0
    807c:	1010           	moveb %a0@,%d0
    807e:	4a00           	tstb %d0
    8080:	6614           	bnes 0x8096
    8082:	202e fffc      	movel %fp@(-4),%d0
    8086:	0680 0000 0000 	addil #0,%d0
    808c:	2040           	moveal %d0,%a0
    808e:	50d0           	st %a0@
    8090:	202e fffc      	movel %fp@(-4),%d0
    8094:	600e           	bras 0x80a4
    8096:	52ae fffc      	addql #1,%fp@(-4)
    809a:	0cae 0000 00fe 	cmpil #254,%fp@(-4)
    80a0:	fffc 
    80a2:	6fcc           	bles 0x8070
    80a4:	4e5e           	unlk %fp
    80a6:	4e75           	rts
    80a8:	4e56 0000      	linkw %fp,#0
    80ac:	202e 0008      	movel %fp@(8),%d0
    80b0:	0680 0000 0000 	addil #0,%d0
    80b6:	2040           	moveal %d0,%a0
    80b8:	4210           	clrb %a0@
    80ba:	4e5e           	unlk %fp
    80bc:	4e75           	rts
    80be:	4e56 fff0      	linkw %fp,#-16
    80c2:	4aae 0008      	tstl %fp@(8)
    80c6:	6616           	bnes 0x80de
    80c8:	4879 0000 0000 	pea 0x0
    80ce:	70f2           	moveq #-14,%d0
    80d0:	d08e           	addl %fp,%d0
    80d2:	2f00           	movel %d0,%sp@-
    80d4:	4eb9 0000 0000 	jsr 0x0
    80da:	508f           	addql #8,%sp
    80dc:	6026           	bras 0x8104
    80de:	2f2e 0008      	movel %fp@(8),%sp@-
    80e2:	70f2           	moveq #-14,%d0
    80e4:	d08e           	addl %fp,%d0
    80e6:	2f00           	movel %d0,%sp@-
    80e8:	4eb9 0000 0000 	jsr 0x0
    80ee:	508f           	addql #8,%sp
    80f0:	70f2           	moveq #-14,%d0
    80f2:	d08e           	addl %fp,%d0
    80f4:	2f00           	movel %d0,%sp@-
    80f6:	4879 0000 0000 	pea 0x0
    80fc:	4eb9 0000 0000 	jsr 0x0
    8102:	508f           	addql #8,%sp
    8104:	2d79 0000 0000 	movel 0x0,%fp@(-4)
    810a:	fffc 
    810c:	6030           	bras 0x813e
    810e:	202e fffc      	movel %fp@(-4),%d0
    8112:	2040           	moveal %d0,%a0
    8114:	2028 0004      	movel %a0@(4),%d0
    8118:	2f00           	movel %d0,%sp@-
    811a:	70f2           	moveq #-14,%d0
    811c:	d08e           	addl %fp,%d0
    811e:	2f00           	movel %d0,%sp@-
    8120:	4eb9 0000 0000 	jsr 0x0
    8126:	508f           	addql #8,%sp
    8128:	4a80           	tstl %d0
    812a:	6606           	bnes 0x8132
    812c:	202e fffc      	movel %fp@(-4),%d0
    8130:	6014           	bras 0x8146
    8132:	202e fffc      	movel %fp@(-4),%d0
    8136:	2040           	moveal %d0,%a0
    8138:	2d68 000c fffc 	movel %a0@(12),%fp@(-4)
    813e:	4aae fffc      	tstl %fp@(-4)
    8142:	66ca           	bnes 0x810e
    8144:	4280           	clrl %d0
    8146:	2200           	movel %d0,%d1
    8148:	2041           	moveal %d1,%a0
    814a:	4e5e           	unlk %fp
    814c:	4e75           	rts
    814e:	4e56 ffec      	linkw %fp,#-20
    8152:	7014           	moveq #20,%d0
    8154:	b0ae 000c      	cmpl %fp@(12),%d0
    8158:	6558           	bcss 0x81b2
    815a:	202e 000c      	movel %fp@(12),%d0
    815e:	d080           	addl %d0,%d0
    8160:	303b 0806      	movew %pc@(0x8168,%d0:l),%d0
    8164:	4efb 0002      	jmp %pc@(0x8168,%d0:w)
    8168:	002a 004a 004a 	orib #74,%a2@(74)
    816e:	0090 004a 004a 	oril #4849738,%a0@
    8174:	004a           	.short 0x004a
    8176:	004a           	.short 0x004a
    8178:	004a           	.short 0x004a
    817a:	004a           	.short 0x004a
    817c:	004a           	.short 0x004a
    817e:	004a           	.short 0x004a
    8180:	004a           	.short 0x004a
    8182:	004a           	.short 0x004a
    8184:	0032 003a 0090 	orib #58,%a2@(ffffff90,%d0:w)
    818a:	004a           	.short 0x004a
    818c:	004a           	.short 0x004a
    818e:	004a           	.short 0x004a
    8190:	0042 2d6e      	oriw #11630,%d2
    8194:	0010 fffc      	orib #-4,%a0@
    8198:	6060           	bras 0x81fa
    819a:	2d6e 0010 fff8 	movel %fp@(16),%fp@(-8)
    81a0:	6058           	bras 0x81fa
    81a2:	2d6e 0010 fff4 	movel %fp@(16),%fp@(-12)
    81a8:	6050           	bras 0x81fa
    81aa:	2d6e 0010 fff0 	movel %fp@(16),%fp@(-16)
    81b0:	6048           	bras 0x81fa
    81b2:	4aae 0008      	tstl %fp@(8)
    81b6:	6604           	bnes 0x81bc
    81b8:	7001           	moveq #1,%d0
    81ba:	6040           	bras 0x81fc
    81bc:	2f2e 0008      	movel %fp@(8),%sp@-
    81c0:	4eba fefc      	jsr %pc@(0x80be)
    81c4:	588f           	addql #4,%sp
    81c6:	2d48 ffec      	movel %a0,%fp@(-20)
    81ca:	4aae ffec      	tstl %fp@(-20)
    81ce:	6604           	bnes 0x81d4
    81d0:	7001           	moveq #1,%d0
    81d2:	6028           	bras 0x81fc
    81d4:	202e ffec      	movel %fp@(-20),%d0
    81d8:	2040           	moveal %d0,%a0
    81da:	2028 0008      	movel %a0@(8),%d0
    81de:	2040           	moveal %d0,%a0
    81e0:	2028 0014      	movel %a0@(20),%d0
    81e4:	2f2e 0010      	movel %fp@(16),%sp@-
    81e8:	2f2e 000c      	movel %fp@(12),%sp@-
    81ec:	42a7           	clrl %sp@-
    81ee:	2040           	moveal %d0,%a0
    81f0:	4e90           	jsr %a0@
    81f2:	4fef 000c      	lea %sp@(12),%sp
    81f6:	6002           	bras 0x81fa
    81f8:	4e71           	nop
    81fa:	4280           	clrl %d0
    81fc:	4e5e           	unlk %fp
    81fe:	4e75           	rts
    8200:	4e56 fff8      	linkw %fp,#-8
    8204:	4878 0010      	pea 0x10
    8208:	4eb9 0000 0000 	jsr 0x0
    820e:	588f           	addql #4,%sp
    8210:	2008           	movel %a0,%d0
    8212:	2d40 fff8      	movel %d0,%fp@(-8)
    8216:	2f2e 0008      	movel %fp@(8),%sp@-
    821a:	4eb9 0000 0000 	jsr 0x0
    8220:	588f           	addql #4,%sp
    8222:	5280           	addql #1,%d0
    8224:	2f00           	movel %d0,%sp@-
    8226:	4eb9 0000 0000 	jsr 0x0
    822c:	588f           	addql #4,%sp
    822e:	2008           	movel %a0,%d0
    8230:	2200           	movel %d0,%d1
    8232:	202e fff8      	movel %fp@(-8),%d0
    8236:	2040           	moveal %d0,%a0
    8238:	2141 0004      	movel %d1,%a0@(4)
    823c:	2f2e 000c      	movel %fp@(12),%sp@-
    8240:	4eb9 0000 0000 	jsr 0x0
    8246:	588f           	addql #4,%sp
    8248:	5280           	addql #1,%d0
    824a:	2f00           	movel %d0,%sp@-
    824c:	4eb9 0000 0000 	jsr 0x0
    8252:	588f           	addql #4,%sp
    8254:	2008           	movel %a0,%d0
    8256:	2200           	movel %d0,%d1
    8258:	202e fff8      	movel %fp@(-8),%d0
    825c:	2040           	moveal %d0,%a0
    825e:	2081           	movel %d1,%a0@
    8260:	202e fff8      	movel %fp@(-8),%d0
    8264:	2040           	moveal %d0,%a0
    8266:	2028 0004      	movel %a0@(4),%d0
    826a:	2f2e 0008      	movel %fp@(8),%sp@-
    826e:	2f00           	movel %d0,%sp@-
    8270:	4eb9 0000 0000 	jsr 0x0
    8276:	508f           	addql #8,%sp
    8278:	202e fff8      	movel %fp@(-8),%d0
    827c:	2040           	moveal %d0,%a0
    827e:	2010           	movel %a0@,%d0
    8280:	2f2e 000c      	movel %fp@(12),%sp@-
    8284:	2f00           	movel %d0,%sp@-
    8286:	4eb9 0000 0000 	jsr 0x0
    828c:	508f           	addql #8,%sp
    828e:	202e fff8      	movel %fp@(-8),%d0
    8292:	2040           	moveal %d0,%a0
    8294:	216e 0010 0008 	movel %fp@(16),%a0@(8)
    829a:	202e fff8      	movel %fp@(-8),%d0
    829e:	2040           	moveal %d0,%a0
    82a0:	42a8 000c      	clrl %a0@(12)
    82a4:	2039 0000 0000 	movel 0x0,%d0
    82aa:	4a80           	tstl %d0
    82ac:	660a           	bnes 0x82b8
    82ae:	23ee fff8 0000 	movel %fp@(-8),0x0
    82b4:	0000 
    82b6:	6030           	bras 0x82e8
    82b8:	2d79 0000 0000 	movel 0x0,%fp@(-4)
    82be:	fffc 
    82c0:	600c           	bras 0x82ce
    82c2:	202e fffc      	movel %fp@(-4),%d0
    82c6:	2040           	moveal %d0,%a0
    82c8:	2d68 000c fffc 	movel %a0@(12),%fp@(-4)
    82ce:	202e fffc      	movel %fp@(-4),%d0
    82d2:	2040           	moveal %d0,%a0
    82d4:	2028 000c      	movel %a0@(12),%d0
    82d8:	4a80           	tstl %d0
    82da:	66e6           	bnes 0x82c2
    82dc:	202e fffc      	movel %fp@(-4),%d0
    82e0:	2040           	moveal %d0,%a0
    82e2:	216e fff8 000c 	movel %fp@(-8),%a0@(12)
    82e8:	4280           	clrl %d0
    82ea:	4e5e           	unlk %fp
    82ec:	4e75           	rts
    82ee:	4e56 fff8      	linkw %fp,#-8
    82f2:	2d79 0000 0000 	movel 0x0,%fp@(-4)
    82f8:	fffc 
    82fa:	2d6e fffc fff8 	movel %fp@(-4),%fp@(-8)
    8300:	607a           	bras 0x837c
    8302:	202e fff8      	movel %fp@(-8),%d0
    8306:	2040           	moveal %d0,%a0
    8308:	2028 0004      	movel %a0@(4),%d0
    830c:	2f2e 0008      	movel %fp@(8),%sp@-
    8310:	2f00           	movel %d0,%sp@-
    8312:	4eb9 0000 0000 	jsr 0x0
    8318:	508f           	addql #8,%sp
    831a:	4a80           	tstl %d0
    831c:	665e           	bnes 0x837c
    831e:	2d6e fffc fff8 	movel %fp@(-4),%fp@(-8)
    8324:	4aae fff8      	tstl %fp@(-8)
    8328:	6708           	beqs 0x8332
    832a:	42b9 0000 0000 	clrl 0x0
    8330:	6014           	bras 0x8346
    8332:	202e fff8      	movel %fp@(-8),%d0
    8336:	2040           	moveal %d0,%a0
    8338:	2228 000c      	movel %a0@(12),%d1
    833c:	202e fffc      	movel %fp@(-4),%d0
    8340:	2040           	moveal %d0,%a0
    8342:	2141 000c      	movel %d1,%a0@(12)
    8346:	202e fff8      	movel %fp@(-8),%d0
    834a:	2040           	moveal %d0,%a0
    834c:	2010           	movel %a0@,%d0
    834e:	2f00           	movel %d0,%sp@-
    8350:	4eb9 0000 0000 	jsr 0x0
    8356:	588f           	addql #4,%sp
    8358:	202e fff8      	movel %fp@(-8),%d0
    835c:	2040           	moveal %d0,%a0
    835e:	2028 0004      	movel %a0@(4),%d0
    8362:	2f00           	movel %d0,%sp@-
    8364:	4eb9 0000 0000 	jsr 0x0
    836a:	588f           	addql #4,%sp
    836c:	2f2e fff8      	movel %fp@(-8),%sp@-
    8370:	4eb9 0000 0000 	jsr 0x0
    8376:	588f           	addql #4,%sp
    8378:	700f           	moveq #15,%d0
    837a:	6008           	bras 0x8384
    837c:	4aae fff8      	tstl %fp@(-8)
    8380:	6680           	bnes 0x8302
    8382:	4280           	clrl %d0
    8384:	4e5e           	unlk %fp
    8386:	4e75           	rts
    8388:	4e56 fffc      	linkw %fp,#-4
    838c:	42ae fffc      	clrl %fp@(-4)
    8390:	6012           	bras 0x83a4
    8392:	202e fffc      	movel %fp@(-4),%d0
    8396:	0680 0000 0000 	addil #0,%d0
    839c:	2040           	moveal %d0,%a0
    839e:	4210           	clrb %a0@
    83a0:	52ae fffc      	addql #1,%fp@(-4)
    83a4:	0cae 0000 00fe 	cmpil #254,%fp@(-4)
    83aa:	fffc 
    83ac:	6fe4           	bles 0x8392
    83ae:	42ae fffc      	clrl %fp@(-4)
    83b2:	6010           	bras 0x83c4
    83b4:	202e fffc      	movel %fp@(-4),%d0
    83b8:	42b0 0db0 0000 	clrl @(00000000,%d0:l:4)
    83be:	0000 
    83c0:	52ae fffc      	addql #1,%fp@(-4)
    83c4:	0cae 0000 00fe 	cmpil #254,%fp@(-4)
    83ca:	fffc 
    83cc:	6fe6           	bles 0x83b4
    83ce:	42b9 0000 0000 	clrl 0x0
    83d4:	1039 0000 0000 	moveb 0x0,%d0
    83da:	0c00 0004      	cmpib #4,%d0
    83de:	6210           	bhis 0x83f0
    83e0:	1039 0000 0000 	moveb 0x0,%d0
    83e6:	0600 0030      	addib #48,%d0
    83ea:	13c0 0000 0000 	moveb %d0,0x0
    83f0:	1039 0000 0000 	moveb 0x0,%d0
    83f6:	0c00 0004      	cmpib #4,%d0
    83fa:	631c           	blss 0x8418
    83fc:	1039 0000 0000 	moveb 0x0,%d0
    8402:	0c00 001e      	cmpib #30,%d0
    8406:	6210           	bhis 0x8418
    8408:	1039 0000 0000 	moveb 0x0,%d0
    840e:	0600 003c      	addib #60,%d0
    8412:	13c0 0000 0000 	moveb %d0,0x0
    8418:	4239 0000 0000 	clrb 0x0
    841e:	4239 0000 0000 	clrb 0x0
    8424:	4eb9 0000 0000 	jsr 0x0
    842a:	4e5e           	unlk %fp
    842c:	4e75           	rts
    842e:	4e56 fd64      	linkw %fp,#-668
    8432:	2d7c 0000 00ff 	movel #255,%fp@(-8)
    8438:	fff8 
    843a:	422e ffdf      	clrb %fp@(-33)
    843e:	422e fee0      	clrb %fp@(-288)
    8442:	422e fecc      	clrb %fp@(-308)
    8446:	422e fec2      	clrb %fp@(-318)
    844a:	422e fea4      	clrb %fp@(-348)
    844e:	422e fd64      	clrb %fp@(-668)
    8452:	200e           	movel %fp,%d0
    8454:	0680 ffff fec2 	addil #-318,%d0
    845a:	2f00           	movel %d0,%sp@-
    845c:	200e           	movel %fp,%d0
    845e:	0680 ffff fecc 	addil #-308,%d0
    8464:	2f00           	movel %d0,%sp@-
    8466:	200e           	movel %fp,%d0
    8468:	0680 ffff fee0 	addil #-288,%d0
    846e:	2f00           	movel %d0,%sp@-
    8470:	70df           	moveq #-33,%d0
    8472:	d08e           	addl %fp,%d0
    8474:	2f00           	movel %d0,%sp@-
    8476:	2f2e 0008      	movel %fp@(8),%sp@-
    847a:	4eba fa88      	jsr %pc@(0x7f04)
    847e:	4fef 0014      	lea %sp@(20),%sp
    8482:	200e           	movel %fp,%d0
    8484:	0680 ffff fecc 	addil #-308,%d0
    848a:	2f00           	movel %d0,%sp@-
    848c:	200e           	movel %fp,%d0
    848e:	0680 ffff fea4 	addil #-348,%d0
    8494:	2f00           	movel %d0,%sp@-
    8496:	4eb9 0000 0000 	jsr 0x0
    849c:	508f           	addql #8,%sp
    849e:	4879 0000 0000 	pea 0x0
    84a4:	200e           	movel %fp,%d0
    84a6:	0680 ffff fea4 	addil #-348,%d0
    84ac:	2f00           	movel %d0,%sp@-
    84ae:	4eb9 0000 0000 	jsr 0x0
    84b4:	508f           	addql #8,%sp
    84b6:	200e           	movel %fp,%d0
    84b8:	0680 ffff fec2 	addil #-318,%d0
    84be:	2f00           	movel %d0,%sp@-
    84c0:	200e           	movel %fp,%d0
    84c2:	0680 ffff fea4 	addil #-348,%d0
    84c8:	2f00           	movel %d0,%sp@-
    84ca:	4eb9 0000 0000 	jsr 0x0
    84d0:	508f           	addql #8,%sp
    84d2:	4879 0000 0000 	pea 0x0
    84d8:	70df           	moveq #-33,%d0
    84da:	d08e           	addl %fp,%d0
    84dc:	2f00           	movel %d0,%sp@-
    84de:	4eb9 0000 0000 	jsr 0x0
    84e4:	508f           	addql #8,%sp
    84e6:	4a80           	tstl %d0
    84e8:	6614           	bnes 0x84fe
    84ea:	70df           	moveq #-33,%d0
    84ec:	d08e           	addl %fp,%d0
    84ee:	2f00           	movel %d0,%sp@-
    84f0:	4879 0000 0000 	pea 0x0
    84f6:	4eb9 0000 0000 	jsr 0x0
    84fc:	508f           	addql #8,%sp
    84fe:	70df           	moveq #-33,%d0
    8500:	d08e           	addl %fp,%d0
    8502:	2f00           	movel %d0,%sp@-
    8504:	4eb9 0000 0000 	jsr 0x0
    850a:	588f           	addql #4,%sp
    850c:	4a80           	tstl %d0
    850e:	6614           	bnes 0x8524
    8510:	4879 0000 0000 	pea 0x0
    8516:	70df           	moveq #-33,%d0
    8518:	d08e           	addl %fp,%d0
    851a:	2f00           	movel %d0,%sp@-
    851c:	4eb9 0000 0000 	jsr 0x0
    8522:	508f           	addql #8,%sp
    8524:	70df           	moveq #-33,%d0
    8526:	d08e           	addl %fp,%d0
    8528:	2f00           	movel %d0,%sp@-
    852a:	200e           	movel %fp,%d0
    852c:	0680 ffff fd64 	addil #-668,%d0
    8532:	2f00           	movel %d0,%sp@-
    8534:	4eb9 0000 0000 	jsr 0x0
    853a:	508f           	addql #8,%sp
    853c:	4879 0000 0000 	pea 0x0
    8542:	200e           	movel %fp,%d0
    8544:	0680 ffff fd64 	addil #-668,%d0
    854a:	2f00           	movel %d0,%sp@-
    854c:	4eb9 0000 0000 	jsr 0x0
    8552:	508f           	addql #8,%sp
    8554:	200e           	movel %fp,%d0
    8556:	0680 ffff fee0 	addil #-288,%d0
    855c:	2f00           	movel %d0,%sp@-
    855e:	200e           	movel %fp,%d0
    8560:	0680 ffff fd64 	addil #-668,%d0
    8566:	2f00           	movel %d0,%sp@-
    8568:	4eb9 0000 0000 	jsr 0x0
    856e:	508f           	addql #8,%sp
    8570:	200e           	movel %fp,%d0
    8572:	0680 ffff fecc 	addil #-308,%d0
    8578:	2f00           	movel %d0,%sp@-
    857a:	200e           	movel %fp,%d0
    857c:	0680 ffff fd64 	addil #-668,%d0
    8582:	2f00           	movel %d0,%sp@-
    8584:	4eb9 0000 0000 	jsr 0x0
    858a:	508f           	addql #8,%sp
    858c:	4879 0000 0000 	pea 0x0
    8592:	200e           	movel %fp,%d0
    8594:	0680 ffff fd64 	addil #-668,%d0
    859a:	2f00           	movel %d0,%sp@-
    859c:	4eb9 0000 0000 	jsr 0x0
    85a2:	508f           	addql #8,%sp
    85a4:	200e           	movel %fp,%d0
    85a6:	0680 ffff fec2 	addil #-318,%d0
    85ac:	2f00           	movel %d0,%sp@-
    85ae:	200e           	movel %fp,%d0
    85b0:	0680 ffff fd64 	addil #-668,%d0
    85b6:	2f00           	movel %d0,%sp@-
    85b8:	4eb9 0000 0000 	jsr 0x0
    85be:	508f           	addql #8,%sp
    85c0:	70df           	moveq #-33,%d0
    85c2:	d08e           	addl %fp,%d0
    85c4:	2f00           	movel %d0,%sp@-
    85c6:	4eba faf6      	jsr %pc@(0x80be)
    85ca:	588f           	addql #4,%sp
    85cc:	2d48 fff4      	movel %a0,%fp@(-12)
    85d0:	4aae fff4      	tstl %fp@(-12)
    85d4:	6606           	bnes 0x85dc
    85d6:	4280           	clrl %d0
    85d8:	6000 0200      	braw 0x87da
    85dc:	42ae fffc      	clrl %fp@(-4)
    85e0:	605a           	bras 0x863c
    85e2:	202e fffc      	movel %fp@(-4),%d0
    85e6:	2d70 0db0 0000 	movel @(00000000,%d0:l:4),%fp@(-16)
    85ec:	0000 fff0 
    85f0:	4aae fff0      	tstl %fp@(-16)
    85f4:	6742           	beqs 0x8638
    85f6:	202e fff0      	movel %fp@(-16),%d0
    85fa:	2040           	moveal %d0,%a0
    85fc:	2228 0014      	movel %a0@(20),%d1
    8600:	200e           	movel %fp,%d0
    8602:	0680 ffff fd64 	addil #-668,%d0
    8608:	2f00           	movel %d0,%sp@-
    860a:	2f01           	movel %d1,%sp@-
    860c:	4eb9 0000 0000 	jsr 0x0
    8612:	508f           	addql #8,%sp
    8614:	4a80           	tstl %d0
    8616:	6620           	bnes 0x8638
    8618:	202e 000c      	movel %fp@(12),%d0
    861c:	0280 0000 0800 	andil #2048,%d0
    8622:	4a80           	tstl %d0
    8624:	6706           	beqs 0x862c
    8626:	4280           	clrl %d0
    8628:	6000 01b0      	braw 0x87da
    862c:	70fd           	moveq #-3,%d0
    862e:	c1ae 000c      	andl %d0,%fp@(12)
    8632:	7001           	moveq #1,%d0
    8634:	81ae 000c      	orl %d0,%fp@(12)
    8638:	52ae fffc      	addql #1,%fp@(-4)
    863c:	0cae 0000 00fe 	cmpil #254,%fp@(-4)
    8642:	fffc 
    8644:	6f9c           	bles 0x85e2
    8646:	4eba fa1c      	jsr %pc@(0x8064)
    864a:	2d40 ffec      	movel %d0,%fp@(-20)
    864e:	0cae 0000 00ff 	cmpil #255,%fp@(-20)
    8654:	ffec 
    8656:	661e           	bnes 0x8676
    8658:	4879 0000 0000 	pea 0x0
    865e:	4eb9 0000 0000 	jsr 0x0
    8664:	588f           	addql #4,%sp
    8666:	2f2e ffec      	movel %fp@(-20),%sp@-
    866a:	4eba fa3c      	jsr %pc@(0x80a8)
    866e:	588f           	addql #4,%sp
    8670:	4280           	clrl %d0
    8672:	6000 0166      	braw 0x87da
    8676:	4878 001c      	pea 0x1c
    867a:	4eb9 0000 0000 	jsr 0x0
    8680:	588f           	addql #4,%sp
    8682:	2008           	movel %a0,%d0
    8684:	2d40 fff0      	movel %d0,%fp@(-16)
    8688:	200e           	movel %fp,%d0
    868a:	0680 ffff fd64 	addil #-668,%d0
    8690:	2f00           	movel %d0,%sp@-
    8692:	4eb9 0000 0000 	jsr 0x0
    8698:	588f           	addql #4,%sp
    869a:	5280           	addql #1,%d0
    869c:	2f00           	movel %d0,%sp@-
    869e:	4eb9 0000 0000 	jsr 0x0
    86a4:	588f           	addql #4,%sp
    86a6:	2008           	movel %a0,%d0
    86a8:	2d40 ffe8      	movel %d0,%fp@(-24)
    86ac:	4aae fff0      	tstl %fp@(-16)
    86b0:	6706           	beqs 0x86b8
    86b2:	4aae ffe8      	tstl %fp@(-24)
    86b6:	6636           	bnes 0x86ee
    86b8:	4879 0000 0000 	pea 0x0
    86be:	4eb9 0000 0000 	jsr 0x0
    86c4:	588f           	addql #4,%sp
    86c6:	2f2e fff0      	movel %fp@(-16),%sp@-
    86ca:	4eb9 0000 0000 	jsr 0x0
    86d0:	588f           	addql #4,%sp
    86d2:	2f2e ffe8      	movel %fp@(-24),%sp@-
    86d6:	4eb9 0000 0000 	jsr 0x0
    86dc:	588f           	addql #4,%sp
    86de:	2f2e ffec      	movel %fp@(-20),%sp@-
    86e2:	4eba f9c4      	jsr %pc@(0x80a8)
    86e6:	588f           	addql #4,%sp
    86e8:	4280           	clrl %d0
    86ea:	6000 00ee      	braw 0x87da
    86ee:	200e           	movel %fp,%d0
    86f0:	0680 ffff fd64 	addil #-668,%d0
    86f6:	2f00           	movel %d0,%sp@-
    86f8:	2f2e ffe8      	movel %fp@(-24),%sp@-
    86fc:	4eb9 0000 0000 	jsr 0x0
    8702:	508f           	addql #8,%sp
    8704:	2008           	movel %a0,%d0
    8706:	4a80           	tstl %d0
    8708:	6636           	bnes 0x8740
    870a:	4879 0000 0000 	pea 0x0
    8710:	4eb9 0000 0000 	jsr 0x0
    8716:	588f           	addql #4,%sp
    8718:	2f2e fff0      	movel %fp@(-16),%sp@-
    871c:	4eb9 0000 0000 	jsr 0x0
    8722:	588f           	addql #4,%sp
    8724:	2f2e ffe8      	movel %fp@(-24),%sp@-
    8728:	4eb9 0000 0000 	jsr 0x0
    872e:	588f           	addql #4,%sp
    8730:	2f2e ffec      	movel %fp@(-20),%sp@-
    8734:	4eba f972      	jsr %pc@(0x80a8)
    8738:	588f           	addql #4,%sp
    873a:	4280           	clrl %d0
    873c:	6000 009c      	braw 0x87da
    8740:	202e fff0      	movel %fp@(-16),%d0
    8744:	2040           	moveal %d0,%a0
    8746:	216e ffe8 0014 	movel %fp@(-24),%a0@(20)
    874c:	202e fff0      	movel %fp@(-16),%d0
    8750:	2040           	moveal %d0,%a0
    8752:	216e ffec 000c 	movel %fp@(-20),%a0@(12)
    8758:	202e fff0      	movel %fp@(-16),%d0
    875c:	2040           	moveal %d0,%a0
    875e:	42a8 0004      	clrl %a0@(4)
    8762:	202e fff0      	movel %fp@(-16),%d0
    8766:	2040           	moveal %d0,%a0
    8768:	20ae 000c      	movel %fp@(12),%a0@
    876c:	202e fff4      	movel %fp@(-12),%d0
    8770:	2040           	moveal %d0,%a0
    8772:	2228 0008      	movel %a0@(8),%d1
    8776:	202e fff0      	movel %fp@(-16),%d0
    877a:	2040           	moveal %d0,%a0
    877c:	2141 0008      	movel %d1,%a0@(8)
    8780:	202e fff0      	movel %fp@(-16),%d0
    8784:	2040           	moveal %d0,%a0
    8786:	2028 0008      	movel %a0@(8),%d0
    878a:	2040           	moveal %d0,%a0
    878c:	2010           	movel %a0@,%d0
    878e:	2f2e fff0      	movel %fp@(-16),%sp@-
    8792:	2040           	moveal %d0,%a0
    8794:	4e90           	jsr %a0@
    8796:	588f           	addql #4,%sp
    8798:	2d40 ffe4      	movel %d0,%fp@(-28)
    879c:	4aae ffe4      	tstl %fp@(-28)
    87a0:	6726           	beqs 0x87c8
    87a2:	2f2e fff0      	movel %fp@(-16),%sp@-
    87a6:	4eb9 0000 0000 	jsr 0x0
    87ac:	588f           	addql #4,%sp
    87ae:	2f2e ffe8      	movel %fp@(-24),%sp@-
    87b2:	4eb9 0000 0000 	jsr 0x0
    87b8:	588f           	addql #4,%sp
    87ba:	2f2e ffec      	movel %fp@(-20),%sp@-
    87be:	4eba f8e8      	jsr %pc@(0x80a8)
    87c2:	588f           	addql #4,%sp
    87c4:	4280           	clrl %d0
    87c6:	6012           	bras 0x87da
    87c8:	202e ffec      	movel %fp@(-20),%d0
    87cc:	21ae fff0 0db0 	movel %fp@(-16),@(00000000,%d0:l:4)
    87d2:	0000 0000 
    87d6:	202e ffec      	movel %fp@(-20),%d0
    87da:	4e5e           	unlk %fp
    87dc:	4e75           	rts
    87de:	4e56 0000      	linkw %fp,#0
    87e2:	202e 000c      	movel %fp@(12),%d0
    87e6:	0040 0800      	oriw #2048,%d0
    87ea:	2f00           	movel %d0,%sp@-
    87ec:	2f2e 0008      	movel %fp@(8),%sp@-
    87f0:	4eba fc3c      	jsr %pc@(0x842e)
    87f4:	508f           	addql #8,%sp
    87f6:	4e5e           	unlk %fp
    87f8:	4e75           	rts
    87fa:	4e56 fff0      	linkw %fp,#-16
    87fe:	2d7c 0000 00ff 	movel #255,%fp@(-4)
    8804:	fffc 
    8806:	202e 0008      	movel %fp@(8),%d0
    880a:	2d70 0db0 0000 	movel @(00000000,%d0:l:4),%fp@(-8)
    8810:	0000 fff8 
    8814:	4aae fff8      	tstl %fp@(-8)
    8818:	676e           	beqs 0x8888
    881a:	202e fff8      	movel %fp@(-8),%d0
    881e:	2040           	moveal %d0,%a0
    8820:	2028 0008      	movel %a0@(8),%d0
    8824:	2040           	moveal %d0,%a0
    8826:	2028 0004      	movel %a0@(4),%d0
    882a:	2f2e fff8      	movel %fp@(-8),%sp@-
    882e:	2040           	moveal %d0,%a0
    8830:	4e90           	jsr %a0@
    8832:	588f           	addql #4,%sp
    8834:	2d40 fff4      	movel %d0,%fp@(-12)
    8838:	4aae fff4      	tstl %fp@(-12)
    883c:	670e           	beqs 0x884c
    883e:	4879 0000 0000 	pea 0x0
    8844:	4eb9 0000 0000 	jsr 0x0
    884a:	588f           	addql #4,%sp
    884c:	202e fff8      	movel %fp@(-8),%d0
    8850:	2040           	moveal %d0,%a0
    8852:	2d68 0014 fff0 	movel %a0@(20),%fp@(-16)
    8858:	2f2e fff8      	movel %fp@(-8),%sp@-
    885c:	4eb9 0000 0000 	jsr 0x0
    8862:	588f           	addql #4,%sp
    8864:	2f2e fff0      	movel %fp@(-16),%sp@-
    8868:	4eb9 0000 0000 	jsr 0x0
    886e:	588f           	addql #4,%sp
    8870:	202e 0008      	movel %fp@(8),%d0
    8874:	42b0 0db0 0000 	clrl @(00000000,%d0:l:4)
    887a:	0000 
    887c:	2f2e 0008      	movel %fp@(8),%sp@-
    8880:	4eba f826      	jsr %pc@(0x80a8)
    8884:	588f           	addql #4,%sp
    8886:	6002           	bras 0x888a
    8888:	4e71           	nop
    888a:	4e5e           	unlk %fp
    888c:	4e75           	rts
    888e:	4e56 fff8      	linkw %fp,#-8
    8892:	7009           	moveq #9,%d0
    8894:	b0ae 0008      	cmpl %fp@(8),%d0
    8898:	6d02           	blts 0x889c
    889a:	6046           	bras 0x88e2
    889c:	202e 0008      	movel %fp@(8),%d0
    88a0:	2d70 0db0 0000 	movel @(00000000,%d0:l:4),%fp@(-4)
    88a6:	0000 fffc 
    88aa:	4aae fffc      	tstl %fp@(-4)
    88ae:	6604           	bnes 0x88b4
    88b0:	7002           	moveq #2,%d0
    88b2:	602e           	bras 0x88e2
    88b4:	202e fffc      	movel %fp@(-4),%d0
    88b8:	2040           	moveal %d0,%a0
    88ba:	2028 0008      	movel %a0@(8),%d0
    88be:	2040           	moveal %d0,%a0
    88c0:	2028 0008      	movel %a0@(8),%d0
    88c4:	222e 000c      	movel %fp@(12),%d1
    88c8:	2f2e 0010      	movel %fp@(16),%sp@-
    88cc:	2f01           	movel %d1,%sp@-
    88ce:	2f2e fffc      	movel %fp@(-4),%sp@-
    88d2:	2040           	moveal %d0,%a0
    88d4:	4e90           	jsr %a0@
    88d6:	4fef 000c      	lea %sp@(12),%sp
    88da:	2d40 fff8      	movel %d0,%fp@(-8)
    88de:	202e fff8      	movel %fp@(-8),%d0
    88e2:	4e5e           	unlk %fp
    88e4:	4e75           	rts
    88e6:	4e56 fff8      	linkw %fp,#-8
    88ea:	202e 0008      	movel %fp@(8),%d0
    88ee:	2d70 0db0 0000 	movel @(00000000,%d0:l:4),%fp@(-4)
    88f4:	0000 fffc 
    88f8:	4aae fffc      	tstl %fp@(-4)
    88fc:	6604           	bnes 0x8902
    88fe:	7002           	moveq #2,%d0
    8900:	602e           	bras 0x8930
    8902:	202e fffc      	movel %fp@(-4),%d0
    8906:	2040           	moveal %d0,%a0
    8908:	2028 0008      	movel %a0@(8),%d0
    890c:	2040           	moveal %d0,%a0
    890e:	2028 000c      	movel %a0@(12),%d0
    8912:	222e 000c      	movel %fp@(12),%d1
    8916:	2f2e 0010      	movel %fp@(16),%sp@-
    891a:	2f01           	movel %d1,%sp@-
    891c:	2f2e fffc      	movel %fp@(-4),%sp@-
    8920:	2040           	moveal %d0,%a0
    8922:	4e90           	jsr %a0@
    8924:	4fef 000c      	lea %sp@(12),%sp
    8928:	2d40 fff8      	movel %d0,%fp@(-8)
    892c:	202e fff8      	movel %fp@(-8),%d0
    8930:	4e5e           	unlk %fp
    8932:	4e75           	rts
    8934:	4e56 0000      	linkw %fp,#0
    8938:	4e5e           	unlk %fp
    893a:	4e75           	rts
    893c:	4e56 fff8      	linkw %fp,#-8
    8940:	202e 0008      	movel %fp@(8),%d0
    8944:	2d70 0db0 0000 	movel @(00000000,%d0:l:4),%fp@(-4)
    894a:	0000 fffc 
    894e:	4aae fffc      	tstl %fp@(-4)
    8952:	672a           	beqs 0x897e
    8954:	202e fffc      	movel %fp@(-4),%d0
    8958:	2040           	moveal %d0,%a0
    895a:	2028 0008      	movel %a0@(8),%d0
    895e:	2040           	moveal %d0,%a0
    8960:	2028 0010      	movel %a0@(16),%d0
    8964:	2f2e 0010      	movel %fp@(16),%sp@-
    8968:	2f2e 000c      	movel %fp@(12),%sp@-
    896c:	2f2e fffc      	movel %fp@(-4),%sp@-
    8970:	2040           	moveal %d0,%a0
    8972:	4e90           	jsr %a0@
    8974:	4fef 000c      	lea %sp@(12),%sp
    8978:	2d40 fff8      	movel %d0,%fp@(-8)
    897c:	6002           	bras 0x8980
    897e:	4e71           	nop
    8980:	4e5e           	unlk %fp
    8982:	4e75           	rts
    8984:	4e56 fff8      	linkw %fp,#-8
    8988:	202e 0008      	movel %fp@(8),%d0
    898c:	2d70 0db0 0000 	movel @(00000000,%d0:l:4),%fp@(-4)
    8992:	0000 fffc 
    8996:	4aae fffc      	tstl %fp@(-4)
    899a:	6604           	bnes 0x89a0
    899c:	7002           	moveq #2,%d0
    899e:	6022           	bras 0x89c2
    89a0:	202e fffc      	movel %fp@(-4),%d0
    89a4:	2040           	moveal %d0,%a0
    89a6:	2028 0008      	movel %a0@(8),%d0
    89aa:	2040           	moveal %d0,%a0
    89ac:	2028 001c      	movel %a0@(28),%d0
    89b0:	2f2e fffc      	movel %fp@(-4),%sp@-
    89b4:	2040           	moveal %d0,%a0
    89b6:	4e90           	jsr %a0@
    89b8:	588f           	addql #4,%sp
    89ba:	2d40 fff8      	movel %d0,%fp@(-8)
    89be:	202e fff8      	movel %fp@(-8),%d0
    89c2:	4e5e           	unlk %fp
    89c4:	4e75           	rts
    89c6:	4e56 ffe8      	linkw %fp,#-24
    89ca:	42ae fffc      	clrl %fp@(-4)
    89ce:	603a           	bras 0x8a0a
    89d0:	202e fffc      	movel %fp@(-4),%d0
    89d4:	2d70 0db0 0000 	movel @(00000000,%d0:l:4),%fp@(-8)
    89da:	0000 fff8 
    89de:	4aae fff8      	tstl %fp@(-8)
    89e2:	6722           	beqs 0x8a06
    89e4:	202e fff8      	movel %fp@(-8),%d0
    89e8:	2040           	moveal %d0,%a0
    89ea:	2028 0014      	movel %a0@(20),%d0
    89ee:	2f2e 0008      	movel %fp@(8),%sp@-
    89f2:	2f00           	movel %d0,%sp@-
    89f4:	4eb9 0000 0000 	jsr 0x0
    89fa:	508f           	addql #8,%sp
    89fc:	4a80           	tstl %d0
    89fe:	6606           	bnes 0x8a06
    8a00:	7005           	moveq #5,%d0
    8a02:	6000 01bc      	braw 0x8bc0
    8a06:	52ae fffc      	addql #1,%fp@(-4)
    8a0a:	0cae 0000 00fe 	cmpil #254,%fp@(-4)
    8a10:	fffc 
    8a12:	6fbc           	bles 0x89d0
    8a14:	2f2e 0008      	movel %fp@(8),%sp@-
    8a18:	4eba f6a4      	jsr %pc@(0x80be)
    8a1c:	588f           	addql #4,%sp
    8a1e:	2d48 fff4      	movel %a0,%fp@(-12)
    8a22:	42ae fff4      	clrl %fp@(-12)
    8a26:	4aae fff4      	tstl %fp@(-12)
    8a2a:	6706           	beqs 0x8a32
    8a2c:	7032           	moveq #50,%d0
    8a2e:	6000 0190      	braw 0x8bc0
    8a32:	4eba f630      	jsr %pc@(0x8064)
    8a36:	2d40 fff0      	movel %d0,%fp@(-16)
    8a3a:	0cae 0000 00ff 	cmpil #255,%fp@(-16)
    8a40:	fff0 
    8a42:	661e           	bnes 0x8a62
    8a44:	4879 0000 0000 	pea 0x0
    8a4a:	4eb9 0000 0000 	jsr 0x0
    8a50:	588f           	addql #4,%sp
    8a52:	2f2e fff0      	movel %fp@(-16),%sp@-
    8a56:	4eba f650      	jsr %pc@(0x80a8)
    8a5a:	588f           	addql #4,%sp
    8a5c:	7004           	moveq #4,%d0
    8a5e:	6000 0160      	braw 0x8bc0
    8a62:	4878 001c      	pea 0x1c
    8a66:	4eb9 0000 0000 	jsr 0x0
    8a6c:	588f           	addql #4,%sp
    8a6e:	2008           	movel %a0,%d0
    8a70:	2d40 fff8      	movel %d0,%fp@(-8)
    8a74:	2f2e 0008      	movel %fp@(8),%sp@-
    8a78:	4eb9 0000 0000 	jsr 0x0
    8a7e:	588f           	addql #4,%sp
    8a80:	5280           	addql #1,%d0
    8a82:	2f00           	movel %d0,%sp@-
    8a84:	4eb9 0000 0000 	jsr 0x0
    8a8a:	588f           	addql #4,%sp
    8a8c:	2008           	movel %a0,%d0
    8a8e:	2d40 ffec      	movel %d0,%fp@(-20)
    8a92:	4aae fff8      	tstl %fp@(-8)
    8a96:	6706           	beqs 0x8a9e
    8a98:	4aae ffec      	tstl %fp@(-20)
    8a9c:	6636           	bnes 0x8ad4
    8a9e:	4879 0000 0000 	pea 0x0
    8aa4:	4eb9 0000 0000 	jsr 0x0
    8aaa:	588f           	addql #4,%sp
    8aac:	2f2e fff8      	movel %fp@(-8),%sp@-
    8ab0:	4eb9 0000 0000 	jsr 0x0
    8ab6:	588f           	addql #4,%sp
    8ab8:	2f2e ffec      	movel %fp@(-20),%sp@-
    8abc:	4eb9 0000 0000 	jsr 0x0
    8ac2:	588f           	addql #4,%sp
    8ac4:	2f2e fff0      	movel %fp@(-16),%sp@-
    8ac8:	4eba f5de      	jsr %pc@(0x80a8)
    8acc:	588f           	addql #4,%sp
    8ace:	7031           	moveq #49,%d0
    8ad0:	6000 00ee      	braw 0x8bc0
    8ad4:	2f2e 0008      	movel %fp@(8),%sp@-
    8ad8:	2f2e ffec      	movel %fp@(-20),%sp@-
    8adc:	4eb9 0000 0000 	jsr 0x0
    8ae2:	508f           	addql #8,%sp
    8ae4:	2008           	movel %a0,%d0
    8ae6:	4a80           	tstl %d0
    8ae8:	6636           	bnes 0x8b20
    8aea:	4879 0000 0000 	pea 0x0
    8af0:	4eb9 0000 0000 	jsr 0x0
    8af6:	588f           	addql #4,%sp
    8af8:	2f2e fff8      	movel %fp@(-8),%sp@-
    8afc:	4eb9 0000 0000 	jsr 0x0
    8b02:	588f           	addql #4,%sp
    8b04:	2f2e ffec      	movel %fp@(-20),%sp@-
    8b08:	4eb9 0000 0000 	jsr 0x0
    8b0e:	588f           	addql #4,%sp
    8b10:	2f2e fff0      	movel %fp@(-16),%sp@-
    8b14:	4eba f592      	jsr %pc@(0x80a8)
    8b18:	588f           	addql #4,%sp
    8b1a:	70ff           	moveq #-1,%d0
    8b1c:	6000 00a2      	braw 0x8bc0
    8b20:	202e fff8      	movel %fp@(-8),%d0
    8b24:	2040           	moveal %d0,%a0
    8b26:	216e ffec 0014 	movel %fp@(-20),%a0@(20)
    8b2c:	202e fff8      	movel %fp@(-8),%d0
    8b30:	2040           	moveal %d0,%a0
    8b32:	216e fff0 000c 	movel %fp@(-16),%a0@(12)
    8b38:	202e fff8      	movel %fp@(-8),%d0
    8b3c:	2040           	moveal %d0,%a0
    8b3e:	42a8 0004      	clrl %a0@(4)
    8b42:	202e fff8      	movel %fp@(-8),%d0
    8b46:	2040           	moveal %d0,%a0
    8b48:	4290           	clrl %a0@
    8b4a:	202e fff4      	movel %fp@(-12),%d0
    8b4e:	2040           	moveal %d0,%a0
    8b50:	2228 0008      	movel %a0@(8),%d1
    8b54:	202e fff8      	movel %fp@(-8),%d0
    8b58:	2040           	moveal %d0,%a0
    8b5a:	2141 0008      	movel %d1,%a0@(8)
    8b5e:	202e fff8      	movel %fp@(-8),%d0
    8b62:	2040           	moveal %d0,%a0
    8b64:	2028 0008      	movel %a0@(8),%d0
    8b68:	2040           	moveal %d0,%a0
    8b6a:	2028 0034      	movel %a0@(52),%d0
    8b6e:	2f2e 000c      	movel %fp@(12),%sp@-
    8b72:	2f2e 0008      	movel %fp@(8),%sp@-
    8b76:	2f2e fff8      	movel %fp@(-8),%sp@-
    8b7a:	2040           	moveal %d0,%a0
    8b7c:	4e90           	jsr %a0@
    8b7e:	4fef 000c      	lea %sp@(12),%sp
    8b82:	2d40 ffe8      	movel %d0,%fp@(-24)
    8b86:	4aae ffe8      	tstl %fp@(-24)
    8b8a:	670e           	beqs 0x8b9a
    8b8c:	4879 0000 0000 	pea 0x0
    8b92:	4eb9 0000 0000 	jsr 0x0
    8b98:	588f           	addql #4,%sp
    8b9a:	2f2e ffec      	movel %fp@(-20),%sp@-
    8b9e:	4eb9 0000 0000 	jsr 0x0
    8ba4:	588f           	addql #4,%sp
    8ba6:	2f2e fff8      	movel %fp@(-8),%sp@-
    8baa:	4eb9 0000 0000 	jsr 0x0
    8bb0:	588f           	addql #4,%sp
    8bb2:	2f2e fff0      	movel %fp@(-16),%sp@-
    8bb6:	4eba f4f0      	jsr %pc@(0x80a8)
    8bba:	588f           	addql #4,%sp
    8bbc:	202e ffe8      	movel %fp@(-24),%d0
    8bc0:	4e5e           	unlk %fp
    8bc2:	4e75           	rts
    8bc4:	4e56 ffe8      	linkw %fp,#-24
    8bc8:	42ae fffc      	clrl %fp@(-4)
    8bcc:	603a           	bras 0x8c08
    8bce:	202e fffc      	movel %fp@(-4),%d0
    8bd2:	2d70 0db0 0000 	movel @(00000000,%d0:l:4),%fp@(-8)
    8bd8:	0000 fff8 
    8bdc:	4aae fff8      	tstl %fp@(-8)
    8be0:	6722           	beqs 0x8c04
    8be2:	202e fff8      	movel %fp@(-8),%d0
    8be6:	2040           	moveal %d0,%a0
    8be8:	2028 0014      	movel %a0@(20),%d0
    8bec:	2f2e 0008      	movel %fp@(8),%sp@-
    8bf0:	2f00           	movel %d0,%sp@-
    8bf2:	4eb9 0000 0000 	jsr 0x0
    8bf8:	508f           	addql #8,%sp
    8bfa:	4a80           	tstl %d0
    8bfc:	6606           	bnes 0x8c04
    8bfe:	7005           	moveq #5,%d0
    8c00:	6000 01b2      	braw 0x8db4
    8c04:	52ae fffc      	addql #1,%fp@(-4)
    8c08:	0cae 0000 00fe 	cmpil #254,%fp@(-4)
    8c0e:	fffc 
    8c10:	6fbc           	bles 0x8bce
    8c12:	2f2e 0008      	movel %fp@(8),%sp@-
    8c16:	4eba f4a6      	jsr %pc@(0x80be)
    8c1a:	588f           	addql #4,%sp
    8c1c:	2d48 fff4      	movel %a0,%fp@(-12)
    8c20:	42ae fff4      	clrl %fp@(-12)
    8c24:	4aae fff4      	tstl %fp@(-12)
    8c28:	6706           	beqs 0x8c30
    8c2a:	7032           	moveq #50,%d0
    8c2c:	6000 0186      	braw 0x8db4
    8c30:	4eba f432      	jsr %pc@(0x8064)
    8c34:	2d40 fff0      	movel %d0,%fp@(-16)
    8c38:	0cae 0000 00ff 	cmpil #255,%fp@(-16)
    8c3e:	fff0 
    8c40:	661e           	bnes 0x8c60
    8c42:	4879 0000 0000 	pea 0x0
    8c48:	4eb9 0000 0000 	jsr 0x0
    8c4e:	588f           	addql #4,%sp
    8c50:	2f2e fff0      	movel %fp@(-16),%sp@-
    8c54:	4eba f452      	jsr %pc@(0x80a8)
    8c58:	588f           	addql #4,%sp
    8c5a:	7004           	moveq #4,%d0
    8c5c:	6000 0156      	braw 0x8db4
    8c60:	4878 001c      	pea 0x1c
    8c64:	4eb9 0000 0000 	jsr 0x0
    8c6a:	588f           	addql #4,%sp
    8c6c:	2008           	movel %a0,%d0
    8c6e:	2d40 fff8      	movel %d0,%fp@(-8)
    8c72:	2f2e 0008      	movel %fp@(8),%sp@-
    8c76:	4eb9 0000 0000 	jsr 0x0
    8c7c:	588f           	addql #4,%sp
    8c7e:	5280           	addql #1,%d0
    8c80:	2f00           	movel %d0,%sp@-
    8c82:	4eb9 0000 0000 	jsr 0x0
    8c88:	588f           	addql #4,%sp
    8c8a:	2008           	movel %a0,%d0
    8c8c:	2d40 ffec      	movel %d0,%fp@(-20)
    8c90:	4aae fff8      	tstl %fp@(-8)
    8c94:	6706           	beqs 0x8c9c
    8c96:	4aae ffec      	tstl %fp@(-20)
    8c9a:	6636           	bnes 0x8cd2
    8c9c:	4879 0000 0000 	pea 0x0
    8ca2:	4eb9 0000 0000 	jsr 0x0
    8ca8:	588f           	addql #4,%sp
    8caa:	2f2e fff8      	movel %fp@(-8),%sp@-
    8cae:	4eb9 0000 0000 	jsr 0x0
    8cb4:	588f           	addql #4,%sp
    8cb6:	2f2e ffec      	movel %fp@(-20),%sp@-
    8cba:	4eb9 0000 0000 	jsr 0x0
    8cc0:	588f           	addql #4,%sp
    8cc2:	2f2e fff0      	movel %fp@(-16),%sp@-
    8cc6:	4eba f3e0      	jsr %pc@(0x80a8)
    8cca:	588f           	addql #4,%sp
    8ccc:	7031           	moveq #49,%d0
    8cce:	6000 00e4      	braw 0x8db4
    8cd2:	2f2e 0008      	movel %fp@(8),%sp@-
    8cd6:	2f2e ffec      	movel %fp@(-20),%sp@-
    8cda:	4eb9 0000 0000 	jsr 0x0
    8ce0:	508f           	addql #8,%sp
    8ce2:	2008           	movel %a0,%d0
    8ce4:	4a80           	tstl %d0
    8ce6:	6636           	bnes 0x8d1e
    8ce8:	4879 0000 0000 	pea 0x0
    8cee:	4eb9 0000 0000 	jsr 0x0
    8cf4:	588f           	addql #4,%sp
    8cf6:	2f2e fff8      	movel %fp@(-8),%sp@-
    8cfa:	4eb9 0000 0000 	jsr 0x0
    8d00:	588f           	addql #4,%sp
    8d02:	2f2e ffec      	movel %fp@(-20),%sp@-
    8d06:	4eb9 0000 0000 	jsr 0x0
    8d0c:	588f           	addql #4,%sp
    8d0e:	2f2e fff0      	movel %fp@(-16),%sp@-
    8d12:	4eba f394      	jsr %pc@(0x80a8)
    8d16:	588f           	addql #4,%sp
    8d18:	70ff           	moveq #-1,%d0
    8d1a:	6000 0098      	braw 0x8db4
    8d1e:	202e fff8      	movel %fp@(-8),%d0
    8d22:	2040           	moveal %d0,%a0
    8d24:	216e ffec 0014 	movel %fp@(-20),%a0@(20)
    8d2a:	202e fff8      	movel %fp@(-8),%d0
    8d2e:	2040           	moveal %d0,%a0
    8d30:	216e fff0 000c 	movel %fp@(-16),%a0@(12)
    8d36:	202e fff8      	movel %fp@(-8),%d0
    8d3a:	2040           	moveal %d0,%a0
    8d3c:	42a8 0004      	clrl %a0@(4)
    8d40:	202e fff8      	movel %fp@(-8),%d0
    8d44:	2040           	moveal %d0,%a0
    8d46:	4290           	clrl %a0@
    8d48:	202e fff4      	movel %fp@(-12),%d0
    8d4c:	2040           	moveal %d0,%a0
    8d4e:	2228 0008      	movel %a0@(8),%d1
    8d52:	202e fff8      	movel %fp@(-8),%d0
    8d56:	2040           	moveal %d0,%a0
    8d58:	2141 0008      	movel %d1,%a0@(8)
    8d5c:	202e fff8      	movel %fp@(-8),%d0
    8d60:	2040           	moveal %d0,%a0
    8d62:	2028 0008      	movel %a0@(8),%d0
    8d66:	2040           	moveal %d0,%a0
    8d68:	2028 0018      	movel %a0@(24),%d0
    8d6c:	2f2e fff8      	movel %fp@(-8),%sp@-
    8d70:	2040           	moveal %d0,%a0
    8d72:	4e90           	jsr %a0@
    8d74:	588f           	addql #4,%sp
    8d76:	2d40 ffe8      	movel %d0,%fp@(-24)
    8d7a:	4aae ffe8      	tstl %fp@(-24)
    8d7e:	670e           	beqs 0x8d8e
    8d80:	4879 0000 0000 	pea 0x0
    8d86:	4eb9 0000 0000 	jsr 0x0
    8d8c:	588f           	addql #4,%sp
    8d8e:	2f2e ffec      	movel %fp@(-20),%sp@-
    8d92:	4eb9 0000 0000 	jsr 0x0
    8d98:	588f           	addql #4,%sp
    8d9a:	2f2e fff8      	movel %fp@(-8),%sp@-
    8d9e:	4eb9 0000 0000 	jsr 0x0
    8da4:	588f           	addql #4,%sp
    8da6:	2f2e fff0      	movel %fp@(-16),%sp@-
    8daa:	4eba f2fc      	jsr %pc@(0x80a8)
    8dae:	588f           	addql #4,%sp
    8db0:	202e ffe8      	movel %fp@(-24),%d0
    8db4:	4e5e           	unlk %fp
    8db6:	4e75           	rts
    8db8:	4e56 fff8      	linkw %fp,#-8
    8dbc:	202e 0008      	movel %fp@(8),%d0
    8dc0:	2040           	moveal %d0,%a0
    8dc2:	1028 0010      	moveb %a0@(16),%d0
    8dc6:	4a00           	tstb %d0
    8dc8:	6704           	beqs 0x8dce
    8dca:	7001           	moveq #1,%d0
    8dcc:	607c           	bras 0x8e4a
    8dce:	202e 0008      	movel %fp@(8),%d0
    8dd2:	2040           	moveal %d0,%a0
    8dd4:	2010           	movel %a0@,%d0
    8dd6:	2040           	moveal %d0,%a0
    8dd8:	2d68 002c fffc 	movel %a0@(44),%fp@(-4)
    8dde:	202e 0008      	movel %fp@(8),%d0
    8de2:	2040           	moveal %d0,%a0
    8de4:	2010           	movel %a0@,%d0
    8de6:	2f00           	movel %d0,%sp@-
    8de8:	4eb9 0000 0000 	jsr 0x0
    8dee:	588f           	addql #4,%sp
    8df0:	1d40 fffb      	moveb %d0,%fp@(-5)
    8df4:	4280           	clrl %d0
    8df6:	102e fffb      	moveb %fp@(-5),%d0
    8dfa:	7201           	moveq #1,%d1
    8dfc:	b280           	cmpl %d0,%d1
    8dfe:	673c           	beqs 0x8e3c
    8e00:	4e71           	nop
    8e02:	202e 0008      	movel %fp@(8),%d0
    8e06:	2040           	moveal %d0,%a0
    8e08:	2010           	movel %a0@,%d0
    8e0a:	2040           	moveal %d0,%a0
    8e0c:	216e fffc 002c 	movel %fp@(-4),%a0@(44)
    8e12:	202e 0008      	movel %fp@(8),%d0
    8e16:	2040           	moveal %d0,%a0
    8e18:	2028 000c      	movel %a0@(12),%d0
    8e1c:	2200           	movel %d0,%d1
    8e1e:	5281           	addql #1,%d1
    8e20:	202e 0008      	movel %fp@(8),%d0
    8e24:	2040           	moveal %d0,%a0
    8e26:	2141 000c      	movel %d1,%a0@(12)
    8e2a:	202e 0008      	movel %fp@(8),%d0
    8e2e:	2040           	moveal %d0,%a0
    8e30:	42a8 0008      	clrl %a0@(8)
    8e34:	4280           	clrl %d0
    8e36:	102e fffb      	moveb %fp@(-5),%d0
    8e3a:	600e           	bras 0x8e4a
    8e3c:	202e 0008      	movel %fp@(8),%d0
    8e40:	2040           	moveal %d0,%a0
    8e42:	117c 0001 0010 	moveb #1,%a0@(16)
    8e48:	7001           	moveq #1,%d0
    8e4a:	4e5e           	unlk %fp
    8e4c:	4e75           	rts
    8e4e:	4e56 fff8      	linkw %fp,#-8
    8e52:	202e 0008      	movel %fp@(8),%d0
    8e56:	2040           	moveal %d0,%a0
    8e58:	2010           	movel %a0@,%d0
    8e5a:	2040           	moveal %d0,%a0
    8e5c:	2d68 002c fffc 	movel %a0@(44),%fp@(-4)
    8e62:	202e 0008      	movel %fp@(8),%d0
    8e66:	2040           	moveal %d0,%a0
    8e68:	2010           	movel %a0@,%d0
    8e6a:	2f00           	movel %d0,%sp@-
    8e6c:	4eb9 0000 0000 	jsr 0x0
    8e72:	588f           	addql #4,%sp
    8e74:	1d40 fffb      	moveb %d0,%fp@(-5)
    8e78:	4280           	clrl %d0
    8e7a:	102e fffb      	moveb %fp@(-5),%d0
    8e7e:	7205           	moveq #5,%d1
    8e80:	b280           	cmpl %d0,%d1
    8e82:	6750           	beqs 0x8ed4
    8e84:	4e71           	nop
    8e86:	202e 0008      	movel %fp@(8),%d0
    8e8a:	2040           	moveal %d0,%a0
    8e8c:	2010           	movel %a0@,%d0
    8e8e:	2040           	moveal %d0,%a0
    8e90:	216e fffc 002c 	movel %fp@(-4),%a0@(44)
    8e96:	202e 0008      	movel %fp@(8),%d0
    8e9a:	2040           	moveal %d0,%a0
    8e9c:	2028 000c      	movel %a0@(12),%d0
    8ea0:	2200           	movel %d0,%d1
    8ea2:	5281           	addql #1,%d1
    8ea4:	202e 0008      	movel %fp@(8),%d0
    8ea8:	2040           	moveal %d0,%a0
    8eaa:	2141 000c      	movel %d1,%a0@(12)
    8eae:	202e 0008      	movel %fp@(8),%d0
    8eb2:	2040           	moveal %d0,%a0
    8eb4:	42a8 0008      	clrl %a0@(8)
    8eb8:	4878 0400      	pea 0x400
    8ebc:	42a7           	clrl %sp@-
    8ebe:	2f2e fffc      	movel %fp@(-4),%sp@-
    8ec2:	4eb9 0000 0000 	jsr 0x0
    8ec8:	4fef 000c      	lea %sp@(12),%sp
    8ecc:	4280           	clrl %d0
    8ece:	102e fffb      	moveb %fp@(-5),%d0
    8ed2:	6002           	bras 0x8ed6
    8ed4:	4280           	clrl %d0
    8ed6:	4e5e           	unlk %fp
    8ed8:	4e75           	rts
    8eda:	4e56 fff0      	linkw %fp,#-16
    8ede:	4878 0030      	pea 0x30
    8ee2:	4eb9 0000 0000 	jsr 0x0
    8ee8:	588f           	addql #4,%sp
    8eea:	2008           	movel %a0,%d0
    8eec:	2d40 fffa      	movel %d0,%fp@(-6)
    8ef0:	4878 0012      	pea 0x12
    8ef4:	4eb9 0000 0000 	jsr 0x0
    8efa:	588f           	addql #4,%sp
    8efc:	2008           	movel %a0,%d0
    8efe:	2d40 fff6      	movel %d0,%fp@(-10)
    8f02:	4878 0400      	pea 0x400
    8f06:	4eb9 0000 0000 	jsr 0x0
    8f0c:	588f           	addql #4,%sp
    8f0e:	2008           	movel %a0,%d0
    8f10:	2d40 fff2      	movel %d0,%fp@(-14)
    8f14:	202e 0008      	movel %fp@(8),%d0
    8f18:	2040           	moveal %d0,%a0
    8f1a:	2028 0014      	movel %a0@(20),%d0
    8f1e:	2f00           	movel %d0,%sp@-
    8f20:	2f2e fffa      	movel %fp@(-6),%sp@-
    8f24:	4eb9 0000 0000 	jsr 0x0
    8f2a:	508f           	addql #8,%sp
    8f2c:	1d40 ffff      	moveb %d0,%fp@(-1)
    8f30:	4a2e ffff      	tstb %fp@(-1)
    8f34:	6738           	beqs 0x8f6e
    8f36:	4879 0000 0000 	pea 0x0
    8f3c:	4eb9 0000 0000 	jsr 0x0
    8f42:	588f           	addql #4,%sp
    8f44:	2f2e fffa      	movel %fp@(-6),%sp@-
    8f48:	4eb9 0000 0000 	jsr 0x0
    8f4e:	588f           	addql #4,%sp
    8f50:	2f2e fff6      	movel %fp@(-10),%sp@-
    8f54:	4eb9 0000 0000 	jsr 0x0
    8f5a:	588f           	addql #4,%sp
    8f5c:	2f2e fff2      	movel %fp@(-14),%sp@-
    8f60:	4eb9 0000 0000 	jsr 0x0
    8f66:	588f           	addql #4,%sp
    8f68:	7002           	moveq #2,%d0
    8f6a:	6000 0136      	braw 0x90a2
    8f6e:	202e fffa      	movel %fp@(-6),%d0
    8f72:	2040           	moveal %d0,%a0
    8f74:	216e fff2 002c 	movel %fp@(-14),%a0@(44)
    8f7a:	202e 0008      	movel %fp@(8),%d0
    8f7e:	2040           	moveal %d0,%a0
    8f80:	2010           	movel %a0@,%d0
    8f82:	0280 0000 0800 	andil #2048,%d0
    8f88:	4a80           	tstl %d0
    8f8a:	6730           	beqs 0x8fbc
    8f8c:	2f2e fffa      	movel %fp@(-6),%sp@-
    8f90:	4eb9 0000 0000 	jsr 0x0
    8f96:	588f           	addql #4,%sp
    8f98:	1d40 ffff      	moveb %d0,%fp@(-1)
    8f9c:	2f2e fffa      	movel %fp@(-6),%sp@-
    8fa0:	4eb9 0000 0000 	jsr 0x0
    8fa6:	588f           	addql #4,%sp
    8fa8:	1d40 ffff      	moveb %d0,%fp@(-1)
    8fac:	0c2e ffff ffff 	cmpib #-1,%fp@(-1)
    8fb2:	6618           	bnes 0x8fcc
    8fb4:	1d7c 0007 ffff 	moveb #7,%fp@(-1)
    8fba:	6010           	bras 0x8fcc
    8fbc:	2f2e fffa      	movel %fp@(-6),%sp@-
    8fc0:	4eb9 0000 0000 	jsr 0x0
    8fc6:	588f           	addql #4,%sp
    8fc8:	1d40 ffff      	moveb %d0,%fp@(-1)
    8fcc:	4e71           	nop
    8fce:	4a2e ffff      	tstb %fp@(-1)
    8fd2:	672a           	beqs 0x8ffe
    8fd4:	2f2e fff6      	movel %fp@(-10),%sp@-
    8fd8:	4eb9 0000 0000 	jsr 0x0
    8fde:	588f           	addql #4,%sp
    8fe0:	2f2e fffa      	movel %fp@(-6),%sp@-
    8fe4:	4eb9 0000 0000 	jsr 0x0
    8fea:	588f           	addql #4,%sp
    8fec:	2f2e fff2      	movel %fp@(-14),%sp@-
    8ff0:	4eb9 0000 0000 	jsr 0x0
    8ff6:	588f           	addql #4,%sp
    8ff8:	7002           	moveq #2,%d0
    8ffa:	6000 00a6      	braw 0x90a2
    8ffe:	202e fffa      	movel %fp@(-6),%d0
    9002:	2040           	moveal %d0,%a0
    9004:	216e fff2 002c 	movel %fp@(-14),%a0@(44)
    900a:	202e 0008      	movel %fp@(8),%d0
    900e:	2040           	moveal %d0,%a0
    9010:	2010           	movel %a0@,%d0
    9012:	7201           	moveq #1,%d1
    9014:	c081           	andl %d1,%d0
    9016:	1000           	moveb %d0,%d0
    9018:	4a00           	tstb %d0
    901a:	671e           	beqs 0x903a
    901c:	202e 0008      	movel %fp@(8),%d0
    9020:	2040           	moveal %d0,%a0
    9022:	2010           	movel %a0@,%d0
    9024:	7202           	moveq #2,%d1
    9026:	c081           	andl %d1,%d0
    9028:	4a80           	tstl %d0
    902a:	660e           	bnes 0x903a
    902c:	202e fffa      	movel %fp@(-6),%d0
    9030:	2040           	moveal %d0,%a0
    9032:	117c ffe4 001c 	moveb #-28,%a0@(28)
    9038:	600c           	bras 0x9046
    903a:	202e fffa      	movel %fp@(-6),%d0
    903e:	2040           	moveal %d0,%a0
    9040:	117c ffe5 001c 	moveb #-27,%a0@(28)
    9046:	202e fff6      	movel %fp@(-10),%d0
    904a:	2040           	moveal %d0,%a0
    904c:	42a8 0004      	clrl %a0@(4)
    9050:	202e fff6      	movel %fp@(-10),%d0
    9054:	2040           	moveal %d0,%a0
    9056:	42a8 0008      	clrl %a0@(8)
    905a:	202e fff6      	movel %fp@(-10),%d0
    905e:	2040           	moveal %d0,%a0
    9060:	42a8 000c      	clrl %a0@(12)
    9064:	202e fff6      	movel %fp@(-10),%d0
    9068:	2040           	moveal %d0,%a0
    906a:	20ae fffa      	movel %fp@(-6),%a0@
    906e:	202e fff6      	movel %fp@(-10),%d0
    9072:	2040           	moveal %d0,%a0
    9074:	4228 0010      	clrb %a0@(16)
    9078:	202e 0008      	movel %fp@(8),%d0
    907c:	2040           	moveal %d0,%a0
    907e:	2010           	movel %a0@,%d0
    9080:	0280 0000 0800 	andil #2048,%d0
    9086:	4a80           	tstl %d0
    9088:	660a           	bnes 0x9094
    908a:	2f2e fff6      	movel %fp@(-10),%sp@-
    908e:	4eba fd28      	jsr %pc@(0x8db8)
    9092:	588f           	addql #4,%sp
    9094:	202e 0008      	movel %fp@(8),%d0
    9098:	2040           	moveal %d0,%a0
    909a:	216e fff6 0018 	movel %fp@(-10),%a0@(24)
    90a0:	4280           	clrl %d0
    90a2:	4e5e           	unlk %fp
    90a4:	4e75           	rts
    90a6:	4e56 fffc      	linkw %fp,#-4
    90aa:	202e 0008      	movel %fp@(8),%d0
    90ae:	2040           	moveal %d0,%a0
    90b0:	2028 0018      	movel %a0@(24),%d0
    90b4:	2d40 fffc      	movel %d0,%fp@(-4)
    90b8:	202e fffc      	movel %fp@(-4),%d0
    90bc:	2040           	moveal %d0,%a0
    90be:	2010           	movel %a0@,%d0
    90c0:	2040           	moveal %d0,%a0
    90c2:	1028 001c      	moveb %a0@(28),%d0
    90c6:	0c00 ffe5      	cmpib #-27,%d0
    90ca:	6618           	bnes 0x90e4
    90cc:	202e fffc      	movel %fp@(-4),%d0
    90d0:	2040           	moveal %d0,%a0
    90d2:	2028 0008      	movel %a0@(8),%d0
    90d6:	4a80           	tstl %d0
    90d8:	6f0a           	bles 0x90e4
    90da:	2f2e fffc      	movel %fp@(-4),%sp@-
    90de:	4eba fd6e      	jsr %pc@(0x8e4e)
    90e2:	588f           	addql #4,%sp
    90e4:	202e fffc      	movel %fp@(-4),%d0
    90e8:	2040           	moveal %d0,%a0
    90ea:	2010           	movel %a0@,%d0
    90ec:	2040           	moveal %d0,%a0
    90ee:	1028 001c      	moveb %a0@(28),%d0
    90f2:	0c00 ffe5      	cmpib #-27,%d0
    90f6:	6618           	bnes 0x9110
    90f8:	202e fffc      	movel %fp@(-4),%d0
    90fc:	2040           	moveal %d0,%a0
    90fe:	2028 0008      	movel %a0@(8),%d0
    9102:	4a80           	tstl %d0
    9104:	6f0a           	bles 0x9110
    9106:	2f2e fffc      	movel %fp@(-4),%sp@-
    910a:	4eba fd42      	jsr %pc@(0x8e4e)
    910e:	588f           	addql #4,%sp
    9110:	202e fffc      	movel %fp@(-4),%d0
    9114:	2040           	moveal %d0,%a0
    9116:	2010           	movel %a0@,%d0
    9118:	2f00           	movel %d0,%sp@-
    911a:	4eb9 0000 0000 	jsr 0x0
    9120:	588f           	addql #4,%sp
    9122:	202e fffc      	movel %fp@(-4),%d0
    9126:	2040           	moveal %d0,%a0
    9128:	2010           	movel %a0@,%d0
    912a:	2040           	moveal %d0,%a0
    912c:	2028 002c      	movel %a0@(44),%d0
    9130:	2f00           	movel %d0,%sp@-
    9132:	4eb9 0000 0000 	jsr 0x0
    9138:	588f           	addql #4,%sp
    913a:	202e fffc      	movel %fp@(-4),%d0
    913e:	2040           	moveal %d0,%a0
    9140:	2010           	movel %a0@,%d0
    9142:	2f00           	movel %d0,%sp@-
    9144:	4eb9 0000 0000 	jsr 0x0
    914a:	588f           	addql #4,%sp
    914c:	2f2e fffc      	movel %fp@(-4),%sp@-
    9150:	4eb9 0000 0000 	jsr 0x0
    9156:	588f           	addql #4,%sp
    9158:	4280           	clrl %d0
    915a:	4e5e           	unlk %fp
    915c:	4e75           	rts
    915e:	4e56 ffec      	linkw %fp,#-20
    9162:	2d6e 0010 fffc 	movel %fp@(16),%fp@(-4)
    9168:	202e 0008      	movel %fp@(8),%d0
    916c:	2040           	moveal %d0,%a0
    916e:	2028 0018      	movel %a0@(24),%d0
    9172:	2d40 fff4      	movel %d0,%fp@(-12)
    9176:	202e fff4      	movel %fp@(-12),%d0
    917a:	2040           	moveal %d0,%a0
    917c:	1028 0010      	moveb %a0@(16),%d0
    9180:	4a00           	tstb %d0
    9182:	6706           	beqs 0x918a
    9184:	4280           	clrl %d0
    9186:	6000 00fc      	braw 0x9284
    918a:	202e fff4      	movel %fp@(-12),%d0
    918e:	2040           	moveal %d0,%a0
    9190:	2010           	movel %a0@,%d0
    9192:	2040           	moveal %d0,%a0
    9194:	2d68 002c fff0 	movel %a0@(44),%fp@(-16)
    919a:	42ae fff8      	clrl %fp@(-8)
    919e:	6000 00d8      	braw 0x9278
    91a2:	202e 000c      	movel %fp@(12),%d0
    91a6:	d0ae fff8      	addl %fp@(-8),%d0
    91aa:	222e fff4      	movel %fp@(-12),%d1
    91ae:	2041           	moveal %d1,%a0
    91b0:	2228 0008      	movel %a0@(8),%d1
    91b4:	d2ae fff0      	addl %fp@(-16),%d1
    91b8:	2041           	moveal %d1,%a0
    91ba:	1210           	moveb %a0@,%d1
    91bc:	2040           	moveal %d0,%a0
    91be:	1081           	moveb %d1,%a0@
    91c0:	202e fff4      	movel %fp@(-12),%d0
    91c4:	2040           	moveal %d0,%a0
    91c6:	2028 0008      	movel %a0@(8),%d0
    91ca:	2200           	movel %d0,%d1
    91cc:	5281           	addql #1,%d1
    91ce:	202e fff4      	movel %fp@(-12),%d0
    91d2:	2040           	moveal %d0,%a0
    91d4:	2141 0008      	movel %d1,%a0@(8)
    91d8:	202e fff4      	movel %fp@(-12),%d0
    91dc:	2040           	moveal %d0,%a0
    91de:	2028 0004      	movel %a0@(4),%d0
    91e2:	2200           	movel %d0,%d1
    91e4:	5281           	addql #1,%d1
    91e6:	202e fff4      	movel %fp@(-12),%d0
    91ea:	2040           	moveal %d0,%a0
    91ec:	2141 0004      	movel %d1,%a0@(4)
    91f0:	53ae fffc      	subql #1,%fp@(-4)
    91f4:	52ae fff8      	addql #1,%fp@(-8)
    91f8:	6002           	bras 0x91fc
    91fa:	4e71           	nop
    91fc:	202e fff4      	movel %fp@(-12),%d0
    9200:	2040           	moveal %d0,%a0
    9202:	2028 0008      	movel %a0@(8),%d0
    9206:	0c80 0000 03ff 	cmpil #1023,%d0
    920c:	6e06           	bgts 0x9214
    920e:	4aae fffc      	tstl %fp@(-4)
    9212:	668e           	bnes 0x91a2
    9214:	4aae fffc      	tstl %fp@(-4)
    9218:	675e           	beqs 0x9278
    921a:	202e fff4      	movel %fp@(-12),%d0
    921e:	2040           	moveal %d0,%a0
    9220:	2228 000c      	movel %a0@(12),%d1
    9224:	202e fff4      	movel %fp@(-12),%d0
    9228:	2040           	moveal %d0,%a0
    922a:	2010           	movel %a0@,%d0
    922c:	2040           	moveal %d0,%a0
    922e:	3028 001a      	movew %a0@(26),%d0
    9232:	3000           	movew %d0,%d0
    9234:	0280 0000 ffff 	andil #65535,%d0
    923a:	b081           	cmpl %d1,%d0
    923c:	6604           	bnes 0x9242
    923e:	4280           	clrl %d0
    9240:	6042           	bras 0x9284
    9242:	2f2e fff4      	movel %fp@(-12),%sp@-
    9246:	4eba fb70      	jsr %pc@(0x8db8)
    924a:	588f           	addql #4,%sp
    924c:	2d40 ffec      	movel %d0,%fp@(-20)
    9250:	202e ffec      	movel %fp@(-20),%d0
    9254:	7201           	moveq #1,%d1
    9256:	b280           	cmpl %d0,%d1
    9258:	670e           	beqs 0x9268
    925a:	7201           	moveq #1,%d1
    925c:	b280           	cmpl %d0,%d1
    925e:	6216           	bhis 0x9276
    9260:	7263           	moveq #99,%d1
    9262:	b280           	cmpl %d0,%d1
    9264:	6708           	beqs 0x926e
    9266:	600a           	bras 0x9272
    9268:	202e fff8      	movel %fp@(-8),%d0
    926c:	6016           	bras 0x9284
    926e:	4280           	clrl %d0
    9270:	6012           	bras 0x9284
    9272:	4280           	clrl %d0
    9274:	600e           	bras 0x9284
    9276:	4e71           	nop
    9278:	4aae fffc      	tstl %fp@(-4)
    927c:	6600 ff7c      	bnew 0x91fa
    9280:	202e fff8      	movel %fp@(-8),%d0
    9284:	4e5e           	unlk %fp
    9286:	4e75           	rts
    9288:	4e56 ffe4      	linkw %fp,#-28
    928c:	2d6e 0010 fff8 	movel %fp@(16),%fp@(-8)
    9292:	422e ffe4      	clrb %fp@(-28)
    9296:	422e ffe5      	clrb %fp@(-27)
    929a:	202e 0008      	movel %fp@(8),%d0
    929e:	2040           	moveal %d0,%a0
    92a0:	2028 0018      	movel %a0@(24),%d0
    92a4:	2d40 fff4      	movel %d0,%fp@(-12)
    92a8:	202e fff4      	movel %fp@(-12),%d0
    92ac:	2040           	moveal %d0,%a0
    92ae:	2010           	movel %a0@,%d0
    92b0:	2040           	moveal %d0,%a0
    92b2:	2d68 002c fff0 	movel %a0@(44),%fp@(-16)
    92b8:	42ae fffc      	clrl %fp@(-4)
    92bc:	6000 00a6      	braw 0x9364
    92c0:	202e fff4      	movel %fp@(-12),%d0
    92c4:	2040           	moveal %d0,%a0
    92c6:	2028 0008      	movel %a0@(8),%d0
    92ca:	d0ae fff0      	addl %fp@(-16),%d0
    92ce:	222e 000c      	movel %fp@(12),%d1
    92d2:	d2ae fffc      	addl %fp@(-4),%d1
    92d6:	2041           	moveal %d1,%a0
    92d8:	1210           	moveb %a0@,%d1
    92da:	2040           	moveal %d0,%a0
    92dc:	1081           	moveb %d1,%a0@
    92de:	202e fff4      	movel %fp@(-12),%d0
    92e2:	2040           	moveal %d0,%a0
    92e4:	2028 0008      	movel %a0@(8),%d0
    92e8:	2200           	movel %d0,%d1
    92ea:	5281           	addql #1,%d1
    92ec:	202e fff4      	movel %fp@(-12),%d0
    92f0:	2040           	moveal %d0,%a0
    92f2:	2141 0008      	movel %d1,%a0@(8)
    92f6:	202e fff4      	movel %fp@(-12),%d0
    92fa:	2040           	moveal %d0,%a0
    92fc:	2028 0004      	movel %a0@(4),%d0
    9300:	2200           	movel %d0,%d1
    9302:	5281           	addql #1,%d1
    9304:	202e fff4      	movel %fp@(-12),%d0
    9308:	2040           	moveal %d0,%a0
    930a:	2141 0004      	movel %d1,%a0@(4)
    930e:	53ae fff8      	subql #1,%fp@(-8)
    9312:	52ae fffc      	addql #1,%fp@(-4)
    9316:	6002           	bras 0x931a
    9318:	4e71           	nop
    931a:	202e fff4      	movel %fp@(-12),%d0
    931e:	2040           	moveal %d0,%a0
    9320:	2028 0008      	movel %a0@(8),%d0
    9324:	0c80 0000 03ff 	cmpil #1023,%d0
    932a:	6e06           	bgts 0x9332
    932c:	4aae fff8      	tstl %fp@(-8)
    9330:	6e8e           	bgts 0x92c0
    9332:	4aae fff8      	tstl %fp@(-8)
    9336:	672c           	beqs 0x9364
    9338:	2f2e fff4      	movel %fp@(-12),%sp@-
    933c:	4eba fb10      	jsr %pc@(0x8e4e)
    9340:	588f           	addql #4,%sp
    9342:	1d40 ffef      	moveb %d0,%fp@(-17)
    9346:	4280           	clrl %d0
    9348:	102e ffef      	moveb %fp@(-17),%d0
    934c:	7205           	moveq #5,%d1
    934e:	b280           	cmpl %d0,%d1
    9350:	670a           	beqs 0x935c
    9352:	0c80 0000 00ff 	cmpil #255,%d0
    9358:	6706           	beqs 0x9360
    935a:	6008           	bras 0x9364
    935c:	701c           	moveq #28,%d0
    935e:	600c           	bras 0x936c
    9360:	7005           	moveq #5,%d0
    9362:	6008           	bras 0x936c
    9364:	4aae fff8      	tstl %fp@(-8)
    9368:	66ae           	bnes 0x9318
    936a:	4280           	clrl %d0
    936c:	4e5e           	unlk %fp
    936e:	4e75           	rts
    9370:	4e56 ffec      	linkw %fp,#-20
    9374:	202e 0008      	movel %fp@(8),%d0
    9378:	2040           	moveal %d0,%a0
    937a:	2028 0018      	movel %a0@(24),%d0
    937e:	2d40 fff8      	movel %d0,%fp@(-8)
    9382:	202e 0010      	movel %fp@(16),%d0
    9386:	7201           	moveq #1,%d1
    9388:	b280           	cmpl %d0,%d1
    938a:	6712           	beqs 0x939e
    938c:	7202           	moveq #2,%d1
    938e:	b280           	cmpl %d0,%d1
    9390:	6722           	beqs 0x93b4
    9392:	4a80           	tstl %d0
    9394:	6646           	bnes 0x93dc
    9396:	2d6e 000c fffc 	movel %fp@(12),%fp@(-4)
    939c:	6046           	bras 0x93e4
    939e:	202e fff8      	movel %fp@(-8),%d0
    93a2:	2040           	moveal %d0,%a0
    93a4:	2028 0004      	movel %a0@(4),%d0
    93a8:	2200           	movel %d0,%d1
    93aa:	d2ae 000c      	addl %fp@(12),%d1
    93ae:	2d41 fffc      	movel %d1,%fp@(-4)
    93b2:	6030           	bras 0x93e4
    93b4:	202e fff8      	movel %fp@(-8),%d0
    93b8:	2040           	moveal %d0,%a0
    93ba:	2010           	movel %a0@,%d0
    93bc:	2040           	moveal %d0,%a0
    93be:	3028 001a      	movew %a0@(26),%d0
    93c2:	3000           	movew %d0,%d0
    93c4:	0280 0000 ffff 	andil #65535,%d0
    93ca:	720a           	moveq #10,%d1
    93cc:	e3a8           	lsll %d1,%d0
    93ce:	d0ae 000c      	addl %fp@(12),%d0
    93d2:	2200           	movel %d0,%d1
    93d4:	5381           	subql #1,%d1
    93d6:	2d41 fffc      	movel %d1,%fp@(-4)
    93da:	6008           	bras 0x93e4
    93dc:	2d6e 000c fffc 	movel %fp@(12),%fp@(-4)
    93e2:	4e71           	nop
    93e4:	4878 0400      	pea 0x400
    93e8:	2f2e fffc      	movel %fp@(-4),%sp@-
    93ec:	4eb9 0000 0000 	jsr 0x0
    93f2:	508f           	addql #8,%sp
    93f4:	2d40 ffee      	movel %d0,%fp@(-18)
    93f8:	2d41 fff2      	movel %d1,%fp@(-14)
    93fc:	202e ffee      	movel %fp@(-18),%d0
    9400:	4a80           	tstl %d0
    9402:	6c08           	bges 0x940c
    9404:	42ae ffee      	clrl %fp@(-18)
    9408:	6000 011a      	braw 0x9524
    940c:	222e ffee      	movel %fp@(-18),%d1
    9410:	202e fff8      	movel %fp@(-8),%d0
    9414:	2040           	moveal %d0,%a0
    9416:	2010           	movel %a0@,%d0
    9418:	2040           	moveal %d0,%a0
    941a:	3028 001a      	movew %a0@(26),%d0
    941e:	3000           	movew %d0,%d0
    9420:	0280 0000 ffff 	andil #65535,%d0
    9426:	b081           	cmpl %d1,%d0
    9428:	6c2c           	bges 0x9456
    942a:	202e fff8      	movel %fp@(-8),%d0
    942e:	2040           	moveal %d0,%a0
    9430:	2010           	movel %a0@,%d0
    9432:	2040           	moveal %d0,%a0
    9434:	3028 001a      	movew %a0@(26),%d0
    9438:	3000           	movew %d0,%d0
    943a:	0280 0000 ffff 	andil #65535,%d0
    9440:	5380           	subql #1,%d0
    9442:	2d40 ffee      	movel %d0,%fp@(-18)
    9446:	202e fff8      	movel %fp@(-8),%d0
    944a:	2040           	moveal %d0,%a0
    944c:	117c 0001 0010 	moveb #1,%a0@(16)
    9452:	6000 00d0      	braw 0x9524
    9456:	222e ffee      	movel %fp@(-18),%d1
    945a:	202e fff8      	movel %fp@(-8),%d0
    945e:	2040           	moveal %d0,%a0
    9460:	2010           	movel %a0@,%d0
    9462:	2040           	moveal %d0,%a0
    9464:	3028 001a      	movew %a0@(26),%d0
    9468:	3000           	movew %d0,%d0
    946a:	0280 0000 ffff 	andil #65535,%d0
    9470:	b081           	cmpl %d1,%d0
    9472:	677e           	beqs 0x94f2
    9474:	222e ffee      	movel %fp@(-18),%d1
    9478:	202e fff8      	movel %fp@(-8),%d0
    947c:	2040           	moveal %d0,%a0
    947e:	2010           	movel %a0@,%d0
    9480:	2f01           	movel %d1,%sp@-
    9482:	2f00           	movel %d0,%sp@-
    9484:	4eb9 0000 0000 	jsr 0x0
    948a:	508f           	addql #8,%sp
    948c:	1d40 fff7      	moveb %d0,%fp@(-9)
    9490:	4280           	clrl %d0
    9492:	102e fff7      	moveb %fp@(-9),%d0
    9496:	7201           	moveq #1,%d1
    9498:	b280           	cmpl %d0,%d1
    949a:	6746           	beqs 0x94e2
    949c:	0c80 0000 00ff 	cmpil #255,%d0
    94a2:	677e           	beqs 0x9522
    94a4:	4a80           	tstl %d0
    94a6:	6648           	bnes 0x94f0
    94a8:	2f2e fff8      	movel %fp@(-8),%sp@-
    94ac:	4eba f90a      	jsr %pc@(0x8db8)
    94b0:	588f           	addql #4,%sp
    94b2:	1d40 fff7      	moveb %d0,%fp@(-9)
    94b6:	4280           	clrl %d0
    94b8:	102e fff7      	moveb %fp@(-9),%d0
    94bc:	7201           	moveq #1,%d1
    94be:	b280           	cmpl %d0,%d1
    94c0:	670e           	beqs 0x94d0
    94c2:	7263           	moveq #99,%d1
    94c4:	b280           	cmpl %d0,%d1
    94c6:	6716           	beqs 0x94de
    94c8:	4a80           	tstl %d0
    94ca:	6702           	beqs 0x94ce
    94cc:	6012           	bras 0x94e0
    94ce:	6010           	bras 0x94e0
    94d0:	202e fff8      	movel %fp@(-8),%d0
    94d4:	2040           	moveal %d0,%a0
    94d6:	117c 0001 0010 	moveb #1,%a0@(16)
    94dc:	6002           	bras 0x94e0
    94de:	4e71           	nop
    94e0:	6010           	bras 0x94f2
    94e2:	202e fff8      	movel %fp@(-8),%d0
    94e6:	2040           	moveal %d0,%a0
    94e8:	117c 0001 0010 	moveb #1,%a0@(16)
    94ee:	6002           	bras 0x94f2
    94f0:	4e71           	nop
    94f2:	202e fff8      	movel %fp@(-8),%d0
    94f6:	2040           	moveal %d0,%a0
    94f8:	216e fffc 0004 	movel %fp@(-4),%a0@(4)
    94fe:	222e fff2      	movel %fp@(-14),%d1
    9502:	202e fff8      	movel %fp@(-8),%d0
    9506:	2040           	moveal %d0,%a0
    9508:	2141 0008      	movel %d1,%a0@(8)
    950c:	202e ffee      	movel %fp@(-18),%d0
    9510:	2200           	movel %d0,%d1
    9512:	5281           	addql #1,%d1
    9514:	202e fff8      	movel %fp@(-8),%d0
    9518:	2040           	moveal %d0,%a0
    951a:	2141 000c      	movel %d1,%a0@(12)
    951e:	4e71           	nop
    9520:	6002           	bras 0x9524
    9522:	4e71           	nop
    9524:	4e5e           	unlk %fp
    9526:	4e75           	rts
    9528:	4e56 0000      	linkw %fp,#0
    952c:	202e 0008      	movel %fp@(8),%d0
    9530:	2040           	moveal %d0,%a0
    9532:	2028 0014      	movel %a0@(20),%d0
    9536:	2f00           	movel %d0,%sp@-
    9538:	4eb9 0000 0000 	jsr 0x0
    953e:	588f           	addql #4,%sp
    9540:	4e5e           	unlk %fp
    9542:	4e75           	rts
    9544:	4e56 fffc      	linkw %fp,#-4
    9548:	202e 0008      	movel %fp@(8),%d0
    954c:	2040           	moveal %d0,%a0
    954e:	2028 0018      	movel %a0@(24),%d0
    9552:	2d40 fffc      	movel %d0,%fp@(-4)
    9556:	202e fffc      	movel %fp@(-4),%d0
    955a:	2040           	moveal %d0,%a0
    955c:	2028 0004      	movel %a0@(4),%d0
    9560:	4e5e           	unlk %fp
    9562:	4e75           	rts
    9564:	4e56 0000      	linkw %fp,#0
    9568:	2f2e 0010      	movel %fp@(16),%sp@-
    956c:	2f2e 000c      	movel %fp@(12),%sp@-
    9570:	4eb9 0000 0000 	jsr 0x0
    9576:	508f           	addql #8,%sp
    9578:	4e5e           	unlk %fp
    957a:	4e75           	rts
    957c:	4e56 0000      	linkw %fp,#0
    9580:	4879 0000 0000 	pea 0x0
    9586:	4879 0000 0000 	pea 0x0
    958c:	4879 0000 0000 	pea 0x0
    9592:	4eb9 0000 0000 	jsr 0x0
    9598:	4fef 000c      	lea %sp@(12),%sp
    959c:	4879 0000 0000 	pea 0x0
    95a2:	4879 0000 0000 	pea 0x0
    95a8:	4879 0000 0000 	pea 0x0
    95ae:	4eb9 0000 0000 	jsr 0x0
    95b4:	4fef 000c      	lea %sp@(12),%sp
    95b8:	4e5e           	unlk %fp
    95ba:	4e75           	rts
    95bc:	48e7 0102      	moveml %d7/%fp,%sp@-
    95c0:	206f 000c      	moveal %sp@(12),%a0
    95c4:	7e0b           	moveq #11,%d7
    95c6:	4e46           	trap #6
    95c8:	43fb 0170 0000 	lea %pc@(0x95ca),%a1
    95ce:	0000 
    95d0:	206f 000c      	moveal %sp@(12),%a0
    95d4:	7e12           	moveq #18,%d7
    95d6:	4e46           	trap #6
    95d8:	43fb 0170 0000 	lea %pc@(0x95da),%a1
    95de:	0000 
    95e0:	7e11           	moveq #17,%d7
    95e2:	4e46           	trap #6
    95e4:	4cdf 4080      	moveml %sp@+,%d7/%fp
    95e8:	4e75           	rts
    95ea:	48e7 0122      	moveml %d7/%a2/%fp,%sp@-
    95ee:	206f 0014      	moveal %sp@(20),%a0
    95f2:	7e0b           	moveq #11,%d7
    95f4:	4e46           	trap #6
    95f6:	43fb 0170 0000 	lea %pc@(0x95f8),%a1
    95fc:	0000 
    95fe:	206f 0014      	moveal %sp@(20),%a0
    9602:	7e12           	moveq #18,%d7
    9604:	4e46           	trap #6
    9606:	2449           	moveal %a1,%a2
    9608:	206f 0010      	moveal %sp@(16),%a0
    960c:	7e0b           	moveq #11,%d7
    960e:	4e46           	trap #6
    9610:	43fb 0170 0000 	lea %pc@(0x9612),%a1
    9616:	0000 
    9618:	d3fc 0000 0040 	addal #64,%a1
    961e:	206f 0010      	moveal %sp@(16),%a0
    9622:	7e12           	moveq #18,%d7
    9624:	4e46           	trap #6
    9626:	7e15           	moveq #21,%d7
    9628:	4e46           	trap #6
    962a:	4cdf 4480      	moveml %sp@+,%d7/%a2/%fp
    962e:	4e75           	rts
    9630:	48e7 0122      	moveml %d7/%a2/%fp,%sp@-
    9634:	4280           	clrl %d0
    9636:	7e35           	moveq #53,%d7
    9638:	4e46           	trap #6
    963a:	4cdf 4480      	moveml %sp@+,%d7/%a2/%fp
    963e:	4e75           	rts
    9640:	48e7 0122      	moveml %d7/%a2/%fp,%sp@-
    9644:	202f 0010      	movel %sp@(16),%d0
    9648:	7e36           	moveq #54,%d7
    964a:	4e46           	trap #6
    964c:	4cdf 4480      	moveml %sp@+,%d7/%a2/%fp
    9650:	4e75           	rts
    9652:	4e71           	nop
    9654:	302f 0004      	movew %sp@(4),%d0
    9658:	c0ef 000a      	muluw %sp@(10),%d0
    965c:	322f 0006      	movew %sp@(6),%d1
    9660:	c2ef 0008      	muluw %sp@(8),%d1
    9664:	d041           	addw %d1,%d0
    9666:	4840           	swap %d0
    9668:	4240           	clrw %d0
    966a:	322f 0006      	movew %sp@(6),%d1
    966e:	c2ef 000a      	muluw %sp@(10),%d1
    9672:	d081           	addl %d1,%d0
    9674:	4e75           	rts
    9676:	4e71           	nop
    9678:	2f02           	movel %d2,%sp@-
    967a:	222f 000c      	movel %sp@(12),%d1
    967e:	202f 0008      	movel %sp@(8),%d0
    9682:	0c81 0001 0000 	cmpil #65536,%d1
    9688:	6416           	bccs 0x96a0
    968a:	2400           	movel %d0,%d2
    968c:	4242           	clrw %d2
    968e:	4842           	swap %d2
    9690:	84c1           	divuw %d1,%d2
    9692:	3002           	movew %d2,%d0
    9694:	4840           	swap %d0
    9696:	342f 000a      	movew %sp@(10),%d2
    969a:	84c1           	divuw %d1,%d2
    969c:	3002           	movew %d2,%d0
    969e:	6030           	bras 0x96d0
    96a0:	2401           	movel %d1,%d2
    96a2:	e289           	lsrl #1,%d1
    96a4:	e288           	lsrl #1,%d0
    96a6:	0c81 0001 0000 	cmpil #65536,%d1
    96ac:	64f4           	bccs 0x96a2
    96ae:	80c1           	divuw %d1,%d0
    96b0:	0280 0000 ffff 	andil #65535,%d0
    96b6:	2202           	movel %d2,%d1
    96b8:	c2c0           	muluw %d0,%d1
    96ba:	4842           	swap %d2
    96bc:	c4c0           	muluw %d0,%d2
    96be:	4842           	swap %d2
    96c0:	4a42           	tstw %d2
    96c2:	660a           	bnes 0x96ce
    96c4:	d282           	addl %d2,%d1
    96c6:	6506           	bcss 0x96ce
    96c8:	b2af 0008      	cmpl %sp@(8),%d1
    96cc:	6302           	blss 0x96d0
    96ce:	5380           	subql #1,%d0
    96d0:	241f           	movel %sp@+,%d2
    96d2:	4e75           	rts
    96d4:	4e56 0000      	linkw %fp,#0
    96d8:	4878 0001      	pea 0x1
    96dc:	2f2e 0014      	movel %fp@(20),%sp@-
    96e0:	2f2e 0010      	movel %fp@(16),%sp@-
    96e4:	2f2e 000c      	movel %fp@(12),%sp@-
    96e8:	2f2e 0008      	movel %fp@(8),%sp@-
    96ec:	61ff 0000 0000 	bsrl 0x96ee
    96f2:	4e5e           	unlk %fp
    96f4:	4e75           	rts
    96f6:	4e71           	nop
    96f8:	2f02           	movel %d2,%sp@-
    96fa:	7401           	moveq #1,%d2
    96fc:	222f 000c      	movel %sp@(12),%d1
    9700:	6a04           	bpls 0x9706
    9702:	4481           	negl %d1
    9704:	4402           	negb %d2
    9706:	202f 0008      	movel %sp@(8),%d0
    970a:	6a04           	bpls 0x9710
    970c:	4480           	negl %d0
    970e:	4402           	negb %d2
    9710:	2f01           	movel %d1,%sp@-
    9712:	2f00           	movel %d0,%sp@-
    9714:	61ff 0000 0000 	bsrl 0x9716
    971a:	508f           	addql #8,%sp
    971c:	4a02           	tstb %d2
    971e:	6a02           	bpls 0x9722
    9720:	4480           	negl %d0
    9722:	241f           	movel %sp@+,%d2
    9724:	4e75           	rts
    9726:	4e71           	nop
    9728:	222f 0008      	movel %sp@(8),%d1
    972c:	202f 0004      	movel %sp@(4),%d0
    9730:	2f01           	movel %d1,%sp@-
    9732:	2f00           	movel %d0,%sp@-
    9734:	61ff 0000 0000 	bsrl 0x9736
    973a:	508f           	addql #8,%sp
    973c:	222f 0008      	movel %sp@(8),%d1
    9740:	2f01           	movel %d1,%sp@-
    9742:	2f00           	movel %d0,%sp@-
    9744:	61ff 0000 0000 	bsrl 0x9746
    974a:	508f           	addql #8,%sp
    974c:	222f 0004      	movel %sp@(4),%d1
    9750:	9280           	subl %d0,%d1
    9752:	2001           	movel %d1,%d0
    9754:	4e75           	rts
    9756:	4e71           	nop
    9758:	222f 0008      	movel %sp@(8),%d1
    975c:	202f 0004      	movel %sp@(4),%d0
    9760:	2f01           	movel %d1,%sp@-
    9762:	2f00           	movel %d0,%sp@-
    9764:	61ff 0000 0000 	bsrl 0x9766
    976a:	508f           	addql #8,%sp
    976c:	222f 0008      	movel %sp@(8),%d1
    9770:	2f01           	movel %d1,%sp@-
    9772:	2f00           	movel %d0,%sp@-
    9774:	61ff 0000 0000 	bsrl 0x9776
    977a:	508f           	addql #8,%sp
    977c:	222f 0004      	movel %sp@(4),%d1
    9780:	9280           	subl %d0,%d1
    9782:	2001           	movel %d1,%d0
    9784:	4e75           	rts
    9786:	4e71           	nop
    9788:	8087           	orl %d7,%d0
    978a:	3e3c 0003      	movew #3,%d7
    978e:	7c02           	moveq #2,%d6
    9790:	4ef9 0000 0000 	jmp 0x0
    9796:	203c 7ff0 0000 	movel #2146435072,%d0
    979c:	7200           	moveq #0,%d1
    979e:	8087           	orl %d7,%d0
    97a0:	3e3c 0005      	movew #5,%d7
    97a4:	7c02           	moveq #2,%d6
    97a6:	4ef9 0000 0000 	jmp 0x0
    97ac:	7000           	moveq #0,%d0
    97ae:	2200           	movel %d0,%d1
    97b0:	3e3c 0003      	movew #3,%d7
    97b4:	7c02           	moveq #2,%d6
    97b6:	4ef9 0000 0000 	jmp 0x0
    97bc:	70ff           	moveq #-1,%d0
    97be:	2200           	movel %d0,%d1
    97c0:	3e3c 0011      	movew #17,%d7
    97c4:	7c02           	moveq #2,%d6
    97c6:	4ef9 0000 0000 	jmp 0x0
    97cc:	203c 7ff0 0000 	movel #2146435072,%d0
    97d2:	7200           	moveq #0,%d1
    97d4:	8087           	orl %d7,%d0
    97d6:	3e3c 0009      	movew #9,%d7
    97da:	7c02           	moveq #2,%d6
    97dc:	4ef9 0000 0000 	jmp 0x0
    97e2:	086f 001f 000c 	bchg #31,%sp@(12)
    97e8:	4e56 0000      	linkw %fp,#0
    97ec:	48e7 3f00      	moveml %d2-%d7,%sp@-
    97f0:	202e 0008      	movel %fp@(8),%d0
    97f4:	222e 000c      	movel %fp@(12),%d1
    97f8:	242e 0010      	movel %fp@(16),%d2
    97fc:	262e 0014      	movel %fp@(20),%d3
    9800:	2e00           	movel %d0,%d7
    9802:	d281           	addl %d1,%d1
    9804:	d180           	addxl %d0,%d0
    9806:	6700 0286      	beqw 0x9a8e
    980a:	2c02           	movel %d2,%d6
    980c:	d683           	addl %d3,%d3
    980e:	d582           	addxl %d2,%d2
    9810:	6700 029a      	beqw 0x9aac
    9814:	0287 8000 0000 	andil #-2147483648,%d7
    981a:	4846           	swap %d6
    981c:	0246 8000      	andiw #-32768,%d6
    9820:	8e46           	orw %d6,%d7
    9822:	2047           	moveal %d7,%a0
    9824:	2c3c 001f ffff 	movel #2097151,%d6
    982a:	2e3c 0020 0000 	movel #2097152,%d7
    9830:	2800           	movel %d0,%d4
    9832:	c086           	andl %d6,%d0
    9834:	4686           	notl %d6
    9836:	c886           	andl %d6,%d4
    9838:	6700 0246      	beqw 0x9a80
    983c:	b886           	cmpl %d6,%d4
    983e:	6700 02ca      	beqw 0x9b0a
    9842:	8087           	orl %d7,%d0
    9844:	4844           	swap %d4
    9846:	ea4c           	lsrw #5,%d4
    9848:	2a02           	movel %d2,%d5
    984a:	ca86           	andl %d6,%d5
    984c:	6700 0238      	beqw 0x9a86
    9850:	ba86           	cmpl %d6,%d5
    9852:	6700 02b6      	beqw 0x9b0a
    9856:	4686           	notl %d6
    9858:	c486           	andl %d6,%d2
    985a:	8487           	orl %d7,%d2
    985c:	4845           	swap %d5
    985e:	ea4d           	lsrw #5,%d5
    9860:	48e7 0030      	moveml %a2-%a3,%sp@-
    9864:	2444           	moveal %d4,%a2
    9866:	2645           	moveal %d5,%a3
    9868:	7e00           	moveq #0,%d7
    986a:	2c07           	movel %d7,%d6
    986c:	2a03           	movel %d3,%d5
    986e:	2802           	movel %d2,%d4
    9870:	2607           	movel %d7,%d3
    9872:	2407           	movel %d7,%d2
    9874:	c98a           	exg %d4,%a2
    9876:	cb8b           	exg %d5,%a3
    9878:	ba44           	cmpw %d4,%d5
    987a:	6700 00cc      	beqw 0x9948
    987e:	6200 0064      	bhiw 0x98e4
    9882:	3404           	movew %d4,%d2
    9884:	9445           	subw %d5,%d2
    9886:	c98a           	exg %d4,%a2
    9888:	cb8b           	exg %d5,%a3
    988a:	0c42 0037      	cmpiw #55,%d2
    988e:	6c00 01d2      	bgew 0x9a62
    9892:	0c42 0020      	cmpiw #32,%d2
    9896:	6c00 0022      	bgew 0x98ba
    989a:	0c42 0010      	cmpiw #16,%d2
    989e:	6c00 002a      	bgew 0x98ca
    98a2:	6000 000a      	braw 0x98ae
    98a6:	e28c           	lsrl #1,%d4
    98a8:	e295           	roxrl #1,%d5
    98aa:	e296           	roxrl #1,%d6
    98ac:	e297           	roxrl #1,%d7
    98ae:	51ca fff6      	dbf %d2,0x98a6
    98b2:	7400           	moveq #0,%d2
    98b4:	2602           	movel %d2,%d3
    98b6:	6000 0094      	braw 0x994c
    98ba:	2e06           	movel %d6,%d7
    98bc:	2c05           	movel %d5,%d6
    98be:	2a04           	movel %d4,%d5
    98c0:	7800           	moveq #0,%d4
    98c2:	0442 0020      	subiw #32,%d2
    98c6:	6000 ffd2      	braw 0x989a
    98ca:	3e06           	movew %d6,%d7
    98cc:	4847           	swap %d7
    98ce:	3c05           	movew %d5,%d6
    98d0:	4846           	swap %d6
    98d2:	3a04           	movew %d4,%d5
    98d4:	4845           	swap %d5
    98d6:	383c 0000      	movew #0,%d4
    98da:	4844           	swap %d4
    98dc:	0442 0010      	subiw #16,%d2
    98e0:	6000 ffcc      	braw 0x98ae
    98e4:	c945           	exg %d4,%d5
    98e6:	3c04           	movew %d4,%d6
    98e8:	9c45           	subw %d5,%d6
    98ea:	c98a           	exg %d4,%a2
    98ec:	cb8b           	exg %d5,%a3
    98ee:	0c46 0037      	cmpiw #55,%d6
    98f2:	6c00 0150      	bgew 0x9a44
    98f6:	0c46 0020      	cmpiw #32,%d6
    98fa:	6c00 0022      	bgew 0x991e
    98fe:	0c46 0010      	cmpiw #16,%d6
    9902:	6c00 002a      	bgew 0x992e
    9906:	6000 000a      	braw 0x9912
    990a:	e288           	lsrl #1,%d0
    990c:	e291           	roxrl #1,%d1
    990e:	e292           	roxrl #1,%d2
    9910:	e293           	roxrl #1,%d3
    9912:	51ce fff6      	dbf %d6,0x990a
    9916:	7e00           	moveq #0,%d7
    9918:	2c07           	movel %d7,%d6
    991a:	6000 0030      	braw 0x994c
    991e:	2602           	movel %d2,%d3
    9920:	2401           	movel %d1,%d2
    9922:	2200           	movel %d0,%d1
    9924:	7000           	moveq #0,%d0
    9926:	0446 0020      	subiw #32,%d6
    992a:	6000 ffd2      	braw 0x98fe
    992e:	3602           	movew %d2,%d3
    9930:	4843           	swap %d3
    9932:	3401           	movew %d1,%d2
    9934:	4842           	swap %d2
    9936:	3200           	movew %d0,%d1
    9938:	4841           	swap %d1
    993a:	303c 0000      	movew #0,%d0
    993e:	4840           	swap %d0
    9940:	0446 0010      	subiw #16,%d6
    9944:	6000 ffcc      	braw 0x9912
    9948:	c98a           	exg %d4,%a2
    994a:	cb8b           	exg %d5,%a3
    994c:	cf88           	exg %d7,%a0
    994e:	cd8b           	exg %d6,%a3
    9950:	2c07           	movel %d7,%d6
    9952:	3e3c 0000      	movew #0,%d7
    9956:	4846           	swap %d6
    9958:	3c3c 0000      	movew #0,%d6
    995c:	bf86           	eorl %d7,%d6
    995e:	6b00 006e      	bmiw 0x99ce
    9962:	cf88           	exg %d7,%a0
    9964:	cd8b           	exg %d6,%a3
    9966:	d687           	addl %d7,%d3
    9968:	d586           	addxl %d6,%d2
    996a:	d385           	addxl %d5,%d1
    996c:	d184           	addxl %d4,%d0
    996e:	280a           	movel %a2,%d4
    9970:	2e08           	movel %a0,%d7
    9972:	0287 8000 0000 	andil #-2147483648,%d7
    9978:	4cdf 0c00      	moveml %sp@+,%a2-%a3
    997c:	0800 0036      	btst #54,%d0
    9980:	6700 000c      	beqw 0x998e
    9984:	e288           	lsrl #1,%d0
    9986:	e291           	roxrl #1,%d1
    9988:	e292           	roxrl #1,%d2
    998a:	e293           	roxrl #1,%d3
    998c:	5244           	addqw #1,%d4
    998e:	41fa 0020      	lea %pc@(0x99b0),%a0
    9992:	43f9 0000 0000 	lea 0x0,%a1
    9998:	3c29 0006      	movew %a1@(6),%d6
    999c:	6700 0750      	beqw 0xa0ee
    99a0:	0c46 0002      	cmpiw #2,%d6
    99a4:	6200 07ac      	bhiw 0xa152
    99a8:	6d00 07a8      	bltw 0xa152
    99ac:	6000 07a4      	braw 0xa152
    99b0:	0c44 07ff      	cmpiw #2047,%d4
    99b4:	6c00 0012      	bgew 0x99c8
    99b8:	0880 0034      	bclr #52,%d0
    99bc:	e94c           	lslw #4,%d4
    99be:	4840           	swap %d0
    99c0:	8044           	orw %d4,%d0
    99c2:	4840           	swap %d0
    99c4:	6000 0128      	braw 0x9aee
    99c8:	7a01           	moveq #1,%d5
    99ca:	6000 fdca      	braw 0x9796
    99ce:	cf88           	exg %d7,%a0
    99d0:	cd8b           	exg %d6,%a3
    99d2:	9687           	subl %d7,%d3
    99d4:	9586           	subxl %d6,%d2
    99d6:	9385           	subxl %d5,%d1
    99d8:	9184           	subxl %d4,%d0
    99da:	6700 010e      	beqw 0x9aea
    99de:	6a00 0012      	bplw 0x99f2
    99e2:	2e08           	movel %a0,%d7
    99e4:	0847 001f      	bchg #31,%d7
    99e8:	2047           	moveal %d7,%a0
    99ea:	4483           	negl %d3
    99ec:	4082           	negxl %d2
    99ee:	4081           	negxl %d1
    99f0:	4080           	negxl %d0
    99f2:	280a           	movel %a2,%d4
    99f4:	2e08           	movel %a0,%d7
    99f6:	0287 8000 0000 	andil #-2147483648,%d7
    99fc:	4cdf 0c00      	moveml %sp@+,%a2-%a3
    9a00:	0800 0036      	btst #54,%d0
    9a04:	6700 000c      	beqw 0x9a12
    9a08:	e288           	lsrl #1,%d0
    9a0a:	e291           	roxrl #1,%d1
    9a0c:	e292           	roxrl #1,%d2
    9a0e:	e293           	roxrl #1,%d3
    9a10:	5244           	addqw #1,%d4
    9a12:	41fa 0020      	lea %pc@(0x9a34),%a0
    9a16:	43f9 0000 0000 	lea 0x0,%a1
    9a1c:	3c29 0006      	movew %a1@(6),%d6
    9a20:	6700 06cc      	beqw 0xa0ee
    9a24:	0c46 0002      	cmpiw #2,%d6
    9a28:	6200 0728      	bhiw 0xa152
    9a2c:	6d00 0724      	bltw 0xa152
    9a30:	6000 0720      	braw 0xa152
    9a34:	0880 0034      	bclr #52,%d0
    9a38:	e94c           	lslw #4,%d4
    9a3a:	4840           	swap %d0
    9a3c:	8044           	orw %d4,%d0
    9a3e:	4840           	swap %d0
    9a40:	6000 00ac      	braw 0x9aee
    9a44:	4cdf 0c00      	moveml %sp@+,%a2-%a3
    9a48:	202e 0010      	movel %fp@(16),%d0
    9a4c:	222e 0014      	movel %fp@(20),%d1
    9a50:	41f9 0000 0000 	lea 0x0,%a0
    9a56:	30bc 0000      	movew #0,%a0@
    9a5a:	4cdf 00fc      	moveml %sp@+,%d2-%d7
    9a5e:	4e5e           	unlk %fp
    9a60:	4e75           	rts
    9a62:	4cdf 0c00      	moveml %sp@+,%a2-%a3
    9a66:	202e 0008      	movel %fp@(8),%d0
    9a6a:	222e 000c      	movel %fp@(12),%d1
    9a6e:	41f9 0000 0000 	lea 0x0,%a0
    9a74:	30bc 0000      	movew #0,%a0@
    9a78:	4cdf 00fc      	moveml %sp@+,%d2-%d7
    9a7c:	4e5e           	unlk %fp
    9a7e:	4e75           	rts
    9a80:	2807           	movel %d7,%d4
    9a82:	6000 fdc0      	braw 0x9844
    9a86:	2a07           	movel %d7,%d5
    9a88:	4686           	notl %d6
    9a8a:	6000 fdd0      	braw 0x985c
    9a8e:	2002           	movel %d2,%d0
    9a90:	2203           	movel %d3,%d1
    9a92:	6600 0020      	bnew 0x9ab4
    9a96:	0c80 8000 0000 	cmpil #-2147483648,%d0
    9a9c:	6600 0016      	bnew 0x9ab4
    9aa0:	0287 8000 0000 	andil #-2147483648,%d7
    9aa6:	4280           	clrl %d0
    9aa8:	6000 0044      	braw 0x9aee
    9aac:	202e 0008      	movel %fp@(8),%d0
    9ab0:	222e 000c      	movel %fp@(12),%d1
    9ab4:	7a01           	moveq #1,%d5
    9ab6:	2e00           	movel %d0,%d7
    9ab8:	0287 8000 0000 	andil #-2147483648,%d7
    9abe:	0880 001f      	bclr #31,%d0
    9ac2:	0c80 7ff0 0000 	cmpil #2146435072,%d0
    9ac8:	6c00 0010      	bgew 0x9ada
    9acc:	2000           	movel %d0,%d0
    9ace:	6600 001e      	bnew 0x9aee
    9ad2:	0887 001f      	bclr #31,%d7
    9ad6:	6000 0016      	braw 0x9aee
    9ada:	0280 000f ffff 	andil #1048575,%d0
    9ae0:	8081           	orl %d1,%d0
    9ae2:	6600 fcd8      	bnew 0x97bc
    9ae6:	6000 fcae      	braw 0x9796
    9aea:	4cdf 0c00      	moveml %sp@+,%a2-%a3
    9aee:	41f9 0000 0000 	lea 0x0,%a0
    9af4:	30bc 0000      	movew #0,%a0@
    9af8:	8087           	orl %d7,%d0
    9afa:	4cdf 00fc      	moveml %sp@+,%d2-%d7
    9afe:	4e5e           	unlk %fp
    9b00:	4e75           	rts
    9b02:	e288           	lsrl #1,%d0
    9b04:	e291           	roxrl #1,%d1
    9b06:	6000 ffe6      	braw 0x9aee
    9b0a:	7a01           	moveq #1,%d5
    9b0c:	202e 0008      	movel %fp@(8),%d0
    9b10:	222e 000c      	movel %fp@(12),%d1
    9b14:	242e 0010      	movel %fp@(16),%d2
    9b18:	262e 0014      	movel %fp@(20),%d3
    9b1c:	283c 7ff0 0000 	movel #2146435072,%d4
    9b22:	2e00           	movel %d0,%d7
    9b24:	2c02           	movel %d2,%d6
    9b26:	0880 001f      	bclr #31,%d0
    9b2a:	0882 001f      	bclr #31,%d2
    9b2e:	b084           	cmpl %d4,%d0
    9b30:	6200 fc8a      	bhiw 0x97bc
    9b34:	6600 0008      	bnew 0x9b3e
    9b38:	4a81           	tstl %d1
    9b3a:	6600 fc80      	bnew 0x97bc
    9b3e:	b484           	cmpl %d4,%d2
    9b40:	6200 fc7a      	bhiw 0x97bc
    9b44:	6600 0008      	bnew 0x9b4e
    9b48:	4a83           	tstl %d3
    9b4a:	6600 fc70      	bnew 0x97bc
    9b4e:	bf86           	eorl %d7,%d6
    9b50:	6b00 000c      	bmiw 0x9b5e
    9b54:	0287 8000 0000 	andil #-2147483648,%d7
    9b5a:	6000 fc3a      	braw 0x9796
    9b5e:	b082           	cmpl %d2,%d0
    9b60:	6600 0008      	bnew 0x9b6a
    9b64:	b283           	cmpl %d3,%d1
    9b66:	6700 fc54      	beqw 0x97bc
    9b6a:	0287 8000 0000 	andil #-2147483648,%d7
    9b70:	b084           	cmpl %d4,%d0
    9b72:	6700 fc22      	beqw 0x9796
    9b76:	0847 001f      	bchg #31,%d7
    9b7a:	6000 fc1a      	braw 0x9796
    9b7e:	4e56 0000      	linkw %fp,#0
    9b82:	48e7 3f00      	moveml %d2-%d7,%sp@-
    9b86:	202e 0008      	movel %fp@(8),%d0
    9b8a:	222e 000c      	movel %fp@(12),%d1
    9b8e:	242e 0010      	movel %fp@(16),%d2
    9b92:	262e 0014      	movel %fp@(20),%d3
    9b96:	2e00           	movel %d0,%d7
    9b98:	b587           	eorl %d2,%d7
    9b9a:	0287 8000 0000 	andil #-2147483648,%d7
    9ba0:	2047           	moveal %d7,%a0
    9ba2:	2e3c 7ff0 0000 	movel #2146435072,%d7
    9ba8:	2c07           	movel %d7,%d6
    9baa:	4686           	notl %d6
    9bac:	0880 001f      	bclr #31,%d0
    9bb0:	2800           	movel %d0,%d4
    9bb2:	8881           	orl %d1,%d4
    9bb4:	6700 0120      	beqw 0x9cd6
    9bb8:	2800           	movel %d0,%d4
    9bba:	0882 001f      	bclr #31,%d2
    9bbe:	2a02           	movel %d2,%d5
    9bc0:	8a83           	orl %d3,%d5
    9bc2:	6700 0106      	beqw 0x9cca
    9bc6:	2a02           	movel %d2,%d5
    9bc8:	b087           	cmpl %d7,%d0
    9bca:	6200 00dc      	bhiw 0x9ca8
    9bce:	6700 00ec      	beqw 0x9cbc
    9bd2:	b487           	cmpl %d7,%d2
    9bd4:	6200 00d2      	bhiw 0x9ca8
    9bd8:	6700 00d4      	beqw 0x9cae
    9bdc:	c887           	andl %d7,%d4
    9bde:	6700 0120      	beqw 0x9d00
    9be2:	c086           	andl %d6,%d0
    9be4:	0080 0010 0000 	oril #1048576,%d0
    9bea:	4844           	swap %d4
    9bec:	e84c           	lsrw #4,%d4
    9bee:	ca87           	andl %d7,%d5
    9bf0:	6700 0124      	beqw 0x9d16
    9bf4:	c486           	andl %d6,%d2
    9bf6:	0082 0010 0000 	oril #1048576,%d2
    9bfc:	4845           	swap %d5
    9bfe:	e84d           	lsrw #4,%d5
    9c00:	d845           	addw %d5,%d4
    9c02:	0444 03ff      	subiw #1023,%d4
    9c06:	48e7 0030      	moveml %a2-%a3,%sp@-
    9c0a:	247c 0000 0000 	moveal #0,%a2
    9c10:	2644           	moveal %d4,%a3
    9c12:	ea9a           	rorl #5,%d2
    9c14:	4842           	swap %d2
    9c16:	ea9b           	rorl #5,%d3
    9c18:	4843           	swap %d3
    9c1a:	3c03           	movew %d3,%d6
    9c1c:	0246 07ff      	andiw #2047,%d6
    9c20:	8446           	orw %d6,%d2
    9c22:	0243 f800      	andiw #-2048,%d3
    9c26:	2c02           	movel %d2,%d6
    9c28:	2e03           	movel %d3,%d7
    9c2a:	2800           	movel %d0,%d4
    9c2c:	2a01           	movel %d1,%d5
    9c2e:	7600           	moveq #0,%d3
    9c30:	2403           	movel %d3,%d2
    9c32:	2203           	movel %d3,%d1
    9c34:	2003           	movel %d3,%d0
    9c36:	227c 0000 0034 	moveal #52,%a1
    9c3c:	cf89           	exg %d7,%a1
    9c3e:	cf89           	exg %d7,%a1
    9c40:	d683           	addl %d3,%d3
    9c42:	d582           	addxl %d2,%d2
    9c44:	d381           	addxl %d1,%d1
    9c46:	d180           	addxl %d0,%d0
    9c48:	de87           	addl %d7,%d7
    9c4a:	dd86           	addxl %d6,%d6
    9c4c:	6400 000e      	bccw 0x9c5c
    9c50:	cf8a           	exg %d7,%a2
    9c52:	d685           	addl %d5,%d3
    9c54:	d584           	addxl %d4,%d2
    9c56:	d387           	addxl %d7,%d1
    9c58:	d187           	addxl %d7,%d0
    9c5a:	cf8a           	exg %d7,%a2
    9c5c:	cf89           	exg %d7,%a1
    9c5e:	51cf ffde      	dbf %d7,0x9c3e
    9c62:	280b           	movel %a3,%d4
    9c64:	4cdf 0c00      	moveml %sp@+,%a2-%a3
    9c68:	4840           	swap %d0
    9c6a:	4841           	swap %d1
    9c6c:	3001           	movew %d1,%d0
    9c6e:	4842           	swap %d2
    9c70:	3202           	movew %d2,%d1
    9c72:	4843           	swap %d3
    9c74:	3403           	movew %d3,%d2
    9c76:	363c 0000      	movew #0,%d3
    9c7a:	e288           	lsrl #1,%d0
    9c7c:	e291           	roxrl #1,%d1
    9c7e:	e292           	roxrl #1,%d2
    9c80:	e293           	roxrl #1,%d3
    9c82:	e288           	lsrl #1,%d0
    9c84:	e291           	roxrl #1,%d1
    9c86:	e292           	roxrl #1,%d2
    9c88:	e293           	roxrl #1,%d3
    9c8a:	e288           	lsrl #1,%d0
    9c8c:	e291           	roxrl #1,%d1
    9c8e:	e292           	roxrl #1,%d2
    9c90:	e293           	roxrl #1,%d3
    9c92:	2e08           	movel %a0,%d7
    9c94:	7a02           	moveq #2,%d5
    9c96:	0800 0016      	btst #22,%d0
    9c9a:	6700 027a      	beqw 0x9f16
    9c9e:	e288           	lsrl #1,%d0
    9ca0:	e291           	roxrl #1,%d1
    9ca2:	5244           	addqw #1,%d4
    9ca4:	6000 0270      	braw 0x9f16
    9ca8:	7a02           	moveq #2,%d5
    9caa:	6000 fb10      	braw 0x97bc
    9cae:	7a02           	moveq #2,%d5
    9cb0:	2e08           	movel %a0,%d7
    9cb2:	4a83           	tstl %d3
    9cb4:	6600 fb06      	bnew 0x97bc
    9cb8:	6000 fadc      	braw 0x9796
    9cbc:	7a02           	moveq #2,%d5
    9cbe:	2e08           	movel %a0,%d7
    9cc0:	4a81           	tstl %d1
    9cc2:	6600 faf8      	bnew 0x97bc
    9cc6:	6000 face      	braw 0x9796
    9cca:	7a02           	moveq #2,%d5
    9ccc:	c540           	exg %d2,%d0
    9cce:	c741           	exg %d3,%d1
    9cd0:	2008           	movel %a0,%d0
    9cd2:	6000 0010      	braw 0x9ce4
    9cd6:	2008           	movel %a0,%d0
    9cd8:	242e 0010      	movel %fp@(16),%d2
    9cdc:	262e 0014      	movel %fp@(20),%d3
    9ce0:	0882 001f      	bclr #31,%d2
    9ce4:	0c82 7ff0 0000 	cmpil #2146435072,%d2
    9cea:	6c00 fad0      	bgew 0x97bc
    9cee:	41f9 0000 0000 	lea 0x0,%a0
    9cf4:	30bc 0000      	movew #0,%a0@
    9cf8:	4cdf 00fc      	moveml %sp@+,%d2-%d7
    9cfc:	4e5e           	unlk %fp
    9cfe:	4e75           	rts
    9d00:	7801           	moveq #1,%d4
    9d02:	c086           	andl %d6,%d0
    9d04:	d281           	addl %d1,%d1
    9d06:	d180           	addxl %d0,%d0
    9d08:	5344           	subqw #1,%d4
    9d0a:	0800 0014      	btst #20,%d0
    9d0e:	6600 fede      	bnew 0x9bee
    9d12:	6000 fff0      	braw 0x9d04
    9d16:	7a01           	moveq #1,%d5
    9d18:	c486           	andl %d6,%d2
    9d1a:	d683           	addl %d3,%d3
    9d1c:	d582           	addxl %d2,%d2
    9d1e:	5345           	subqw #1,%d5
    9d20:	0802 0014      	btst #20,%d2
    9d24:	6600 feda      	bnew 0x9c00
    9d28:	6000 fff0      	braw 0x9d1a
    9d2c:	4e56 0000      	linkw %fp,#0
    9d30:	48e7 3f00      	moveml %d2-%d7,%sp@-
    9d34:	202e 0008      	movel %fp@(8),%d0
    9d38:	222e 000c      	movel %fp@(12),%d1
    9d3c:	242e 0010      	movel %fp@(16),%d2
    9d40:	262e 0014      	movel %fp@(20),%d3
    9d44:	2e00           	movel %d0,%d7
    9d46:	b587           	eorl %d2,%d7
    9d48:	0287 8000 0000 	andil #-2147483648,%d7
    9d4e:	2047           	moveal %d7,%a0
    9d50:	2e3c 7ff0 0000 	movel #2146435072,%d7
    9d56:	2c07           	movel %d7,%d6
    9d58:	4686           	notl %d6
    9d5a:	0880 001f      	bclr #31,%d0
    9d5e:	2800           	movel %d0,%d4
    9d60:	8881           	orl %d1,%d4
    9d62:	6700 0112      	beqw 0x9e76
    9d66:	2800           	movel %d0,%d4
    9d68:	0882 001f      	bclr #31,%d2
    9d6c:	2a02           	movel %d2,%d5
    9d6e:	8a83           	orl %d3,%d5
    9d70:	6700 013c      	beqw 0x9eae
    9d74:	2a02           	movel %d2,%d5
    9d76:	b087           	cmpl %d7,%d0
    9d78:	6200 00f6      	bhiw 0x9e70
    9d7c:	6700 0154      	beqw 0x9ed2
    9d80:	b487           	cmpl %d7,%d2
    9d82:	6200 00ec      	bhiw 0x9e70
    9d86:	6700 013e      	beqw 0x9ec6
    9d8a:	c887           	andl %d7,%d4
    9d8c:	6700 015c      	beqw 0x9eea
    9d90:	c086           	andl %d6,%d0
    9d92:	0080 0010 0000 	oril #1048576,%d0
    9d98:	4844           	swap %d4
    9d9a:	e84c           	lsrw #4,%d4
    9d9c:	ca87           	andl %d7,%d5
    9d9e:	6700 0160      	beqw 0x9f00
    9da2:	c486           	andl %d6,%d2
    9da4:	0082 0010 0000 	oril #1048576,%d2
    9daa:	4845           	swap %d5
    9dac:	e84d           	lsrw #4,%d5
    9dae:	9845           	subw %d5,%d4
    9db0:	0644 03fe      	addiw #1022,%d4
    9db4:	7c00           	moveq #0,%d6
    9db6:	2e06           	movel %d6,%d7
    9db8:	227c 0000 0000 	moveal #0,%a1
    9dbe:	7a16           	moveq #22,%d5
    9dc0:	b480           	cmpl %d0,%d2
    9dc2:	6200 000c      	bhiw 0x9dd0
    9dc6:	6700 0014      	beqw 0x9ddc
    9dca:	9283           	subl %d3,%d1
    9dcc:	9182           	subxl %d2,%d0
    9dce:	0bc6           	bset %d5,%d6
    9dd0:	d281           	addl %d1,%d1
    9dd2:	d180           	addxl %d0,%d0
    9dd4:	51cd ffea      	dbf %d5,0x9dc0
    9dd8:	6000 000c      	braw 0x9de6
    9ddc:	b681           	cmpl %d1,%d3
    9dde:	6200 fff0      	bhiw 0x9dd0
    9de2:	6000 ffe6      	braw 0x9dca
    9de6:	7a1f           	moveq #31,%d5
    9de8:	b480           	cmpl %d0,%d2
    9dea:	6200 000c      	bhiw 0x9df8
    9dee:	6700 0014      	beqw 0x9e04
    9df2:	9283           	subl %d3,%d1
    9df4:	9182           	subxl %d2,%d0
    9df6:	0bc7           	bset %d5,%d7
    9df8:	d281           	addl %d1,%d1
    9dfa:	d180           	addxl %d0,%d0
    9dfc:	51cd ffea      	dbf %d5,0x9de8
    9e00:	6000 000c      	braw 0x9e0e
    9e04:	b681           	cmpl %d1,%d3
    9e06:	6200 fff0      	bhiw 0x9df8
    9e0a:	6000 ffe6      	braw 0x9df2
    9e0e:	7a35           	moveq #53,%d5
    9e10:	b082           	cmpl %d2,%d0
    9e12:	6200 001c      	bhiw 0x9e30
    9e16:	6700 0012      	beqw 0x9e2a
    9e1a:	d281           	addl %d1,%d1
    9e1c:	d180           	addxl %d0,%d0
    9e1e:	51cd fff0      	dbf %d5,0x9e10
    9e22:	7400           	moveq #0,%d2
    9e24:	2602           	movel %d2,%d3
    9e26:	6000 0028      	braw 0x9e50
    9e2a:	b681           	cmpl %d1,%d3
    9e2c:	6200 ffec      	bhiw 0x9e1a
    9e30:	7400           	moveq #0,%d2
    9e32:	2602           	movel %d2,%d3
    9e34:	0445 0035      	subiw #53,%d5
    9e38:	0645 003f      	addiw #63,%d5
    9e3c:	0c45 001f      	cmpiw #31,%d5
    9e40:	6200 000c      	bhiw 0x9e4e
    9e44:	0bc3           	bset %d5,%d3
    9e46:	6000 0008      	braw 0x9e50
    9e4a:	0445 0020      	subiw #32,%d5
    9e4e:	0bc2           	bset %d5,%d2
    9e50:	2006           	movel %d6,%d0
    9e52:	2207           	movel %d7,%d1
    9e54:	7600           	moveq #0,%d3
    9e56:	0800 0016      	btst #22,%d0
    9e5a:	6700 000c      	beqw 0x9e68
    9e5e:	e288           	lsrl #1,%d0
    9e60:	e291           	roxrl #1,%d1
    9e62:	e292           	roxrl #1,%d2
    9e64:	e293           	roxrl #1,%d3
    9e66:	5244           	addqw #1,%d4
    9e68:	2e08           	movel %a0,%d7
    9e6a:	7a03           	moveq #3,%d5
    9e6c:	6000 00a8      	braw 0x9f16
    9e70:	7a03           	moveq #3,%d5
    9e72:	6000 f948      	braw 0x97bc
    9e76:	7a03           	moveq #3,%d5
    9e78:	0882 001f      	bclr #31,%d2
    9e7c:	2802           	movel %d2,%d4
    9e7e:	8883           	orl %d3,%d4
    9e80:	6700 f93a      	beqw 0x97bc
    9e84:	0c82 7ff0 0000 	cmpil #2146435072,%d2
    9e8a:	6200 f930      	bhiw 0x97bc
    9e8e:	6d00 0008      	bltw 0x9e98
    9e92:	4a83           	tstl %d3
    9e94:	6600 f926      	bnew 0x97bc
    9e98:	2008           	movel %a0,%d0
    9e9a:	7200           	moveq #0,%d1
    9e9c:	41f9 0000 0000 	lea 0x0,%a0
    9ea2:	30bc 0000      	movew #0,%a0@
    9ea6:	4cdf 00fc      	moveml %sp@+,%d2-%d7
    9eaa:	4e5e           	unlk %fp
    9eac:	4e75           	rts
    9eae:	7a03           	moveq #3,%d5
    9eb0:	2e08           	movel %a0,%d7
    9eb2:	0c80 7ff0 0000 	cmpil #2146435072,%d0
    9eb8:	6200 f902      	bhiw 0x97bc
    9ebc:	4a81           	tstl %d1
    9ebe:	6600 f8fc      	bnew 0x97bc
    9ec2:	6000 f908      	braw 0x97cc
    9ec6:	7a03           	moveq #3,%d5
    9ec8:	4a83           	tstl %d3
    9eca:	6600 f8f0      	bnew 0x97bc
    9ece:	6000 f8dc      	braw 0x97ac
    9ed2:	7a03           	moveq #3,%d5
    9ed4:	4a81           	tstl %d1
    9ed6:	6600 f8e4      	bnew 0x97bc
    9eda:	b487           	cmpl %d7,%d2
    9edc:	6c00 f8de      	bgew 0x97bc
    9ee0:	4a83           	tstl %d3
    9ee2:	6600 f8d8      	bnew 0x97bc
    9ee6:	6000 f8ae      	braw 0x9796
    9eea:	7801           	moveq #1,%d4
    9eec:	c086           	andl %d6,%d0
    9eee:	d281           	addl %d1,%d1
    9ef0:	d180           	addxl %d0,%d0
    9ef2:	5344           	subqw #1,%d4
    9ef4:	0800 0014      	btst #20,%d0
    9ef8:	6600 fea2      	bnew 0x9d9c
    9efc:	6000 fff0      	braw 0x9eee
    9f00:	7a01           	moveq #1,%d5
    9f02:	c486           	andl %d6,%d2
    9f04:	d683           	addl %d3,%d3
    9f06:	d582           	addxl %d2,%d2
    9f08:	5345           	subqw #1,%d5
    9f0a:	0802 0014      	btst #20,%d2
    9f0e:	6600 fe9e      	bnew 0x9dae
    9f12:	6000 fff0      	braw 0x9f04
    9f16:	0c44 ffca      	cmpiw #-54,%d4
    9f1a:	6d00 f890      	bltw 0x97ac
    9f1e:	2047           	moveal %d7,%a0
    9f20:	7c00           	moveq #0,%d6
    9f22:	2e06           	movel %d6,%d7
    9f24:	0c44 0001      	cmpiw #1,%d4
    9f28:	6c00 0020      	bgew 0x9f4a
    9f2c:	5244           	addqw #1,%d4
    9f2e:	e288           	lsrl #1,%d0
    9f30:	e291           	roxrl #1,%d1
    9f32:	e292           	roxrl #1,%d2
    9f34:	e293           	roxrl #1,%d3
    9f36:	e296           	roxrl #1,%d6
    9f38:	e297           	roxrl #1,%d7
    9f3a:	0c44 0001      	cmpiw #1,%d4
    9f3e:	6700 000a      	beqw 0x9f4a
    9f42:	6000 ffe8      	braw 0x9f2c
    9f46:	6000 f864      	braw 0x97ac
    9f4a:	8486           	orl %d6,%d2
    9f4c:	8687           	orl %d7,%d3
    9f4e:	2e08           	movel %a0,%d7
    9f50:	41fa 0020      	lea %pc@(0x9f72),%a0
    9f54:	43f9 0000 0000 	lea 0x0,%a1
    9f5a:	3c29 0006      	movew %a1@(6),%d6
    9f5e:	6700 018e      	beqw 0xa0ee
    9f62:	0c46 0002      	cmpiw #2,%d6
    9f66:	6200 01ea      	bhiw 0xa152
    9f6a:	6d00 01e6      	bltw 0xa152
    9f6e:	6000 01e2      	braw 0xa152
    9f72:	0c44 07ff      	cmpiw #2047,%d4
    9f76:	6c00 f81e      	bgew 0x9796
    9f7a:	3804           	movew %d4,%d4
    9f7c:	6700 f80a      	beqw 0x9788
    9f80:	e94c           	lslw #4,%d4
    9f82:	0880 0014      	bclr #20,%d0
    9f86:	4840           	swap %d0
    9f88:	8044           	orw %d4,%d0
    9f8a:	4840           	swap %d0
    9f8c:	8087           	orl %d7,%d0
    9f8e:	41f9 0000 0000 	lea 0x0,%a0
    9f94:	30bc 0000      	movew #0,%a0@
    9f98:	4cdf 00fc      	moveml %sp@+,%d2-%d7
    9f9c:	4e5e           	unlk %fp
    9f9e:	4e75           	rts
    9fa0:	4e56 0000      	linkw %fp,#0
    9fa4:	48e7 3f00      	moveml %d2-%d7,%sp@-
    9fa8:	7a04           	moveq #4,%d5
    9faa:	202e 0008      	movel %fp@(8),%d0
    9fae:	222e 000c      	movel %fp@(12),%d1
    9fb2:	0840 001f      	bchg #31,%d0
    9fb6:	2400           	movel %d0,%d2
    9fb8:	0882 001f      	bclr #31,%d2
    9fbc:	2802           	movel %d2,%d4
    9fbe:	8881           	orl %d1,%d4
    9fc0:	6700 0034      	beqw 0x9ff6
    9fc4:	0c82 7ff0 0000 	cmpil #2146435072,%d2
    9fca:	6d00 0018      	bltw 0x9fe4
    9fce:	6200 f7ec      	bhiw 0x97bc
    9fd2:	4a81           	tstl %d1
    9fd4:	6600 f7e6      	bnew 0x97bc
    9fd8:	2e00           	movel %d0,%d7
    9fda:	0287 8000 0000 	andil #-2147483648,%d7
    9fe0:	6000 f7b4      	braw 0x9796
    9fe4:	41f9 0000 0000 	lea 0x0,%a0
    9fea:	30bc 0000      	movew #0,%a0@
    9fee:	4cdf 00fc      	moveml %sp@+,%d2-%d7
    9ff2:	4e5e           	unlk %fp
    9ff4:	4e75           	rts
    9ff6:	0880 001f      	bclr #31,%d0
    9ffa:	6000 ffe8      	braw 0x9fe4
    9ffe:	4e56 0000      	linkw %fp,#0
    a002:	48e7 3f00      	moveml %d2-%d7,%sp@-
    a006:	7a05           	moveq #5,%d5
    a008:	202e 0008      	movel %fp@(8),%d0
    a00c:	222e 000c      	movel %fp@(12),%d1
    a010:	242e 0010      	movel %fp@(16),%d2
    a014:	262e 0014      	movel %fp@(20),%d3
    a018:	2c00           	movel %d0,%d6
    a01a:	0880 001f      	bclr #31,%d0
    a01e:	2e02           	movel %d2,%d7
    a020:	0882 001f      	bclr #31,%d2
    a024:	0c80 7ff0 0000 	cmpil #2146435072,%d0
    a02a:	6200 0094      	bhiw 0xa0c0
    a02e:	6700 007c      	beqw 0xa0ac
    a032:	2800           	movel %d0,%d4
    a034:	8881           	orl %d1,%d4
    a036:	6700 0064      	beqw 0xa09c
    a03a:	0c82 7ff0 0000 	cmpil #2146435072,%d2
    a040:	6200 007e      	bhiw 0xa0c0
    a044:	6700 0070      	beqw 0xa0b6
    a048:	2802           	movel %d2,%d4
    a04a:	8883           	orl %d3,%d4
    a04c:	6700 0056      	beqw 0xa0a4
    a050:	bd87           	eorl %d6,%d7
    a052:	6a00 000c      	bplw 0xa060
    a056:	4a86           	tstl %d6
    a058:	6a00 002e      	bplw 0xa088
    a05c:	6b00 0034      	bmiw 0xa092
    a060:	4a86           	tstl %d6
    a062:	6a00 0006      	bplw 0xa06a
    a066:	c142           	exg %d0,%d2
    a068:	c343           	exg %d1,%d3
    a06a:	b480           	cmpl %d0,%d2
    a06c:	6200 0024      	bhiw 0xa092
    a070:	6600 0016      	bnew 0xa088
    a074:	b681           	cmpl %d1,%d3
    a076:	6200 001a      	bhiw 0xa092
    a07a:	6600 000c      	bnew 0xa088
    a07e:	7000           	moveq #0,%d0
    a080:	4cdf 00fc      	moveml %sp@+,%d2-%d7
    a084:	4e5e           	unlk %fp
    a086:	4e75           	rts
    a088:	7001           	moveq #1,%d0
    a08a:	4cdf 00fc      	moveml %sp@+,%d2-%d7
    a08e:	4e5e           	unlk %fp
    a090:	4e75           	rts
    a092:	70ff           	moveq #-1,%d0
    a094:	4cdf 00fc      	moveml %sp@+,%d2-%d7
    a098:	4e5e           	unlk %fp
    a09a:	4e75           	rts
    a09c:	0886 001f      	bclr #31,%d6
    a0a0:	6000 ff98      	braw 0xa03a
    a0a4:	0887 001f      	bclr #31,%d7
    a0a8:	6000 ffa6      	braw 0xa050
    a0ac:	4a81           	tstl %d1
    a0ae:	6600 f70c      	bnew 0x97bc
    a0b2:	6000 ff86      	braw 0xa03a
    a0b6:	4a83           	tstl %d3
    a0b8:	6600 f702      	bnew 0x97bc
    a0bc:	6000 ff92      	braw 0xa050
    a0c0:	202e 0018      	movel %fp@(24),%d0
    a0c4:	7e11           	moveq #17,%d7
    a0c6:	7c02           	moveq #2,%d6
    a0c8:	4ef9 0000 0000 	jmp 0x0
    a0ce:	4e56 0000      	linkw %fp,#0
    a0d2:	4878 0001      	pea 0x1
    a0d6:	2f2e 0014      	movel %fp@(20),%sp@-
    a0da:	2f2e 0010      	movel %fp@(16),%sp@-
    a0de:	2f2e 000c      	movel %fp@(12),%sp@-
    a0e2:	2f2e 0008      	movel %fp@(8),%sp@-
    a0e6:	6100 ff16      	bsrw 0x9ffe
    a0ea:	4e5e           	unlk %fp
    a0ec:	4e75           	rts
    a0ee:	0800 0015      	btst #21,%d0
    a0f2:	6600 0016      	bnew 0xa10a
    a0f6:	0c44 0001      	cmpiw #1,%d4
    a0fa:	6700 000e      	beqw 0xa10a
    a0fe:	d683           	addl %d3,%d3
    a100:	d582           	addxl %d2,%d2
    a102:	d381           	addxl %d1,%d1
    a104:	d180           	addxl %d0,%d0
    a106:	51cc ffe6      	dbf %d4,0xa0ee
    a10a:	0801 0000      	btst #0,%d1
    a10e:	6700 0022      	beqw 0xa132
    a112:	8682           	orl %d2,%d3
    a114:	6600 0014      	bnew 0xa12a
    a118:	2601           	movel %d1,%d3
    a11a:	0283 0000 0002 	andil #2,%d3
    a120:	7400           	moveq #0,%d2
    a122:	d283           	addl %d3,%d1
    a124:	d182           	addxl %d2,%d0
    a126:	6000 000a      	braw 0xa132
    a12a:	7601           	moveq #1,%d3
    a12c:	7400           	moveq #0,%d2
    a12e:	d283           	addl %d3,%d1
    a130:	d182           	addxl %d2,%d0
    a132:	e288           	lsrl #1,%d0
    a134:	e291           	roxrl #1,%d1
    a136:	0800 0015      	btst #21,%d0
    a13a:	6700 0008      	beqw 0xa144
    a13e:	e288           	lsrl #1,%d0
    a140:	e291           	roxrl #1,%d1
    a142:	5244           	addqw #1,%d4
    a144:	0800 0014      	btst #20,%d0
    a148:	6700 0004      	beqw 0xa14e
    a14c:	4ed0           	jmp %a0@
    a14e:	7800           	moveq #0,%d4
    a150:	4ed0           	jmp %a0@
    a152:	4ed0           	jmp %a0@
    a154:	8087           	orl %d7,%d0
    a156:	7e03           	moveq #3,%d7
    a158:	7c01           	moveq #1,%d6
    a15a:	4ef9 0000 0000 	jmp 0x0
    a160:	203c 7f80 0000 	movel #2139095040,%d0
    a166:	8087           	orl %d7,%d0
    a168:	7e05           	moveq #5,%d7
    a16a:	7c01           	moveq #1,%d6
    a16c:	4ef9 0000 0000 	jmp 0x0
    a172:	7000           	moveq #0,%d0
    a174:	7e03           	moveq #3,%d7
    a176:	7c01           	moveq #1,%d6
    a178:	4ef9 0000 0000 	jmp 0x0
    a17e:	70ff           	moveq #-1,%d0
    a180:	7e11           	moveq #17,%d7
    a182:	7c01           	moveq #1,%d6
    a184:	4ef9 0000 0000 	jmp 0x0
    a18a:	203c 7f80 0000 	movel #2139095040,%d0
    a190:	8087           	orl %d7,%d0
    a192:	7e09           	moveq #9,%d7
    a194:	7c01           	moveq #1,%d6
    a196:	4ef9 0000 0000 	jmp 0x0
    a19c:	086f 001f 0008 	bchg #31,%sp@(8)
    a1a2:	4e56 0000      	linkw %fp,#0
    a1a6:	48e7 3f00      	moveml %d2-%d7,%sp@-
    a1aa:	202e 0008      	movel %fp@(8),%d0
    a1ae:	222e 000c      	movel %fp@(12),%d1
    a1b2:	2040           	moveal %d0,%a0
    a1b4:	d080           	addl %d0,%d0
    a1b6:	6700 01b6      	beqw 0xa36e
    a1ba:	2241           	moveal %d1,%a1
    a1bc:	d281           	addl %d1,%d1
    a1be:	6700 01ca      	beqw 0xa38a
    a1c2:	283c 00ff ffff 	movel #16777215,%d4
    a1c8:	2a3c 0100 0000 	movel #16777216,%d5
    a1ce:	2c00           	movel %d0,%d6
    a1d0:	c084           	andl %d4,%d0
    a1d2:	4684           	notl %d4
    a1d4:	cc84           	andl %d4,%d6
    a1d6:	6700 0184      	beqw 0xa35c
    a1da:	bc84           	cmpl %d4,%d6
    a1dc:	6700 01fe      	beqw 0xa3dc
    a1e0:	4846           	swap %d6
    a1e2:	8085           	orl %d5,%d0
    a1e4:	2e01           	movel %d1,%d7
    a1e6:	ce84           	andl %d4,%d7
    a1e8:	6700 017a      	beqw 0xa364
    a1ec:	be84           	cmpl %d4,%d7
    a1ee:	6700 01ec      	beqw 0xa3dc
    a1f2:	4847           	swap %d7
    a1f4:	4684           	notl %d4
    a1f6:	c284           	andl %d4,%d1
    a1f8:	8285           	orl %d5,%d1
    a1fa:	2401           	movel %d1,%d2
    a1fc:	7200           	moveq #0,%d1
    a1fe:	2601           	movel %d1,%d3
    a200:	be46           	cmpw %d6,%d7
    a202:	6700 0074      	beqw 0xa278
    a206:	6200 003a      	bhiw 0xa242
    a20a:	9e86           	subl %d6,%d7
    a20c:	4487           	negl %d7
    a20e:	e04f           	lsrw #8,%d7
    a210:	0c47 001a      	cmpiw #26,%d7
    a214:	6c00 0130      	bgew 0xa346
    a218:	0c47 0010      	cmpiw #16,%d7
    a21c:	6c00 0010      	bgew 0xa22e
    a220:	5347           	subqw #1,%d7
    a222:	e28a           	lsrl #1,%d2
    a224:	e293           	roxrl #1,%d3
    a226:	51cf fffa      	dbf %d7,0xa222
    a22a:	6000 004c      	braw 0xa278
    a22e:	3602           	movew %d2,%d3
    a230:	4843           	swap %d3
    a232:	3403           	movew %d3,%d2
    a234:	4842           	swap %d2
    a236:	0447 0010      	subiw #16,%d7
    a23a:	6600 ffe4      	bnew 0xa220
    a23e:	6000 0038      	braw 0xa278
    a242:	cd47           	exg %d6,%d7
    a244:	9e86           	subl %d6,%d7
    a246:	4487           	negl %d7
    a248:	e04f           	lsrw #8,%d7
    a24a:	0c47 001a      	cmpiw #26,%d7
    a24e:	6c00 00e0      	bgew 0xa330
    a252:	0c47 0010      	cmpiw #16,%d7
    a256:	6c00 0010      	bgew 0xa268
    a25a:	5347           	subqw #1,%d7
    a25c:	e288           	lsrl #1,%d0
    a25e:	e291           	roxrl #1,%d1
    a260:	51cf fffa      	dbf %d7,0xa25c
    a264:	6000 0012      	braw 0xa278
    a268:	3200           	movew %d0,%d1
    a26a:	4841           	swap %d1
    a26c:	3001           	movew %d1,%d0
    a26e:	4840           	swap %d0
    a270:	0447 0010      	subiw #16,%d7
    a274:	6600 ffe4      	bnew 0xa25a
    a278:	cd88           	exg %d6,%a0
    a27a:	cf89           	exg %d7,%a1
    a27c:	bd87           	eorl %d6,%d7
    a27e:	6b00 0060      	bmiw 0xa2e0
    a282:	cd88           	exg %d6,%a0
    a284:	2e08           	movel %a0,%d7
    a286:	0287 8000 0000 	andil #-2147483648,%d7
    a28c:	d283           	addl %d3,%d1
    a28e:	d182           	addxl %d2,%d0
    a290:	2406           	movel %d6,%d2
    a292:	e04a           	lsrw #8,%d2
    a294:	0800 0019      	btst #25,%d0
    a298:	6700 0008      	beqw 0xa2a2
    a29c:	e288           	lsrl #1,%d0
    a29e:	e291           	roxrl #1,%d1
    a2a0:	5282           	addql #1,%d2
    a2a2:	41fa 0020      	lea %pc@(0xa2c4),%a0
    a2a6:	43f9 0000 0000 	lea 0x0,%a1
    a2ac:	3c29 0006      	movew %a1@(6),%d6
    a2b0:	6700 0578      	beqw 0xa82a
    a2b4:	0c46 0002      	cmpiw #2,%d6
    a2b8:	6200 05c4      	bhiw 0xa87e
    a2bc:	6d00 05c0      	bltw 0xa87e
    a2c0:	6000 05bc      	braw 0xa87e
    a2c4:	0c42 00ff      	cmpiw #255,%d2
    a2c8:	6200 0010      	bhiw 0xa2da
    a2cc:	0880 0017      	bclr #23,%d0
    a2d0:	ef4a           	lslw #7,%d2
    a2d2:	4842           	swap %d2
    a2d4:	8082           	orl %d2,%d0
    a2d6:	6000 00ea      	braw 0xa3c2
    a2da:	7a01           	moveq #1,%d5
    a2dc:	6000 fe82      	braw 0xa160
    a2e0:	2e06           	movel %d6,%d7
    a2e2:	0287 8000 0000 	andil #-2147483648,%d7
    a2e8:	9283           	subl %d3,%d1
    a2ea:	9182           	subxl %d2,%d0
    a2ec:	6700 00d4      	beqw 0xa3c2
    a2f0:	6a00 000a      	bplw 0xa2fc
    a2f4:	0847 001f      	bchg #31,%d7
    a2f8:	4481           	negl %d1
    a2fa:	4080           	negxl %d0
    a2fc:	c588           	exg %d2,%a0
    a2fe:	e04a           	lsrw #8,%d2
    a300:	41fa 0020      	lea %pc@(0xa322),%a0
    a304:	43f9 0000 0000 	lea 0x0,%a1
    a30a:	3c29 0006      	movew %a1@(6),%d6
    a30e:	6700 051a      	beqw 0xa82a
    a312:	0c46 0002      	cmpiw #2,%d6
    a316:	6200 0566      	bhiw 0xa87e
    a31a:	6d00 0562      	bltw 0xa87e
    a31e:	6000 055e      	braw 0xa87e
    a322:	0880 0017      	bclr #23,%d0
    a326:	ef4a           	lslw #7,%d2
    a328:	4842           	swap %d2
    a32a:	8082           	orl %d2,%d0
    a32c:	6000 0094      	braw 0xa3c2
    a330:	202e 000c      	movel %fp@(12),%d0
    a334:	41f9 0000 0000 	lea 0x0,%a0
    a33a:	30bc 0000      	movew #0,%a0@
    a33e:	4cdf 00fc      	moveml %sp@+,%d2-%d7
    a342:	4e5e           	unlk %fp
    a344:	4e75           	rts
    a346:	202e 0008      	movel %fp@(8),%d0
    a34a:	41f9 0000 0000 	lea 0x0,%a0
    a350:	30bc 0000      	movew #0,%a0@
    a354:	4cdf 00fc      	moveml %sp@+,%d2-%d7
    a358:	4e5e           	unlk %fp
    a35a:	4e75           	rts
    a35c:	2c05           	movel %d5,%d6
    a35e:	4846           	swap %d6
    a360:	6000 fe82      	braw 0xa1e4
    a364:	2e05           	movel %d5,%d7
    a366:	4847           	swap %d7
    a368:	4684           	notl %d4
    a36a:	6000 fe8e      	braw 0xa1fa
    a36e:	202e 000c      	movel %fp@(12),%d0
    a372:	0c80 8000 0000 	cmpil #-2147483648,%d0
    a378:	6600 0014      	bnew 0xa38e
    a37c:	2e08           	movel %a0,%d7
    a37e:	0287 8000 0000 	andil #-2147483648,%d7
    a384:	4280           	clrl %d0
    a386:	6000 003a      	braw 0xa3c2
    a38a:	202e 0008      	movel %fp@(8),%d0
    a38e:	7a01           	moveq #1,%d5
    a390:	2e00           	movel %d0,%d7
    a392:	0287 8000 0000 	andil #-2147483648,%d7
    a398:	0880 001f      	bclr #31,%d0
    a39c:	0c80 7f80 0000 	cmpil #2139095040,%d0
    a3a2:	6c00 0010      	bgew 0xa3b4
    a3a6:	2000           	movel %d0,%d0
    a3a8:	6600 0018      	bnew 0xa3c2
    a3ac:	0887 001f      	bclr #31,%d7
    a3b0:	6000 0010      	braw 0xa3c2
    a3b4:	0280 007f ffff 	andil #8388607,%d0
    a3ba:	6600 fdc2      	bnew 0xa17e
    a3be:	6000 fda0      	braw 0xa160
    a3c2:	41f9 0000 0000 	lea 0x0,%a0
    a3c8:	30bc 0000      	movew #0,%a0@
    a3cc:	8087           	orl %d7,%d0
    a3ce:	4cdf 00fc      	moveml %sp@+,%d2-%d7
    a3d2:	4e5e           	unlk %fp
    a3d4:	4e75           	rts
    a3d6:	e288           	lsrl #1,%d0
    a3d8:	6000 ffe8      	braw 0xa3c2
    a3dc:	7a01           	moveq #1,%d5
    a3de:	202e 0008      	movel %fp@(8),%d0
    a3e2:	222e 000c      	movel %fp@(12),%d1
    a3e6:	283c 7f80 0000 	movel #2139095040,%d4
    a3ec:	2400           	movel %d0,%d2
    a3ee:	2601           	movel %d1,%d3
    a3f0:	0880 001f      	bclr #31,%d0
    a3f4:	0881 001f      	bclr #31,%d1
    a3f8:	b084           	cmpl %d4,%d0
    a3fa:	6200 fd82      	bhiw 0xa17e
    a3fe:	b284           	cmpl %d4,%d1
    a400:	6200 fd7c      	bhiw 0xa17e
    a404:	b782           	eorl %d3,%d2
    a406:	6b00 000e      	bmiw 0xa416
    a40a:	2e00           	movel %d0,%d7
    a40c:	0287 8000 0000 	andil #-2147483648,%d7
    a412:	6000 fd4c      	braw 0xa160
    a416:	b081           	cmpl %d1,%d0
    a418:	6700 fd64      	beqw 0xa17e
    a41c:	2e00           	movel %d0,%d7
    a41e:	0287 8000 0000 	andil #-2147483648,%d7
    a424:	b084           	cmpl %d4,%d0
    a426:	6700 fd38      	beqw 0xa160
    a42a:	0847 001f      	bchg #31,%d7
    a42e:	6000 fd30      	braw 0xa160
    a432:	4e56 0000      	linkw %fp,#0
    a436:	48e7 3f00      	moveml %d2-%d7,%sp@-
    a43a:	202e 0008      	movel %fp@(8),%d0
    a43e:	222e 000c      	movel %fp@(12),%d1
    a442:	2e00           	movel %d0,%d7
    a444:	b387           	eorl %d1,%d7
    a446:	0287 8000 0000 	andil #-2147483648,%d7
    a44c:	2c3c 7f80 0000 	movel #2139095040,%d6
    a452:	2a06           	movel %d6,%d5
    a454:	4685           	notl %d5
    a456:	283c 0080 0000 	movel #8388608,%d4
    a45c:	0880 001f      	bclr #31,%d0
    a460:	2400           	movel %d0,%d2
    a462:	6700 00ac      	beqw 0xa510
    a466:	0881 001f      	bclr #31,%d1
    a46a:	2601           	movel %d1,%d3
    a46c:	6700 009a      	beqw 0xa508
    a470:	b086           	cmpl %d6,%d0
    a472:	6200 007c      	bhiw 0xa4f0
    a476:	6700 0084      	beqw 0xa4fc
    a47a:	b286           	cmpl %d6,%d1
    a47c:	6200 0072      	bhiw 0xa4f0
    a480:	6700 0074      	beqw 0xa4f6
    a484:	c486           	andl %d6,%d2
    a486:	6700 00ae      	beqw 0xa536
    a48a:	c085           	andl %d5,%d0
    a48c:	8084           	orl %d4,%d0
    a48e:	4842           	swap %d2
    a490:	ee4a           	lsrw #7,%d2
    a492:	c686           	andl %d6,%d3
    a494:	6700 00b4      	beqw 0xa54a
    a498:	c285           	andl %d5,%d1
    a49a:	8284           	orl %d4,%d1
    a49c:	4843           	swap %d3
    a49e:	ee4b           	lsrw #7,%d3
    a4a0:	d443           	addw %d3,%d2
    a4a2:	0442 007f      	subiw #127,%d2
    a4a6:	2c01           	movel %d1,%d6
    a4a8:	2a00           	movel %d0,%d5
    a4aa:	7800           	moveq #0,%d4
    a4ac:	2204           	movel %d4,%d1
    a4ae:	2004           	movel %d4,%d0
    a4b0:	e18e           	lsll #8,%d6
    a4b2:	7617           	moveq #23,%d3
    a4b4:	d281           	addl %d1,%d1
    a4b6:	d180           	addxl %d0,%d0
    a4b8:	e38e           	lsll #1,%d6
    a4ba:	6400 0006      	bccw 0xa4c2
    a4be:	d285           	addl %d5,%d1
    a4c0:	d184           	addxl %d4,%d0
    a4c2:	51cb fff0      	dbf %d3,0xa4b4
    a4c6:	ec99           	rorl #6,%d1
    a4c8:	4841           	swap %d1
    a4ca:	3601           	movew %d1,%d3
    a4cc:	0243 03ff      	andiw #1023,%d3
    a4d0:	0241 fd00      	andiw #-768,%d1
    a4d4:	e188           	lsll #8,%d0
    a4d6:	d080           	addl %d0,%d0
    a4d8:	d080           	addl %d0,%d0
    a4da:	8043           	orw %d3,%d0
    a4dc:	7a02           	moveq #2,%d5
    a4de:	0800 0019      	btst #25,%d0
    a4e2:	6700 01c4      	beqw 0xa6a8
    a4e6:	e288           	lsrl #1,%d0
    a4e8:	e291           	roxrl #1,%d1
    a4ea:	5242           	addqw #1,%d2
    a4ec:	6000 01ba      	braw 0xa6a8
    a4f0:	7a02           	moveq #2,%d5
    a4f2:	6000 fc8a      	braw 0xa17e
    a4f6:	7a02           	moveq #2,%d5
    a4f8:	6000 fc66      	braw 0xa160
    a4fc:	7a02           	moveq #2,%d5
    a4fe:	b286           	cmpl %d6,%d1
    a500:	6200 fc7c      	bhiw 0xa17e
    a504:	6000 fc5a      	braw 0xa160
    a508:	222e 0008      	movel %fp@(8),%d1
    a50c:	6000 0006      	braw 0xa514
    a510:	222e 000c      	movel %fp@(12),%d1
    a514:	0881 001f      	bclr #31,%d1
    a518:	0c81 7f80 0000 	cmpil #2139095040,%d1
    a51e:	6c00 fc5e      	bgew 0xa17e
    a522:	2007           	movel %d7,%d0
    a524:	41f9 0000 0000 	lea 0x0,%a0
    a52a:	30bc 0000      	movew #0,%a0@
    a52e:	4cdf 00fc      	moveml %sp@+,%d2-%d7
    a532:	4e5e           	unlk %fp
    a534:	4e75           	rts
    a536:	7401           	moveq #1,%d2
    a538:	c085           	andl %d5,%d0
    a53a:	d080           	addl %d0,%d0
    a53c:	5342           	subqw #1,%d2
    a53e:	0800 0017      	btst #23,%d0
    a542:	6600 ff4e      	bnew 0xa492
    a546:	6000 fff2      	braw 0xa53a
    a54a:	7601           	moveq #1,%d3
    a54c:	c285           	andl %d5,%d1
    a54e:	d281           	addl %d1,%d1
    a550:	5343           	subqw #1,%d3
    a552:	0801 0017      	btst #23,%d1
    a556:	6600 ff48      	bnew 0xa4a0
    a55a:	6000 fff2      	braw 0xa54e
    a55e:	4e56 0000      	linkw %fp,#0
    a562:	48e7 3f00      	moveml %d2-%d7,%sp@-
    a566:	202e 0008      	movel %fp@(8),%d0
    a56a:	222e 000c      	movel %fp@(12),%d1
    a56e:	2e00           	movel %d0,%d7
    a570:	b387           	eorl %d1,%d7
    a572:	0287 8000 0000 	andil #-2147483648,%d7
    a578:	2c3c 7f80 0000 	movel #2139095040,%d6
    a57e:	2a06           	movel %d6,%d5
    a580:	4685           	notl %d5
    a582:	283c 0080 0000 	movel #8388608,%d4
    a588:	0880 001f      	bclr #31,%d0
    a58c:	2400           	movel %d0,%d2
    a58e:	6700 00a6      	beqw 0xa636
    a592:	0881 001f      	bclr #31,%d1
    a596:	2601           	movel %d1,%d3
    a598:	6700 00c6      	beqw 0xa660
    a59c:	b086           	cmpl %d6,%d0
    a59e:	6200 0084      	bhiw 0xa624
    a5a2:	6700 00cc      	beqw 0xa670
    a5a6:	b286           	cmpl %d6,%d1
    a5a8:	6200 007a      	bhiw 0xa624
    a5ac:	6700 0082      	beqw 0xa630
    a5b0:	c486           	andl %d6,%d2
    a5b2:	6700 00cc      	beqw 0xa680
    a5b6:	c085           	andl %d5,%d0
    a5b8:	8084           	orl %d4,%d0
    a5ba:	4842           	swap %d2
    a5bc:	ee4a           	lsrw #7,%d2
    a5be:	c686           	andl %d6,%d3
    a5c0:	6700 00d2      	beqw 0xa694
    a5c4:	c285           	andl %d5,%d1
    a5c6:	8284           	orl %d4,%d1
    a5c8:	4843           	swap %d3
    a5ca:	ee4b           	lsrw #7,%d3
    a5cc:	9443           	subw %d3,%d2
    a5ce:	0642 007e      	addiw #126,%d2
    a5d2:	2047           	moveal %d7,%a0
    a5d4:	7c00           	moveq #0,%d6
    a5d6:	2e06           	movel %d6,%d7
    a5d8:	7619           	moveq #25,%d3
    a5da:	b280           	cmpl %d0,%d1
    a5dc:	6200 000a      	bhiw 0xa5e8
    a5e0:	07c6           	bset %d3,%d6
    a5e2:	9081           	subl %d1,%d0
    a5e4:	6700 0028      	beqw 0xa60e
    a5e8:	d080           	addl %d0,%d0
    a5ea:	51cb ffee      	dbf %d3,0xa5da
    a5ee:	7618           	moveq #24,%d3
    a5f0:	b280           	cmpl %d0,%d1
    a5f2:	6f00 000e      	blew 0xa602
    a5f6:	d080           	addl %d0,%d0
    a5f8:	51cb fff6      	dbf %d3,0xa5f0
    a5fc:	7200           	moveq #0,%d1
    a5fe:	6000 000e      	braw 0xa60e
    a602:	7200           	moveq #0,%d1
    a604:	0443 0018      	subiw #24,%d3
    a608:	0643 001f      	addiw #31,%d3
    a60c:	07c1           	bset %d3,%d1
    a60e:	2006           	movel %d6,%d0
    a610:	2e08           	movel %a0,%d7
    a612:	0800 0019      	btst #25,%d0
    a616:	6700 0006      	beqw 0xa61e
    a61a:	e288           	lsrl #1,%d0
    a61c:	5242           	addqw #1,%d2
    a61e:	7a03           	moveq #3,%d5
    a620:	6000 0086      	braw 0xa6a8
    a624:	7a03           	moveq #3,%d5
    a626:	6000 fb56      	braw 0xa17e
    a62a:	7a03           	moveq #3,%d5
    a62c:	6000 fb32      	braw 0xa160
    a630:	7a03           	moveq #3,%d5
    a632:	6000 fb3e      	braw 0xa172
    a636:	7a03           	moveq #3,%d5
    a638:	0281 7fff ffff 	andil #2147483647,%d1
    a63e:	6700 fb3e      	beqw 0xa17e
    a642:	0c81 7f80 0000 	cmpil #2139095040,%d1
    a648:	6200 fb34      	bhiw 0xa17e
    a64c:	2007           	movel %d7,%d0
    a64e:	41f9 0000 0000 	lea 0x0,%a0
    a654:	30bc 0000      	movew #0,%a0@
    a658:	4cdf 00fc      	moveml %sp@+,%d2-%d7
    a65c:	4e5e           	unlk %fp
    a65e:	4e75           	rts
    a660:	7a03           	moveq #3,%d5
    a662:	0c80 7f80 0000 	cmpil #2139095040,%d0
    a668:	6200 fb14      	bhiw 0xa17e
    a66c:	6000 fb1c      	braw 0xa18a
    a670:	7a03           	moveq #3,%d5
    a672:	0c81 7f80 0000 	cmpil #2139095040,%d1
    a678:	6c00 fb04      	bgew 0xa17e
    a67c:	6000 fae2      	braw 0xa160
    a680:	7401           	moveq #1,%d2
    a682:	c085           	andl %d5,%d0
    a684:	d080           	addl %d0,%d0
    a686:	5342           	subqw #1,%d2
    a688:	0800 0017      	btst #23,%d0
    a68c:	6600 ff30      	bnew 0xa5be
    a690:	6000 fff2      	braw 0xa684
    a694:	7601           	moveq #1,%d3
    a696:	c285           	andl %d5,%d1
    a698:	d281           	addl %d1,%d1
    a69a:	5343           	subqw #1,%d3
    a69c:	0801 0017      	btst #23,%d1
    a6a0:	6600 ff2a      	bnew 0xa5cc
    a6a4:	6000 fff2      	braw 0xa698
    a6a8:	0c42 ffe7      	cmpiw #-25,%d2
    a6ac:	6d00 fac4      	bltw 0xa172
    a6b0:	7c00           	moveq #0,%d6
    a6b2:	0c42 0001      	cmpiw #1,%d2
    a6b6:	6c00 001a      	bgew 0xa6d2
    a6ba:	5242           	addqw #1,%d2
    a6bc:	e288           	lsrl #1,%d0
    a6be:	e291           	roxrl #1,%d1
    a6c0:	e296           	roxrl #1,%d6
    a6c2:	0c42 0001      	cmpiw #1,%d2
    a6c6:	6700 000a      	beqw 0xa6d2
    a6ca:	6000 ffee      	braw 0xa6ba
    a6ce:	6000 faa2      	braw 0xa172
    a6d2:	8286           	orl %d6,%d1
    a6d4:	41fa 0020      	lea %pc@(0xa6f6),%a0
    a6d8:	43f9 0000 0000 	lea 0x0,%a1
    a6de:	3c29 0006      	movew %a1@(6),%d6
    a6e2:	6700 0146      	beqw 0xa82a
    a6e6:	0c46 0002      	cmpiw #2,%d6
    a6ea:	6200 0192      	bhiw 0xa87e
    a6ee:	6d00 018e      	bltw 0xa87e
    a6f2:	6000 018a      	braw 0xa87e
    a6f6:	0c42 00ff      	cmpiw #255,%d2
    a6fa:	6c00 fa64      	bgew 0xa160
    a6fe:	3402           	movew %d2,%d2
    a700:	6700 fa52      	beqw 0xa154
    a704:	ef4a           	lslw #7,%d2
    a706:	0880 0017      	bclr #23,%d0
    a70a:	4840           	swap %d0
    a70c:	8042           	orw %d2,%d0
    a70e:	4840           	swap %d0
    a710:	8087           	orl %d7,%d0
    a712:	41f9 0000 0000 	lea 0x0,%a0
    a718:	30bc 0000      	movew #0,%a0@
    a71c:	4cdf 00fc      	moveml %sp@+,%d2-%d7
    a720:	4e5e           	unlk %fp
    a722:	4e75           	rts
    a724:	4e56 0000      	linkw %fp,#0
    a728:	48e7 3f00      	moveml %d2-%d7,%sp@-
    a72c:	7a04           	moveq #4,%d5
    a72e:	202e 0008      	movel %fp@(8),%d0
    a732:	0840 001f      	bchg #31,%d0
    a736:	2200           	movel %d0,%d1
    a738:	0881 001f      	bclr #31,%d1
    a73c:	4a81           	tstl %d1
    a73e:	6700 002e      	beqw 0xa76e
    a742:	0c81 7f80 0000 	cmpil #2139095040,%d1
    a748:	6d00 0012      	bltw 0xa75c
    a74c:	6200 fa30      	bhiw 0xa17e
    a750:	2e00           	movel %d0,%d7
    a752:	0287 8000 0000 	andil #-2147483648,%d7
    a758:	6000 fa06      	braw 0xa160
    a75c:	41f9 0000 0000 	lea 0x0,%a0
    a762:	30bc 0000      	movew #0,%a0@
    a766:	4cdf 00fc      	moveml %sp@+,%d2-%d7
    a76a:	4e5e           	unlk %fp
    a76c:	4e75           	rts
    a76e:	0880 001f      	bclr #31,%d0
    a772:	6000 ffe8      	braw 0xa75c
    a776:	4e56 0000      	linkw %fp,#0
    a77a:	48e7 3f00      	moveml %d2-%d7,%sp@-
    a77e:	7a05           	moveq #5,%d5
    a780:	202e 0008      	movel %fp@(8),%d0
    a784:	222e 000c      	movel %fp@(12),%d1
    a788:	2c00           	movel %d0,%d6
    a78a:	0280 7fff ffff 	andil #2147483647,%d0
    a790:	6700 0062      	beqw 0xa7f4
    a794:	0c80 7f80 0000 	cmpil #2139095040,%d0
    a79a:	6200 0068      	bhiw 0xa804
    a79e:	2e01           	movel %d1,%d7
    a7a0:	0281 7fff ffff 	andil #2147483647,%d1
    a7a6:	6700 0054      	beqw 0xa7fc
    a7aa:	0c81 7f80 0000 	cmpil #2139095040,%d1
    a7b0:	6200 0052      	bhiw 0xa804
    a7b4:	bd87           	eorl %d6,%d7
    a7b6:	6a00 000c      	bplw 0xa7c4
    a7ba:	4a86           	tstl %d6
    a7bc:	6a00 0022      	bplw 0xa7e0
    a7c0:	6b00 0028      	bmiw 0xa7ea
    a7c4:	4a86           	tstl %d6
    a7c6:	6a00 0004      	bplw 0xa7cc
    a7ca:	c141           	exg %d0,%d1
    a7cc:	b280           	cmpl %d0,%d1
    a7ce:	6200 001a      	bhiw 0xa7ea
    a7d2:	6600 000c      	bnew 0xa7e0
    a7d6:	7000           	moveq #0,%d0
    a7d8:	4cdf 00fc      	moveml %sp@+,%d2-%d7
    a7dc:	4e5e           	unlk %fp
    a7de:	4e75           	rts
    a7e0:	7001           	moveq #1,%d0
    a7e2:	4cdf 00fc      	moveml %sp@+,%d2-%d7
    a7e6:	4e5e           	unlk %fp
    a7e8:	4e75           	rts
    a7ea:	70ff           	moveq #-1,%d0
    a7ec:	4cdf 00fc      	moveml %sp@+,%d2-%d7
    a7f0:	4e5e           	unlk %fp
    a7f2:	4e75           	rts
    a7f4:	0886 001f      	bclr #31,%d6
    a7f8:	6000 ffa4      	braw 0xa79e
    a7fc:	0887 001f      	bclr #31,%d7
    a800:	6000 ffb2      	braw 0xa7b4
    a804:	202e 0010      	movel %fp@(16),%d0
    a808:	7e11           	moveq #17,%d7
    a80a:	7c01           	moveq #1,%d6
    a80c:	4ef9 0000 0000 	jmp 0x0
    a812:	4e56 0000      	linkw %fp,#0
    a816:	4878 0001      	pea 0x1
    a81a:	2f2e 000c      	movel %fp@(12),%sp@-
    a81e:	2f2e 0008      	movel %fp@(8),%sp@-
    a822:	6100 ff52      	bsrw 0xa776
    a826:	4e5e           	unlk %fp
    a828:	4e75           	rts
    a82a:	0800 0018      	btst #24,%d0
    a82e:	6600 0012      	bnew 0xa842
    a832:	0c42 0001      	cmpiw #1,%d2
    a836:	6700 000a      	beqw 0xa842
    a83a:	d281           	addl %d1,%d1
    a83c:	d180           	addxl %d0,%d0
    a83e:	51ca ffea      	dbf %d2,0xa82a
    a842:	0800 0000      	btst #0,%d0
    a846:	6700 001a      	beqw 0xa862
    a84a:	4a81           	tstl %d1
    a84c:	6600 0010      	bnew 0xa85e
    a850:	2200           	movel %d0,%d1
    a852:	0281 0000 0002 	andil #2,%d1
    a858:	d081           	addl %d1,%d0
    a85a:	6000 0006      	braw 0xa862
    a85e:	7201           	moveq #1,%d1
    a860:	d081           	addl %d1,%d0
    a862:	e288           	lsrl #1,%d0
    a864:	0800 0018      	btst #24,%d0
    a868:	6700 0006      	beqw 0xa870
    a86c:	e288           	lsrl #1,%d0
    a86e:	5242           	addqw #1,%d2
    a870:	0800 0017      	btst #23,%d0
    a874:	6700 0004      	beqw 0xa87a
    a878:	4ed0           	jmp %a0@
    a87a:	7400           	moveq #0,%d2
    a87c:	4ed0           	jmp %a0@
    a87e:	4ed0           	jmp %a0@
    a880:	41f9 0000 0000 	lea 0x0,%a0
    a886:	317c 0000 0004 	movew #0,%a0@(4)
    a88c:	4e75           	rts
    a88e:	41f9 0000 0000 	lea 0x0,%a0
    a894:	3087           	movew %d7,%a0@
    a896:	8f68 0004      	orw %d7,%a0@(4)
    a89a:	3146 0008      	movew %d6,%a0@(8)
    a89e:	3145 000a      	movew %d5,%a0@(10)
    a8a2:	0c46 0001      	cmpiw #1,%d6
    a8a6:	6700 001e      	beqw 0xa8c6
    a8aa:	216e 0008 000c 	movel %fp@(8),%a0@(12)
    a8b0:	216e 000c 0010 	movel %fp@(12),%a0@(16)
    a8b6:	216e 0010 0014 	movel %fp@(16),%a0@(20)
    a8bc:	216e 0014 0018 	movel %fp@(20),%a0@(24)
    a8c2:	6000 000e      	braw 0xa8d2
    a8c6:	216e 0008 000c 	movel %fp@(8),%a0@(12)
    a8cc:	216e 000c 0014 	movel %fp@(12),%a0@(20)
    a8d2:	ce68 0002      	andw %a0@(2),%d7
    a8d6:	6700 000a      	beqw 0xa8e2
    a8da:	4879 0000 0000 	pea 0x0
    a8e0:	4e4f           	trap #15
    a8e2:	4cdf 00fc      	moveml %sp@+,%d2-%d7
    a8e6:	4e5e           	unlk %fp
    a8e8:	4e75           	rts
    a8ea:	4e71           	nop
    a8ec:	4e56 0000      	linkw %fp,#0
    a8f0:	4878 0001      	pea 0x1
    a8f4:	2f2e 0014      	movel %fp@(20),%sp@-
    a8f8:	2f2e 0010      	movel %fp@(16),%sp@-
    a8fc:	2f2e 000c      	movel %fp@(12),%sp@-
    a900:	2f2e 0008      	movel %fp@(8),%sp@-
    a904:	61ff 0000 0000 	bsrl 0xa906
    a90a:	4e5e           	unlk %fp
    a90c:	4e75           	rts
    a90e:	4e71           	nop
    a910:	4e56 0000      	linkw %fp,#0
    a914:	4878 ffff      	pea 0xffffffff
    a918:	2f2e 0014      	movel %fp@(20),%sp@-
    a91c:	2f2e 0010      	movel %fp@(16),%sp@-
    a920:	2f2e 000c      	movel %fp@(12),%sp@-
    a924:	2f2e 0008      	movel %fp@(8),%sp@-
    a928:	61ff 0000 0000 	bsrl 0xa92a
    a92e:	4e5e           	unlk %fp
    a930:	4e75           	rts
    a932:	4e71           	nop
    a934:	4e56 0000      	linkw %fp,#0
    a938:	4878 ffff      	pea 0xffffffff
    a93c:	2f2e 0014      	movel %fp@(20),%sp@-
    a940:	2f2e 0010      	movel %fp@(16),%sp@-
    a944:	2f2e 000c      	movel %fp@(12),%sp@-
    a948:	2f2e 0008      	movel %fp@(8),%sp@-
    a94c:	61ff 0000 0000 	bsrl 0xa94e
    a952:	4e5e           	unlk %fp
    a954:	4e75           	rts
    a956:	4e71           	nop
    a958:	4e56 0000      	linkw %fp,#0
    a95c:	4878 0001      	pea 0x1
    a960:	2f2e 0014      	movel %fp@(20),%sp@-
    a964:	2f2e 0010      	movel %fp@(16),%sp@-
    a968:	2f2e 000c      	movel %fp@(12),%sp@-
    a96c:	2f2e 0008      	movel %fp@(8),%sp@-
    a970:	61ff 0000 0000 	bsrl 0xa972
    a976:	4e5e           	unlk %fp
    a978:	4e75           	rts
    a97a:	4e71           	nop
    a97c:	4e56 0000      	linkw %fp,#0
    a980:	4878 0001      	pea 0x1
    a984:	2f2e 0014      	movel %fp@(20),%sp@-
    a988:	2f2e 0010      	movel %fp@(16),%sp@-
    a98c:	2f2e 000c      	movel %fp@(12),%sp@-
    a990:	2f2e 0008      	movel %fp@(8),%sp@-
    a994:	61ff 0000 0000 	bsrl 0xa996
    a99a:	4e5e           	unlk %fp
    a99c:	4e75           	rts
    a99e:	4e71           	nop
    a9a0:	4e56 0000      	linkw %fp,#0
    a9a4:	4878 0001      	pea 0x1
    a9a8:	2f2e 000c      	movel %fp@(12),%sp@-
    a9ac:	2f2e 0008      	movel %fp@(8),%sp@-
    a9b0:	61ff 0000 0000 	bsrl 0xa9b2
    a9b6:	4e5e           	unlk %fp
    a9b8:	4e75           	rts
    a9ba:	4e71           	nop
    a9bc:	4e56 0000      	linkw %fp,#0
    a9c0:	4878 0001      	pea 0x1
    a9c4:	2f2e 000c      	movel %fp@(12),%sp@-
    a9c8:	2f2e 0008      	movel %fp@(8),%sp@-
    a9cc:	61ff 0000 0000 	bsrl 0xa9ce
    a9d2:	4e5e           	unlk %fp
    a9d4:	4e75           	rts
    a9d6:	4e71           	nop
    a9d8:	4e56 0000      	linkw %fp,#0
    a9dc:	4878 ffff      	pea 0xffffffff
    a9e0:	2f2e 000c      	movel %fp@(12),%sp@-
    a9e4:	2f2e 0008      	movel %fp@(8),%sp@-
    a9e8:	61ff 0000 0000 	bsrl 0xa9ea
    a9ee:	4e5e           	unlk %fp
    a9f0:	4e75           	rts
    a9f2:	4e71           	nop
    a9f4:	4e56 0000      	linkw %fp,#0
    a9f8:	4878 ffff      	pea 0xffffffff
    a9fc:	2f2e 000c      	movel %fp@(12),%sp@-
    aa00:	2f2e 0008      	movel %fp@(8),%sp@-
    aa04:	61ff 0000 0000 	bsrl 0xaa06
    aa0a:	4e5e           	unlk %fp
    aa0c:	4e75           	rts
    aa0e:	4e71           	nop
    aa10:	4e56 0000      	linkw %fp,#0
    aa14:	4878 0001      	pea 0x1
    aa18:	2f2e 000c      	movel %fp@(12),%sp@-
    aa1c:	2f2e 0008      	movel %fp@(8),%sp@-
    aa20:	61ff 0000 0000 	bsrl 0xaa22
    aa26:	4e5e           	unlk %fp
    aa28:	4e75           	rts
    aa2a:	4e71           	nop
    aa2c:	4e56 0000      	linkw %fp,#0
    aa30:	4878 0001      	pea 0x1
    aa34:	2f2e 000c      	movel %fp@(12),%sp@-
    aa38:	2f2e 0008      	movel %fp@(8),%sp@-
    aa3c:	61ff 0000 0000 	bsrl 0xaa3e
    aa42:	4e5e           	unlk %fp
    aa44:	4e75           	rts
    aa46:	4e71           	nop
    aa48:	4e56 fffc      	linkw %fp,#-4
    aa4c:	2d6e 0008 fffc 	movel %fp@(8),%fp@(-4)
    aa52:	202e fffc      	movel %fp@(-4),%d0
    aa56:	7217           	moveq #23,%d1
    aa58:	e2a0           	asrl %d1,%d0
    aa5a:	7200           	moveq #0,%d1
    aa5c:	4601           	notb %d1
    aa5e:	c081           	andl %d1,%d0
    aa60:	0c80 0000 00ff 	cmpil #255,%d0
    aa66:	6612           	bnes 0xaa7a
    aa68:	202e fffc      	movel %fp@(-4),%d0
    aa6c:	0280 007f ffff 	andil #8388607,%d0
    aa72:	4a80           	tstl %d0
    aa74:	6704           	beqs 0xaa7a
    aa76:	7001           	moveq #1,%d0
    aa78:	6030           	bras 0xaaaa
    aa7a:	2d6e 000c fffc 	movel %fp@(12),%fp@(-4)
    aa80:	202e fffc      	movel %fp@(-4),%d0
    aa84:	7217           	moveq #23,%d1
    aa86:	e2a0           	asrl %d1,%d0
    aa88:	7200           	moveq #0,%d1
    aa8a:	4601           	notb %d1
    aa8c:	c081           	andl %d1,%d0
    aa8e:	0c80 0000 00ff 	cmpil #255,%d0
    aa94:	6612           	bnes 0xaaa8
    aa96:	202e fffc      	movel %fp@(-4),%d0
    aa9a:	0280 007f ffff 	andil #8388607,%d0
    aaa0:	4a80           	tstl %d0
    aaa2:	6704           	beqs 0xaaa8
    aaa4:	7001           	moveq #1,%d0
    aaa6:	6002           	bras 0xaaaa
    aaa8:	4280           	clrl %d0
    aaaa:	4e5e           	unlk %fp
    aaac:	4e75           	rts
    aaae:	4e56 fff8      	linkw %fp,#-8
    aab2:	2d6e 0008 fff8 	movel %fp@(8),%fp@(-8)
    aab8:	2d6e 000c fffc 	movel %fp@(12),%fp@(-4)
    aabe:	202e fff8      	movel %fp@(-8),%d0
    aac2:	7214           	moveq #20,%d1
    aac4:	e2a0           	asrl %d1,%d0
    aac6:	0280 0000 07ff 	andil #2047,%d0
    aacc:	0c80 0000 07ff 	cmpil #2047,%d0
    aad2:	661a           	bnes 0xaaee
    aad4:	202e fff8      	movel %fp@(-8),%d0
    aad8:	0280 000f ffff 	andil #1048575,%d0
    aade:	4a80           	tstl %d0
    aae0:	6608           	bnes 0xaaea
    aae2:	202e fffc      	movel %fp@(-4),%d0
    aae6:	4a80           	tstl %d0
    aae8:	6704           	beqs 0xaaee
    aaea:	7001           	moveq #1,%d0
    aaec:	603e           	bras 0xab2c
    aaee:	2d6e 0010 fff8 	movel %fp@(16),%fp@(-8)
    aaf4:	2d6e 0014 fffc 	movel %fp@(20),%fp@(-4)
    aafa:	202e fff8      	movel %fp@(-8),%d0
    aafe:	7214           	moveq #20,%d1
    ab00:	e2a0           	asrl %d1,%d0
    ab02:	0280 0000 07ff 	andil #2047,%d0
    ab08:	0c80 0000 07ff 	cmpil #2047,%d0
    ab0e:	661a           	bnes 0xab2a
    ab10:	202e fff8      	movel %fp@(-8),%d0
    ab14:	0280 000f ffff 	andil #1048575,%d0
    ab1a:	4a80           	tstl %d0
    ab1c:	6608           	bnes 0xab26
    ab1e:	202e fffc      	movel %fp@(-4),%d0
    ab22:	4a80           	tstl %d0
    ab24:	6704           	beqs 0xab2a
    ab26:	7001           	moveq #1,%d0
    ab28:	6002           	bras 0xab2c
    ab2a:	4280           	clrl %d0
    ab2c:	4e5e           	unlk %fp
    ab2e:	4e75           	rts
    ab30:	4e56 fff4      	linkw %fp,#-12
    ab34:	2f02           	movel %d2,%sp@-
    ab36:	2d7c 0000 041e 	movel #1054,%fp@(-4)
    ab3c:	fffc 
    ab3e:	4aae 0008      	tstl %fp@(8)
    ab42:	6620           	bnes 0xab64
    ab44:	42ae fff8      	clrl %fp@(-8)
    ab48:	42ae fff4      	clrl %fp@(-12)
    ab4c:	202e fff4      	movel %fp@(-12),%d0
    ab50:	222e fff8      	movel %fp@(-8),%d1
    ab54:	6068           	bras 0xabbe
    ab56:	202e 0008      	movel %fp@(8),%d0
    ab5a:	e988           	lsll #4,%d0
    ab5c:	2d40 0008      	movel %d0,%fp@(8)
    ab60:	59ae fffc      	subql #4,%fp@(-4)
    ab64:	0cae 01ff ffff 	cmpil #33554431,%fp@(8)
    ab6a:	0008 
    ab6c:	63e8           	blss 0xab56
    ab6e:	600e           	bras 0xab7e
    ab70:	202e 0008      	movel %fp@(8),%d0
    ab74:	d080           	addl %d0,%d0
    ab76:	2d40 0008      	movel %d0,%fp@(8)
    ab7a:	53ae fffc      	subql #1,%fp@(-4)
    ab7e:	202e 0008      	movel %fp@(8),%d0
    ab82:	4a80           	tstl %d0
    ab84:	6cea           	bges 0xab70
    ab86:	202e fffc      	movel %fp@(-4),%d0
    ab8a:	7214           	moveq #20,%d1
    ab8c:	e3a8           	lsll %d1,%d0
    ab8e:	2d40 fff4      	movel %d0,%fp@(-12)
    ab92:	202e fff4      	movel %fp@(-12),%d0
    ab96:	2200           	movel %d0,%d1
    ab98:	202e 0008      	movel %fp@(8),%d0
    ab9c:	740b           	moveq #11,%d2
    ab9e:	e4a8           	lsrl %d2,%d0
    aba0:	0880 0014      	bclr #20,%d0
    aba4:	8081           	orl %d1,%d0
    aba6:	2d40 fff4      	movel %d0,%fp@(-12)
    abaa:	202e 0008      	movel %fp@(8),%d0
    abae:	7215           	moveq #21,%d1
    abb0:	e3a8           	lsll %d1,%d0
    abb2:	2d40 fff8      	movel %d0,%fp@(-8)
    abb6:	202e fff4      	movel %fp@(-12),%d0
    abba:	222e fff8      	movel %fp@(-8),%d1
    abbe:	2f01           	movel %d1,%sp@-
    abc0:	2f00           	movel %d0,%sp@-
    abc2:	f21f 5400      	fmoved %sp@+,%fp0
    abc6:	241f           	movel %sp@+,%d2
    abc8:	4e5e           	unlk %fp
    abca:	4e75           	rts
    abcc:	4e56 fff0      	linkw %fp,#-16
    abd0:	2f02           	movel %d2,%sp@-
    abd2:	42ae fffc      	clrl %fp@(-4)
    abd6:	2d7c 0000 041d 	movel #1053,%fp@(-8)
    abdc:	fff8 
    abde:	4aae 0008      	tstl %fp@(8)
    abe2:	6614           	bnes 0xabf8
    abe4:	42ae fff4      	clrl %fp@(-12)
    abe8:	42ae fff0      	clrl %fp@(-16)
    abec:	202e fff0      	movel %fp@(-16),%d0
    abf0:	222e fff4      	movel %fp@(-12),%d1
    abf4:	6000 00aa      	braw 0xaca0
    abf8:	4aae 0008      	tstl %fp@(8)
    abfc:	6c3c           	bges 0xac3a
    abfe:	2d7c 8000 0000 	movel #-2147483648,%fp@(-4)
    ac04:	fffc 
    ac06:	202e 0008      	movel %fp@(8),%d0
    ac0a:	4480           	negl %d0
    ac0c:	2d40 0008      	movel %d0,%fp@(8)
    ac10:	4aae 0008      	tstl %fp@(8)
    ac14:	6c24           	bges 0xac3a
    ac16:	2d7c c1e0 0000 	movel #-1042284544,%fp@(-16)
    ac1c:	fff0 
    ac1e:	42ae fff4      	clrl %fp@(-12)
    ac22:	202e fff0      	movel %fp@(-16),%d0
    ac26:	222e fff4      	movel %fp@(-12),%d1
    ac2a:	6074           	bras 0xaca0
    ac2c:	202e 0008      	movel %fp@(8),%d0
    ac30:	e988           	lsll #4,%d0
    ac32:	2d40 0008      	movel %d0,%fp@(8)
    ac36:	59ae fff8      	subql #4,%fp@(-8)
    ac3a:	0cae 00ff ffff 	cmpil #16777215,%fp@(8)
    ac40:	0008 
    ac42:	6fe8           	bles 0xac2c
    ac44:	600e           	bras 0xac54
    ac46:	202e 0008      	movel %fp@(8),%d0
    ac4a:	d080           	addl %d0,%d0
    ac4c:	2d40 0008      	movel %d0,%fp@(8)
    ac50:	53ae fff8      	subql #1,%fp@(-8)
    ac54:	0cae 3fff ffff 	cmpil #1073741823,%fp@(8)
    ac5a:	0008 
    ac5c:	6fe8           	bles 0xac46
    ac5e:	2d6e fffc fff0 	movel %fp@(-4),%fp@(-16)
    ac64:	222e fff0      	movel %fp@(-16),%d1
    ac68:	202e fff8      	movel %fp@(-8),%d0
    ac6c:	7414           	moveq #20,%d2
    ac6e:	e5a8           	lsll %d2,%d0
    ac70:	8081           	orl %d1,%d0
    ac72:	2d40 fff0      	movel %d0,%fp@(-16)
    ac76:	222e fff0      	movel %fp@(-16),%d1
    ac7a:	202e 0008      	movel %fp@(8),%d0
    ac7e:	740a           	moveq #10,%d2
    ac80:	e4a0           	asrl %d2,%d0
    ac82:	0880 0014      	bclr #20,%d0
    ac86:	8081           	orl %d1,%d0
    ac88:	2d40 fff0      	movel %d0,%fp@(-16)
    ac8c:	202e 0008      	movel %fp@(8),%d0
    ac90:	7216           	moveq #22,%d1
    ac92:	e3a8           	lsll %d1,%d0
    ac94:	2d40 fff4      	movel %d0,%fp@(-12)
    ac98:	202e fff0      	movel %fp@(-16),%d0
    ac9c:	222e fff4      	movel %fp@(-12),%d1
    aca0:	2f01           	movel %d1,%sp@-
    aca2:	2f00           	movel %d0,%sp@-
    aca4:	f21f 5400      	fmoved %sp@+,%fp0
    aca8:	241f           	movel %sp@+,%d2
    acaa:	4e5e           	unlk %fp
    acac:	4e75           	rts
    acae:	4e56 fff8      	linkw %fp,#-8
    acb2:	2f2e 0008      	movel %fp@(8),%sp@-
    acb6:	4eba fe78      	jsr %pc@(0xab30)
    acba:	588f           	addql #4,%sp
    acbc:	f22e 7400 fff8 	fmoved %fp0,%fp@(-8)
    acc2:	f22e 5400 fff8 	fmoved %fp@(-8),%fp0
    acc8:	f200 6400      	fmoves %fp0,%d0
    accc:	f200 4400      	fmoves %d0,%fp0
    acd0:	4e5e           	unlk %fp
    acd2:	4e75           	rts
    acd4:	4e56 fff8      	linkw %fp,#-8
    acd8:	2f2e 0008      	movel %fp@(8),%sp@-
    acdc:	4eba feee      	jsr %pc@(0xabcc)
    ace0:	588f           	addql #4,%sp
    ace2:	f22e 7400 fff8 	fmoved %fp0,%fp@(-8)
    ace8:	f22e 5400 fff8 	fmoved %fp@(-8),%fp0
    acee:	f200 6400      	fmoves %fp0,%d0
    acf2:	f200 4400      	fmoves %d0,%fp0
    acf6:	4e5e           	unlk %fp
    acf8:	4e75           	rts
    acfa:	4e56 0000      	linkw %fp,#0
    acfe:	48e7 3c00      	moveml %d2-%d5,%sp@-
    ad02:	282e 0008      	movel %fp@(8),%d4
    ad06:	2004           	movel %d4,%d0
    ad08:	0280 8000 0000 	andil #-2147483648,%d0
    ad0e:	2400           	movel %d0,%d2
    ad10:	2004           	movel %d4,%d0
    ad12:	0880 001f      	bclr #31,%d0
    ad16:	4a80           	tstl %d0
    ad18:	6608           	bnes 0xad22
    ad1a:	4283           	clrl %d3
    ad1c:	2002           	movel %d2,%d0
    ad1e:	2203           	movel %d3,%d1
    ad20:	605a           	bras 0xad7c
    ad22:	2004           	movel %d4,%d0
    ad24:	7217           	moveq #23,%d1
    ad26:	e2a0           	asrl %d1,%d0
    ad28:	7a00           	moveq #0,%d5
    ad2a:	4605           	notb %d5
    ad2c:	ca80           	andl %d0,%d5
    ad2e:	2004           	movel %d4,%d0
    ad30:	2800           	movel %d0,%d4
    ad32:	0284 007f ffff 	andil #8388607,%d4
    ad38:	4a85           	tstl %d5
    ad3a:	6618           	bnes 0xad54
    ad3c:	7a01           	moveq #1,%d5
    ad3e:	6004           	bras 0xad44
    ad40:	d884           	addl %d4,%d4
    ad42:	5385           	subql #1,%d5
    ad44:	2004           	movel %d4,%d0
    ad46:	0280 0080 0000 	andil #8388608,%d0
    ad4c:	4a80           	tstl %d0
    ad4e:	67f0           	beqs 0xad40
    ad50:	0884 0017      	bclr #23,%d4
    ad54:	0685 0000 0380 	addil #896,%d5
    ad5a:	2202           	movel %d2,%d1
    ad5c:	2005           	movel %d5,%d0
    ad5e:	7414           	moveq #20,%d2
    ad60:	e5a8           	lsll %d2,%d0
    ad62:	8081           	orl %d1,%d0
    ad64:	2400           	movel %d0,%d2
    ad66:	2202           	movel %d2,%d1
    ad68:	2004           	movel %d4,%d0
    ad6a:	e680           	asrl #3,%d0
    ad6c:	8081           	orl %d1,%d0
    ad6e:	2400           	movel %d0,%d2
    ad70:	2004           	movel %d4,%d0
    ad72:	721d           	moveq #29,%d1
    ad74:	e3a8           	lsll %d1,%d0
    ad76:	2600           	movel %d0,%d3
    ad78:	2002           	movel %d2,%d0
    ad7a:	2203           	movel %d3,%d1
    ad7c:	2f01           	movel %d1,%sp@-
    ad7e:	2f00           	movel %d0,%sp@-
    ad80:	f21f 5400      	fmoved %sp@+,%fp0
    ad84:	4cdf 003c      	moveml %sp@+,%d2-%d5
    ad88:	4e5e           	unlk %fp
    ad8a:	4e75           	rts
    ad8c:	4e56 fff4      	linkw %fp,#-12
    ad90:	48e7 3e00      	moveml %d2-%d6,%sp@-
    ad94:	262e 0008      	movel %fp@(8),%d3
    ad98:	282e 000c      	movel %fp@(12),%d4
    ad9c:	2003           	movel %d3,%d0
    ad9e:	0880 001f      	bclr #31,%d0
    ada2:	4a80           	tstl %d0
    ada4:	6616           	bnes 0xadbc
    ada6:	2004           	movel %d4,%d0
    ada8:	4a80           	tstl %d0
    adaa:	6610           	bnes 0xadbc
    adac:	2003           	movel %d3,%d0
    adae:	0280 8000 0000 	andil #-2147483648,%d0
    adb4:	2400           	movel %d0,%d2
    adb6:	2002           	movel %d2,%d0
    adb8:	6000 00e0      	braw 0xae9a
    adbc:	2003           	movel %d3,%d0
    adbe:	7214           	moveq #20,%d1
    adc0:	e2a0           	asrl %d1,%d0
    adc2:	0280 0000 07ff 	andil #2047,%d0
    adc8:	2a00           	movel %d0,%d5
    adca:	0685 ffff fc80 	addil #-896,%d5
    add0:	2004           	movel %d4,%d0
    add2:	2400           	movel %d0,%d2
    add4:	0282 003f ffff 	andil #4194303,%d2
    adda:	2d42 fffc      	movel %d2,%fp@(-4)
    adde:	2003           	movel %d3,%d0
    ade0:	0280 000f ffff 	andil #1048575,%d0
    ade6:	08c0 0014      	bset #20,%d0
    adea:	7c0a           	moveq #10,%d6
    adec:	eda8           	lsll %d6,%d0
    adee:	2200           	movel %d0,%d1
    adf0:	2004           	movel %d4,%d0
    adf2:	7416           	moveq #22,%d2
    adf4:	e4a8           	lsrl %d2,%d0
    adf6:	8081           	orl %d1,%d0
    adf8:	2400           	movel %d0,%d2
    adfa:	703f           	moveq #63,%d0
    adfc:	c082           	andl %d2,%d0
    adfe:	81ae fffc      	orl %d0,%fp@(-4)
    ae02:	ec82           	asrl #6,%d2
    ae04:	4a85           	tstl %d5
    ae06:	6e2a           	bgts 0xae32
    ae08:	7ce8           	moveq #-24,%d6
    ae0a:	bc85           	cmpl %d5,%d6
    ae0c:	6f08           	bles 0xae16
    ae0e:	85ae fffc      	orl %d2,%fp@(-4)
    ae12:	4282           	clrl %d2
    ae14:	601a           	bras 0xae30
    ae16:	7001           	moveq #1,%d0
    ae18:	9085           	subl %d5,%d0
    ae1a:	7201           	moveq #1,%d1
    ae1c:	2c01           	movel %d1,%d6
    ae1e:	e1ae           	lsll %d0,%d6
    ae20:	2006           	movel %d6,%d0
    ae22:	5380           	subql #1,%d0
    ae24:	c082           	andl %d2,%d0
    ae26:	81ae fffc      	orl %d0,%fp@(-4)
    ae2a:	7001           	moveq #1,%d0
    ae2c:	9085           	subl %d5,%d0
    ae2e:	e0a2           	asrl %d0,%d2
    ae30:	4285           	clrl %d5
    ae32:	7001           	moveq #1,%d0
    ae34:	2d40 fff8      	movel %d0,%fp@(-8)
    ae38:	7001           	moveq #1,%d0
    ae3a:	c082           	andl %d2,%d0
    ae3c:	1000           	moveb %d0,%d0
    ae3e:	4a00           	tstb %d0
    ae40:	6736           	beqs 0xae78
    ae42:	4aae fffc      	tstl %fp@(-4)
    ae46:	6608           	bnes 0xae50
    ae48:	7002           	moveq #2,%d0
    ae4a:	c082           	andl %d2,%d0
    ae4c:	4a80           	tstl %d0
    ae4e:	6728           	beqs 0xae78
    ae50:	4a85           	tstl %d5
    ae52:	6704           	beqs 0xae58
    ae54:	7002           	moveq #2,%d0
    ae56:	6002           	bras 0xae5a
    ae58:	7001           	moveq #1,%d0
    ae5a:	2d40 fff4      	movel %d0,%fp@(-12)
    ae5e:	5282           	addql #1,%d2
    ae60:	203c 0080 0000 	movel #8388608,%d0
    ae66:	222e fff4      	movel %fp@(-12),%d1
    ae6a:	e3a8           	lsll %d1,%d0
    ae6c:	b480           	cmpl %d0,%d2
    ae6e:	6d08           	blts 0xae78
    ae70:	5285           	addql #1,%d5
    ae72:	2d6e fff4 fff8 	movel %fp@(-12),%fp@(-8)
    ae78:	2c2e fff8      	movel %fp@(-8),%d6
    ae7c:	eca2           	asrl %d6,%d2
    ae7e:	0882 0017      	bclr #23,%d2
    ae82:	2003           	movel %d3,%d0
    ae84:	0280 8000 0000 	andil #-2147483648,%d0
    ae8a:	2205           	movel %d5,%d1
    ae8c:	7617           	moveq #23,%d3
    ae8e:	e7a9           	lsll %d3,%d1
    ae90:	8081           	orl %d1,%d0
    ae92:	2202           	movel %d2,%d1
    ae94:	8081           	orl %d1,%d0
    ae96:	2400           	movel %d0,%d2
    ae98:	2002           	movel %d2,%d0
    ae9a:	f200 4400      	fmoves %d0,%fp0
    ae9e:	4cdf 007c      	moveml %sp@+,%d2-%d6
    aea2:	4e5e           	unlk %fp
    aea4:	4e75           	rts
    aea6:	4e56 0000      	linkw %fp,#0
    aeaa:	48e7 3c00      	moveml %d2-%d5,%sp@-
    aeae:	242e 0008      	movel %fp@(8),%d2
    aeb2:	262e 000c      	movel %fp@(12),%d3
    aeb6:	2002           	movel %d2,%d0
    aeb8:	4a80           	tstl %d0
    aeba:	660a           	bnes 0xaec6
    aebc:	2003           	movel %d3,%d0
    aebe:	4a80           	tstl %d0
    aec0:	6604           	bnes 0xaec6
    aec2:	4280           	clrl %d0
    aec4:	606c           	bras 0xaf32
    aec6:	2002           	movel %d2,%d0
    aec8:	7214           	moveq #20,%d1
    aeca:	e2a0           	asrl %d1,%d0
    aecc:	0280 0000 07ff 	andil #2047,%d0
    aed2:	2a00           	movel %d0,%d5
    aed4:	0685 ffff fbe3 	addil #-1053,%d5
    aeda:	2002           	movel %d2,%d0
    aedc:	0280 000f ffff 	andil #1048575,%d0
    aee2:	08c0 0014      	bset #20,%d0
    aee6:	780a           	moveq #10,%d4
    aee8:	e9a8           	lsll %d4,%d0
    aeea:	2200           	movel %d0,%d1
    aeec:	2003           	movel %d3,%d0
    aeee:	7816           	moveq #22,%d4
    aef0:	e8a8           	lsrl %d4,%d0
    aef2:	8081           	orl %d1,%d0
    aef4:	2800           	movel %d0,%d4
    aef6:	4a85           	tstl %d5
    aef8:	6f16           	bles 0xaf10
    aefa:	2002           	movel %d2,%d0
    aefc:	4a80           	tstl %d0
    aefe:	6c08           	bges 0xaf08
    af00:	203c 8000 0000 	movel #-2147483648,%d0
    af06:	6006           	bras 0xaf0e
    af08:	203c 7fff ffff 	movel #2147483647,%d0
    af0e:	6022           	bras 0xaf32
    af10:	70e1           	moveq #-31,%d0
    af12:	b085           	cmpl %d5,%d0
    af14:	6f04           	bles 0xaf1a
    af16:	4280           	clrl %d0
    af18:	6018           	bras 0xaf32
    af1a:	4a85           	tstl %d5
    af1c:	6c06           	bges 0xaf24
    af1e:	2005           	movel %d5,%d0
    af20:	4480           	negl %d0
    af22:	e0a4           	asrl %d0,%d4
    af24:	2002           	movel %d2,%d0
    af26:	4a80           	tstl %d0
    af28:	6c06           	bges 0xaf30
    af2a:	2004           	movel %d4,%d0
    af2c:	4480           	negl %d0
    af2e:	6002           	bras 0xaf32
    af30:	2004           	movel %d4,%d0
    af32:	4cdf 003c      	moveml %sp@+,%d2-%d5
    af36:	4e5e           	unlk %fp
    af38:	4e75           	rts
    af3a:	4e56 fff0      	linkw %fp,#-16
    af3e:	2f02           	movel %d2,%sp@-
    af40:	2d6e 0008 fff0 	movel %fp@(8),%fp@(-16)
    af46:	2d6e 000c fff4 	movel %fp@(12),%fp@(-12)
    af4c:	202e fff0      	movel %fp@(-16),%d0
    af50:	4a80           	tstl %d0
    af52:	660c           	bnes 0xaf60
    af54:	202e fff4      	movel %fp@(-12),%d0
    af58:	4a80           	tstl %d0
    af5a:	6604           	bnes 0xaf60
    af5c:	4280           	clrl %d0
    af5e:	6078           	bras 0xafd8
    af60:	202e fff0      	movel %fp@(-16),%d0
    af64:	7214           	moveq #20,%d1
    af66:	e2a0           	asrl %d1,%d0
    af68:	0280 0000 07ff 	andil #2047,%d0
    af6e:	2400           	movel %d0,%d2
    af70:	0682 ffff fbe2 	addil #-1054,%d2
    af76:	2d42 fffc      	movel %d2,%fp@(-4)
    af7a:	202e fff0      	movel %fp@(-16),%d0
    af7e:	0280 000f ffff 	andil #1048575,%d0
    af84:	08c0 0014      	bset #20,%d0
    af88:	720b           	moveq #11,%d1
    af8a:	e3a8           	lsll %d1,%d0
    af8c:	2200           	movel %d0,%d1
    af8e:	202e fff4      	movel %fp@(-12),%d0
    af92:	7415           	moveq #21,%d2
    af94:	e4a8           	lsrl %d2,%d0
    af96:	2401           	movel %d1,%d2
    af98:	8480           	orl %d0,%d2
    af9a:	2d42 fff8      	movel %d2,%fp@(-8)
    af9e:	4aae fffc      	tstl %fp@(-4)
    afa2:	6f04           	bles 0xafa8
    afa4:	70ff           	moveq #-1,%d0
    afa6:	6030           	bras 0xafd8
    afa8:	4aae fffc      	tstl %fp@(-4)
    afac:	6c28           	bges 0xafd6
    afae:	70e1           	moveq #-31,%d0
    afb0:	b0ae fffc      	cmpl %fp@(-4),%d0
    afb4:	6e20           	bgts 0xafd6
    afb6:	4aae fff8      	tstl %fp@(-8)
    afba:	671a           	beqs 0xafd6
    afbc:	202e fffc      	movel %fp@(-4),%d0
    afc0:	4480           	negl %d0
    afc2:	222e fff8      	movel %fp@(-8),%d1
    afc6:	2401           	movel %d1,%d2
    afc8:	e0aa           	lsrl %d0,%d2
    afca:	2002           	movel %d2,%d0
    afcc:	2d40 fff8      	movel %d0,%fp@(-8)
    afd0:	202e fff8      	movel %fp@(-8),%d0
    afd4:	6002           	bras 0xafd8
    afd6:	4280           	clrl %d0
    afd8:	241f           	movel %sp@+,%d2
    afda:	4e5e           	unlk %fp
    afdc:	4e75           	rts
    afde:	4e56 fff8      	linkw %fp,#-8
    afe2:	f22e 4400 0008 	fmoves %fp@(8),%fp0
    afe8:	f22e 7400 fff8 	fmoved %fp0,%fp@(-8)
    afee:	2f2e fffc      	movel %fp@(-4),%sp@-
    aff2:	2f2e fff8      	movel %fp@(-8),%sp@-
    aff6:	4eba feae      	jsr %pc@(0xaea6)
    affa:	508f           	addql #8,%sp
    affc:	4e5e           	unlk %fp
    affe:	4e75           	rts
    b000:	4e56 fff0      	linkw %fp,#-16
    b004:	2f03           	movel %d3,%sp@-
    b006:	2f02           	movel %d2,%sp@-
    b008:	42ae fff8      	clrl %fp@(-8)
    b00c:	42ae fffc      	clrl %fp@(-4)
    b010:	42ae fff0      	clrl %fp@(-16)
    b014:	2d7c 0000 0001 	movel #1,%fp@(-12)
    b01a:	fff4 
    b01c:	242e 0010      	movel %fp@(16),%d2
    b020:	262e 0014      	movel %fp@(20),%d3
    b024:	4483           	negl %d3
    b026:	4082           	negxl %d2
    b028:	6640           	bnes 0xb06a
    b02a:	206e 0014      	moveal %fp@(20),%a0
    b02e:	7601           	moveq #1,%d3
    b030:	2008           	movel %a0,%d0
    b032:	4c40 3000      	divull %d0,%d0,%d3
    b036:	2043           	moveal %d3,%a0
    b038:	2208           	movel %a0,%d1
    b03a:	4280           	clrl %d0
    b03c:	6000 00da      	braw 0xb118
    b040:	202e 0010      	movel %fp@(16),%d0
    b044:	222e 0014      	movel %fp@(20),%d1
    b048:	d281           	addl %d1,%d1
    b04a:	d180           	addxl %d0,%d0
    b04c:	2d40 0010      	movel %d0,%fp@(16)
    b050:	2d41 0014      	movel %d1,%fp@(20)
    b054:	202e fff0      	movel %fp@(-16),%d0
    b058:	222e fff4      	movel %fp@(-12),%d1
    b05c:	d281           	addl %d1,%d1
    b05e:	d180           	addxl %d0,%d0
    b060:	2d40 fff0      	movel %d0,%fp@(-16)
    b064:	2d41 fff4      	movel %d1,%fp@(-12)
    b068:	6002           	bras 0xb06c
    b06a:	4e71           	nop
    b06c:	202e 0010      	movel %fp@(16),%d0
    b070:	222e 0014      	movel %fp@(20),%d1
    b074:	9482           	subl %d2,%d2
    b076:	4a81           	tstl %d1
    b078:	9182           	subxl %d2,%d0
    b07a:	6cc4           	bges 0xb040
    b07c:	606a           	bras 0xb0e8
    b07e:	202e 0010      	movel %fp@(16),%d0
    b082:	222e 0014      	movel %fp@(20),%d1
    b086:	242e 0008      	movel %fp@(8),%d2
    b08a:	262e 000c      	movel %fp@(12),%d3
    b08e:	9283           	subl %d3,%d1
    b090:	9182           	subxl %d2,%d0
    b092:	622c           	bhis 0xb0c0
    b094:	202e 0010      	movel %fp@(16),%d0
    b098:	222e 0014      	movel %fp@(20),%d1
    b09c:	93ae 000c      	subl %d1,%fp@(12)
    b0a0:	242e 0008      	movel %fp@(8),%d2
    b0a4:	9580           	subxl %d0,%d2
    b0a6:	2d42 0008      	movel %d2,%fp@(8)
    b0aa:	202e fff0      	movel %fp@(-16),%d0
    b0ae:	222e fff4      	movel %fp@(-12),%d1
    b0b2:	d3ae fffc      	addl %d1,%fp@(-4)
    b0b6:	242e fff8      	movel %fp@(-8),%d2
    b0ba:	d580           	addxl %d0,%d2
    b0bc:	2d42 fff8      	movel %d2,%fp@(-8)
    b0c0:	202e 0010      	movel %fp@(16),%d0
    b0c4:	222e 0014      	movel %fp@(20),%d1
    b0c8:	e288           	lsrl #1,%d0
    b0ca:	e291           	roxrl #1,%d1
    b0cc:	2d40 0010      	movel %d0,%fp@(16)
    b0d0:	2d41 0014      	movel %d1,%fp@(20)
    b0d4:	202e fff0      	movel %fp@(-16),%d0
    b0d8:	222e fff4      	movel %fp@(-12),%d1
    b0dc:	e288           	lsrl #1,%d0
    b0de:	e291           	roxrl #1,%d1
    b0e0:	2d40 fff0      	movel %d0,%fp@(-16)
    b0e4:	2d41 fff4      	movel %d1,%fp@(-12)
    b0e8:	202e fff0      	movel %fp@(-16),%d0
    b0ec:	222e fff4      	movel %fp@(-12),%d1
    b0f0:	4481           	negl %d1
    b0f2:	4080           	negxl %d0
    b0f4:	6688           	bnes 0xb07e
    b0f6:	4aae 0018      	tstl %fp@(24)
    b0fa:	6714           	beqs 0xb110
    b0fc:	202e 0018      	movel %fp@(24),%d0
    b100:	222e 0008      	movel %fp@(8),%d1
    b104:	242e 000c      	movel %fp@(12),%d2
    b108:	2040           	moveal %d0,%a0
    b10a:	2081           	movel %d1,%a0@
    b10c:	2142 0004      	movel %d2,%a0@(4)
    b110:	202e fff8      	movel %fp@(-8),%d0
    b114:	222e fffc      	movel %fp@(-4),%d1
    b118:	2040           	moveal %d0,%a0
    b11a:	2241           	moveal %d1,%a1
    b11c:	2008           	movel %a0,%d0
    b11e:	2209           	movel %a1,%d1
    b120:	241f           	movel %sp@+,%d2
    b122:	261f           	movel %sp@+,%d3
    b124:	4e5e           	unlk %fp
    b126:	4e75           	rts
    b128:	4e56 fff8      	linkw %fp,#-8
    b12c:	200e           	movel %fp,%d0
    b12e:	5180           	subql #8,%d0
    b130:	2f00           	movel %d0,%sp@-
    b132:	2f2e 0014      	movel %fp@(20),%sp@-
    b136:	2f2e 0010      	movel %fp@(16),%sp@-
    b13a:	2f2e 000c      	movel %fp@(12),%sp@-
    b13e:	2f2e 0008      	movel %fp@(8),%sp@-
    b142:	4eba febc      	jsr %pc@(0xb000)
    b146:	4fef 0014      	lea %sp@(20),%sp
    b14a:	206e fff8      	moveal %fp@(-8),%a0
    b14e:	226e fffc      	moveal %fp@(-4),%a1
    b152:	2008           	movel %a0,%d0
    b154:	2209           	movel %a1,%d1
    b156:	4e5e           	unlk %fp
    b158:	4e75           	rts
    b15a:	4e56 0000      	linkw %fp,#0
    b15e:	42a7           	clrl %sp@-
    b160:	2f2e 0014      	movel %fp@(20),%sp@-
    b164:	2f2e 0010      	movel %fp@(16),%sp@-
    b168:	2f2e 000c      	movel %fp@(12),%sp@-
    b16c:	2f2e 0008      	movel %fp@(8),%sp@-
    b170:	4eba fe8e      	jsr %pc@(0xb000)
    b174:	4fef 0014      	lea %sp@(20),%sp
    b178:	2040           	moveal %d0,%a0
    b17a:	2241           	moveal %d1,%a1
    b17c:	2008           	movel %a0,%d0
    b17e:	2209           	movel %a1,%d1
    b180:	4e5e           	unlk %fp
    b182:	4e75           	rts
    b184:	f22f 541c 0004 	facosd %sp@(4),%fp0
    b18a:	4e75           	rts
    b18c:	f22f 540c 0004 	fasind %sp@(4),%fp0
    b192:	4e75           	rts
    b194:	f22f 540a 0004 	fatand %sp@(4),%fp0
    b19a:	4e75           	rts
    b19c:	41ef 0004      	lea %sp@(4),%a0
    b1a0:	f210 5400      	fmoved %a0@,%fp0
    b1a4:	f200 0001      	fintx %fp0,%fp0
    b1a8:	f23c 5422 3ff0 	faddd #0e1,%fp0
    b1ae:	0000 0000 0000 
    b1b4:	4e75           	rts
    b1b6:	4e71           	nop
    b1b8:	f22f 541d 0004 	fcosd %sp@(4),%fp0
    b1be:	4e75           	rts
    b1c0:	f22f 5419 0004 	fcoshd %sp@(4),%fp0
    b1c6:	4e75           	rts
    b1c8:	f22f 5410 0004 	fetoxd %sp@(4),%fp0
    b1ce:	4e75           	rts
    b1d0:	f22f 5418 0004 	fabsd %sp@(4),%fp0
    b1d6:	4e75           	rts
    b1d8:	f22f 5400 0004 	fmoved %sp@(4),%fp0
    b1de:	f200 0001      	fintx %fp0,%fp0
    b1e2:	4e75           	rts
    b1e4:	41ef 0004      	lea %sp@(4),%a0
    b1e8:	f210 5400      	fmoved %a0@,%fp0
    b1ec:	f228 5421 0008 	fmodd %a0@(8),%fp0
    b1f2:	4e75           	rts
    b1f4:	41ef 0004      	lea %sp@(4),%a0
    b1f8:	f210 5480      	fmoved %a0@,%fp1
    b1fc:	f200 041f      	fgetmanx %fp1,%fp0
    b200:	f200 051e      	fgetexpx %fp1,%fp2
    b204:	2068 0008      	moveal %a0@(8),%a0
    b208:	f210 6100      	fmovel %fp2,%a0@
    b20c:	f23c 4820 4000 	fdivx #0e2,%fp0
    b212:	0000 8000 0000 
    b218:	0000 0000 
    b21c:	5290           	addql #1,%a0@
    b21e:	4e75           	rts
    b220:	41ef 0004      	lea %sp@(4),%a0
    b224:	f228 4011 0008 	ftwotoxl %a0@(8),%fp0
    b22a:	f210 5423      	fmuld %a0@,%fp0
    b22e:	4e75           	rts
    b230:	f22f 5414 0004 	flognd %sp@(4),%fp0
    b236:	4e75           	rts
    b238:	f22f 5415 0004 	flog10d %sp@(4),%fp0
    b23e:	4e75           	rts
    b240:	41ef 0004      	lea %sp@(4),%a0
    b244:	f210 5483      	fintrzd %a0@,%fp1
    b248:	f210 5400      	fmoved %a0@,%fp0
    b24c:	f200 0428      	fsubx %fp1,%fp0
    b250:	2068 0008      	moveal %a0@(8),%a0
    b254:	f210 7480      	fmoved %fp1,%a0@
    b258:	4e75           	rts
    b25a:	4e71           	nop
    b25c:	41ef 0004      	lea %sp@(4),%a0
    b260:	4e56 fff8      	linkw %fp,#-8
    b264:	f210 5414      	flognd %a0@,%fp0
    b268:	f228 5423 0008 	fmuld %a0@(8),%fp0
    b26e:	f22e 7400 fff8 	fmoved %fp0,%fp@(-8)
    b274:	f22e 5410 fff8 	fetoxd %fp@(-8),%fp0
    b27a:	4e5e           	unlk %fp
    b27c:	4e75           	rts
    b27e:	4e71           	nop
    b280:	f22f 540e 0004 	fsind %sp@(4),%fp0
    b286:	4e75           	rts
    b288:	f22f 5402 0004 	fsinhd %sp@(4),%fp0
    b28e:	4e75           	rts
    b290:	f22f 5404 0004 	fsqrtd %sp@(4),%fp0
    b296:	4e75           	rts
    b298:	f22f 540f 0004 	ftand %sp@(4),%fp0
    b29e:	4e75           	rts
    b2a0:	f22f 5409 0004 	ftanhd %sp@(4),%fp0
    b2a6:	4e75           	rts
    b2a8:	4e56 0000      	linkw %fp,#0
    b2ac:	4eba 0e9c      	jsr %pc@(0xc14a)
    b2b0:	4e5e           	unlk %fp
    b2b2:	4e75           	rts
    b2b4:	4e56 0000      	linkw %fp,#0
    b2b8:	4879 0000 0000 	pea 0x0
    b2be:	4eb9 0000 0000 	jsr 0x0
    b2c4:	588f           	addql #4,%sp
    b2c6:	4e5e           	unlk %fp
    b2c8:	4e75           	rts
    b2ca:	4e56 0000      	linkw %fp,#0
    b2ce:	4879 0000 0000 	pea 0x0
    b2d4:	4eb9 0000 0000 	jsr 0x0
    b2da:	588f           	addql #4,%sp
    b2dc:	60fe           	bras 0xb2dc
    b2de:	4e56 ffcc      	linkw %fp,#-52
    b2e2:	4879 0000 0000 	pea 0x0
    b2e8:	4eb9 0000 0000 	jsr 0x0
    b2ee:	588f           	addql #4,%sp
    b2f0:	2d7c 0fff ffff 	movel #268435455,%fp@(-8)
    b2f6:	fff8 
    b2f8:	2d7c ffff ffff 	movel #-1,%fp@(-4)
    b2fe:	fffc 
    b300:	42ae fff0      	clrl %fp@(-16)
    b304:	2d7c 1234 5678 	movel #305419896,%fp@(-12)
    b30a:	fff4 
    b30c:	2f2e fff4      	movel %fp@(-12),%sp@-
    b310:	2f2e fff0      	movel %fp@(-16),%sp@-
    b314:	2f2e fffc      	movel %fp@(-4),%sp@-
    b318:	2f2e fff8      	movel %fp@(-8),%sp@-
    b31c:	4eb9 0000 0000 	jsr 0x0
    b322:	4fef 0010      	lea %sp@(16),%sp
    b326:	2d40 ffe8      	movel %d0,%fp@(-24)
    b32a:	2d41 ffec      	movel %d1,%fp@(-20)
    b32e:	4879 0000 0000 	pea 0x0
    b334:	4eb9 0000 0000 	jsr 0x0
    b33a:	588f           	addql #4,%sp
    b33c:	2f2e ffec      	movel %fp@(-20),%sp@-
    b340:	2f2e ffe8      	movel %fp@(-24),%sp@-
    b344:	2f2e fff4      	movel %fp@(-12),%sp@-
    b348:	2f2e fff0      	movel %fp@(-16),%sp@-
    b34c:	2f2e fffc      	movel %fp@(-4),%sp@-
    b350:	2f2e fff8      	movel %fp@(-8),%sp@-
    b354:	4879 0000 0000 	pea 0x0
    b35a:	4eb9 0000 0000 	jsr 0x0
    b360:	4fef 001c      	lea %sp@(28),%sp
    b364:	4e5e           	unlk %fp
    b366:	4e75           	rts
    b368:	4e56 0000      	linkw %fp,#0
    b36c:	4879 0000 0000 	pea 0x0
    b372:	4eb9 0000 0000 	jsr 0x0
    b378:	588f           	addql #4,%sp
    b37a:	203c 0000 0000 	movel #0,%d0
    b380:	2040           	moveal %d0,%a0
    b382:	2010           	movel %a0@,%d0
    b384:	2f00           	movel %d0,%sp@-
    b386:	4eb9 0000 0000 	jsr 0x0
    b38c:	588f           	addql #4,%sp
    b38e:	4879 0000 0000 	pea 0x0
    b394:	4eb9 0000 0000 	jsr 0x0
    b39a:	588f           	addql #4,%sp
    b39c:	4878 0015      	pea 0x15
    b3a0:	4eb9 0000 0000 	jsr 0x0
    b3a6:	588f           	addql #4,%sp
    b3a8:	4e5e           	unlk %fp
    b3aa:	4e75           	rts
    b3ac:	4e56 fff8      	linkw %fp,#-8
    b3b0:	4879 0000 0000 	pea 0x0
    b3b6:	4eb9 0000 0000 	jsr 0x0
    b3bc:	588f           	addql #4,%sp
    b3be:	42a7           	clrl %sp@-
    b3c0:	4eb9 0000 0000 	jsr 0x0
    b3c6:	588f           	addql #4,%sp
    b3c8:	2d40 fff8      	movel %d0,%fp@(-8)
    b3cc:	200e           	movel %fp,%d0
    b3ce:	5180           	subql #8,%d0
    b3d0:	2f00           	movel %d0,%sp@-
    b3d2:	4eb9 0000 0000 	jsr 0x0
    b3d8:	588f           	addql #4,%sp
    b3da:	2008           	movel %a0,%d0
    b3dc:	2f00           	movel %d0,%sp@-
    b3de:	4879 0000 0000 	pea 0x0
    b3e4:	4eb9 0000 0000 	jsr 0x0
    b3ea:	508f           	addql #8,%sp
    b3ec:	200e           	movel %fp,%d0
    b3ee:	5180           	subql #8,%d0
    b3f0:	2f00           	movel %d0,%sp@-
    b3f2:	4eb9 0000 0000 	jsr 0x0
    b3f8:	588f           	addql #4,%sp
    b3fa:	200e           	movel %fp,%d0
    b3fc:	5180           	subql #8,%d0
    b3fe:	2f00           	movel %d0,%sp@-
    b400:	4eb9 0000 0000 	jsr 0x0
    b406:	588f           	addql #4,%sp
    b408:	2d48 fffc      	movel %a0,%fp@(-4)
    b40c:	2f2e fffc      	movel %fp@(-4),%sp@-
    b410:	4eb9 0000 0000 	jsr 0x0
    b416:	588f           	addql #4,%sp
    b418:	2008           	movel %a0,%d0
    b41a:	2f00           	movel %d0,%sp@-
    b41c:	4879 0000 0000 	pea 0x0
    b422:	4eb9 0000 0000 	jsr 0x0
    b428:	508f           	addql #8,%sp
    b42a:	4879 0000 0000 	pea 0x0
    b430:	4eb9 0000 0000 	jsr 0x0
    b436:	588f           	addql #4,%sp
    b438:	4e5e           	unlk %fp
    b43a:	4e75           	rts
    b43c:	4e56 fffc      	linkw %fp,#-4
    b440:	200e           	movel %fp,%d0
    b442:	5980           	subql #4,%d0
    b444:	2f00           	movel %d0,%sp@-
    b446:	4eb9 0000 0000 	jsr 0x0
    b44c:	588f           	addql #4,%sp
    b44e:	200e           	movel %fp,%d0
    b450:	5980           	subql #4,%d0
    b452:	2f00           	movel %d0,%sp@-
    b454:	4eb9 0000 0000 	jsr 0x0
    b45a:	588f           	addql #4,%sp
    b45c:	2008           	movel %a0,%d0
    b45e:	23c0 0000 0000 	movel %d0,0x0
    b464:	4879 0000 0000 	pea 0x0
    b46a:	4eb9 0000 0000 	jsr 0x0
    b470:	588f           	addql #4,%sp
    b472:	2039 0000 0000 	movel 0x0,%d0
    b478:	2040           	moveal %d0,%a0
    b47a:	2028 0014      	movel %a0@(20),%d0
    b47e:	2200           	movel %d0,%d1
    b480:	0681 0000 076c 	addil #1900,%d1
    b486:	2039 0000 0000 	movel 0x0,%d0
    b48c:	2040           	moveal %d0,%a0
    b48e:	2028 0010      	movel %a0@(16),%d0
    b492:	5280           	addql #1,%d0
    b494:	2079 0000 0000 	moveal 0x0,%a0
    b49a:	2068 000c      	moveal %a0@(12),%a0
    b49e:	2f01           	movel %d1,%sp@-
    b4a0:	2f00           	movel %d0,%sp@-
    b4a2:	2f08           	movel %a0,%sp@-
    b4a4:	4879 0000 0000 	pea 0x0
    b4aa:	4eb9 0000 0000 	jsr 0x0
    b4b0:	4fef 0010      	lea %sp@(16),%sp
    b4b4:	4e5e           	unlk %fp
    b4b6:	4e75           	rts
    b4b8:	4e56 ffec      	linkw %fp,#-20
    b4bc:	2f02           	movel %d2,%sp@-
    b4be:	42ae fffc      	clrl %fp@(-4)
    b4c2:	4879 0000 0000 	pea 0x0
    b4c8:	4eb9 0000 0000 	jsr 0x0
    b4ce:	588f           	addql #4,%sp
    b4d0:	4879 0000 0000 	pea 0x0
    b4d6:	4eb9 0000 0000 	jsr 0x0
    b4dc:	588f           	addql #4,%sp
    b4de:	70f4           	moveq #-12,%d0
    b4e0:	d08e           	addl %fp,%d0
    b4e2:	2f00           	movel %d0,%sp@-
    b4e4:	4879 0000 0000 	pea 0x0
    b4ea:	4eb9 0000 0000 	jsr 0x0
    b4f0:	508f           	addql #8,%sp
    b4f2:	4879 0000 0000 	pea 0x0
    b4f8:	4eb9 0000 0000 	jsr 0x0
    b4fe:	588f           	addql #4,%sp
    b500:	70f0           	moveq #-16,%d0
    b502:	d08e           	addl %fp,%d0
    b504:	2f00           	movel %d0,%sp@-
    b506:	4879 0000 0000 	pea 0x0
    b50c:	4eb9 0000 0000 	jsr 0x0
    b512:	508f           	addql #8,%sp
    b514:	4879 0000 0000 	pea 0x0
    b51a:	4eb9 0000 0000 	jsr 0x0
    b520:	588f           	addql #4,%sp
    b522:	70ec           	moveq #-20,%d0
    b524:	d08e           	addl %fp,%d0
    b526:	2f00           	movel %d0,%sp@-
    b528:	4879 0000 0000 	pea 0x0
    b52e:	4eb9 0000 0000 	jsr 0x0
    b534:	508f           	addql #8,%sp
    b536:	4eba ff04      	jsr %pc@(0xb43c)
    b53a:	2039 0000 0000 	movel 0x0,%d0
    b540:	2040           	moveal %d0,%a0
    b542:	2228 0010      	movel %a0@(16),%d1
    b546:	202e fff0      	movel %fp@(-16),%d0
    b54a:	b081           	cmpl %d1,%d0
    b54c:	6f2a           	bles 0xb578
    b54e:	7001           	moveq #1,%d0
    b550:	2d40 fffc      	movel %d0,%fp@(-4)
    b554:	2039 0000 0000 	movel 0x0,%d0
    b55a:	2040           	moveal %d0,%a0
    b55c:	2028 0010      	movel %a0@(16),%d0
    b560:	5280           	addql #1,%d0
    b562:	222e fff0      	movel %fp@(-16),%d1
    b566:	9081           	subl %d1,%d0
    b568:	2d40 fff8      	movel %d0,%fp@(-8)
    b56c:	700c           	moveq #12,%d0
    b56e:	d0ae fff8      	addl %fp@(-8),%d0
    b572:	2d40 fff0      	movel %d0,%fp@(-16)
    b576:	6020           	bras 0xb598
    b578:	2039 0000 0000 	movel 0x0,%d0
    b57e:	2240           	moveal %d0,%a1
    b580:	2029 0010      	movel %a1@(16),%d0
    b584:	5280           	addql #1,%d0
    b586:	222e fff0      	movel %fp@(-16),%d1
    b58a:	9081           	subl %d1,%d0
    b58c:	2d40 fff8      	movel %d0,%fp@(-8)
    b590:	202e fff8      	movel %fp@(-8),%d0
    b594:	2d40 fff0      	movel %d0,%fp@(-16)
    b598:	202e fff0      	movel %fp@(-16),%d0
    b59c:	720c           	moveq #12,%d1
    b59e:	b280           	cmpl %d0,%d1
    b5a0:	6608           	bnes 0xb5aa
    b5a2:	42ae fff0      	clrl %fp@(-16)
    b5a6:	42ae fffc      	clrl %fp@(-4)
    b5aa:	2039 0000 0000 	movel 0x0,%d0
    b5b0:	2040           	moveal %d0,%a0
    b5b2:	2028 000c      	movel %a0@(12),%d0
    b5b6:	222e fff4      	movel %fp@(-12),%d1
    b5ba:	2400           	movel %d0,%d2
    b5bc:	9481           	subl %d1,%d2
    b5be:	2202           	movel %d2,%d1
    b5c0:	206e fff0      	moveal %fp@(-16),%a0
    b5c4:	2039 0000 0000 	movel 0x0,%d0
    b5ca:	2240           	moveal %d0,%a1
    b5cc:	2029 0014      	movel %a1@(20),%d0
    b5d0:	0680 0000 076c 	addil #1900,%d0
    b5d6:	226e ffec      	moveal %fp@(-20),%a1
    b5da:	9089           	subl %a1,%d0
    b5dc:	90ae fffc      	subl %fp@(-4),%d0
    b5e0:	2f01           	movel %d1,%sp@-
    b5e2:	2f08           	movel %a0,%sp@-
    b5e4:	2f00           	movel %d0,%sp@-
    b5e6:	4879 0000 0000 	pea 0x0
    b5ec:	4eb9 0000 0000 	jsr 0x0
    b5f2:	4fef 0010      	lea %sp@(16),%sp
    b5f6:	242e ffe8      	movel %fp@(-24),%d2
    b5fa:	4e5e           	unlk %fp
    b5fc:	4e75           	rts
    b5fe:	4e56 fff0      	linkw %fp,#-16
    b602:	4879 0000 0000 	pea 0x0
    b608:	4eb9 0000 0000 	jsr 0x0
    b60e:	588f           	addql #4,%sp
    b610:	4eb9 0000 0000 	jsr 0x0
    b616:	4879 0000 0000 	pea 0x0
    b61c:	4879 0000 0000 	pea 0x0
    b622:	4eb9 0000 0000 	jsr 0x0
    b628:	508f           	addql #8,%sp
    b62a:	2d48 fffc      	movel %a0,%fp@(-4)
    b62e:	4aae fffc      	tstl %fp@(-4)
    b632:	6612           	bnes 0xb646
    b634:	4879 0000 0000 	pea 0x0
    b63a:	4eb9 0000 0000 	jsr 0x0
    b640:	588f           	addql #4,%sp
    b642:	6000 0154      	braw 0xb798
    b646:	4879 0000 0000 	pea 0x0
    b64c:	4eb9 0000 0000 	jsr 0x0
    b652:	588f           	addql #4,%sp
    b654:	4eb9 0000 0000 	jsr 0x0
    b65a:	4879 0000 0000 	pea 0x0
    b660:	2f2e fffc      	movel %fp@(-4),%sp@-
    b664:	4eb9 0000 0000 	jsr 0x0
    b66a:	508f           	addql #8,%sp
    b66c:	4879 0000 0000 	pea 0x0
    b672:	4eb9 0000 0000 	jsr 0x0
    b678:	588f           	addql #4,%sp
    b67a:	4eb9 0000 0000 	jsr 0x0
    b680:	4879 0000 0000 	pea 0x0
    b686:	2f2e fffc      	movel %fp@(-4),%sp@-
    b68a:	4eb9 0000 0000 	jsr 0x0
    b690:	508f           	addql #8,%sp
    b692:	4879 0000 0000 	pea 0x0
    b698:	4eb9 0000 0000 	jsr 0x0
    b69e:	588f           	addql #4,%sp
    b6a0:	4eb9 0000 0000 	jsr 0x0
    b6a6:	4879 0000 0000 	pea 0x0
    b6ac:	2f2e fffc      	movel %fp@(-4),%sp@-
    b6b0:	4eb9 0000 0000 	jsr 0x0
    b6b6:	508f           	addql #8,%sp
    b6b8:	4879 0000 0000 	pea 0x0
    b6be:	4eb9 0000 0000 	jsr 0x0
    b6c4:	588f           	addql #4,%sp
    b6c6:	4eb9 0000 0000 	jsr 0x0
    b6cc:	4879 0000 0000 	pea 0x0
    b6d2:	2f2e fffc      	movel %fp@(-4),%sp@-
    b6d6:	4eb9 0000 0000 	jsr 0x0
    b6dc:	508f           	addql #8,%sp
    b6de:	4879 0000 0000 	pea 0x0
    b6e4:	4eb9 0000 0000 	jsr 0x0
    b6ea:	588f           	addql #4,%sp
    b6ec:	4eb9 0000 0000 	jsr 0x0
    b6f2:	4879 0000 0000 	pea 0x0
    b6f8:	2f2e fffc      	movel %fp@(-4),%sp@-
    b6fc:	4eb9 0000 0000 	jsr 0x0
    b702:	508f           	addql #8,%sp
    b704:	4879 0000 0000 	pea 0x0
    b70a:	4eb9 0000 0000 	jsr 0x0
    b710:	588f           	addql #4,%sp
    b712:	4eb9 0000 0000 	jsr 0x0
    b718:	4879 0000 0000 	pea 0x0
    b71e:	2f2e fffc      	movel %fp@(-4),%sp@-
    b722:	4eb9 0000 0000 	jsr 0x0
    b728:	508f           	addql #8,%sp
    b72a:	4879 0000 0000 	pea 0x0
    b730:	4eb9 0000 0000 	jsr 0x0
    b736:	588f           	addql #4,%sp
    b738:	4eb9 0000 0000 	jsr 0x0
    b73e:	4879 0000 0000 	pea 0x0
    b744:	2f2e fffc      	movel %fp@(-4),%sp@-
    b748:	4eb9 0000 0000 	jsr 0x0
    b74e:	508f           	addql #8,%sp
    b750:	4879 0000 0000 	pea 0x0
    b756:	4eb9 0000 0000 	jsr 0x0
    b75c:	588f           	addql #4,%sp
    b75e:	4eb9 0000 0000 	jsr 0x0
    b764:	4879 0000 0000 	pea 0x0
    b76a:	2f2e fffc      	movel %fp@(-4),%sp@-
    b76e:	4eb9 0000 0000 	jsr 0x0
    b774:	508f           	addql #8,%sp
    b776:	4879 0000 0000 	pea 0x0
    b77c:	4eb9 0000 0000 	jsr 0x0
    b782:	588f           	addql #4,%sp
    b784:	4eb9 0000 0000 	jsr 0x0
    b78a:	2f2e fffc      	movel %fp@(-4),%sp@-
    b78e:	4eb9 0000 0000 	jsr 0x0
    b794:	588f           	addql #4,%sp
    b796:	4e71           	nop
    b798:	4e5e           	unlk %fp
    b79a:	4e75           	rts
    b79c:	4e56 fee0      	linkw %fp,#-288
    b7a0:	2f02           	movel %d2,%sp@-
    b7a2:	2d7c 0000 0000 	movel #0,%fp@(-8)
    b7a8:	fff8 
    b7aa:	42ae fff4      	clrl %fp@(-12)
    b7ae:	200e           	movel %fp,%d0
    b7b0:	0680 ffff fee0 	addil #-288,%d0
    b7b6:	2040           	moveal %d0,%a0
    b7b8:	20bc 5465 7874 	movel #1415936116,%a0@
    b7be:	5880           	addql #4,%d0
    b7c0:	2040           	moveal %d0,%a0
    b7c2:	20bc 2d53 7472 	movel #760444018,%a0@
    b7c8:	5880           	addql #4,%d0
    b7ca:	2040           	moveal %d0,%a0
    b7cc:	20bc 696e 6700 	movel #1768843008,%a0@
    b7d2:	5880           	addql #4,%d0
    b7d4:	4879 0000 0000 	pea 0x0
    b7da:	4eb9 0000 0000 	jsr 0x0
    b7e0:	588f           	addql #4,%sp
    b7e2:	4879 0000 0000 	pea 0x0
    b7e8:	4eb9 0000 0000 	jsr 0x0
    b7ee:	588f           	addql #4,%sp
    b7f0:	42ae fffc      	clrl %fp@(-4)
    b7f4:	606c           	bras 0xb862
    b7f6:	4eb9 0000 0000 	jsr 0x0
    b7fc:	2200           	movel %d0,%d1
    b7fe:	2401           	movel %d1,%d2
    b800:	4c3c 2c00 51eb 	mulsl #1374389535,%d0,%d2
    b806:	851f 
    b808:	ea80           	asrl #5,%d0
    b80a:	2401           	movel %d1,%d2
    b80c:	d482           	addl %d2,%d2
    b80e:	9582           	subxl %d2,%d2
    b810:	2042           	moveal %d2,%a0
    b812:	2400           	movel %d0,%d2
    b814:	9488           	subl %a0,%d2
    b816:	2d42 fff0      	movel %d2,%fp@(-16)
    b81a:	202e fff0      	movel %fp@(-16),%d0
    b81e:	e588           	lsll #2,%d0
    b820:	2400           	movel %d0,%d2
    b822:	e58a           	lsll #2,%d2
    b824:	2042           	moveal %d2,%a0
    b826:	d088           	addl %a0,%d0
    b828:	2400           	movel %d0,%d2
    b82a:	e58a           	lsll #2,%d2
    b82c:	2042           	moveal %d2,%a0
    b82e:	d088           	addl %a0,%d0
    b830:	2401           	movel %d1,%d2
    b832:	9480           	subl %d0,%d2
    b834:	2d42 fff0      	movel %d2,%fp@(-16)
    b838:	200e           	movel %fp,%d0
    b83a:	0680 ffff fee0 	addil #-288,%d0
    b840:	2f00           	movel %d0,%sp@-
    b842:	2f2e fff0      	movel %fp@(-16),%sp@-
    b846:	2f2e fff0      	movel %fp@(-16),%sp@-
    b84a:	2f2e fff0      	movel %fp@(-16),%sp@-
    b84e:	4879 0000 0000 	pea 0x0
    b854:	4eb9 0000 0000 	jsr 0x0
    b85a:	4fef 0014      	lea %sp@(20),%sp
    b85e:	52ae fffc      	addql #1,%fp@(-4)
    b862:	700e           	moveq #14,%d0
    b864:	b0ae fffc      	cmpl %fp@(-4),%d0
    b868:	6c8c           	bges 0xb7f6
    b86a:	4879 0000 0000 	pea 0x0
    b870:	4eb9 0000 0000 	jsr 0x0
    b876:	588f           	addql #4,%sp
    b878:	203c 0000 0000 	movel #0,%d0
    b87e:	2040           	moveal %d0,%a0
    b880:	2010           	movel %a0@,%d0
    b882:	2f00           	movel %d0,%sp@-
    b884:	4eb9 0000 0000 	jsr 0x0
    b88a:	588f           	addql #4,%sp
    b88c:	4879 0000 0000 	pea 0x0
    b892:	4eb9 0000 0000 	jsr 0x0
    b898:	588f           	addql #4,%sp
    b89a:	4878 0061      	pea 0x61
    b89e:	2f2e fff4      	movel %fp@(-12),%sp@-
    b8a2:	2f2e fff8      	movel %fp@(-8),%sp@-
    b8a6:	4879 0000 0000 	pea 0x0
    b8ac:	4eb9 0000 0000 	jsr 0x0
    b8b2:	4fef 0010      	lea %sp@(16),%sp
    b8b6:	4878 0002      	pea 0x2
    b8ba:	4878 00ff      	pea 0xff
    b8be:	4879 0000 0000 	pea 0x0
    b8c4:	4eb9 0000 0000 	jsr 0x0
    b8ca:	4fef 000c      	lea %sp@(12),%sp
    b8ce:	4878 fffd      	pea 0xfffffffd
    b8d2:	4878 fffd      	pea 0xfffffffd
    b8d6:	4878 fffd      	pea 0xfffffffd
    b8da:	4879 0000 0000 	pea 0x0
    b8e0:	4eb9 0000 0000 	jsr 0x0
    b8e6:	4fef 0010      	lea %sp@(16),%sp
    b8ea:	4879 0000 0000 	pea 0x0
    b8f0:	42a7           	clrl %sp@-
    b8f2:	4879 0000 0000 	pea 0x0
    b8f8:	4eb9 0000 0000 	jsr 0x0
    b8fe:	4fef 000c      	lea %sp@(12),%sp
    b902:	4879 0000 0000 	pea 0x0
    b908:	4879 0000 0000 	pea 0x0
    b90e:	4879 0000 0000 	pea 0x0
    b914:	200e           	movel %fp,%d0
    b916:	0680 ffff feec 	addil #-276,%d0
    b91c:	2f00           	movel %d0,%sp@-
    b91e:	4eb9 0000 0000 	jsr 0x0
    b924:	4fef 0010      	lea %sp@(16),%sp
    b928:	2d40 ffec      	movel %d0,%fp@(-20)
    b92c:	200e           	movel %fp,%d0
    b92e:	0680 ffff feec 	addil #-276,%d0
    b934:	2f00           	movel %d0,%sp@-
    b936:	2f2e ffec      	movel %fp@(-20),%sp@-
    b93a:	4879 0000 0000 	pea 0x0
    b940:	4eb9 0000 0000 	jsr 0x0
    b946:	4fef 000c      	lea %sp@(12),%sp
    b94a:	4878 0003      	pea 0x3
    b94e:	4878 0003      	pea 0x3
    b952:	4878 0003      	pea 0x3
    b956:	4879 0000 0000 	pea 0x0
    b95c:	4eb9 0000 0000 	jsr 0x0
    b962:	4fef 0010      	lea %sp@(16),%sp
    b966:	42ae ffec      	clrl %fp@(-20)
    b96a:	222e ffec      	movel %fp@(-20),%d1
    b96e:	200e           	movel %fp,%d0
    b970:	0680 ffff feec 	addil #-276,%d0
    b976:	d081           	addl %d1,%d0
    b978:	4878 fffd      	pea 0xfffffffd
    b97c:	4879 0000 0000 	pea 0x0
    b982:	2f00           	movel %d0,%sp@-
    b984:	4eb9 0000 0000 	jsr 0x0
    b98a:	4fef 000c      	lea %sp@(12),%sp
    b98e:	d1ae ffec      	addl %d0,%fp@(-20)
    b992:	222e ffec      	movel %fp@(-20),%d1
    b996:	200e           	movel %fp,%d0
    b998:	0680 ffff feec 	addil #-276,%d0
    b99e:	d081           	addl %d1,%d0
    b9a0:	4878 fffd      	pea 0xfffffffd
    b9a4:	4879 0000 0000 	pea 0x0
    b9aa:	2f00           	movel %d0,%sp@-
    b9ac:	4eb9 0000 0000 	jsr 0x0
    b9b2:	4fef 000c      	lea %sp@(12),%sp
    b9b6:	d1ae ffec      	addl %d0,%fp@(-20)
    b9ba:	222e ffec      	movel %fp@(-20),%d1
    b9be:	200e           	movel %fp,%d0
    b9c0:	0680 ffff feec 	addil #-276,%d0
    b9c6:	d081           	addl %d1,%d0
    b9c8:	4878 fffd      	pea 0xfffffffd
    b9cc:	4879 0000 0000 	pea 0x0
    b9d2:	2f00           	movel %d0,%sp@-
    b9d4:	4eb9 0000 0000 	jsr 0x0
    b9da:	4fef 000c      	lea %sp@(12),%sp
    b9de:	d1ae ffec      	addl %d0,%fp@(-20)
    b9e2:	200e           	movel %fp,%d0
    b9e4:	0680 ffff feec 	addil #-276,%d0
    b9ea:	2f00           	movel %d0,%sp@-
    b9ec:	2f2e ffec      	movel %fp@(-20),%sp@-
    b9f0:	4879 0000 0000 	pea 0x0
    b9f6:	4eb9 0000 0000 	jsr 0x0
    b9fc:	4fef 000c      	lea %sp@(12),%sp
    ba00:	42a7           	clrl %sp@-
    ba02:	2f3c 4008 0000 	movel #1074266112,%sp@-
    ba08:	4878 0003      	pea 0x3
    ba0c:	42a7           	clrl %sp@-
    ba0e:	2f3c c008 0000 	movel #-1073217536,%sp@-
    ba14:	42a7           	clrl %sp@-
    ba16:	2f3c 4008 0000 	movel #1074266112,%sp@-
    ba1c:	4878 fffd      	pea 0xfffffffd
    ba20:	4878 0003      	pea 0x3
    ba24:	4879 0000 0000 	pea 0x0
    ba2a:	4eb9 0000 0000 	jsr 0x0
    ba30:	4fef 0028      	lea %sp@(40),%sp
    ba34:	2f3c 47ae 147b 	movel #1202590843,%sp@-
    ba3a:	2f3c 400a 7ae1 	movel #1074428641,%sp@-
    ba40:	4879 0000 0000 	pea 0x0
    ba46:	4eb9 0000 0000 	jsr 0x0
    ba4c:	4fef 000c      	lea %sp@(12),%sp
    ba50:	2f3c 0000 b38f 	movel #45967,%sp@-
    ba56:	4878 0017      	pea 0x17
    ba5a:	4878 0005      	pea 0x5
    ba5e:	4878 000f      	pea 0xf
    ba62:	4879 0000 0000 	pea 0x0
    ba68:	4eb9 0000 0000 	jsr 0x0
    ba6e:	4fef 0014      	lea %sp@(20),%sp
    ba72:	4878 0064      	pea 0x64
    ba76:	4878 0063      	pea 0x63
    ba7a:	4878 0062      	pea 0x62
    ba7e:	4878 0061      	pea 0x61
    ba82:	4879 0000 0000 	pea 0x0
    ba88:	4eb9 0000 0000 	jsr 0x0
    ba8e:	4fef 0014      	lea %sp@(20),%sp
    ba92:	2f3c 020c 49ba 	movel #34359738,%sp@-
    ba98:	2f3c c011 872b 	movel #-1072593109,%sp@-
    ba9e:	2f3c d70a 3d71 	movel #-687194767,%sp@-
    baa4:	2f3c 402b 70a3 	movel #1076588707,%sp@-
    baaa:	2f3c c8b4 3958 	movel #-927712936,%sp@-
    bab0:	2f3c 4008 be76 	movel #1074314870,%sp@-
    bab6:	2f3c 9999 999a 	movel #-1717986918,%sp@-
    babc:	2f3c bff1 9999 	movel #-1074685543,%sp@-
    bac2:	2f3c 9999 999a 	movel #-1717986918,%sp@-
    bac8:	2f3c 4003 9999 	movel #1073977753,%sp@-
    bace:	2f3c d70a 3d71 	movel #-687194767,%sp@-
    bad4:	2f3c 400f 70a3 	movel #1074753699,%sp@-
    bada:	2f3c 9999 999a 	movel #-1717986918,%sp@-
    bae0:	2f3c 400b 9999 	movel #1074502041,%sp@-
    bae6:	4879 0000 0000 	pea 0x0
    baec:	4eb9 0000 0000 	jsr 0x0
    baf2:	4fef 003c      	lea %sp@(60),%sp
    baf6:	2f3c f01b 866e 	movel #-266631570,%sp@-
    bafc:	2f3c 4009 21f9 	movel #1074340345,%sp@-
    bb02:	2f3c f01b 866e 	movel #-266631570,%sp@-
    bb08:	2f3c 4009 21f9 	movel #1074340345,%sp@-
    bb0e:	2f3c f01b 866e 	movel #-266631570,%sp@-
    bb14:	2f3c 4009 21f9 	movel #1074340345,%sp@-
    bb1a:	2f3c f01b 866e 	movel #-266631570,%sp@-
    bb20:	2f3c 4009 21f9 	movel #1074340345,%sp@-
    bb26:	2f3c f01b 866e 	movel #-266631570,%sp@-
    bb2c:	2f3c 4009 21f9 	movel #1074340345,%sp@-
    bb32:	2f3c f01b 866e 	movel #-266631570,%sp@-
    bb38:	2f3c 4009 21f9 	movel #1074340345,%sp@-
    bb3e:	4879 0000 0000 	pea 0x0
    bb44:	4eb9 0000 0000 	jsr 0x0
    bb4a:	4fef 0034      	lea %sp@(52),%sp
    bb4e:	2f3c 020c 49ba 	movel #34359738,%sp@-
    bb54:	2f3c c011 872b 	movel #-1072593109,%sp@-
    bb5a:	2f3c b645 a1cb 	movel #-1236950581,%sp@-
    bb60:	2f3c 400f fdf3 	movel #1074789875,%sp@-
    bb66:	2f3c a786 c227 	movel #-1484340697,%sp@-
    bb6c:	2f3c 4008 ca57 	movel #1074317911,%sp@-
    bb72:	2f3c 7ae1 47ae 	movel #2061584302,%sp@-
    bb78:	2f3c 400f ae14 	movel #1074769428,%sp@-
    bb7e:	2f3c d70a 3d71 	movel #-687194767,%sp@-
    bb84:	2f3c 400f 70a3 	movel #1074753699,%sp@-
    bb8a:	4879 0000 0000 	pea 0x0
    bb90:	4eb9 0000 0000 	jsr 0x0
    bb96:	4fef 002c      	lea %sp@(44),%sp
    bb9a:	4879 0000 0000 	pea 0x0
    bba0:	4eb9 0000 0000 	jsr 0x0
    bba6:	588f           	addql #4,%sp
    bba8:	242e fedc      	movel %fp@(-292),%d2
    bbac:	4e5e           	unlk %fp
    bbae:	4e75           	rts
    bbb0:	4e56 ff34      	linkw %fp,#-204
    bbb4:	200e           	movel %fp,%d0
    bbb6:	0680 ffff ff34 	addil #-204,%d0
    bbbc:	2f00           	movel %d0,%sp@-
    bbbe:	7098           	moveq #-104,%d0
    bbc0:	d08e           	addl %fp,%d0
    bbc2:	2f00           	movel %d0,%sp@-
    bbc4:	4879 0000 0000 	pea 0x0
    bbca:	4eb9 0000 0000 	jsr 0x0
    bbd0:	4fef 000c      	lea %sp@(12),%sp
    bbd4:	4879 0000 0000 	pea 0x0
    bbda:	4eb9 0000 0000 	jsr 0x0
    bbe0:	588f           	addql #4,%sp
    bbe2:	203c 0000 0000 	movel #0,%d0
    bbe8:	2040           	moveal %d0,%a0
    bbea:	2010           	movel %a0@,%d0
    bbec:	2f00           	movel %d0,%sp@-
    bbee:	4eb9 0000 0000 	jsr 0x0
    bbf4:	588f           	addql #4,%sp
    bbf6:	4879 0000 0000 	pea 0x0
    bbfc:	4eb9 0000 0000 	jsr 0x0
    bc02:	588f           	addql #4,%sp
    bc04:	4878 0032      	pea 0x32
    bc08:	4878 0055      	pea 0x55
    bc0c:	7098           	moveq #-104,%d0
    bc0e:	d08e           	addl %fp,%d0
    bc10:	2f00           	movel %d0,%sp@-
    bc12:	4eb9 0000 0000 	jsr 0x0
    bc18:	4fef 000c      	lea %sp@(12),%sp
    bc1c:	7098           	moveq #-104,%d0
    bc1e:	d08e           	addl %fp,%d0
    bc20:	7232           	moveq #50,%d1
    bc22:	d081           	addl %d1,%d0
    bc24:	4878 0032      	pea 0x32
    bc28:	4878 00aa      	pea 0xaa
    bc2c:	2f00           	movel %d0,%sp@-
    bc2e:	4eb9 0000 0000 	jsr 0x0
    bc34:	4fef 000c      	lea %sp@(12),%sp
    bc38:	4878 0064      	pea 0x64
    bc3c:	42a7           	clrl %sp@-
    bc3e:	200e           	movel %fp,%d0
    bc40:	0680 ffff ff34 	addil #-204,%d0
    bc46:	2f00           	movel %d0,%sp@-
    bc48:	4eb9 0000 0000 	jsr 0x0
    bc4e:	4fef 000c      	lea %sp@(12),%sp
    bc52:	4878 0064      	pea 0x64
    bc56:	7098           	moveq #-104,%d0
    bc58:	d08e           	addl %fp,%d0
    bc5a:	2f00           	movel %d0,%sp@-
    bc5c:	200e           	movel %fp,%d0
    bc5e:	0680 ffff ff34 	addil #-204,%d0
    bc64:	2f00           	movel %d0,%sp@-
    bc66:	4eb9 0000 0000 	jsr 0x0
    bc6c:	4fef 000c      	lea %sp@(12),%sp
    bc70:	42ae fffc      	clrl %fp@(-4)
    bc74:	6068           	bras 0xbcde
    bc76:	200e           	movel %fp,%d0
    bc78:	0680 ffff ff34 	addil #-204,%d0
    bc7e:	d0ae fffc      	addl %fp@(-4),%d0
    bc82:	2040           	moveal %d0,%a0
    bc84:	1010           	moveb %a0@,%d0
    bc86:	0c00 0055      	cmpib #85,%d0
    bc8a:	674e           	beqs 0xbcda
    bc8c:	200e           	movel %fp,%d0
    bc8e:	0680 ffff ff34 	addil #-204,%d0
    bc94:	d0ae fffc      	addl %fp@(-4),%d0
    bc98:	2040           	moveal %d0,%a0
    bc9a:	1010           	moveb %a0@,%d0
    bc9c:	4281           	clrl %d1
    bc9e:	1200           	moveb %d0,%d1
    bca0:	206e fffc      	moveal %fp@(-4),%a0
    bca4:	200e           	movel %fp,%d0
    bca6:	0680 ffff ff34 	addil #-204,%d0
    bcac:	d088           	addl %a0,%d0
    bcae:	2f01           	movel %d1,%sp@-
    bcb0:	2f00           	movel %d0,%sp@-
    bcb2:	2f2e fffc      	movel %fp@(-4),%sp@-
    bcb6:	4879 0000 0000 	pea 0x0
    bcbc:	4eb9 0000 0000 	jsr 0x0
    bcc2:	4fef 0010      	lea %sp@(16),%sp
    bcc6:	203c 0000 0000 	movel #0,%d0
    bccc:	2040           	moveal %d0,%a0
    bcce:	2010           	movel %a0@,%d0
    bcd0:	2f00           	movel %d0,%sp@-
    bcd2:	4eb9 0000 0000 	jsr 0x0
    bcd8:	588f           	addql #4,%sp
    bcda:	52ae fffc      	addql #1,%fp@(-4)
    bcde:	7031           	moveq #49,%d0
    bce0:	b0ae fffc      	cmpl %fp@(-4),%d0
    bce4:	6c90           	bges 0xbc76
    bce6:	7232           	moveq #50,%d1
    bce8:	2d41 fffc      	movel %d1,%fp@(-4)
    bcec:	6068           	bras 0xbd56
    bcee:	200e           	movel %fp,%d0
    bcf0:	0680 ffff ff34 	addil #-204,%d0
    bcf6:	d0ae fffc      	addl %fp@(-4),%d0
    bcfa:	2040           	moveal %d0,%a0
    bcfc:	1010           	moveb %a0@,%d0
    bcfe:	0c00 ffaa      	cmpib #-86,%d0
    bd02:	674e           	beqs 0xbd52
    bd04:	200e           	movel %fp,%d0
    bd06:	0680 ffff ff34 	addil #-204,%d0
    bd0c:	d0ae fffc      	addl %fp@(-4),%d0
    bd10:	2040           	moveal %d0,%a0
    bd12:	1010           	moveb %a0@,%d0
    bd14:	4281           	clrl %d1
    bd16:	1200           	moveb %d0,%d1
    bd18:	206e fffc      	moveal %fp@(-4),%a0
    bd1c:	200e           	movel %fp,%d0
    bd1e:	0680 ffff ff34 	addil #-204,%d0
    bd24:	d088           	addl %a0,%d0
    bd26:	2f01           	movel %d1,%sp@-
    bd28:	2f00           	movel %d0,%sp@-
    bd2a:	2f2e fffc      	movel %fp@(-4),%sp@-
    bd2e:	4879 0000 0000 	pea 0x0
    bd34:	4eb9 0000 0000 	jsr 0x0
    bd3a:	4fef 0010      	lea %sp@(16),%sp
    bd3e:	203c 0000 0000 	movel #0,%d0
    bd44:	2040           	moveal %d0,%a0
    bd46:	2010           	movel %a0@,%d0
    bd48:	2f00           	movel %d0,%sp@-
    bd4a:	4eb9 0000 0000 	jsr 0x0
    bd50:	588f           	addql #4,%sp
    bd52:	52ae fffc      	addql #1,%fp@(-4)
    bd56:	7063           	moveq #99,%d0
    bd58:	b0ae fffc      	cmpl %fp@(-4),%d0
    bd5c:	6c90           	bges 0xbcee
    bd5e:	4879 0000 0000 	pea 0x0
    bd64:	4eb9 0000 0000 	jsr 0x0
    bd6a:	588f           	addql #4,%sp
    bd6c:	203c 0000 0000 	movel #0,%d0
    bd72:	2040           	moveal %d0,%a0
    bd74:	2010           	movel %a0@,%d0
    bd76:	2f00           	movel %d0,%sp@-
    bd78:	4eb9 0000 0000 	jsr 0x0
    bd7e:	588f           	addql #4,%sp
    bd80:	4879 0000 0000 	pea 0x0
    bd86:	4eb9 0000 0000 	jsr 0x0
    bd8c:	588f           	addql #4,%sp
    bd8e:	4878 0032      	pea 0x32
    bd92:	4878 0055      	pea 0x55
    bd96:	7098           	moveq #-104,%d0
    bd98:	d08e           	addl %fp,%d0
    bd9a:	2f00           	movel %d0,%sp@-
    bd9c:	4eb9 0000 0000 	jsr 0x0
    bda2:	4fef 000c      	lea %sp@(12),%sp
    bda6:	7098           	moveq #-104,%d0
    bda8:	d08e           	addl %fp,%d0
    bdaa:	7232           	moveq #50,%d1
    bdac:	d081           	addl %d1,%d0
    bdae:	4878 0032      	pea 0x32
    bdb2:	4878 00aa      	pea 0xaa
    bdb6:	2f00           	movel %d0,%sp@-
    bdb8:	4eb9 0000 0000 	jsr 0x0
    bdbe:	4fef 000c      	lea %sp@(12),%sp
    bdc2:	4878 0064      	pea 0x64
    bdc6:	42a7           	clrl %sp@-
    bdc8:	200e           	movel %fp,%d0
    bdca:	0680 ffff ff34 	addil #-204,%d0
    bdd0:	2f00           	movel %d0,%sp@-
    bdd2:	4eb9 0000 0000 	jsr 0x0
    bdd8:	4fef 000c      	lea %sp@(12),%sp
    bddc:	4878 0064      	pea 0x64
    bde0:	7098           	moveq #-104,%d0
    bde2:	d08e           	addl %fp,%d0
    bde4:	2f00           	movel %d0,%sp@-
    bde6:	200e           	movel %fp,%d0
    bde8:	0680 ffff ff34 	addil #-204,%d0
    bdee:	2f00           	movel %d0,%sp@-
    bdf0:	4eb9 0000 0000 	jsr 0x0
    bdf6:	4fef 000c      	lea %sp@(12),%sp
    bdfa:	42ae fffc      	clrl %fp@(-4)
    bdfe:	6068           	bras 0xbe68
    be00:	200e           	movel %fp,%d0
    be02:	0680 ffff ff34 	addil #-204,%d0
    be08:	d0ae fffc      	addl %fp@(-4),%d0
    be0c:	2040           	moveal %d0,%a0
    be0e:	1010           	moveb %a0@,%d0
    be10:	0c00 0055      	cmpib #85,%d0
    be14:	674e           	beqs 0xbe64
    be16:	200e           	movel %fp,%d0
    be18:	0680 ffff ff34 	addil #-204,%d0
    be1e:	d0ae fffc      	addl %fp@(-4),%d0
    be22:	2040           	moveal %d0,%a0
    be24:	1010           	moveb %a0@,%d0
    be26:	4281           	clrl %d1
    be28:	1200           	moveb %d0,%d1
    be2a:	206e fffc      	moveal %fp@(-4),%a0
    be2e:	200e           	movel %fp,%d0
    be30:	0680 ffff ff34 	addil #-204,%d0
    be36:	d088           	addl %a0,%d0
    be38:	2f01           	movel %d1,%sp@-
    be3a:	2f00           	movel %d0,%sp@-
    be3c:	2f2e fffc      	movel %fp@(-4),%sp@-
    be40:	4879 0000 0000 	pea 0x0
    be46:	4eb9 0000 0000 	jsr 0x0
    be4c:	4fef 0010      	lea %sp@(16),%sp
    be50:	203c 0000 0000 	movel #0,%d0
    be56:	2040           	moveal %d0,%a0
    be58:	2010           	movel %a0@,%d0
    be5a:	2f00           	movel %d0,%sp@-
    be5c:	4eb9 0000 0000 	jsr 0x0
    be62:	588f           	addql #4,%sp
    be64:	52ae fffc      	addql #1,%fp@(-4)
    be68:	7031           	moveq #49,%d0
    be6a:	b0ae fffc      	cmpl %fp@(-4),%d0
    be6e:	6c90           	bges 0xbe00
    be70:	7232           	moveq #50,%d1
    be72:	2d41 fffc      	movel %d1,%fp@(-4)
    be76:	6068           	bras 0xbee0
    be78:	200e           	movel %fp,%d0
    be7a:	0680 ffff ff34 	addil #-204,%d0
    be80:	d0ae fffc      	addl %fp@(-4),%d0
    be84:	2040           	moveal %d0,%a0
    be86:	1010           	moveb %a0@,%d0
    be88:	0c00 ffaa      	cmpib #-86,%d0
    be8c:	674e           	beqs 0xbedc
    be8e:	200e           	movel %fp,%d0
    be90:	0680 ffff ff34 	addil #-204,%d0
    be96:	d0ae fffc      	addl %fp@(-4),%d0
    be9a:	2040           	moveal %d0,%a0
    be9c:	1010           	moveb %a0@,%d0
    be9e:	4281           	clrl %d1
    bea0:	1200           	moveb %d0,%d1
    bea2:	206e fffc      	moveal %fp@(-4),%a0
    bea6:	200e           	movel %fp,%d0
    bea8:	0680 ffff ff34 	addil #-204,%d0
    beae:	d088           	addl %a0,%d0
    beb0:	2f01           	movel %d1,%sp@-
    beb2:	2f00           	movel %d0,%sp@-
    beb4:	2f2e fffc      	movel %fp@(-4),%sp@-
    beb8:	4879 0000 0000 	pea 0x0
    bebe:	4eb9 0000 0000 	jsr 0x0
    bec4:	4fef 0010      	lea %sp@(16),%sp
    bec8:	203c 0000 0000 	movel #0,%d0
    bece:	2040           	moveal %d0,%a0
    bed0:	2010           	movel %a0@,%d0
    bed2:	2f00           	movel %d0,%sp@-
    bed4:	4eb9 0000 0000 	jsr 0x0
    beda:	588f           	addql #4,%sp
    bedc:	52ae fffc      	addql #1,%fp@(-4)
    bee0:	7063           	moveq #99,%d0
    bee2:	b0ae fffc      	cmpl %fp@(-4),%d0
    bee6:	6c90           	bges 0xbe78
    bee8:	4e5e           	unlk %fp
    beea:	4e75           	rts
    beec:	4e56 fe70      	linkw %fp,#-400
    bef0:	4879 0000 0000 	pea 0x0
    bef6:	4eb9 0000 0000 	jsr 0x0
    befc:	588f           	addql #4,%sp
    befe:	203c 0000 0000 	movel #0,%d0
    bf04:	2040           	moveal %d0,%a0
    bf06:	2010           	movel %a0@,%d0
    bf08:	2f00           	movel %d0,%sp@-
    bf0a:	4eb9 0000 0000 	jsr 0x0
    bf10:	588f           	addql #4,%sp
    bf12:	4879 0000 0000 	pea 0x0
    bf18:	4eb9 0000 0000 	jsr 0x0
    bf1e:	588f           	addql #4,%sp
    bf20:	4878 2710      	pea 0x2710
    bf24:	4eb9 0000 0000 	jsr 0x0
    bf2a:	588f           	addql #4,%sp
    bf2c:	2008           	movel %a0,%d0
    bf2e:	2d40 fe70      	movel %d0,%fp@(-400)
    bf32:	4878 01f4      	pea 0x1f4
    bf36:	4eb9 0000 0000 	jsr 0x0
    bf3c:	588f           	addql #4,%sp
    bf3e:	2008           	movel %a0,%d0
    bf40:	2d40 fe74      	movel %d0,%fp@(-396)
    bf44:	2f3c 0003 0d40 	movel #200000,%sp@-
    bf4a:	4eb9 0000 0000 	jsr 0x0
    bf50:	588f           	addql #4,%sp
    bf52:	2008           	movel %a0,%d0
    bf54:	2d40 fe78      	movel %d0,%fp@(-392)
    bf58:	4878 000a      	pea 0xa
    bf5c:	4eb9 0000 0000 	jsr 0x0
    bf62:	588f           	addql #4,%sp
    bf64:	2008           	movel %a0,%d0
    bf66:	2d40 fe7c      	movel %d0,%fp@(-388)
    bf6a:	4878 0064      	pea 0x64
    bf6e:	4eb9 0000 0000 	jsr 0x0
    bf74:	588f           	addql #4,%sp
    bf76:	2008           	movel %a0,%d0
    bf78:	2d40 fe80      	movel %d0,%fp@(-384)
    bf7c:	2f3c 0007 a120 	movel #500000,%sp@-
    bf82:	4eb9 0000 0000 	jsr 0x0
    bf88:	588f           	addql #4,%sp
    bf8a:	2008           	movel %a0,%d0
    bf8c:	2d40 fe84      	movel %d0,%fp@(-380)
    bf90:	4eb9 0000 0000 	jsr 0x0
    bf96:	203c 0000 0000 	movel #0,%d0
    bf9c:	2040           	moveal %d0,%a0
    bf9e:	2010           	movel %a0@,%d0
    bfa0:	2f00           	movel %d0,%sp@-
    bfa2:	4eb9 0000 0000 	jsr 0x0
    bfa8:	588f           	addql #4,%sp
    bfaa:	202e fe74      	movel %fp@(-396),%d0
    bfae:	2f00           	movel %d0,%sp@-
    bfb0:	4eb9 0000 0000 	jsr 0x0
    bfb6:	588f           	addql #4,%sp
    bfb8:	202e fe7c      	movel %fp@(-388),%d0
    bfbc:	2f00           	movel %d0,%sp@-
    bfbe:	4eb9 0000 0000 	jsr 0x0
    bfc4:	588f           	addql #4,%sp
    bfc6:	202e fe80      	movel %fp@(-384),%d0
    bfca:	2f00           	movel %d0,%sp@-
    bfcc:	4eb9 0000 0000 	jsr 0x0
    bfd2:	588f           	addql #4,%sp
    bfd4:	4eb9 0000 0000 	jsr 0x0
    bfda:	203c 0000 0000 	movel #0,%d0
    bfe0:	2040           	moveal %d0,%a0
    bfe2:	2010           	movel %a0@,%d0
    bfe4:	2f00           	movel %d0,%sp@-
    bfe6:	4eb9 0000 0000 	jsr 0x0
    bfec:	588f           	addql #4,%sp
    bfee:	4878 01c2      	pea 0x1c2
    bff2:	4eb9 0000 0000 	jsr 0x0
    bff8:	588f           	addql #4,%sp
    bffa:	2008           	movel %a0,%d0
    bffc:	2d40 fe74      	movel %d0,%fp@(-396)
    c000:	4eb9 0000 0000 	jsr 0x0
    c006:	203c 0000 0000 	movel #0,%d0
    c00c:	2040           	moveal %d0,%a0
    c00e:	2010           	movel %a0@,%d0
    c010:	2f00           	movel %d0,%sp@-
    c012:	4eb9 0000 0000 	jsr 0x0
    c018:	588f           	addql #4,%sp
    c01a:	4878 0069      	pea 0x69
    c01e:	4eb9 0000 0000 	jsr 0x0
    c024:	588f           	addql #4,%sp
    c026:	2008           	movel %a0,%d0
    c028:	2d40 fe7c      	movel %d0,%fp@(-388)
    c02c:	4eb9 0000 0000 	jsr 0x0
    c032:	203c 0000 0000 	movel #0,%d0
    c038:	2040           	moveal %d0,%a0
    c03a:	2010           	movel %a0@,%d0
    c03c:	2f00           	movel %d0,%sp@-
    c03e:	4eb9 0000 0000 	jsr 0x0
    c044:	588f           	addql #4,%sp
    c046:	202e fe78      	movel %fp@(-392),%d0
    c04a:	2f00           	movel %d0,%sp@-
    c04c:	4eb9 0000 0000 	jsr 0x0
    c052:	588f           	addql #4,%sp
    c054:	4eb9 0000 0000 	jsr 0x0
    c05a:	203c 0000 0000 	movel #0,%d0
    c060:	2040           	moveal %d0,%a0
    c062:	2010           	movel %a0@,%d0
    c064:	2f00           	movel %d0,%sp@-
    c066:	4eb9 0000 0000 	jsr 0x0
    c06c:	588f           	addql #4,%sp
    c06e:	2f3c 0003 0d4a 	movel #200010,%sp@-
    c074:	4eb9 0000 0000 	jsr 0x0
    c07a:	588f           	addql #4,%sp
    c07c:	2008           	movel %a0,%d0
    c07e:	2d40 fe78      	movel %d0,%fp@(-392)
    c082:	4eb9 0000 0000 	jsr 0x0
    c088:	203c 0000 0000 	movel #0,%d0
    c08e:	2040           	moveal %d0,%a0
    c090:	2010           	movel %a0@,%d0
    c092:	2f00           	movel %d0,%sp@-
    c094:	4eb9 0000 0000 	jsr 0x0
    c09a:	588f           	addql #4,%sp
    c09c:	2f3c 0003 0d4a 	movel #200010,%sp@-
    c0a2:	4eb9 0000 0000 	jsr 0x0
    c0a8:	588f           	addql #4,%sp
    c0aa:	2008           	movel %a0,%d0
    c0ac:	2d40 fe80      	movel %d0,%fp@(-384)
    c0b0:	4eb9 0000 0000 	jsr 0x0
    c0b6:	203c 0000 0000 	movel #0,%d0
    c0bc:	2040           	moveal %d0,%a0
    c0be:	2010           	movel %a0@,%d0
    c0c0:	2f00           	movel %d0,%sp@-
    c0c2:	4eb9 0000 0000 	jsr 0x0
    c0c8:	588f           	addql #4,%sp
    c0ca:	202e fe70      	movel %fp@(-400),%d0
    c0ce:	2f00           	movel %d0,%sp@-
    c0d0:	4eb9 0000 0000 	jsr 0x0
    c0d6:	588f           	addql #4,%sp
    c0d8:	202e fe74      	movel %fp@(-396),%d0
    c0dc:	2f00           	movel %d0,%sp@-
    c0de:	4eb9 0000 0000 	jsr 0x0
    c0e4:	588f           	addql #4,%sp
    c0e6:	202e fe78      	movel %fp@(-392),%d0
    c0ea:	2f00           	movel %d0,%sp@-
    c0ec:	4eb9 0000 0000 	jsr 0x0
    c0f2:	588f           	addql #4,%sp
    c0f4:	202e fe7c      	movel %fp@(-388),%d0
    c0f8:	2f00           	movel %d0,%sp@-
    c0fa:	4eb9 0000 0000 	jsr 0x0
    c100:	588f           	addql #4,%sp
    c102:	202e fe80      	movel %fp@(-384),%d0
    c106:	2f00           	movel %d0,%sp@-
    c108:	4eb9 0000 0000 	jsr 0x0
    c10e:	588f           	addql #4,%sp
    c110:	202e fe84      	movel %fp@(-380),%d0
    c114:	2f00           	movel %d0,%sp@-
    c116:	4eb9 0000 0000 	jsr 0x0
    c11c:	588f           	addql #4,%sp
    c11e:	4eb9 0000 0000 	jsr 0x0
    c124:	203c 0000 0000 	movel #0,%d0
    c12a:	2040           	moveal %d0,%a0
    c12c:	2010           	movel %a0@,%d0
    c12e:	2f00           	movel %d0,%sp@-
    c130:	4eb9 0000 0000 	jsr 0x0
    c136:	588f           	addql #4,%sp
    c138:	4879 0000 0000 	pea 0x0
    c13e:	4eb9 0000 0000 	jsr 0x0
    c144:	588f           	addql #4,%sp
    c146:	4e5e           	unlk %fp
    c148:	4e75           	rts
    c14a:	4e56 f694      	linkw %fp,#-2412
    c14e:	2f02           	movel %d2,%sp@-
    c150:	4879 0000 0000 	pea 0x0
    c156:	4eb9 0000 0000 	jsr 0x0
    c15c:	588f           	addql #4,%sp
    c15e:	4879 0000 0000 	pea 0x0
    c164:	4eb9 0000 0000 	jsr 0x0
    c16a:	588f           	addql #4,%sp
    c16c:	203c 0000 0000 	movel #0,%d0
    c172:	2040           	moveal %d0,%a0
    c174:	2010           	movel %a0@,%d0
    c176:	2f00           	movel %d0,%sp@-
    c178:	4eb9 0000 0000 	jsr 0x0
    c17e:	588f           	addql #4,%sp
    c180:	4878 012c      	pea 0x12c
    c184:	42a7           	clrl %sp@-
    c186:	200e           	movel %fp,%d0
    c188:	0680 ffff f694 	addil #-2412,%d0
    c18e:	2f00           	movel %d0,%sp@-
    c190:	4eb9 0000 0000 	jsr 0x0
    c196:	4fef 000c      	lea %sp@(12),%sp
    c19a:	2d7c 01c0 0000 	movel #29360128,%fp@(-8)
    c1a0:	fff8 
    c1a2:	2d7c 01c0 ffff 	movel #29425663,%fp@(-12)
    c1a8:	fff4 
    c1aa:	42a7           	clrl %sp@-
    c1ac:	42a7           	clrl %sp@-
    c1ae:	42a7           	clrl %sp@-
    c1b0:	4eb9 0000 0000 	jsr 0x0
    c1b6:	4fef 000c      	lea %sp@(12),%sp
    c1ba:	42ae fffc      	clrl %fp@(-4)
    c1be:	6000 00d8      	braw 0xc298
    c1c2:	700a           	moveq #10,%d0
    c1c4:	d0ae fffc      	addl %fp@(-4),%d0
    c1c8:	2200           	movel %d0,%d1
    c1ca:	d281           	addl %d1,%d1
    c1cc:	2241           	moveal %d1,%a1
    c1ce:	700a           	moveq #10,%d0
    c1d0:	d0ae fffc      	addl %fp@(-4),%d0
    c1d4:	d080           	addl %d0,%d0
    c1d6:	2040           	moveal %d0,%a0
    c1d8:	5288           	addql #1,%a0
    c1da:	202e fffc      	movel %fp@(-4),%d0
    c1de:	5a80           	addql #5,%d0
    c1e0:	2200           	movel %d0,%d1
    c1e2:	d281           	addl %d1,%d1
    c1e4:	202e fffc      	movel %fp@(-4),%d0
    c1e8:	5a80           	addql #5,%d0
    c1ea:	d080           	addl %d0,%d0
    c1ec:	240e           	movel %fp,%d2
    c1ee:	0682 ffff fb44 	addil #-1212,%d2
    c1f4:	2f02           	movel %d2,%sp@-
    c1f6:	2f09           	movel %a1,%sp@-
    c1f8:	2f08           	movel %a0,%sp@-
    c1fa:	2f01           	movel %d1,%sp@-
    c1fc:	2f00           	movel %d0,%sp@-
    c1fe:	4eb9 0000 0000 	jsr 0x0
    c204:	4fef 0014      	lea %sp@(20),%sp
    c208:	700a           	moveq #10,%d0
    c20a:	d0ae fffc      	addl %fp@(-4),%d0
    c20e:	2200           	movel %d0,%d1
    c210:	d281           	addl %d1,%d1
    c212:	2241           	moveal %d1,%a1
    c214:	700a           	moveq #10,%d0
    c216:	d0ae fffc      	addl %fp@(-4),%d0
    c21a:	d080           	addl %d0,%d0
    c21c:	2040           	moveal %d0,%a0
    c21e:	5288           	addql #1,%a0
    c220:	202e fffc      	movel %fp@(-4),%d0
    c224:	5a80           	addql #5,%d0
    c226:	2200           	movel %d0,%d1
    c228:	d281           	addl %d1,%d1
    c22a:	202e fffc      	movel %fp@(-4),%d0
    c22e:	5a80           	addql #5,%d0
    c230:	d080           	addl %d0,%d0
    c232:	4878 2222      	pea 0x2222
    c236:	2f09           	movel %a1,%sp@-
    c238:	2f08           	movel %a0,%sp@-
    c23a:	2f01           	movel %d1,%sp@-
    c23c:	2f00           	movel %d0,%sp@-
    c23e:	4eb9 0000 0000 	jsr 0x0
    c244:	4fef 0014      	lea %sp@(20),%sp
    c248:	4eb9 0000 0000 	jsr 0x0
    c24e:	700a           	moveq #10,%d0
    c250:	d0ae fffc      	addl %fp@(-4),%d0
    c254:	2200           	movel %d0,%d1
    c256:	d281           	addl %d1,%d1
    c258:	2241           	moveal %d1,%a1
    c25a:	700a           	moveq #10,%d0
    c25c:	d0ae fffc      	addl %fp@(-4),%d0
    c260:	d080           	addl %d0,%d0
    c262:	2040           	moveal %d0,%a0
    c264:	5288           	addql #1,%a0
    c266:	202e fffc      	movel %fp@(-4),%d0
    c26a:	5a80           	addql #5,%d0
    c26c:	2200           	movel %d0,%d1
    c26e:	d281           	addl %d1,%d1
    c270:	202e fffc      	movel %fp@(-4),%d0
    c274:	5a80           	addql #5,%d0
    c276:	d080           	addl %d0,%d0
    c278:	240e           	movel %fp,%d2
    c27a:	0682 ffff fb44 	addil #-1212,%d2
    c280:	2f02           	movel %d2,%sp@-
    c282:	2f09           	movel %a1,%sp@-
    c284:	2f08           	movel %a0,%sp@-
    c286:	2f01           	movel %d1,%sp@-
    c288:	2f00           	movel %d0,%sp@-
    c28a:	4eb9 0000 0000 	jsr 0x0
    c290:	4fef 0014      	lea %sp@(20),%sp
    c294:	52ae fffc      	addql #1,%fp@(-4)
    c298:	7063           	moveq #99,%d0
    c29a:	b0ae fffc      	cmpl %fp@(-4),%d0
    c29e:	6400 ff22      	bccw 0xc1c2
    c2a2:	242e f690      	movel %fp@(-2416),%d2
    c2a6:	4e5e           	unlk %fp
    c2a8:	4e75           	rts
    c2aa:	4e71           	nop
    c2ac:	222f 000c      	movel %sp@(12),%d1
    c2b0:	242f 0008      	movel %sp@(8),%d2
    c2b4:	206f 0004      	moveal %sp@(4),%a0
    c2b8:	2008           	movel %a0,%d0
    c2ba:	30c2           	movew %d2,%a0@+
    c2bc:	5541           	subqw #2,%d1
    c2be:	6600 fffa      	bnew 0xc2ba
    c2c2:	2040           	moveal %d0,%a0
    c2c4:	4e75           	rts
    c2c6:	222f 000c      	movel %sp@(12),%d1
    c2ca:	226f 0008      	moveal %sp@(8),%a1
    c2ce:	206f 0004      	moveal %sp@(4),%a0
    c2d2:	2008           	movel %a0,%d0
    c2d4:	30d9           	movew %a1@+,%a0@+
    c2d6:	5541           	subqw #2,%d1
    c2d8:	6600 fffa      	bnew 0xc2d4
    c2dc:	2040           	moveal %d0,%a0
    c2de:	4e75           	rts
    c2e0:	222f 000c      	movel %sp@(12),%d1
    c2e4:	226f 0008      	moveal %sp@(8),%a1
    c2e8:	206f 0004      	moveal %sp@(4),%a0
    c2ec:	2008           	movel %a0,%d0
    c2ee:	b1c9           	cmpal %a1,%a0
    c2f0:	6400 000e      	bccw 0xc300
    c2f4:	30d9           	movew %a1@+,%a0@+
    c2f6:	5541           	subqw #2,%d1
    c2f8:	6600 fffa      	bnew 0xc2f4
    c2fc:	2040           	moveal %d0,%a0
    c2fe:	4e75           	rts
    c300:	d3c1           	addal %d1,%a1
    c302:	d1c1           	addal %d1,%a0
    c304:	3121           	movew %a1@-,%a0@-
    c306:	5541           	subqw #2,%d1
    c308:	6600 fffa      	bnew 0xc304
    c30c:	2040           	moveal %d0,%a0
    c30e:	4e75           	rts
    c310:	222f 000c      	movel %sp@(12),%d1
    c314:	222f 0008      	movel %sp@(8),%d1
    c318:	242f 0004      	movel %sp@(4),%d2
    c31c:	4e75           	rts
    c31e:	222f 0014      	movel %sp@(20),%d1
    c322:	222f 0010      	movel %sp@(16),%d1
    c326:	222f 000c      	movel %sp@(12),%d1
    c32a:	242f 0008      	movel %sp@(8),%d2
    c32e:	206f 0004      	moveal %sp@(4),%a0
    c332:	4e75           	rts
    c334:	222f 0014      	movel %sp@(20),%d1
    c338:	222f 0010      	movel %sp@(16),%d1
    c33c:	222f 000c      	movel %sp@(12),%d1
    c340:	242f 0008      	movel %sp@(8),%d2
    c344:	206f 0004      	moveal %sp@(4),%a0
    c348:	4e75           	rts
    c34a:	0000 2020      	orib #32,%d0
    c34e:	2020           	movel %a0@-,%d0
    c350:	2020           	movel %a0@-,%d0
    c352:	2020           	movel %a0@-,%d0
    c354:	2021           	movel %a1@-,%d0
    c356:	2020           	movel %a0@-,%d0
    c358:	2020           	movel %a0@-,%d0
    c35a:	2020           	movel %a0@-,%d0
    c35c:	2020           	movel %a0@-,%d0
    c35e:	2020           	movel %a0@-,%d0
    c360:	2020           	movel %a0@-,%d0
    c362:	2020           	movel %a0@-,%d0
    c364:	2020           	movel %a0@-,%d0
    c366:	2020           	movel %a0@-,%d0
    c368:	2020           	movel %a0@-,%d0
    c36a:	2020           	movel %a0@-,%d0
    c36c:	8140 4000      	pack %d0,%d0,#16384
    c370:	0000 0040      	orib #64,%d0
    c374:	4040           	negxw %d0
    c376:	0000 4000      	orib #0,%d0
    c37a:	4000           	negxb %d0
    c37c:	1212           	moveb %a2@,%d1
    c37e:	1212           	moveb %a2@,%d1
    c380:	1212           	moveb %a2@,%d1
    c382:	1212           	moveb %a2@,%d1
    c384:	1212           	moveb %a2@,%d1
    c386:	4040           	negxw %d0
    c388:	0000 0040      	orib #64,%d0
    c38c:	0014 1414      	orib #20,%a4@
    c390:	1414           	moveb %a4@,%d2
    c392:	1404           	moveb %d4,%d2
    c394:	0404 0404      	subib #4,%d4
    c398:	0404 0404      	subib #4,%d4
    c39c:	0404 0404      	subib #4,%d4
    c3a0:	0404 0404      	subib #4,%d4
    c3a4:	0404 0440      	subib #64,%d4
    c3a8:	4040           	negxw %d0
    c3aa:	0040 4018      	oriw #16408,%d0
    c3ae:	1818           	moveb %a0@+,%d4
    c3b0:	1818           	moveb %a0@+,%d4
    c3b2:	1808           	.short 0x1808
    c3b4:	0808           	.short 0x0808
    c3b6:	0808           	.short 0x0808
    c3b8:	0808           	.short 0x0808
    c3ba:	0808           	.short 0x0808
    c3bc:	0808           	.short 0x0808
    c3be:	0808           	.short 0x0808
    c3c0:	0808           	.short 0x0808
    c3c2:	0808           	.short 0x0808
    c3c4:	0808           	.short 0x0808
    c3c6:	0840 0040      	bchg #64,%d0
    c3ca:	0020 0000      	orib #0,%a0@-
	...
    c44a:	0000 1f1c      	orib #28,%d0
    c44e:	1f1e           	moveb %fp@+,%sp@-
    c450:	1f1e           	moveb %fp@+,%sp@-
    c452:	1f1f           	moveb %sp@+,%sp@-
    c454:	1e1f           	moveb %sp@+,%d7
    c456:	1e1f           	moveb %sp@+,%d7
	...
    c568:	0000 2043      	orib #67,%d0
    c56c:	7472           	moveq #114,%d2
    c56e:	6c2d           	bges 0xc59d
    c570:	430d           	.short 0x430d
    c572:	0a00 2e00      	eorib #0,%d0
	...
    cb82:	000b           	.short 0x000b
    cb84:	0100           	btst %d0,%d0
    cb86:	0000 0001      	orib #1,%d0
	...
    cb96:	444c           	.short 0x444c
    cb98:	0000 0000      	orib #0,%d0
    cb9c:	0000 000a      	orib #10,%d0
    cba0:	0200 0000      	andib #0,%d0
    cba4:	0001 0000      	orib #0,%d1
	...
    cbb0:	0000 444c      	orib #76,%d0
	...
    ccc0:	5f6c 6c5f      	subqw #7,%a4@(27743)
    ccc4:	7265           	moveq #101,%d1
    ccc6:	6164           	bsrs 0xcd2c
    ccc8:	5f0d           	subqb #7,%a5
    ccca:	0a00 2062      	eorib #98,%d0
    ccce:	7566           	mvsw %fp@-,%d2
    ccd0:	6665           	bnes 0xcd37
    ccd2:	7220           	moveq #32,%d1
    ccd4:	3d20           	movew %a0@-,%fp@-
    ccd6:	3078 0020      	moveaw 0x20,%a0
    ccda:	7369 7a65      	mvsw %a1@(31333),%d1
    ccde:	2020           	movel %a0@-,%d0
    cce0:	203d           	.short 0x203d
    cce2:	2030 7800      	movel %a0@(00000000,%d7:l),%d0
    cce6:	2066           	moveal %fp@-,%a0
    cce8:	6420           	bccs 0xcd0a
    ccea:	2020           	movel %a0@-,%d0
    ccec:	2020           	movel %a0@-,%d0
    ccee:	3d20           	movew %a0@-,%fp@-
    ccf0:	3078 005f      	moveaw 0x5f,%a0
    ccf4:	6c6c           	bges 0xcd62
    ccf6:	5f77 7269      	subqw #7,%sp@(00000069,%d7:w:2)
    ccfa:	7465           	moveq #101,%d2
    ccfc:	5f0d           	subqb #7,%a5
    ccfe:	0a00 0d0a      	eorib #10,%d0
	...
    ce02:	0000 0400      	orib #0,%d0
    ce06:	0f00           	btst %d7,%d0
    ce08:	0000 7f00      	orib #0,%d0
    ce0c:	0000 0000      	orib #0,%d0
    ce10:	1f1c           	moveb %a4@+,%sp@-
    ce12:	1f1e           	moveb %fp@+,%sp@-
    ce14:	1f1e           	moveb %fp@+,%sp@-
    ce16:	1f1f           	moveb %sp@+,%sp@-
    ce18:	1e1f           	moveb %sp@+,%d7
    ce1a:	1e1f           	moveb %sp@+,%d7
	...
    ce24:	7fff           	.short 0x7fff
    ce26:	ffe0           	.short 0xffe0
    ce28:	7fff           	.short 0x7fff
    ce2a:	ffe0           	.short 0xffe0
	...
    ce34:	007e           	.short 0x007e
    ce36:	1100           	moveb %d0,%a0@-
	...
    ce40:	0000 ffff      	orib #-1,%d0
    ce44:	ffff           	.short 0xffff
    ce46:	ffff           	.short 0xffff
    ce48:	ffff           	.short 0xffff
    ce4a:	ffff           	.short 0xffff
	...
    ce54:	ffff           	.short 0xffff
    ce56:	ffff           	.short 0xffff
    ce58:	fffc           	.short 0xfffc
	...
    ce62:	0000 ffff      	orib #-1,%d0
    ce66:	ff00 ffff      	cp1stb %sp,%d0,#8,#511
    ce6a:	ff00 0000      	cp1stb %d0,%d0,#1,#0
    ce6e:	0000 0000      	orib #0,%d0
    ce72:	0000 ffff      	orib #-1,%d0
    ce76:	f800           	.short 0xf800
    ce78:	ffff           	.short 0xffff
    ce7a:	fff0           	.short 0xfff0
	...
    cf1c:	0024 0000      	orib #0,%a4@-
    cf20:	8000           	orb %d0,%d0
	...
    cf2a:	0001 0000      	orib #0,%d1
	...
    cf8e:	0000 2aa8      	orib #-88,%d0
    cf92:	b1d8           	cmpal %a0@+,%a0
    cf94:	8076 3b10      	orw %fp@(00000000,%d3:l:2),%d0
    cf98:	0804 0201      	btst #1,%d4
	...
    d010:	ff00 0000      	cp1stb %d0,%d0,#1,#0
	...
    d020:	65ca           	bcss 0xcfec
    d022:	0031 0000 001d 	orib #0,%a1@(0000001d,%d0:w)
    d028:	8000           	orb %d0,%d0
    d02a:	0014 0000      	orib #0,%a4@
    d02e:	0000 0000      	orib #0,%d0
    d032:	0000 0076      	orib #118,%d0
    d036:	eec0 0000      	bfset %d0,0,0
    d03a:	0000 0000      	orib #0,%d0
    d03e:	0000 ffe0      	orib #-32,%d0
	...
    d062:	0ffc           	.short 0x0ffc
    d064:	0000 00fc      	orib #-4,%d0
    d068:	0000 00f0      	orib #-16,%d0
    d06c:	0000 0000      	orib #0,%d0
    d070:	0040 0000      	oriw #0,%d0
	...
    d128:	7fff           	.short 0x7fff
    d12a:	ffe0           	.short 0xffe0
	...
    d140:	0000 5555      	orib #85,%d0
    d144:	5555           	subqw #2,%a5@
    d146:	5555           	subqw #2,%a5@
    d148:	5555           	subqw #2,%a5@
    d14a:	5555           	subqw #2,%a5@
	...
    d154:	ffff           	.short 0xffff
    d156:	ffff           	.short 0xffff
    d158:	fe00 0000      	cp1nop #1
	...
    d168:	ffff           	.short 0xffff
    d16a:	ff00 0000      	cp1stb %d0,%d0,#1,#0
	...
    d176:	0000 ffff      	orib #-1,%d0
    d17a:	fff0           	.short 0xfff0
	...
    d21c:	ffff           	.short 0xffff
    d21e:	ffff           	.short 0xffff
    d220:	ffff           	.short 0xffff
    d222:	ffff           	.short 0xffff
    d224:	0000 0000      	orib #0,%d0
    d228:	ffff           	.short 0xffff
    d22a:	ffff           	.short 0xffff
    d22c:	0000 0000      	orib #0,%d0
    d230:	ffff           	.short 0xffff
    d232:	ffff           	.short 0xffff
    d234:	ffff           	.short 0xffff
    d236:	ffff           	.short 0xffff
    d238:	ffff           	.short 0xffff
    d23a:	ffff           	.short 0xffff
    d23c:	0000 0000      	orib #0,%d0
    d240:	ffff           	.short 0xffff
    d242:	ffff           	.short 0xffff
    d244:	ffff           	.short 0xffff
    d246:	ffff           	.short 0xffff
    d248:	0000 0000      	orib #0,%d0
    d24c:	ffff           	.short 0xffff
    d24e:	ffff           	.short 0xffff
    d250:	ffff           	.short 0xffff
    d252:	ffff           	.short 0xffff
    d254:	ffff           	.short 0xffff
    d256:	ffff           	.short 0xffff
	...
    d264:	ffff           	.short 0xffff
    d266:	ffff           	.short 0xffff
    d268:	ffff           	.short 0xffff
    d26a:	ffff           	.short 0xffff
	...
    d278:	ffff           	.short 0xffff
    d27a:	ffff           	.short 0xffff
    d27c:	0100           	btst %d0,%d0
	...
    d31e:	0000 0400      	orib #0,%d0
    d322:	0f00           	btst %d7,%d0
    d324:	0000 7f00      	orib #0,%d0
    d328:	0000 0001      	orib #1,%d0
	...
    d43c:	2020           	movel %a0@-,%d0
    d43e:	2020           	movel %a0@-,%d0
    d440:	0028 0029 0030 	orib #41,%a0@(48)
    d446:	7800           	moveq #0,%d4
    d448:	204e           	moveal %fp,%a0
    d44a:	4b43           	.short 0x4b43
    d44c:	2d43 4c49      	movel %d3,%fp@(19529)
    d450:	4220           	clrb %a0@-
    d452:	2843           	moveal %d3,%a4
    d454:	2920           	movel %a0@-,%a4@-
    d456:	3230 3134 2054 	movew %a0@(20546f72)@(00000000,%d3:w),%d1
    d45c:	6f72 
    d45e:	7374 656e 2048 	mvsw %a4@(00002048)@(0000656d),%d1
    d464:	656d 
    d466:	6d65           	blts 0xd4cd
    d468:	636b           	blss 0xd4d5
    d46a:	650d           	bcss 0xd479
    d46c:	0a00 2042      	eorib #66,%d0
    d470:	5353           	subqw #1,%a3@
    d472:	2073 6567 6d65 	moveal %a3@(00006d65)@(6e742069),%a0
    d478:	6e74 2069 
    d47c:	6e69           	bgts 0xd4e7
    d47e:	7461           	moveq #97,%d2
    d480:	696c           	bvss 0xd4ee
    d482:	697a           	bvss 0xd4fe
    d484:	6564           	bcss 0xd4ea
    d486:	0d0a 0020      	movepw %a2@(32),%d6
    d48a:	4845           	swap %d5
    d48c:	4150           	.short 0x4150
    d48e:	2063           	moveal %a3@-,%a0
    d490:	616c           	bsrs 0xd4fe
    d492:	6375           	blss 0xd509
    d494:	6c61           	bges 0xd4f7
    d496:	7465           	moveq #101,%d2
    d498:	6420           	bccs 0xd4ba
    d49a:	2e2e 2e2e      	movel %fp@(11822),%d7
    d49e:	0d0a 0020      	movepw %a2@(32),%d6
    d4a2:	2e2e 2e61      	movel %fp@(11873),%d7
    d4a6:	6e64           	bgts 0xd50c
    d4a8:	2069 6e69      	moveal %a1@(28265),%a0
    d4ac:	7469           	moveq #105,%d2
    d4ae:	616c           	bsrs 0xd51c
    d4b0:	697a           	bvss 0xd52c
    d4b2:	6564           	bcss 0xd518
    d4b4:	0d0a 0020      	movepw %a2@(32),%d6
    d4b8:	6172           	bsrs 0xd52c
    d4ba:	6773           	beqs 0xd52f
    d4bc:	2061           	moveal %a1@-,%a0
    d4be:	6e64           	bgts 0xd524
    d4c0:	2065           	moveal %a5@-,%a0
    d4c2:	6e76           	bgts 0xd53a
    d4c4:	2063           	moveal %a3@-,%a0
    d4c6:	6f70           	bles 0xd538
    d4c8:	6965           	bvss 0xd52f
    d4ca:	6420           	bccs 0xd4ec
    d4cc:	746f           	moveq #111,%d2
    d4ce:	2070 726f      	moveal %a0@(0000006f,%d7:w:2),%a0
    d4d2:	6772           	beqs 0xd546
    d4d4:	616d           	bsrs 0xd543
    d4d6:	2061           	moveal %a1@-,%a0
    d4d8:	7265           	moveq #101,%d1
    d4da:	610d           	bsrs 0xd4e9
    d4dc:	0a00 2073      	eorib #115,%d0
    d4e0:	7461           	moveq #97,%d2
    d4e2:	7274           	moveq #116,%d1
    d4e4:	7570 2072      	mvsw %a0@(00000072,%d2:w),%d2
    d4e8:	6f75           	bles 0xd55f
    d4ea:	7469           	moveq #105,%d2
    d4ec:	6e65           	bgts 0xd553
    d4ee:	7320           	mvsb %a0@-,%d1
    d4f0:	6578           	bcss 0xd56a
    d4f2:	6563           	bcss 0xd557
    d4f4:	7574 6564 2c20 	mvsw %a4@(00002c20)@(00000000),%d2
    d4fa:	6e6f           	bgts 0xd56b
    d4fc:	7720           	mvsb %a0@-,%d3
    d4fe:	6361           	blss 0xd561
    d500:	6c6c           	bges 0xd56e
    d502:	696e           	bvss 0xd572
    d504:	6720           	beqs 0xd526
    d506:	6d61           	blts 0xd569
    d508:	696e           	bvss 0xd578
    d50a:	0d0a 0d0a      	movepw %a2@(3338),%d6
    d50e:	0020 6661      	orib #97,%a0@-
    d512:	6b65           	bmis 0xd579
    d514:	2072 6f75 7469 	moveal %a2@(74696e65)@(00000000),%a0
    d51a:	6e65 
    d51c:	2063           	moveal %a3@-,%a0
    d51e:	616c           	bsrs 0xd58c
    d520:	6c65           	bges 0xd587
    d522:	6420           	bccs 0xd544
    d524:	6672           	bnes 0xd598
    d526:	6f6d           	bles 0xd595
    d528:	206d 6169      	moveal %a5@(24937),%a0
    d52c:	6e2c           	bgts 0xd55a
    d52e:	2072 6574 7572 	moveal %a2@(75726e69)@(00000000),%a0
    d534:	6e69 
    d536:	6e67           	bgts 0xd59f
    d538:	2069 6d6d      	moveal %a1@(28013),%a0
    d53c:	6564           	bcss 0xd5a2
    d53e:	6961           	bvss 0xd5a1
    d540:	7465           	moveq #101,%d2
    d542:	6c79           	bges 0xd5bd
    d544:	0d0a 0020      	movepw %a2@(32),%d6
    d548:	6578           	bcss 0xd5c2
    d54a:	6563           	bcss 0xd5af
    d54c:	7574 696e 6720 	mvsw %a4@(00006720)@(00007275),%d2
    d552:	7275 
    d554:	6e64           	bgts 0xd5ba
    d556:	6f77           	bles 0xd5cf
    d558:	6e20           	bgts 0xd57a
    d55a:	726f           	moveq #111,%d1
    d55c:	7574 696e 6573 	mvsw %a4@(00006573)@(00002e2e),%d2
    d562:	2e2e 
    d564:	2e62           	moveal %a2@-,%sp
    d566:	7965           	mvsw %a5@-,%d4
    d568:	2062           	moveal %a2@-,%a0
    d56a:	7965           	mvsw %a5@-,%d4
    d56c:	2e2e 2e0d      	movel %fp@(11789),%d7
    d570:	0a00 206c      	eorib #108,%d0
    d574:	6f61           	bles 0xd5d7
    d576:	6420           	bccs 0xd598
    d578:	6164           	bsrs 0xd5de
    d57a:	6472           	bccs 0xd5ee
    d57c:	6573           	bcss 0xd5f1
    d57e:	7320           	mvsb %a0@-,%d1
    d580:	3a20           	movew %a0@-,%d5
    d582:	3078 0020      	moveaw 0x20,%a0
    d586:	6273           	bhis 0xd5fb
    d588:	7320           	mvsb %a0@-,%d1
    d58a:	7374 6172 7473 	mvsw %a4@(74732061)@(0000743a),%d1
    d590:	2061 743a 
    d594:	2030 7800      	movel %a0@(00000000,%d7:l),%d0
    d598:	2052           	moveal %a2@,%a0
    d59a:	656c           	bcss 0xd608
    d59c:	6f63           	bles 0xd601
    d59e:	6174           	bsrs 0xd614
    d5a0:	696f           	bvss 0xd611
    d5a2:	6e20           	bgts 0xd5c4
    d5a4:	5461           	addqw #2,%a1@-
    d5a6:	626c           	bhis 0xd614
    d5a8:	653a           	bcss 0xd5e4
    d5aa:	0d0a 0d0a      	movepw %a2@(3338),%d6
    d5ae:	206f 6666      	moveal %sp@(26214),%a0
    d5b2:	7365           	mvsw %a5@-,%d1
    d5b4:	7420           	moveq #32,%d2
    d5b6:	2020           	movel %a0@-,%d0
    d5b8:	2074 7970 6520 	moveal %a4@(65202020),%a0
    d5be:	2020 
    d5c0:	2020           	movel %a0@-,%d0
    d5c2:	2020           	movel %a0@-,%d0
    d5c4:	7661           	moveq #97,%d3
    d5c6:	6c75           	bges 0xd63d
    d5c8:	650d           	bcss 0xd5d7
    d5ca:	0a00 204d      	eorib #77,%d0
    d5ce:	6167           	bsrs 0xd637
    d5d0:	6963           	bvss 0xd635
    d5d2:	2066           	moveal %fp@-,%a0
    d5d4:	6f75           	bles 0xd64b
    d5d6:	6e64           	bgts 0xd63c
    d5d8:	0d0a 0020      	movepw %a2@(32),%d6
    d5dc:	4d61           	.short 0x4d61
    d5de:	6769           	beqs 0xd649
    d5e0:	6320           	blss 0xd602
    d5e2:	6e6f           	bgts 0xd653
    d5e4:	7420           	moveq #32,%d2
    d5e6:	666f           	bnes 0xd657
    d5e8:	756e 640d      	mvsw %fp@(25613),%d2
    d5ec:	0a00 206e      	eorib #110,%d0
    d5f0:	756d 6265      	mvsw %a5@(25189),%d2
    d5f4:	7220           	moveq #32,%d1
    d5f6:	6f66           	bles 0xd65e
    d5f8:	2072 656c 6f63 	moveal %a2@(00006f63)@(00000000),%a0
    d5fe:	6174           	bsrs 0xd674
    d600:	696f           	bvss 0xd671
    d602:	6e73           	bgts 0xd677
    d604:	3a20           	movew %a0@-,%d5
    d606:	3078 0020      	moveaw 0x20,%a0
    d60a:	756e 7375      	mvsw %fp@(29557),%d2
    d60e:	7070           	moveq #112,%d0
    d610:	6f72           	bles 0xd684
    d612:	7465           	moveq #101,%d2
    d614:	6420           	bccs 0xd636
    d616:	7265           	moveq #101,%d1
    d618:	6c6f           	bges 0xd689
    d61a:	6361           	blss 0xd67d
    d61c:	7469           	moveq #105,%d2
    d61e:	6f6e           	bles 0xd68e
    d620:	2021           	movel %a1@-,%d0
    d622:	200d           	movel %a5,%d0
    d624:	0a00 2052      	eorib #82,%d0
    d628:	656c           	bcss 0xd696
    d62a:	6f63           	bles 0xd68f
    d62c:	6174           	bsrs 0xd6a2
    d62e:	696f           	bvss 0xd69f
    d630:	6e73           	bgts 0xd6a5
    d632:	2064           	moveal %a4@-,%a0
    d634:	6f6e           	bles 0xd6a4
    d636:	6520           	bcss 0xd658
    d638:	2120           	movel %a0@-,%a0@-
    d63a:	0d0a 0020      	movepw %a2@(32),%d6
    d63e:	6c6f           	bges 0xd6af
    d640:	6164           	bsrs 0xd6a6
    d642:	696e           	bvss 0xd6b2
    d644:	672e           	beqs 0xd674
    d646:	2e2e 2e0d      	movel %fp@(11789),%d7
    d64a:	0a00 0d0a      	eorib #10,%d0
    d64e:	0d0a 2065      	movepw %a2@(8293),%d6
    d652:	7869           	moveq #105,%d4
    d654:	742e           	moveq #46,%d2
    d656:	2e2e 0d0a      	movel %fp@(3338),%d7
    d65a:	0020 6e6f      	orib #111,%a0@-
    d65e:	2072 656c 6f63 	moveal %a2@(00006f63)@(00000000),%a0
    d664:	6174           	bsrs 0xd6da
    d666:	696f           	bvss 0xd6d7
    d668:	6e20           	bgts 0xd68a
    d66a:	6e65           	bgts 0xd6d1
    d66c:	6365           	blss 0xd6d3
    d66e:	7373 6172 790d 	mvsw %a3@(790d0a00)@(00002063),%d1
    d674:	0a00 2063 
    d678:	6f6d           	bles 0xd6e7
    d67a:	7069           	moveq #105,%d0
    d67c:	6c65           	bges 0xd6e3
    d67e:	6420           	bccs 0xd6a0
    d680:	666f           	bnes 0xd6f1
    d682:	7220           	moveq #32,%d1
    d684:	6164           	bsrs 0xd6ea
    d686:	6472           	bccs 0xd6fa
    d688:	6573           	bcss 0xd6fd
    d68a:	733a 2030      	mvsb %pc@(0xf6bc),%d1
    d68e:	7800           	moveq #0,%d4
    d690:	2041           	moveal %d1,%a0
    d692:	4444           	negw %d4
    d694:	5220           	addqb #1,%a0@-
    d696:	3078 0020      	moveaw 0x20,%a0
    d69a:	3d20           	movew %a0@-,%fp@-
    d69c:	3078 0020      	moveaw 0x20,%a0
    d6a0:	2d2d 2d3e      	movel %a5@(11582),%fp@-
    d6a4:	2030 7800      	movel %a0@(00000000,%d7:l),%d0
    d6a8:	205f           	moveal %sp@+,%a0
    d6aa:	5f72 6578 6974 	subqw #7,%a2@(6974202e)
    d6b0:	202e 
    d6b2:	2e2e 2e0d      	movel %fp@(11789),%d7
    d6b6:	0a00 2062      	eorib #98,%d0
    d6ba:	7373 2065      	mvsw %a3@(00000065,%d2:w),%d1
    d6be:	6e64           	bgts 0xd724
    d6c0:	7320           	mvsb %a0@-,%d1
    d6c2:	2848           	moveal %a0,%a4
    d6c4:	4541           	.short 0x4541
    d6c6:	5020           	addqb #8,%a0@-
    d6c8:	7374 6172 7473 	mvsw %a4@(74732920)@(00006174),%d1
    d6ce:	2920 6174 
    d6d2:	3a20           	movew %a0@-,%d5
    d6d4:	3078 0020      	moveaw 0x20,%a0
    d6d8:	5241           	addqw #1,%d1
    d6da:	4d5f           	.short 0x4d5f
    d6dc:	544f           	addqw #2,%sp
    d6de:	5020           	addqb #8,%a0@-
    d6e0:	6174           	bsrs 0xd756
    d6e2:	3a20           	movew %a0@-,%d5
    d6e4:	3078 0020      	moveaw 0x20,%a0
    d6e8:	5479 3a20 3078 	addqw #2,0x3a203078
    d6ee:	0020 6174      	orib #116,%a0@-
    d6f2:	3a20           	movew %a0@-,%d5
    d6f4:	3078 0020      	moveaw 0x20,%a0
    d6f8:	7661           	moveq #97,%d3
    d6fa:	6c3a           	bges 0xd736
    d6fc:	2030 7800      	movel %a0@(00000000,%d7:l),%d0
    d700:	206f 6666      	moveal %sp@(26214),%a0
    d704:	3a20           	movew %a0@-,%d5
    d706:	3078 0020      	moveaw 0x20,%a0
    d70a:	3078 0020      	moveaw 0x20,%a0
    d70e:	7265           	moveq #101,%d1
    d710:	6c6f           	bges 0xd781
    d712:	6361           	blss 0xd775
    d714:	7469           	moveq #105,%d2
    d716:	6f6e           	bles 0xd786
    d718:	2069 6e66      	moveal %a1@(28262),%a0
    d71c:	6f20           	bles 0xd73e
    d71e:	6e65           	bgts 0xd785
    d720:	6564           	bcss 0xd786
    d722:	6564           	bcss 0xd788
    d724:	2062           	moveal %a2@-,%a0
    d726:	7574 206e      	mvsw %a4@(0000006e,%d2:w),%d2
    d72a:	6f74           	bles 0xd7a0
    d72c:	2066           	moveal %fp@-,%a0
    d72e:	6f75           	bles 0xd7a5
    d730:	6e64           	bgts 0xd796
    d732:	2021           	movel %a1@-,%d0
    d734:	0d0a 0000      	movepw %a2@(0),%d6
	...
    d838:	4516           	chkl %fp@,%d2
    d83a:	8297           	orl %sp@,%d1
	...
    d958:	4669 6c65      	notw %a1@(27749)
    d95c:	206e 616d      	moveal %fp@(24941),%a0
    d960:	6520           	bcss 0xd982
    d962:	756e 6b6e      	mvsw %fp@(27502),%d2
    d966:	6f77           	bles 0xd9df
    d968:	6e00 2561      	bgtw 0xfecb
    d96c:	2025           	movel %a5@-,%d0
    d96e:	6220           	bhis 0xd990
    d970:	2563 0a00      	movel %a3@-,%a2@(2560)
    d974:	2573 2025 7328 	movel %a3@(00000025,%d2:w),%a2@(29480)
    d97a:	2564 2920      	movel %a4@-,%a2@(10528)
    d97e:	3a20           	movew %a0@-,%d5
    d980:	2573 0a00 0a00 	movel %a3@(00000000,%d0:l:2),%a2@(2560)
    d986:	0a20 5370      	eorib #112,%a0@-
    d98a:	6569           	bcss 0xd9f5
    d98c:	6368           	blss 0xd9f6
    d98e:	6572           	bcss 0xda02
    d990:	6265           	bhis 0xd9f7
    d992:	6c65           	bges 0xd9f9
    d994:	6775           	beqs 0xda0b
    d996:	6e67           	bgts 0xd9ff
    d998:	3a20           	movew %a0@-,%d5
    d99a:	0a0a           	.short 0x0a0a
    d99c:	0020 426c      	orib #108,%a0@-
    d9a0:	6f63           	bles 0xda05
    d9a2:	6b20           	bmis 0xd9c4
    d9a4:	4e6f           	movel %usp,%sp
    d9a6:	2e20           	movel %a0@-,%d7
    d9a8:	2020           	movel %a0@-,%d0
    d9aa:	2020           	movel %a0@-,%d0
    d9ac:	5374 6172 7420 	subqw #1,%a4@(74202020)@(00002020)
    d9b2:	2020 2020 
    d9b6:	2020           	movel %a0@-,%d0
    d9b8:	2020           	movel %a0@-,%d0
    d9ba:	2053           	moveal %a3@,%a0
    d9bc:	697a           	bvss 0xda38
    d9be:	6520           	bcss 0xd9e0
    d9c0:	2020           	movel %a0@-,%d0
    d9c2:	2020           	movel %a0@-,%d0
    d9c4:	2020           	movel %a0@-,%d0
    d9c6:	2020           	movel %a0@-,%d0
    d9c8:	4e65           	movel %a5,%usp
    d9ca:	7874           	moveq #116,%d4
    d9cc:	2048           	moveal %a0,%a0
    d9ce:	6472           	bccs 0xda42
    d9d0:	2020           	movel %a0@-,%d0
    d9d2:	2020           	movel %a0@-,%d0
    d9d4:	2020           	movel %a0@-,%d0
    d9d6:	4672 6565 0a0a 	notw %a2@(00000a0a)@(00000000)
    d9dc:	0020 2020      	orib #32,%a0@-
    d9e0:	2020           	movel %a0@-,%d0
    d9e2:	2000           	movel %d0,%d0
    d9e4:	2020           	movel %a0@-,%d0
    d9e6:	2020           	movel %a0@-,%d0
    d9e8:	2030 7800      	movel %a0@(00000000,%d7:l),%d0
    d9ec:	2020           	movel %a0@-,%d0
    d9ee:	2020           	movel %a0@-,%d0
    d9f0:	3078 0020      	moveaw 0x20,%a0
    d9f4:	2020           	movel %a0@-,%d0
    d9f6:	000a           	.short 0x000a
    d9f8:	000a           	.short 0x000a
    d9fa:	466c 6f61      	notw %a4@(28513)
    d9fe:	7469           	moveq #105,%d2
    da00:	6e67           	bgts 0xda69
    da02:	2070 6f69 6e74 	moveal %a0@(00006e74)@(00000000),%a0
    da08:	2065           	moveal %a5@-,%a0
    da0a:	7863           	moveq #99,%d4
    da0c:	6570           	bcss 0xda7e
    da0e:	7469           	moveq #105,%d2
    da10:	6f6e           	bles 0xda80
    da12:	000a           	.short 0x000a
    da14:	4765           	.short 0x4765
    da16:	6e65           	bgts 0xda7d
    da18:	7261           	moveq #97,%d1
    da1a:	6c20           	bges 0xda3c
    da1c:	7072           	moveq #114,%d0
    da1e:	6f74           	bles 0xda94
    da20:	6563           	bcss 0xda85
    da22:	7469           	moveq #105,%d2
    da24:	6f6e           	bles 0xda94
    da26:	2066           	moveal %fp@-,%a0
    da28:	6175           	bsrs 0xda9f
    da2a:	6c74           	bges 0xdaa0
    da2c:	0000 3fe0      	orib #-32,%d0
    da30:	0000 0000      	orib #0,%d0
    da34:	0000 3fa9      	orib #-87,%d0
    da38:	9999           	subl %d4,%a1@+
    da3a:	9999           	subl %d4,%a1@+
    da3c:	999a           	subl %d4,%a2@+
    da3e:	3f74 7ae1 47ae 	movew %a4@(ffffffe1,%d7:l:2),%sp@(18350)
    da44:	147b           	.short 0x147b
    da46:	3f40 624d      	movew %d0,%sp@(25165)
    da4a:	d2f1 a9fc 3f0a 	addaw @(3f0a36e2)@(00000000),%a1
    da50:	36e2 
    da52:	eb1c           	rolb #5,%d4
    da54:	432d 3ed4      	chkl %a5@(16084),%d1
    da58:	f8b5           	.short 0xf8b5
    da5a:	88e3           	divuw %a3@-,%d4
    da5c:	68f1           	bvcs 0xda4f
    da5e:	3ea0           	movew %a0@-,%sp@
    da60:	c6f7 a0b5      	muluw %sp@(ffffffb5,%a2:w),%d3
    da64:	ed8d           	lsll #6,%d5
    da66:	3e6a d7f2      	moveaw %a2@(-10254),%sp
    da6a:	9abc af48 286e 	subl #-1354225554,%d5
    da70:	756c 6c29      	mvsw %a4@(27689),%d2
    da74:	0073 7472 6572 	oriw #29810,%a3@(726f7220)@(00006675)
    da7a:	726f 7220 6675 
    da80:	6e63           	bgts 0xdae5
    da82:	7469           	moveq #105,%d2
    da84:	6f6e           	bles 0xdaf4
    da86:	206e 6f74      	moveal %fp@(28532),%a0
    da8a:	2069 6d70      	moveal %a1@(28016),%a0
    da8e:	6c65           	bges 0xdaf5
    da90:	6d65           	blts 0xdaf7
    da92:	6e74           	bgts 0xdb08
    da94:	6564           	bcss 0xdafa
    da96:	0053 756e      	oriw #30062,%a3@
    da9a:	004d           	.short 0x004d
    da9c:	6f6e           	bles 0xdb0c
    da9e:	0054 7565      	oriw #30053,%a4@
    daa2:	0057 6564      	oriw #25956,%sp@
    daa6:	0054 6875      	oriw #26741,%a4@
    daaa:	0046 7269      	oriw #29289,%d6
    daae:	0053 6174      	oriw #24948,%a3@
    dab2:	004a           	.short 0x004a
    dab4:	616e           	bsrs 0xdb24
    dab6:	0046 6562      	oriw #25954,%d6
    daba:	004d           	.short 0x004d
    dabc:	6172           	bsrs 0xdb30
    dabe:	0041 7072      	oriw #28786,%d1
    dac2:	004d           	.short 0x004d
    dac4:	6179           	bsrs 0xdb3f
    dac6:	004a           	.short 0x004a
    dac8:	756e 004a      	mvsw %fp@(74),%d2
    dacc:	756c 0041      	mvsw %a4@(65),%d2
    dad0:	7567           	mvsw %sp@-,%d2
    dad2:	0053 6570      	oriw #25968,%a3@
    dad6:	004f           	.short 0x004f
    dad8:	6374           	blss 0xdb4e
    dada:	004e           	.short 0x004e
    dadc:	6f76           	bles 0xdb54
    dade:	0044 6563      	oriw #25955,%d4
    dae2:	0061 6d00      	oriw #27904,%a1@-
    dae6:	706d           	moveq #109,%d0
    dae8:	0053 756e      	oriw #30062,%a3@
    daec:	6461           	bccs 0xdb4f
    daee:	7900           	mvsb %d0,%d4
    daf0:	4d6f           	.short 0x4d6f
    daf2:	6e64           	bgts 0xdb58
    daf4:	6179           	bsrs 0xdb6f
    daf6:	0054 7565      	oriw #30053,%a4@
    dafa:	7364           	mvsw %a4@-,%d1
    dafc:	6179           	bsrs 0xdb77
    dafe:	0057 6564      	oriw #25956,%sp@
    db02:	6e65           	bgts 0xdb69
    db04:	7364           	mvsw %a4@-,%d1
    db06:	6179           	bsrs 0xdb81
    db08:	0054 6875      	oriw #26741,%a4@
    db0c:	7273           	moveq #115,%d1
    db0e:	6461           	bccs 0xdb71
    db10:	7900           	mvsb %d0,%d4
    db12:	4672 6964 6179 	notw %a2@(00006179)@(00000000)
    db18:	0053 6174      	oriw #24948,%a3@
    db1c:	7572 6461      	mvsw %a2@(00000061,%d6:w:4),%d2
    db20:	7900           	mvsb %d0,%d4
    db22:	4a61           	tstw %a1@-
    db24:	6e75           	bgts 0xdb9b
    db26:	6172           	bsrs 0xdb9a
    db28:	7900           	mvsb %d0,%d4
    db2a:	4665           	notw %a5@-
    db2c:	6272           	bhis 0xdba0
    db2e:	7561           	mvsw %a1@-,%d2
    db30:	7279           	moveq #121,%d1
    db32:	004d           	.short 0x004d
    db34:	6172           	bsrs 0xdba8
    db36:	6368           	blss 0xdba0
    db38:	0041 7072      	oriw #28786,%d1
    db3c:	696c           	bvss 0xdbaa
    db3e:	004a           	.short 0x004a
    db40:	756e 6500      	mvsw %fp@(25856),%d2
    db44:	4a75 6c79      	tstw %a5@(00000079,%d6:l:4)
    db48:	0041 7567      	oriw #30055,%d1
    db4c:	7573 7400      	mvsw %a3@(00000000,%d7:w:4),%d2
    db50:	5365           	subqw #1,%a5@-
    db52:	7074           	moveq #116,%d0
    db54:	656d           	bcss 0xdbc3
    db56:	6265           	bhis 0xdbbd
    db58:	7200           	moveq #0,%d1
    db5a:	4f63           	.short 0x4f63
    db5c:	746f           	moveq #111,%d2
    db5e:	6265           	bhis 0xdbc5
    db60:	7200           	moveq #0,%d1
    db62:	4e6f           	movel %usp,%sp
    db64:	7665           	moveq #101,%d3
    db66:	6d62           	blts 0xdbca
    db68:	6572           	bcss 0xdbdc
    db6a:	0044 6563      	oriw #25955,%d4
    db6e:	656d           	bcss 0xdbdd
    db70:	6265           	bhis 0xdbd7
    db72:	7200           	moveq #0,%d1
    db74:	2000           	movel %d0,%d0
    db76:	3a00           	movew %d0,%d5
    db78:	4561           	.short 0x4561
    db7a:	7374 6572 6e20 	mvsw %a4@(6e205374)@(0000616e),%d1
    db80:	5374 616e 
    db84:	6461           	bccs 0xdbe7
    db86:	7264           	moveq #100,%d1
    db88:	2054           	moveal %a4@,%a0
    db8a:	696d           	bvss 0xdbf9
    db8c:	6500 7262      	bcsw 0x14df0
    db90:	0077 622b 002e 	oriw #25131,%sp@(0000002e,%d0:w)
    db96:	003a           	.short 0x003a
    db98:	0066 732e      	oriw #29486,%fp@-
    db9c:	633a           	blss 0xdbd8
    db9e:	2020           	movel %a0@-,%d0
    dba0:	6e6f           	bgts 0xdc11
    dba2:	206d 6f72      	moveal %a5@(28530),%a0
    dba6:	6520           	bcss 0xdbc8
    dba8:	6672           	bnes 0xdc1c
    dbaa:	6565           	bcss 0xdc11
    dbac:	2066           	moveal %fp@-,%a0
    dbae:	696c           	bvss 0xdc1c
    dbb0:	6520           	bcss 0xdbd2
    dbb2:	6861           	bvcs 0xdc15
    dbb4:	6e64           	bgts 0xdc1a
    dbb6:	6c65           	bges 0xdc1d
    dbb8:	7320           	mvsb %a0@-,%d1
    dbba:	696e           	bvss 0xdc2a
    dbbc:	205f           	moveal %sp@+,%a0
    dbbe:	6c6c           	bges 0xdc2c
    dbc0:	5f6f 7065      	subqw #7,%sp@(28773)
    dbc4:	6e0a           	bgts 0xdbd0
    dbc6:	0020 6572      	orib #114,%a0@-
    dbca:	726f           	moveq #111,%d1
    dbcc:	7220           	moveq #32,%d1
    dbce:	6d61           	blts 0xdc31
    dbd0:	6c6c           	bges 0xdc3e
    dbd2:	6f63           	bles 0xdc37
    dbd4:	2069 6e20      	moveal %a1@(28192),%a0
    dbd8:	5f6c 6c5f      	subqw #7,%a4@(27743)
    dbdc:	6f70           	bles 0xdc4e
    dbde:	656e           	bcss 0xdc4e
    dbe0:	0a00 2065      	eorib #101,%d0
    dbe4:	7272           	moveq #114,%d1
    dbe6:	6f72           	bles 0xdc5a
    dbe8:	2073 7472      	moveal %a3@(00000072,%d7:w:4),%a0
    dbec:	6370           	blss 0xdc5e
    dbee:	7920           	mvsb %a0@-,%d4
    dbf0:	696e           	bvss 0xdc60
    dbf2:	205f           	moveal %sp@+,%a0
    dbf4:	6c6c           	bges 0xdc62
    dbf6:	5f6f 7065      	subqw #7,%sp@(28773)
    dbfa:	6e0a           	bgts 0xdc06
    dbfc:	0066 732e      	oriw #29486,%fp@-
    dc00:	633a           	blss 0xdc3c
    dc02:	2020           	movel %a0@-,%d0
    dc04:	6572           	bcss 0xdc78
    dc06:	726f           	moveq #111,%d1
    dc08:	7220           	moveq #32,%d1
    dc0a:	665f           	bnes 0xdc6b
    dc0c:	6f70           	bles 0xdc7e
    dc0e:	732d 636c      	mvsb %a5@(25452),%d1
    dc12:	6f73           	bles 0xdc87
    dc14:	6528           	bcss 0xdc3e
    dc16:	2920           	movel %a0@-,%a4@-
    dc18:	696e           	bvss 0xdc88
    dc1a:	205f           	moveal %sp@+,%a0
    dc1c:	6c6c           	bges 0xdc8a
    dc1e:	5f6c 6f73      	subqw #7,%a4@(28531)
    dc22:	650a           	bcss 0xdc2e
    dc24:	0020 6e6f      	orib #111,%a0@-
    dc28:	206d 6f72      	moveal %a5@(28530),%a0
    dc2c:	6520           	bcss 0xdc4e
    dc2e:	6672           	bnes 0xdca2
    dc30:	6565           	bcss 0xdc97
    dc32:	2066           	moveal %fp@-,%a0
    dc34:	696c           	bvss 0xdca2
    dc36:	6520           	bcss 0xdc58
    dc38:	6861           	bvcs 0xdc9b
    dc3a:	6e64           	bgts 0xdca0
    dc3c:	6c65           	bges 0xdca3
    dc3e:	7320           	mvsb %a0@-,%d1
    dc40:	696e           	bvss 0xdcb0
    dc42:	205f           	moveal %sp@+,%a0
    dc44:	6c6c           	bges 0xdcb2
    dc46:	5f72 656e 616d 	subqw #7,%a2@(0000616d)@(0000650a)
    dc4c:	650a 
    dc4e:	0020 6572      	orib #114,%a0@-
    dc52:	726f           	moveq #111,%d1
    dc54:	7220           	moveq #32,%d1
    dc56:	6d61           	blts 0xdcb9
    dc58:	6c6c           	bges 0xdcc6
    dc5a:	6f63           	bles 0xdcbf
    dc5c:	2069 6e20      	moveal %a1@(28192),%a0
    dc60:	5f6c 6c5f      	subqw #7,%a4@(27743)
    dc64:	7265           	moveq #101,%d1
    dc66:	6e61           	bgts 0xdcc9
    dc68:	6d65           	blts 0xdccf
    dc6a:	0a00 2065      	eorib #101,%d0
    dc6e:	7272           	moveq #114,%d1
    dc70:	6f72           	bles 0xdce4
    dc72:	2073 7472      	moveal %a3@(00000072,%d7:w:4),%a0
    dc76:	6370           	blss 0xdce8
    dc78:	7920           	mvsb %a0@-,%d4
    dc7a:	696e           	bvss 0xdcea
    dc7c:	205f           	moveal %sp@+,%a0
    dc7e:	6c6c           	bges 0xdcec
    dc80:	5f72 656e 616d 	subqw #7,%a2@(0000616d)@(0000650a)
    dc86:	650a 
    dc88:	0020 6572      	orib #114,%a0@-
    dc8c:	726f           	moveq #111,%d1
    dc8e:	7220           	moveq #32,%d1
    dc90:	7265           	moveq #101,%d1
    dc92:	6e61           	bgts 0xdcf5
    dc94:	6d69           	blts 0xdcff
    dc96:	6e67           	bgts 0xdcff
    dc98:	2066           	moveal %fp@-,%a0
    dc9a:	696c           	bvss 0xdd08
    dc9c:	650a           	bcss 0xdca8
	...
    dcd6:	0000 2065      	orib #101,%d0
    dcda:	7272           	moveq #114,%d1
    dcdc:	6f72           	bles 0xdd50
    dcde:	2066           	moveal %fp@-,%a0
    dce0:	696c           	bvss 0xdd4e
    dce2:	6c66           	bges 0xdd4a
    dce4:	6362           	blss 0xdd48
    dce6:	3a20           	movew %a0@-,%d5
    dce8:	6e6f           	bgts 0xdd59
    dcea:	7420           	moveq #32,%d2
    dcec:	6120           	bsrs 0xdd0e
    dcee:	6669           	bnes 0xdd59
    dcf0:	6c65           	bges 0xdd57
    dcf2:	6e61           	bgts 0xdd55
    dcf4:	6d65           	blts 0xdd5b
    dcf6:	0a00 4a41      	eorib #65,%d0
    dcfa:	444f           	.short 0x444f
    dcfc:	5346           	subqw #1,%d6
    dcfe:	5300           	subqb #1,%d0
    dd00:	4100           	chkl %d0,%d0
    dd02:	5100           	subqb #8,%d0
    dd04:	202a 2a2a      	movel %a2@(10794),%d0
    dd08:	2a2a 2a2a      	movel %a2@(10794),%d5
    dd0c:	2a20           	movel %a0@-,%d5
    dd0e:	4641           	notw %d1
    dd10:	5433 322d      	addqb #2,%a3@(0000002d,%d3:w:2)
    dd14:	5465           	addqw #2,%a5@-
    dd16:	7374 202a      	mvsw %a4@(0000002a,%d2:w),%d1
    dd1a:	2a2a 2a2a      	movel %a2@(10794),%d5
    dd1e:	2a2a 2a2a      	movel %a2@(10794),%d5
    dd22:	2a0a           	movel %a2,%d5
    dd24:	000a           	.short 0x000a
    dd26:	2043           	moveal %d3,%a0
    dd28:	5452           	addqw #2,%a2@
    dd2a:	4c43           	.short 0x4c43
    dd2c:	5f54           	subqw #7,%a4@
    dd2e:	4553           	.short 0x4553
    dd30:	542e 2e2e      	addqb #2,%fp@(11822)
    dd34:	0a00 0a20      	eorib #32,%d0
    dd38:	4d41           	.short 0x4d41
    dd3a:	5448           	addqw #2,%a0
    dd3c:	5f54           	subqw #7,%a4@
    dd3e:	4553           	.short 0x4553
    dd40:	542e 2e2e      	addqb #2,%fp@(11822)
    dd44:	0a00 646f      	eorib #111,%d0
    dd48:	6e65           	bgts 0xddaf
    dd4a:	2e2e 2e00      	movel %fp@(11776),%d7
    dd4e:	206c 3120      	moveal %a4@(12576),%a0
    dd52:	3d20           	movew %a0@-,%fp@-
    dd54:	3078 256c      	moveaw 0x256c,%a0
    dd58:	6c78           	bges 0xddd2
    dd5a:	2c20           	movel %a0@-,%d6
    dd5c:	6c32           	bges 0xdd90
    dd5e:	3d20           	movew %a0@-,%fp@-
    dd60:	3078 256c      	moveaw 0x256c,%a0
    dd64:	6c78           	bges 0xddde
    dd66:	2c20           	movel %a0@-,%d6
    dd68:	6c33           	bges 0xdd9d
    dd6a:	203d           	.short 0x203d
    dd6c:	2030 7825      	movel %a0@(00000025,%d7:l),%d0
    dd70:	6c6c           	bges 0xddde
    dd72:	780a           	moveq #10,%d4
    dd74:	000a           	.short 0x000a
    dd76:	2053           	moveal %a3@,%a0
    dd78:	4947           	.short 0x4947
    dd7a:	4e41           	trap #1
    dd7c:	4c5f           	.short 0x4c5f
    dd7e:	5445           	addqw #2,%d5
    dd80:	5354           	subqw #1,%a4@
    dd82:	2e2e 2e2e      	movel %fp@(11822),%d7
    dd86:	284b           	moveal %a3,%a4
    dd88:	4559           	.short 0x4559
    dd8a:	2900           	movel %d0,%a4@-
    dd8c:	0a00 0a20      	eorib #32,%d0
    dd90:	5449           	addqw #2,%a1
    dd92:	4d45           	.short 0x4d45
    dd94:	5f54           	subqw #7,%a4@
    dd96:	4553           	.short 0x4553
    dd98:	542e 2e2e      	addqb #2,%fp@(11822)
    dd9c:	0a00 2573      	eorib #115,%d0
    dda0:	0a00 5468      	eorib #104,%d0
    dda4:	6520           	bcss 0xddc6
    dda6:	6375           	blss 0xde1d
    dda8:	7272           	moveq #114,%d1
    ddaa:	656e           	bcss 0xde1a
    ddac:	7420           	moveq #32,%d2
    ddae:	6461           	bccs 0xde11
    ddb0:	7465           	moveq #101,%d2
    ddb2:	2f74 696d 6520 	movel %a4@(00006520)@(00000000),%sp@(26995)
    ddb8:	6973 
    ddba:	3a20           	movew %a0@-,%d5
    ddbc:	2573 0020 2e2e 	movel %a3@(00000020,%d0:w),%a2@(11822)
    ddc2:	2e2e 5449      	movel %fp@(21577),%d7
    ddc6:	4d45           	.short 0x4d45
    ddc8:	5f54           	subqw #7,%a4@
    ddca:	4553           	.short 0x4553
    ddcc:	540a           	.short 0x540a
    ddce:	0048           	.short 0x0048
    ddd0:	6575           	bcss 0xde47
    ddd2:	7465           	moveq #101,%d2
    ddd4:	2069 7374      	moveal %a1@(29556),%a0
    ddd8:	2064           	moveal %a4@-,%a0
    ddda:	6572           	bcss 0xde4e
    dddc:	2000           	movel %d0,%d0
    ddde:	2564 2e25      	movel %a4@-,%a2@(11813)
    dde2:	642e           	bccs 0xde12
    dde4:	2564 0a00      	movel %a4@-,%a2@(2560)
    dde8:	4269 7474      	clrw %a1@(29812)
    ddec:	6520           	bcss 0xde0e
    ddee:	6769           	beqs 0xde59
    ddf0:	6220           	bhis 0xde12
    ddf2:	4465           	negw %a5@-
    ddf4:	696e           	bvss 0xde64
    ddf6:	656e           	bcss 0xde66
    ddf8:	2047           	moveal %d7,%a0
    ddfa:	6562           	bcss 0xde5e
    ddfc:	7572 7473      	mvsw %a2@(00000073,%d7:w:4),%d2
    de00:	7461           	moveq #97,%d2
    de02:	6720           	beqs 0xde24
    de04:	6569           	bcss 0xde6f
    de06:	6e21           	bgts 0xde29
    de08:	0a00 5461      	eorib #97,%d0
    de0c:	6720           	beqs 0xde2e
    de0e:	3a20           	movew %a0@-,%d5
    de10:	0025 6400      	orib #0,%a5@-
    de14:	4d6f           	.short 0x4d6f
    de16:	6e61           	bgts 0xde79
    de18:	7420           	moveq #32,%d2
    de1a:	3a20           	movew %a0@-,%d5
    de1c:	004a           	.short 0x004a
    de1e:	6168           	bsrs 0xde88
    de20:	7220           	moveq #32,%d1
    de22:	286a 6a6a      	moveal %a2@(27242),%a4
    de26:	6a29           	bpls 0xde51
    de28:	203a 2000      	movel %pc@(0xfe2a),%d0
    de2c:	5369 6520      	subqw #1,%a1@(25888)
    de30:	7369 6e64      	mvsw %a1@(28260),%d1
    de34:	2025           	movel %a5@-,%d0
    de36:	6420           	bccs 0xde58
    de38:	4a61           	tstw %a1@-
    de3a:	6872           	bvcs 0xdeae
    de3c:	6520           	bcss 0xde5e
    de3e:	2564 204d      	movel %a4@-,%a2@(8269)
    de42:	6f6e           	bles 0xdeb2
    de44:	6174           	bsrs 0xdeba
    de46:	2865           	moveal %a5@-,%a4
    de48:	2920           	movel %a0@-,%a4@-
    de4a:	2564 2054      	movel %a4@-,%a2@(8276)
    de4e:	6167           	bsrs 0xdeb7
    de50:	2865           	moveal %a5@-,%a4
    de52:	2920           	movel %a0@-,%a4@-
    de54:	616c           	bsrs 0xdec2
    de56:	740a           	moveq #10,%d2
    de58:	0020 7772      	orib #114,%a0@-
    de5c:	6974           	bvss 0xded2
    de5e:	696e           	bvss 0xdece
    de60:	6720           	beqs 0xde82
    de62:	696e           	bvss 0xded2
    de64:	746f           	moveq #111,%d2
    de66:	2074 6578 7420 	moveal %a4@(74206669),%a0
    de6c:	6669 
    de6e:	6c65           	bges 0xded5
    de70:	2e2e 2e2e      	movel %fp@(11822),%d7
    de74:	2e2e 2e2e      	movel %fp@(11822),%d7
    de78:	2e2e 2e2e      	movel %fp@(11822),%d7
    de7c:	2e2e 2e2e      	movel %fp@(11822),%d7
    de80:	2e2e 2e2e      	movel %fp@(11822),%d7
    de84:	2e2e 2e2e      	movel %fp@(11822),%d7
    de88:	2e2e 2e2e      	movel %fp@(11822),%d7
    de8c:	2e2e 2e2e      	movel %fp@(11822),%d7
    de90:	2e2e 2e2e      	movel %fp@(11822),%d7
    de94:	2e0a           	movel %a2,%d7
    de96:	0077 2b00 6864 	oriw #11008,%sp@(00000064,%d6:l)
    de9c:	6130           	bsrs 0xdece
    de9e:	3a54           	moveaw %a4@,%a5
    dea0:	4553           	.short 0x4553
    dea2:	5431 2e54      	addqb #2,%a1@(00000054,%d2:l:8)
    dea6:	5854           	addqw #4,%a4@
    dea8:	0020 6572      	orib #114,%a0@-
    deac:	726f           	moveq #111,%d1
    deae:	7220           	moveq #32,%d1
    deb0:	6f70           	bles 0xdf22
    deb2:	656e           	bcss 0xdf22
    deb4:	696e           	bvss 0xdf24
    deb6:	6720           	beqs 0xded8
    deb8:	6669           	bnes 0xdf23
    deba:	6c65           	bges 0xdf21
    debc:	202e 2e2e      	movel %fp@(11822),%d0
    dec0:	0a00 207a      	eorib #122,%d0
    dec4:	6569           	bcss 0xdf2f
    dec6:	6c65           	bges 0xdf2d
    dec8:	2031 3a0a      	movel %a1@(0000000a,%d3:l:2),%d0
    decc:	0020 4469      	orib #105,%a0@-
    ded0:	6573           	bcss 0xdf45
    ded2:	2069 7374      	moveal %a1@(29556),%a0
    ded6:	205a           	moveal %a2@+,%a0
    ded8:	6569           	bcss 0xdf43
    deda:	6c65           	bges 0xdf41
    dedc:	2031 0a00      	movel %a1@(00000000,%d0:l:2),%d0
    dee0:	207a 6569      	moveal %pc@(0x1444b),%a0
    dee4:	6c65           	bges 0xdf4b
    dee6:	2032 3a0a      	movel %a2@(0000000a,%d3:l:2),%d0
    deea:	0020 4469      	orib #105,%a0@-
    deee:	6573           	bcss 0xdf63
    def0:	2069 7374      	moveal %a1@(29556),%a0
    def4:	205a           	moveal %a2@+,%a0
    def6:	6569           	bcss 0xdf61
    def8:	6c65           	bges 0xdf5f
    defa:	2032 0a00      	movel %a2@(00000000,%d0:l:2),%d0
    defe:	207a 6569      	moveal %pc@(0x14469),%a0
    df02:	6c65           	bges 0xdf69
    df04:	2033 3a0a      	movel %a3@(0000000a,%d3:l:2),%d0
    df08:	0020 4469      	orib #105,%a0@-
    df0c:	6573           	bcss 0xdf81
    df0e:	2069 7374      	moveal %a1@(29556),%a0
    df12:	205a           	moveal %a2@+,%a0
    df14:	6569           	bcss 0xdf7f
    df16:	6c65           	bges 0xdf7d
    df18:	2033 0a00      	movel %a3@(00000000,%d0:l:2),%d0
    df1c:	207a 6569      	moveal %pc@(0x14487),%a0
    df20:	6c65           	bges 0xdf87
    df22:	2034 3a0a      	movel %a4@(0000000a,%d3:l:2),%d0
    df26:	0020 4469      	orib #105,%a0@-
    df2a:	6573           	bcss 0xdf9f
    df2c:	2069 7374      	moveal %a1@(29556),%a0
    df30:	205a           	moveal %a2@+,%a0
    df32:	6569           	bcss 0xdf9d
    df34:	6c65           	bges 0xdf9b
    df36:	2034 0a00      	movel %a4@(00000000,%d0:l:2),%d0
    df3a:	207a 6569      	moveal %pc@(0x144a5),%a0
    df3e:	6c65           	bges 0xdfa5
    df40:	2035 3a0a      	movel %a5@(0000000a,%d3:l:2),%d0
    df44:	0020 4469      	orib #105,%a0@-
    df48:	6573           	bcss 0xdfbd
    df4a:	2069 7374      	moveal %a1@(29556),%a0
    df4e:	205a           	moveal %a2@+,%a0
    df50:	6569           	bcss 0xdfbb
    df52:	6c65           	bges 0xdfb9
    df54:	2035 0a00      	movel %a5@(00000000,%d0:l:2),%d0
    df58:	207a 6569      	moveal %pc@(0x144c3),%a0
    df5c:	6c65           	bges 0xdfc3
    df5e:	2036 3a0a      	movel %fp@(0000000a,%d3:l:2),%d0
    df62:	0020 4469      	orib #105,%a0@-
    df66:	6573           	bcss 0xdfdb
    df68:	2069 7374      	moveal %a1@(29556),%a0
    df6c:	205a           	moveal %a2@+,%a0
    df6e:	6569           	bcss 0xdfd9
    df70:	6c65           	bges 0xdfd7
    df72:	2036 0a00      	movel %fp@(00000000,%d0:l:2),%d0
    df76:	207a 6569      	moveal %pc@(0x144e1),%a0
    df7a:	6c65           	bges 0xdfe1
    df7c:	2037 3a0a      	movel %sp@(0000000a,%d3:l:2),%d0
    df80:	0020 4469      	orib #105,%a0@-
    df84:	6573           	bcss 0xdff9
    df86:	2069 7374      	moveal %a1@(29556),%a0
    df8a:	205a           	moveal %a2@+,%a0
    df8c:	6569           	bcss 0xdff7
    df8e:	6c65           	bges 0xdff5
    df90:	2037 0a00      	movel %sp@(00000000,%d0:l:2),%d0
    df94:	207a 6569      	moveal %pc@(0x144ff),%a0
    df98:	6c65           	bges 0xdfff
    df9a:	2038 3a0a      	movel 0x3a0a,%d0
    df9e:	0020 4469      	orib #105,%a0@-
    dfa2:	6573           	bcss 0xe017
    dfa4:	2069 7374      	moveal %a1@(29556),%a0
    dfa8:	205a           	moveal %a2@+,%a0
    dfaa:	6569           	bcss 0xe015
    dfac:	6c65           	bges 0xe013
    dfae:	2038 0a00      	movel 0xa00,%d0
    dfb2:	2063           	moveal %a3@-,%a0
    dfb4:	6c6f           	bges 0xe025
    dfb6:	7369 6e67      	mvsw %a1@(28263),%d1
    dfba:	2069 6e70      	moveal %a1@(28272),%a0
    dfbe:	7574 2066      	mvsw %a4@(00000066,%d2:w),%d2
    dfc2:	696c           	bvss 0xe030
    dfc4:	650a           	bcss 0xdfd0
    dfc6:	0048           	.short 0x0048
    dfc8:	656c           	bcss 0xe036
    dfca:	6c6f           	bges 0xe03b
    dfcc:	2077 6f72 6c64 	moveal %sp@(6c642100)@(00002050),%a0
    dfd2:	2100 2050 
    dfd6:	5249           	addqw #1,%a1
    dfd8:	4e54 465f      	linkw %a4,#18015
    dfdc:	5445           	addqw #2,%d5
    dfde:	5354           	subqw #1,%a4@
    dfe0:	3a0a           	movew %a2,%d5
    dfe2:	0a00 2044      	eorib #68,%d0
    dfe6:	4543           	.short 0x4543
    dfe8:	2020           	movel %a0@-,%d0
    dfea:	2020           	movel %a0@-,%d0
    dfec:	2020           	movel %a0@-,%d0
    dfee:	4845           	swap %d5
    dff0:	5820           	addqb #4,%a0@-
    dff2:	2020           	movel %a0@-,%d0
    dff4:	2020           	movel %a0@-,%d0
    dff6:	204f           	moveal %sp,%a0
    dff8:	4354           	.short 0x4354
    dffa:	2020           	movel %a0@-,%d0
    dffc:	2020           	movel %a0@-,%d0
    dffe:	2020           	movel %a0@-,%d0
    e000:	5354           	subqw #1,%a4@
    e002:	5249           	addqw #1,%a1
    e004:	4e47           	trap #7
    e006:	0a00 2025      	eorib #37,%d0
    e00a:	6420           	bccs 0xe02c
    e00c:	2020           	movel %a0@-,%d0
    e00e:	2020           	movel %a0@-,%d0
    e010:	2020           	movel %a0@-,%d0
    e012:	3078 2530      	moveaw 0x2530,%a0
    e016:	7820           	moveq #32,%d4
    e018:	2020           	movel %a0@-,%d0
    e01a:	206f 256f      	moveal %sp@(9583),%a0
    e01e:	2020           	movel %a0@-,%d0
    e020:	2020           	movel %a0@-,%d0
    e022:	2020           	movel %a0@-,%d0
    e024:	2573 0a00 2077 	movel %a3@(00000000,%d0:l:2),%a2@(8311)
    e02a:	6569           	bcss 0xe095
    e02c:	7465           	moveq #101,%d2
    e02e:	7220           	moveq #32,%d1
    e030:	6d69           	blts 0xe09b
    e032:	7420           	moveq #32,%d2
    e034:	5461           	addqw #2,%a1@-
    e036:	7374 652e 2e2e 	mvsw %a4@(00002e2e)@(00000070,%d6:w:4),%d1
    e03c:	0070 
    e03e:	7472           	moveq #114,%d2
    e040:	3d25           	movew %a5@-,%fp@-
    e042:	732c 2025      	mvsb %a4@(8229),%d1
    e046:	7320           	mvsb %a0@-,%d1
    e048:	6973           	bvss 0xe0bd
    e04a:	206e 756c      	moveal %fp@(30060),%a0
    e04e:	6c20           	bges 0xe070
    e050:	706f           	moveq #111,%d0
    e052:	696e           	bvss 0xe0c2
    e054:	7465           	moveq #101,%d2
    e056:	722c           	moveq #44,%d1
    e058:	2063           	moveal %a3@-,%a0
    e05a:	6861           	bvcs 0xe0bd
    e05c:	7220           	moveq #32,%d1
    e05e:	2563 3d27      	movel %a3@-,%a2@(15655)
    e062:	6127           	bsrs 0xe08b
    e064:	0a00 6865      	eorib #101,%d0
    e068:	7820           	moveq #32,%d4
    e06a:	2578 203d 2066 	movel 0x203d,%a2@(8294)
    e070:	662c           	bnes 0xe09e
    e072:	2068 6578      	moveal %a0@(25976),%a0
    e076:	3032 3d25 3032 	movew %a2@(00003032)@(00000000,%d3:l:4),%d0
    e07c:	780a           	moveq #10,%d4
    e07e:	0073 6967 6e65 	oriw #26983,%a3@(00000065,%d6:l:8)
    e084:	6420           	bccs 0xe0a6
    e086:	2564 203d      	movel %a4@-,%a2@(8253)
    e08a:	2025           	movel %a5@-,%d0
    e08c:	7555           	mvsw %a5@,%d2
    e08e:	203d           	.short 0x203d
    e090:	2030 7825      	movel %a0@(00000025,%d7:l),%d0
    e094:	580a           	.short 0x580a
    e096:	006d 6573 7361 	oriw #25971,%a5@(29537)
    e09c:	6765           	beqs 0xe103
    e09e:	0025 6420      	orib #32,%a5@-
    e0a2:	2573 2873 2920 	movel %a3@(00000073,%d2:l),%a2@(10528)
    e0a8:	7769 7468      	mvsw %a1@(29800),%d3
    e0ac:	2025           	movel %a5@-,%d0
    e0ae:	250a           	movel %a2,%a2@-
    e0b0:	0072 6967 6874 	oriw #26983,%a2@(00000074,%d6:l)
    e0b6:	006c 6566 7400 	oriw #25958,%a4@(29696)
    e0bc:	6a75           	bpls 0xe133
    e0be:	7374 6966 793a 	mvsw %a4@(0000793a)@(0000206c),%d1
    e0c4:	206c 
    e0c6:	6566           	bcss 0xe12e
    e0c8:	743d           	moveq #61,%d2
    e0ca:	2225           	movel %a5@-,%d1
    e0cc:	2d31 3073      	movel %a1@(00000073,%d3:w),%fp@-
    e0d0:	222c 2072      	movel %a4@(8306),%d1
    e0d4:	6967           	bvss 0xe13d
    e0d6:	6874           	bvcs 0xe14c
    e0d8:	3d22           	movew %a2@-,%fp@-
    e0da:	2531 3073      	movel %a1@(00000073,%d3:w),%a2@-
    e0de:	220a           	movel %a2,%d1
    e0e0:	005b 6c65      	oriw #27749,%a3@+
    e0e4:	6e3d           	bgts 0xe123
    e0e6:	2564 5d20      	movel %a4@-,%a2@(23840)
    e0ea:	2573 0020 2020 	movel %a3@(00000020,%d0:w),%a2@(8224)
    e0f0:	2020           	movel %a0@-,%d0
    e0f2:	7061           	moveq #97,%d0
    e0f4:	6464           	bccs 0xe15a
    e0f6:	696e           	bvss 0xe166
    e0f8:	6720           	beqs 0xe11a
    e0fa:	2870 6f73 293a 	moveal %a0@(293a207a)@(65726f3d),%a4
    e100:	207a 6572 6f3d 
    e106:	5b25           	subqb #5,%a5@-
    e108:	3034 645d      	movew %a4@(0000005d,%d6:w:4),%d0
    e10c:	2c20           	movel %a0@-,%d6
    e10e:	6c65           	bges 0xe175
    e110:	6674           	bnes 0xe186
    e112:	3d5b 252d      	movew %a3@+,%fp@(9517)
    e116:	3464           	moveaw %a4@-,%a2
    e118:	5d2c 2072      	subqb #6,%a4@(8306)
    e11c:	6967           	bvss 0xe185
    e11e:	6874           	bvcs 0xe194
    e120:	3d5b 2534      	movew %a3@+,%fp@(9524)
    e124:	645d           	bccs 0xe183
    e126:	0a00 7061      	eorib #97,%d0
    e12a:	6464           	bccs 0xe190
    e12c:	696e           	bvss 0xe19c
    e12e:	6720           	beqs 0xe150
    e130:	286e 6567      	moveal %fp@(25959),%a4
    e134:	293a 207a      	movel %pc@(0x101b0),%a4@-
    e138:	6572           	bcss 0xe1ac
    e13a:	6f3d           	bles 0xe179
    e13c:	5b25           	subqb #5,%a5@-
    e13e:	3034 645d      	movew %a4@(0000005d,%d6:w:4),%d0
    e142:	2c20           	movel %a0@-,%d6
    e144:	006c 6566 743d 	oriw #25958,%a4@(29757)
    e14a:	5b25           	subqb #5,%a5@-
    e14c:	2d34 645d      	movel %a4@(0000005d,%d6:w:4),%fp@-
    e150:	2c20           	movel %a0@-,%d6
    e152:	0072 6967 6874 	oriw #26983,%a2@(00000074,%d6:l)
    e158:	3d5b 2534      	movew %a3@+,%fp@(9524)
    e15c:	645d           	bccs 0xe1bb
    e15e:	0a00 5b25      	eorib #37,%d0
    e162:	645d           	bccs 0xe1c1
    e164:	2025           	movel %a5@-,%d0
    e166:	7300           	mvsb %d0,%d1
    e168:	2b20           	movel %a0@-,%a5@-
    e16a:	666f           	bnes 0xe1db
    e16c:	726d           	moveq #109,%d1
    e16e:	6174           	bsrs 0xe1e4
    e170:	3a20           	movew %a0@-,%d5
    e172:	696e           	bvss 0xe1e2
    e174:	743a           	moveq #58,%d2
    e176:	2025           	movel %a5@-,%d0
    e178:	2b64 2c20      	movel %a4@-,%a5@(11296)
    e17c:	252b 642c      	movel %a3@(25644),%a2@-
    e180:	2064           	moveal %a4@-,%a0
    e182:	6f75           	bles 0xe1f9
    e184:	626c           	bhis 0xe1f2
    e186:	653a           	bcss 0xe1c2
    e188:	2025           	movel %a5@-,%d0
    e18a:	2b2e 3166      	movel %fp@(12646),%a5@-
    e18e:	2c20           	movel %a0@-,%d6
    e190:	252b 2e31      	movel %a3@(11825),%a2@-
    e194:	662c           	bnes 0xe1c2
    e196:	2072 6573 6574 	moveal %a2@(65743a20)@(25642c20),%a0
    e19c:	3a20 2564 2c20 
    e1a2:	252e 3166      	movel %fp@(12646),%a2@-
    e1a6:	0a00 252e      	eorib #46,%d0
    e1aa:	3266           	moveaw %fp@-,%a1
    e1ac:	2069 7320      	moveal %a1@(29472),%a0
    e1b0:	6120           	bsrs 0xe1d2
    e1b2:	646f           	bccs 0xe223
    e1b4:	7562           	mvsw %a2@-,%d2
    e1b6:	6c65           	bges 0xe21d
    e1b8:	0a00 6d75      	eorib #117,%d0
    e1bc:	6c74           	bges 0xe232
    e1be:	6970           	bvss 0xe230
    e1c0:	6c65           	bges 0xe227
    e1c2:	2075 6e73      	moveal %a5@(00000073,%d6:l:8),%a0
    e1c6:	6967           	bvss 0xe22f
    e1c8:	6e65           	bgts 0xe22f
    e1ca:	6473           	bccs 0xe23f
    e1cc:	3a20           	movew %a0@-,%d5
    e1ce:	2575 2025 7520 	movel %a5@(00000025,%d2:w),%a2@(29984)
    e1d4:	2532 7520 2558 	movel %a2@(00002558,%d7:w:4),%a2@-
    e1da:	0a00 6d75      	eorib #117,%d0
    e1de:	6c74           	bges 0xe254
    e1e0:	6970           	bvss 0xe252
    e1e2:	6c65           	bges 0xe249
    e1e4:	2063           	moveal %a3@-,%a0
    e1e6:	6861           	bvcs 0xe249
    e1e8:	7273           	moveq #115,%d1
    e1ea:	3a20           	movew %a0@-,%d5
    e1ec:	2563 2025      	movel %a3@-,%a2@(8229)
    e1f0:	6320           	blss 0xe212
    e1f2:	2563 2025      	movel %a3@-,%a2@(8229)
    e1f6:	630a           	blss 0xe202
    e1f8:	006d 756c 7469 	oriw #30060,%a5@(29801)
    e1fe:	706c           	moveq #108,%d0
    e200:	6520           	bcss 0xe222
    e202:	646f           	bccs 0xe273
    e204:	7562           	mvsw %a2@-,%d2
    e206:	6c65           	bges 0xe26d
    e208:	733a 2025      	mvsb %pc@(0x1022f),%d1
    e20c:	6620           	bnes 0xe22e
    e20e:	252e 3166      	movel %fp@(12646),%a2@-
    e212:	2025           	movel %a5@-,%d0
    e214:	322e 3066      	movew %fp@(12390),%d1
    e218:	2025           	movel %a5@-,%d0
    e21a:	2e32 6620      	movel %a2@(00000020,%d6:w:8),%d7
    e21e:	252e 3366      	movel %fp@(13158),%a2@-
    e222:	2025           	movel %a5@-,%d0
    e224:	2e32 6620      	movel %a2@(00000020,%d6:w:8),%d7
    e228:	5b25           	subqb #5,%a5@-
    e22a:	2d38 2e33      	movel 0x2e33,%fp@-
    e22e:	665d           	bnes 0xe28d
    e230:	0a00 646f      	eorib #111,%d0
    e234:	7562           	mvsw %a2@-,%d2
    e236:	6c65           	bges 0xe29d
    e238:	2073 7065      	moveal %a3@(00000065,%d7:w),%a0
    e23c:	6369           	blss 0xe2a7
    e23e:	616c           	bsrs 0xe2ac
    e240:	2063           	moveal %a3@-,%a0
    e242:	6173           	bsrs 0xe2b7
    e244:	6573           	bcss 0xe2b9
    e246:	3a20           	movew %a0@-,%d5
    e248:	2566 2025      	movel %fp@-,%a2@(8229)
    e24c:	2e66           	moveal %fp@-,%sp
    e24e:	2025           	movel %a5@-,%d0
    e250:	2e30 6620      	movel %a0@(00000020,%d6:w:8),%d7
    e254:	2532 6620      	movel %a2@(00000020,%d6:w:8),%a2@-
    e258:	2532 2e66      	movel %a2@(00000066,%d2:l:8),%a2@-
    e25c:	2025           	movel %a5@-,%d0
    e25e:	322e 3066      	movew %fp@(12390),%d1
    e262:	0a00 726f      	eorib #111,%d0
    e266:	756e 6469      	mvsw %fp@(25705),%d2
    e26a:	6e67           	bgts 0xe2d3
    e26c:	2064           	moveal %a4@-,%a0
    e26e:	6f75           	bles 0xe2e5
    e270:	626c           	bhis 0xe2de
    e272:	6573           	bcss 0xe2e7
    e274:	3a20           	movew %a0@-,%d5
    e276:	252e 3166      	movel %fp@(12646),%a2@-
    e27a:	2025           	movel %a5@-,%d0
    e27c:	2e31 6620      	movel %a1@(00000020,%d6:w:8),%d7
    e280:	252e 3366      	movel %fp@(13158),%a2@-
    e284:	2025           	movel %a5@-,%d0
    e286:	2e32 6620      	movel %a2@(00000020,%d6:w:8),%d7
    e28a:	5b25           	subqb #5,%a5@-
    e28c:	2d38 2e33      	movel 0x2e33,%fp@-
    e290:	665d           	bnes 0xe2ef
    e292:	0a00 2a2a      	eorib #42,%d0
    e296:	2a2a 2053      	movel %a2@(8275),%d5
    e29a:	7472           	moveq #114,%d2
    e29c:	696e           	bvss 0xe30c
    e29e:	6720           	beqs 0xe2c0
    e2a0:	6c6f           	bges 0xe311
    e2a2:	6e67           	bgts 0xe30b
    e2a4:	6572           	bcss 0xe318
    e2a6:	2074 6861      	moveal %a4@(00000061,%d6:l),%a0
    e2aa:	7420           	moveq #32,%d2
    e2ac:	3332 4279      	movew %a2@(00000079,%d4:w:2),%a1@-
    e2b0:	7465           	moveq #101,%d2
    e2b2:	7320           	mvsb %a0@-,%d1
    e2b4:	4142           	.short 0x4142
    e2b6:	4344           	.short 0x4344
    e2b8:	4546           	.short 0x4546
    e2ba:	4748           	.short 0x4748
    e2bc:	494a           	.short 0x494a
    e2be:	4b4c           	.short 0x4b4c
    e2c0:	4d4e           	.short 0x4d4e
    e2c2:	4f50           	.short 0x4f50
    e2c4:	5152           	subqw #8,%a2@
    e2c6:	5354           	subqw #1,%a4@
    e2c8:	5556           	subqw #2,%fp@
    e2ca:	5758           	subqw #3,%a0@+
    e2cc:	595a           	subqw #4,%a2@+
    e2ce:	3031 3233      	movew %a1@(00000033,%d3:w:2),%d0
    e2d2:	3435 3637      	movew %a5@(00000037,%d3:w:8),%d2
    e2d6:	3839 202a 2a2a 	movew 0x202a2a2a,%d4
    e2dc:	2a00           	movel %d0,%d5
    e2de:	206d 656d      	moveal %a5@(25965),%a0
    e2e2:	3120           	movew %a0@-,%a0@-
    e2e4:	3d20           	movew %a0@-,%fp@-
    e2e6:	3078 256c      	moveaw 0x256c,%a0
    e2ea:	782c           	moveq #44,%d4
    e2ec:	206d 656d      	moveal %a5@(25965),%a0
    e2f0:	3220           	movew %a0@-,%d1
    e2f2:	3d20           	movew %a0@-,%fp@-
    e2f4:	3078 256c      	moveaw 0x256c,%a0
    e2f8:	780a           	moveq #10,%d4
    e2fa:	0020 5374      	orib #116,%a0@-
    e2fe:	6172           	bsrs 0xe372
    e300:	7420           	moveq #32,%d2
    e302:	6d65           	blts 0xe369
    e304:	6d6d           	blts 0xe373
    e306:	6f76           	bles 0xe37e
    e308:	6520           	bcss 0xe32a
    e30a:	5465           	addqw #2,%a5@-
    e30c:	7374 3a20      	mvsw %a4@(00000020,%d3:l:2),%d1
    e310:	284b           	moveal %a3,%a4
    e312:	4559           	.short 0x4559
    e314:	2900           	movel %d0,%a4@-
    e316:	0a0a           	.short 0x0a0a
    e318:	0046 6568      	oriw #25960,%d6
    e31c:	6c65           	bges 0xe383
    e31e:	7228           	moveq #40,%d1
    e320:	2564 293a      	movel %a4@-,%a2@(10554)
    e324:	2030 7825      	movel %a0@(00000025,%d7:l),%d0
    e328:	7820           	moveq #32,%d4
    e32a:	3d21           	movew %a1@-,%fp@-
    e32c:	3d20           	movew %a0@-,%fp@-
    e32e:	3078 2578      	moveaw 0x2578,%a0
    e332:	0a00 2053      	eorib #83,%d0
    e336:	7461           	moveq #97,%d2
    e338:	7274           	moveq #116,%d1
    e33a:	206d 656d      	moveal %a5@(25965),%a0
    e33e:	6370           	blss 0xe3b0
    e340:	7920           	mvsb %a0@-,%d4
    e342:	5465           	addqw #2,%a5@-
    e344:	7374 3a20      	mvsw %a4@(00000020,%d3:l:2),%d1
    e348:	284b           	moveal %a3,%a4
    e34a:	4559           	.short 0x4559
    e34c:	2900           	movel %d0,%a4@-
    e34e:	2053           	moveal %a3@,%a0
    e350:	7461           	moveq #97,%d2
    e352:	7274           	moveq #116,%d1
    e354:	204d           	moveal %a5,%a0
    e356:	414c           	.short 0x414c
    e358:	4c4f           	.short 0x4c4f
    e35a:	4320           	chkl %a0@-,%d1
    e35c:	5465           	addqw #2,%a5@-
    e35e:	7374 3a20      	mvsw %a4@(00000020,%d3:l:2),%d1
    e362:	284b           	moveal %a3,%a4
    e364:	4559           	.short 0x4559
    e366:	2900           	movel %d0,%a4@-
    e368:	5265           	addqw #1,%a5@-
    e36a:	6164           	bsrs 0xe3d0
    e36c:	7920           	mvsb %a0@-,%d4
    e36e:	210a           	movel %a2,%a0@-
    e370:	0020 2a2a      	orib #42,%a0@-
    e374:	2a2a 2a2a      	movel %a2@(10794),%d5
    e378:	2a2a 2056      	movel %a2@(8278),%d5
    e37c:	4d45           	.short 0x4d45
    e37e:	4d2d 5465      	chkl %a5@(21605),%d6
    e382:	7374 202a      	mvsw %a4@(0000002a,%d2:w),%d1
    e386:	2a2a 2a2a      	movel %a2@(10794),%d5
    e38a:	2a2a 2a2a      	movel %a2@(10794),%d5
    e38e:	2a0a           	movel %a2,%d5
    e390:	0050 7265      	oriw #29285,%a0@
    e394:	7373 2061      	mvsw %a3@(00000061,%d2:w),%d1
    e398:	6e79           	bgts 0xe413
    e39a:	206b 6579      	moveal %a3@(25977),%a0
    e39e:	2074 6f20 636f 	moveal %a4@(0000636f,%d6:l:8),%a0
    e3a4:	6e74           	bgts 0xe41a
    e3a6:	696e           	bvss 0xe416
    e3a8:	7565           	mvsw %a5@-,%d2
    e3aa:	2e2e 2e00      	movel %fp@(11776),%d7
