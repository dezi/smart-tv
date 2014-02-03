#!/bin/sh
# XBMC configure script
# By dezi

CPPFLAGS="-I/usr/include/samba-4.0"

CFLAGS="-march=native -mfloat-abi=hard -mfpu=neon -ftree-vectorize -mvectorize-with-neon-quad -ffast-math -mcpu=cortex-a9 -mtune=cortex-a9 -mthumb -O2 -pipe -fstack-protector --param=ssp-buffer-size=4 -D_FORTIFY_SOURCE=2"

export CPPFLAGS
export CFLAGS

./configure \
  --build=armv7a-hardfloat-linux-gnueabi \
  --host=armv7a-hardfloat-linux-gnueabi \
  --disable-ccache \
  --disable-vdpau \
  --disable-vaapi \
  --disable-gl \
  --enable-exynos4 \
  --enable-gles \
  --enable-x11

