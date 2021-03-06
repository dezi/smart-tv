#!/bin/sh

cd
cd install

rm -rf odroid-3.8.y

git clone --depth 1 https://github.com/hardkernel/linux.git -b odroid-3.8.y odroid-3.8.y

cd odroid-3.8.y

wget --no-check-certificate https://raw.github.com/dezi/smart-tv/master/part-02/configs/$1
mv $1 arch/arm/configs/$1

rm rt2x00.dezi.diff*
wget --no-check-certificate https://raw.github.com/dezi/smart-tv/master/part-02/patches/rt2x00.dezi.diff
git apply rt2x00.dezi.diff

make $1

make -j5 zImage modules

sudo make modules_install

sudo cp arch/arm/boot/zImage /boot/zImage-`cat include/config/kernel.release`
sudo cp .config /boot/config-`cat include/config/kernel.release`
sudo update-initramfs -c -t -k `cat include/config/kernel.release`
sudo mkimage -A arm -O linux -T ramdisk -C none -a 0 -e 0 -n uInitrd -d /boot/initrd.img-`cat include/config/kernel.release` /boot/uInitrd-`cat include/config/kernel.release`

sudo cp /boot/zImage-`cat include/config/kernel.release` /boot/zImage
sudo cp /boot/uInitrd-`cat include/config/kernel.release` /boot/uInitrd

sudo mv /etc/modprobe.d/blacklist-ralink.conf /etc/modprobe.d/blacklist-ralink.noconf
sudo rm -f /etc/modprobe.d/rtl8192cu.conf
