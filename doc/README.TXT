Hi,
	This is the source for a basic C run-time library.  The library
is mostly ansi; some work is required to interface file/Io and memory
management functions in with the underlying operating system.  See the
files in MSDOS/386 for example code showing how to interface the RTL
into DOS using a DPMI subsystem (in this case TRAN's PMODE 3.07).

This RTL has suitable code for both the 386 and the 68K processors.
Most of the code is in C but some of it (notably string handling
functions) were written in assembly for speed.

This RTL is a companion file to the two files:

ccdl139e.zip - C compiler executables with DOS libraries (for DOS)
ccdl139s.zip - C compiler sources

Which should also be available on the distribution site you got this
from.  Read the LICENSE.TXT file for redistribution information.	

See license.txt for licensing information.

David Lindauer
1428 Hepburn Ln. Apt #1
Louisville, KY 40204

email:  gclind01@starbase.spd.louisville.edu



The given run-time library has been extended to provide support for filesystems and hardware devices through drivers.
It has been narrowed down to be used on NKC hardware (http://www.schuetz.thtec.org/), but can easily be extended/changed to be used on any other hardware.
Focus has been set on ease of use and understanding, therefore the i386 and other DOS/Win related parts have been removed and only necessary (68k) parts left.

The used FAT file system was developed by Elm Chang (http://elm-chan.org/fsw/ff/00index_e.html) and has been integrated in the filesystem with minor changes.

TorstenHemmecke@yahoo.de
