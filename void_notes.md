# Installation
access to bios: F12

### ISO prep
https://docs.voidlinux.org/installation/live-images/guide.html

### partitioning
- use bios
- uefi
- gpt
partitions:
https://www.youtube.com/watch?v=U33JUYeGu5M, 31:00

2GB      		EFI system         fat32   /boot/efi
a lot of GB   	Linux Filesystem   etx4    / (root) "most of your stuff goes here"
24GB     		Linux Swap         Linux Swap
...      		Linux Filesystem   etx4    /home "maybe do not create"

install: 10:00

## change default shell from sh to bash

## purge old kernels

sudo
uname -a
vkpurge list
vkpurge rm all

## add volume icon to bar

## build neovim from source, install extra stuff from xbps
use the relative bash script

## xfce window manager change keybinds

## install a nice font for the single user (comes preloaded now...)
<!-- #### sources -->
<!-- - https://www.youtube.com/watch?v=1rtlypzbtta -->
<!-- - https://www.fontsquirrel.com/fonts/nimbus-mono -->
<!-- - https://www.madeintext.com/zip-to-ttf/ -->
<!-- #### steps -->
<!-- 1. download font from source -->
<!-- 1. unzip using above website -->
<!-- 1. place into /home/guido/.local/share/fonts/ -->
<!-- 1. done -->

