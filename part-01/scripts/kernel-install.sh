#!/bin/bash

sudo cp -f /boot/zImage /boot/zImage-`uname -r`
sudo cp -f /boot/uInitrd /boot/uInitrd-`uname -r`

sudo cp arch/arm/boot/zImage /boot/zImage-`cat include/config/kernel.release`
sudo cp .config /boot/config-`cat include/config/kernel.release`

sudo update-initramfs -c -k `cat include/config/kernel.release`

sudo mkimage -A arm -O linux -T ramdisk -C none -a 0 -e 0 -n uInitrd -d /boot/initrd.img-`cat include/config/kernel.release` /boot/uInitrd-`cat include/config/kernel.release`

sudo cp /boot/zImage-`cat include/config/kernel.release` /boot/zImage
sudo cp /boot/uInitrd-`cat include/config/kernel.release` /boot/uInitrd

