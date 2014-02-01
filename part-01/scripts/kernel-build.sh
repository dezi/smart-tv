#!/bin/bash
# Build kernel and install script
# By dezi

make odroidu2_defconfig
make -j5 zImage modules
sudo make modules_install

