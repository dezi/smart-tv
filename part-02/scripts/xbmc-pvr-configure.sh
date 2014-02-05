#!/bin/sh
# XBMC configure script
# By dezi

./bootstrap

export CFLAGS="-march=native -mfloat-abi=hard \
-mfpu=neon -ftree-vectorize \
-mvectorize-with-neon-quad \
-ffast-math -mcpu=cortex-a9 \
-mtune=cortex-a9 -mthumb \
-O2 -pipe -fstack-protector \
--param=ssp-buffer-size=4 \
-D_FORTIFY_SOURCE=2"

./configure --prefix=/usr/local --enable-addons-with-dependencies
