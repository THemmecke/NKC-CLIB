#ifndef _PHITEXT_H_
#define _PHITEXT_H_

#define SYM_VAC		(0x7f)
#define SYM_EQ		((4<<7)+33)
#define SYM_NE		((4<<7)+37)
#define SYM_ALTSTAR     ((4<<7)+38)
#define SYM_ALTDIV	((4<<7)+42)
#define SYM_LE		((4<<7)+50)
#define SYM_GE		((4<<7)+51)
#define SYM_SHL		((4<<7)+122)
#define SYM_SHR		((4<<7)+123)
#define SYM_LB 		((1<<7)+0x49)
#define SYM_CENT	((1<<7)+0x4a)
#define SYM_YEN		((1<<7)+0x4b)

#define BOLD 16
#define FLASH 8
#define HIDDEN 4
#define UNDERLINE 2
#define BOLD 1

#define DKBLACK 0
#define DKRED 1
#define DKORANGE 2
#define DKYELLOW 3
#define DKGREEN 4
#define DKBLUE 5
#define DKPURPLE 6
#define DKWHITE 7
#define LTBLACK 8
#define LTRED 9
#define LTORANGE 10
#define LTYELLOW 11
#define LTGREEN 12
#define LTBLUE 13
#define LTPURPLE 14
#define LTWHITE 15

typedef struct {
	char size;
	char style;
	char bgc;
	char fgc;
	char attrib;
	char bank;
	char cwb;
	long repsize;
} PHITEXT;

#endif /* _PHITEXT_H_ */