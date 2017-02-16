base ditribution is /pub/uClinux/m68k-elf-tools/tools-20101118
-> http://www.uclinux.org/pub/uClinux/m68k-elf-tools/tools-20101118/


Build on Ubuntu 14.04.3 LTS (Trusty Tahr)
- GCC 4.5.1 
  with gcc-4.5.1-psignal-const.patch
- BinUtils 2.24
- Linux 2.6.35

Step by step build on XUbuntu 14.04.03 LTS:


- install Xubuntu in a VM with 'xubuntu-14.04.3-desktop-i386.iso' 
- install additional packages:
  sudo apt-get install libgmp-dev
  sudo apt-get install libmpfr-dev
  sudo apt-get install libmpc-dev
  sudo apt-get install zlib1g-dev
  sudo apt-get build-essential
  
- download m68k-elf-tools (http://www.uclinux.org/pub/uClinux/m68k-elf-tools/tools-20101118/):
- download BinUtils 2.24 (http://ftp.gnu.org/gnu/binutils/binutils-2.24.tar.bz2)

- you directory should look like this:

-rw-rw-r-- 1 torsten torsten 17501436 Oct 28 12:51 binutils-2.20.1.tar.bz2
-rwxrw-r-- 1 torsten torsten 22716802 Oct 28 12:57 binutils-2.24.tar.bz2
-rwxrw-r-- 1 torsten torsten    22354 Oct 28 13:02 build-uclinux-tools.sh
-rw-rw-r-- 1 torsten torsten   126099 Oct 28 12:48 elf2flt-20100914.tar.gz
-rw-rw-r-- 1 torsten torsten      338 Oct 28 12:48 gcc-4.5.1-psignal-const.patch
-rw-rw-r-- 1 torsten torsten 66121821 Oct 28 12:57 gcc-4.5.1.tar.bz2
-rw-rw-r-- 1 torsten torsten     1187 Oct 28 12:48 genromfs-0.5.1.tar.gz
-rw-rw-r-- 1 torsten torsten     1187 Oct 28 12:49 linux-2.6.35.tar.gz
-rw-rw-r-- 1 torsten torsten 99644910 Oct 28 12:56 m68k-uclinux-tools-20101118.sh
-rw-rw-r-- 1 torsten torsten     1187 Oct 28 12:49 uClibc-0.9.31-m68k.config
-rw-rw-r-- 1 torsten torsten     1187 Oct 28 12:49 uClibc-0.9.31.tar.bz2


- edit build-uclinux-tools.sh
  - change: BINUTILSVERS="2.24"
  
- build 

  
  
  
*********************************************************************************************************  
- build in chroot on an arbitrary system (here XUbuntu 16.04-LTS (64Bit))


setup basic chroot:
  install chroot Trusty Thar (14.04LTS) 32Bit  in /var/chroot:

  -Install the schroot and debootstrap packages.
   sudo apt-get install schroot
   sudo apt-get install debootstrap  
   
  - create a directory for the chroot: sudo mkdir /var/chroot
  
  - open /etc/schroot/schroot.conf in a text editor: sudo vim /etc/schroot/schroot.conf
  - add:
    [Trusty-Tahr]
    description=Ubuntu Trusty Tahr 32Bit
    location=/var/chroot
    priority=3
    users=user
    groups=sbuild
    root-groups=root
  
  - install Trusty: debootstrap --arch i386 trusty /var/chroot http://de.archive.ubuntu.com/ubuntu
  
  - mount drives:
    sudo mount -o bind /proc /var/chroot/proc
    sudo mount -o bind /dev /var/chroot/dev
    sudo mount -o bind /sys /var/chroot/sys
  
  - change to chroot: sudo chroot /var/chroot /bin/bash

  - install:
    sudo apt-get install patch
    sudo apt-get install make
    sudo apt-get install zlib1g-dev
    sudo apt-get install libgmp-dev
    sudo apt-get install libmpfr-dev
    sudo apt-get install libmpc-dev  
    
    
  - download m68k-elf-tools (http://www.uclinux.org/pub/uClinux/m68k-elf-tools/tools-20101118/):
  - download BinUtils 2.24 (http://ftp.gnu.org/gnu/binutils/binutils-2.24.tar.bz2)

  - your directory should look like this:

    -rw-rw-r-- 1 torsten torsten 17501436 Oct 28 12:51 binutils-2.20.1.tar.bz2
    -rwxrw-r-- 1 torsten torsten 22716802 Oct 28 12:57 binutils-2.24.tar.bz2
    -rwxrw-r-- 1 torsten torsten    22354 Oct 28 13:02 build-uclinux-tools.sh
    -rw-rw-r-- 1 torsten torsten   126099 Oct 28 12:48 elf2flt-20100914.tar.gz
    -rw-rw-r-- 1 torsten torsten      338 Oct 28 12:48 gcc-4.5.1-psignal-const.patch
    -rw-rw-r-- 1 torsten torsten 66121821 Oct 28 12:57 gcc-4.5.1.tar.bz2
    -rw-rw-r-- 1 torsten torsten     1187 Oct 28 12:48 genromfs-0.5.1.tar.gz
    -rw-rw-r-- 1 torsten torsten     1187 Oct 28 12:49 linux-2.6.35.tar.gz
    -rw-rw-r-- 1 torsten torsten 99644910 Oct 28 12:56 m68k-uclinux-tools-20101118.sh
    -rw-rw-r-- 1 torsten torsten     1187 Oct 28 12:49 uClibc-0.9.31-m68k.config
    -rw-rw-r-- 1 torsten torsten     1187 Oct 28 12:49 uClibc-0.9.31.tar.bz2 

  - edit build-uclinux-tools.sh
      - change: BINUTILSVERS="2.24"
      
  - build 
    ./build-uclinux-tools.sh build