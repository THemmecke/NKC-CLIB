	.text
	.global _ll_init_std,  __ll_seek,  __ll_getpos, __ll_close, __ll_creat, __ll_open
/*************************************************************************
 * _llinit  setup standard files (stdio, stderr)
 *************************************************************************/
_ll_init_std:
#ifdef M68000
	lea output_file,%a0	
	lea _pstreams,%a1	
#else
	lea output_file(%pc),%a0	
	lea _pstreams(%pc),%a1	
#endif
	move.l %a0,(%a1)+
	move.l %a0,(%a1)+
#ifdef M68000
	lea error_file,%a0
#else
	lea error_file(%pc),%a0
#endif
	move.l %a0,(%a1)+
	move.l #10,maxfiles
	rts
/*************************************************************************
 *
 * int _llopen(char *name, int flags)
 * open an existing file, return handle
 *************************************************************************/
__ll_open:
	move.l 4(%sp),%a0 /* *name */
	move.l 8(%sp),%d0 /* flags */
	rts
/*************************************************************************
*
* int _ll_creat(char *name, int flags)
* create new file, if file exists it will be truncated to zero legth
 *************************************************************************/
__ll_creat:
	move.l 4(%sp),%a0 /* *name */
	move.l 8(%sp),%d0 /* flags */
	rts
/*************************************************************************
*
* void _ll_close(int fd)
* close file
 *************************************************************************/
__ll_close:
	move.l 4(%sp),%d0 /* fd */
	rts

/*************************************************************************
*
* int _ll_getpos(int fd)
* in DOS: seek to current position, current position is returned
 *************************************************************************/
__ll_getpos:
	move.l 4(%sp),%d0 /* fd */
	rts
	
/*************************************************************************
 * int _ll_flags(int flags)
        convert _F_READ(1) => 0
        	_F_WRIT(2) => 1
 *************************************************************************/ 
__ll_flags:
	move.l 4(%sp),%d1 /* flags */	
	clr.l %d0
	btst #1,%d1  /* _F_READ ? */
	beq _nowrit
	addq #1,%d0
	btst #2,%d1  /* _F_WRIT ? */
	beq _nowrit
	addq #1,%d0  /* _F_READ | _F_WRIT */
_nowrit:
	rts
/*************************************************************************
 *
 * void _ll_seek(int fd, int pos, int origin)
 * set file position, fd = file descriptor, pos = offset into file, origin = method
 * origin = 0 => pos gives absolute offset from start of file
 * origin = 1 => pos gives offset from current file pointer
 * origin = 2 => pos gives signed offset from EOF
 *************************************************************************/
__ll_seek:
	move.l %d2,-(%sp)	/* save %d2 */
	
	move.l 8(%sp),%d0 	/* fd */
	move.l 12(%sp),%d1 	/* pos */
	move.l 16(%sp),%d2 	/* origin */

	move.l (%sp)+, %d2	/* restore %d2 */
	
	rts
