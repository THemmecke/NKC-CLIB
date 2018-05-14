The ToolChain runs on a 32 bit Ubuntu 14.04.3 LTS (Trusty Tahr).
Alternatively it can be set up in a chroot environment, which ist recommended for better portability.


This ReadMe describes the chroot installation on a 64-bit XUbuntu 18.04 LTS in /var/chroot.


1) Install XUbuntu 18.04 LTS 64 Bit

2) set up chroot :

2.1) install your prefered editor (vim or nano or ...):
sudo apt-get install vim

2.2) install schroot and debootstrap packages:
sudo apt-get install schroot
sudo apt-get install debootstrap
sudo mkdir /var/chroot

2.3) configure chroot:
sudo vim /etc/schroot/schroot.conf

add too the end of the file:

[Trusty-Tahr]
description=Ubuntu Trusty Tahr 32Bit
location=/var/chroot
priority=3
users=user
groups=sbuild
root-groups=root


2.4) install Trusty 32-Bit:
sudo debootstrap --arch i386 trusty /var/chroot http://de.archive.ubuntu.com/ubuntu

2.5) map chroot drives:
sudo mount -o bind /proc /var/chroot/proc  
sudo mount -o bind /dev /var/chroot/dev
sudo mount -o bind /sys /var/chroot/sys    

2.6) enter chroot:
sudo chroot /var/chroot /bin/bash

2.7) install some stuff in chroot:
sudo apt-get install vim
sudo apt-get install patch          
sudo apt-get install make       
sudo apt-get install zlib1g-dev 
sudo apt-get install libgmp-dev cd Download
sudo apt-get install libmpfr-devsudo cp * /var/chroot/home/m68k-tools
sudo apt-get install libmpc-dev   
sudo apt-get install git  

3) create directories:

cd home
mkdir m68k-tools
mkdir myCLIB

3.1) download tool chain packages (not in chroot)
http://www.uclinux.org/pub/uClinux/m68k-elf-tools/tools-20101118/
http://ftp.gnu.org/gnu/binutils/binutils-2.24.tar.bz2

3.2) open a terminal an copy files to chroot:
cd Download
sudo cp * /var/chroot/home/m68k-tools

3.4) go to chroot (sudo chroot /var/chroot /bin/bash) and build the tools:

3.5) edit 'build-uclinux-tools.sh' to use BinUtils Version 2.24
change: BINUTILSVERS="2.24"

cd home/m68k-tools

3.6) make 'build-uclinux-tools.sh' executable:
chmod 744 build-uclinux-tools.sh
and start (this may take some time)
./build-uclinux-tools.sh build


4) in the meantime, still in chroot, clone CLIB:
apt-get install git (if not already done)
cd home/myCLIB
git clone https://github.com/THemmecke/NKC-CLIB.git



5) if build (3.6) was successfull the CLIB can be build:

cd NKC-LIB
make

build test shell
cd projetcts/shell/
make


--> NKC68K.ROM can be run on NKC.



