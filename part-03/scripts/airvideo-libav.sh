#!/bin/sh
# Configuration script for Air Video Server libav
# By dezi

export CFLAGS="-march=native -mfloat-abi=hard \
               -mfpu=neon -ftree-vectorize \
               -mvectorize-with-neon-quad \
               -ffast-math -mcpu=cortex-a9 \
               -mtune=cortex-a9 -mthumb \
               -O2 -pipe -fstack-protector \
               --param=ssp-buffer-size=4 \
               -D_FORTIFY_SOURCE=2"

./configure --enable-pthreads --disable-shared --enable-static \
    --enable-gpl --enable-libx264 --enable-libmp3lame \
    --enable-nonfree --enable-libfaac

