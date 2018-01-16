# NKC-CLIB
This is the source for a basic C run-time library customized for the legendary NKC (NDR Klein Comoputer) with a 68K CPU.

The library is based on the LADSoft CC386 compiler http://ladsoft.tripod.com/cc386_compiler.html.
The FAT file system used is based on elm chan's FatFs http://elm-chan.org/fsw/ff/00index_e.html

The given run-time library has been extended to provide support for filesystems and hardware devices through drivers.
It has been narrowed down to be used on NKC hardware (http://www.schuetz.thtec.org/), but can easily be extended/changed to be used on any other hardware.
Focus has been set on ease of use and understanding, therefore the i386 and other DOS/Win related parts have been removed and only necessary (68k) parts left.
