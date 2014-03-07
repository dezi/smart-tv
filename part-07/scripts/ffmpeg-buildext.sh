#!/bin/sh
# Build all external libs for ffmpeg
# By dezi

#
# XAVS bereitstellen
#
# XAVS ist ein chinesischer Video-Standard
# und wird wie folgt bereitgestellt:
#

svn co https://xavs.svn.sourceforge.net/svnroot/xavs/trunk xavs-snv
cd xavs-snv
./configure --enable-pic --disable-asm --enable-shared
make -j6
sudo make install
make clean
cd ..

#
# CELT bereitstellen
#
# CELT ist ein Audio-Codec mit sehr geringer Verzögerung
# und wird wie folgt bereitgestellt:
# 

git clone --depth 1 git://git.xiph.org/celt.git celt-git
cd celt-git
./autogen.sh
./configure --prefix=/usr/local
make -j6
sudo make install
make clean
cd ..

#
# FDK AAC bereitstellen
#
# FDK AAC ist der Open Source AAC Encoder
# des Fraunhofer Instituts und wird wie folgt
# bereitgestellt:
#

git clone --depth 1 https://github.com/mstorsjo/fdk-aac.git fdk-aac-git
cd fdk-aac-git
autoreconf -fiv
./configure
make -j6
sudo make install
make clean
cd ..

#
# AAC+ bereitstellen
#
# AAC+ ist ein hoch effizienter AAC+ Encoder der
# Firma Distrotech und wird wie folgt
# bereitgestellt:
#

git clone --depth 1 https://github.com/Distrotech/libaacplus.git libaacplus-git
cd libaacplus-git
./autogen.sh --enable-shared --enable-static
make -j6
sudo make install
make clean
cd ..

#
# ILBC bereitstellen
#
# ILBC ist eine Abkürzung für
# Internet Low Bitrate Codec und wird
# wie folgt bereitgestellt:
#

git clone --depth 1 https://github.com/dekkers/libilbc.git libilbc-git
cd libilbc-git
autoreconf -fiv
./configure
make -j6
sudo make install
make clean
cd ..

#
# NUT bereitstellen
#
# NUT ist ein Containerformat für FFmpeg,
# MPlayer und Libav der Firma Distrotech
# und wird wie folgt bereitgestellt:
#

git clone --depth 1 https://github.com/Distrotech/libnut libnut-git
cd libnut-git
echo "prefix = /usr/local" | tee -a Makefile
make -j6
sudo make install
make clean
cd ..

#
# UT-Video bereitstellen
#
# UT Video ist ein schneller, verlustfreier Video-Codec
# von Takeshi Umezawa und wird wie folgt bereitgestellt:
#

git clone --depth 1 https://github.com/qyot27/libutvideo.git libutvideo-git
cd libutvideo-git
./configure --enable-shared --enable-pic
make -j6
sudo make install
make clean
cd ..

#
# SHINE bereitstellen
#
# SHINE ist ein schneller Festkomma-MP3 Encoder
# und wird wie folgt bereitgestellt:
#

git clone https://github.com/savonet/shine.git shine-git
cd shine-git
./bootstrap
./configure
make -j6
sudo make install
make clean
cd ..

#
# ENCA bereitstellen
#
# ENCA ist ein Acronym für "Extremely Naive
# Charset Analyser" und wird wie folgt
# bereitgestellt:
#

wget http://ftp.de.debian.org/debian/pool/main/e/enca/enca_1.15.orig.tar.gz
tar xvf enca_1.15.orig.tar.gz
cd enca-1.15
sed -i 's/ln -s/ln -sf/g' configure
./configure --enable-shared --enable-static
make -j6
sudo make install
make clean
cd ..

#
# SOXR bereitstellen
#
# SOXR ist eine Audio-Resampler Bibliothek. Achtung, das
# Ganze wird zweimal compiliert, einmal als Shared-Library
# sowie darauf als Static-Library und wird wie folgt
# bereitgestellt:
#

wget http://sourceforge.net/projects/soxr/files/soxr-0.1.1-Source.tar.xz
tar xvf soxr-0.1.1-Source.tar.xz
cd soxr-0.1.1-Source
cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr/local -DBUILD_SHARED_LIBS=OFF
make -j6
sudo make install
cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr/local -DBUILD_SHARED_LIBS=ON
make -j6
sudo make install
make clean
cd ..

#
# GME bereitstellen
#
# GME ist ein Akronym für "Game Music Emulator". Achtung, das
# Ganze wird zweimal compiliert, einmal als Shared-Library
# sowie darauf als Static-Library und wird wie folgt
# bereitgestellt:
#

wget http://game-music-emu.googlecode.com/files/game-music-emu-0.6.0.tar.bz2
tar xvf game-music-emu-0.6.0.tar.bz2
cd game-music-emu-0.6.0
cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr/local
make -j6
sudo make install
sed -i 's/gme SHARED/gme STATIC/g' gme/CMakeLists.txt
cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr/local
make -j6
sudo make install
make clean
cd ..

#
# FriBiDi bereitstellen
#
# GNU FriBidi ist eine Implementation des
# "Unicode Bidirectional Algorithm" (bidi)
# und wird wie folgt bereitgestellt:
#

wget http://fribidi.org/download/fribidi-0.19.6.tar.bz2
tar xvf fribidi-0.19.6.tar.bz2
cd fribidi-0.19.6
./configure --enable-shared --enable-static
make -j6
sudo make install
make clean
cd ..

#
# VID.STAB bereitstellen
#
# VID.STAB ist ein Video-Stabilisierer. Achtung, das
# Ganze wird zweimal compiliert, einmal als Shared-Library
# sowie darauf als Static-Library und wird wie folgti
# bereitgestellt:
#

git clone --depth 1 https://github.com/georgmartius/vid.stab.git vid.stab-git
cd vid.stab-git
cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr/local
make -j6
sudo make install
sed -i 's/^add_library/##add_library/g' CMakeLists.txt
sed -i 's/^# add_library/add_library/g' CMakeLists.txt
cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr/local
make -j6
sudo make install
make clean
cd ..

#
# ALSA bereitstellen
#
# ALSA ist ein Akronym für "Advanced Linux Sound Architecture".
# Achtung, das Ganze wird zweimal compiliert, einmal als
# Shared-Library sowie darauf als Static-Library und wird
# wie folgt bereitgestellt:
#

wget http://ftp.de.debian.org/debian/pool/main/a/alsa-lib/alsa-lib_1.0.27.2.orig.tar.bz2
tar xvf alsa-lib_1.0.27.2.orig.tar.bz2
cd alsa-lib-1.0.27.2
./configure --enable-static --disable-shared --prefix=/usr/local --with-pic
make -j6
sudo make install
make clean
./configure --disable-static --enable-shared --prefix=/usr/local --with-pic
make -j6
sudo make install
make clean
cd ..

#
# PulseAudio bereitstellen
#
# PulseAudio enthält Header und Bibliotheken für
# Client-Entwicklungen und wird wie folgt
# bereitgestellt:
#

wget http://ftp.de.debian.org/debian/pool/main/p/pulseaudio/pulseaudio_4.0.orig.tar.xz
tar xvf pulseaudio_4.0.orig.tar.xz
cd pulseaudio-4.0
sed -i 's/const char \*const table/static const char *const table/g' src/pulse/channelmap.c
./configure --enable-shared --enable-static
make -j6
sudo make install
make clean
cd ..

#
# P11-Kit bereitstellen
#
# Das P11-Kit ist eine Bibliothek für Laden und
# Zugriffskoordination von PKCS#11-Modulen und
# wird wie folgt bereitgestellt:
#

wget http://ftp.de.debian.org/debian/pool/main/p/p11-kit/p11-kit_0.20.2.orig.tar.gz
tar xvf p11-kit_0.20.2.orig.tar.gz
cd p11-kit-0.20.2
sed -i 's/as_fn_error $? "p11-kit/as_echo_n $? "p11-kit/g' configure
./configure --enable-shared --enable-static
make -j6
sudo make install
cd ..

#
# TSlib bereitstellen
#
# TSlib ist eine Bibliothek für Touchscreens und
# wird wie folgt bereitgestellt:
#

wget http://ftp.de.debian.org/debian/pool/main/t/tslib/tslib_1.0.orig.tar.bz2
tar xvf tslib_1.0.orig.tar.bz2
cd tslib-1.0
./autogen.sh
./configure --enable-static
make -j6
sudo make install
make clean
cd ..

#
# ModPlug bereitstellen
#
# Ist eine Bibliothek für das MOD File Format
# der Amiga Systeme aus den späten 1980ger und
# wird wie folgt bereitgestellt:
#

wget http://ftp.de.debian.org/debian/pool/main/libm/libmodplug/libmodplug_0.8.8.4.orig.tar.gz
tar xvf libmodplug_0.8.8.4.orig.tar.gz
cd libmodplug-0.8.8.4
./configure --enable-static
make -j6
sudo make install
make clean
cd ..

#
# OpenCL bereitstellen
#
# Das Paket "Generic OpenCL ICD Loader"
# wird wie folgt bereitgestellt:
#

wget http://ftp.de.debian.org/debian/pool/main/o/ocl-icd/ocl-icd_2.1.3.orig.tar.gz
tar xvf ocl-icd_2.1.3.orig.tar.gz
cd ocl-icd-2.1.3
./configure --enable-static
make -j6
sudo make install
make clean
cd ..

#
# AVC1394 bereitstellen
#
# AVC1394 ist eine Bibliothek zur Kontrolle von
# Audio-/Videogeräten nach IEEE 1394 und wird
# wie folgt bereitgestellt:
#

wget http://ftp.de.debian.org/debian/pool/main/liba/libavc1394/libavc1394_0.5.4.orig.tar.gz
tar xvf libavc1394_0.5.4.orig.tar.gz
cd libavc1394-0.5.4
sed -i 's/get_unit_size/avc_get_unit_size/g' librom1394/rom1394_internal.c
sed -i 's/get_unit_size/avc_get_unit_size/g' librom1394/rom1394_main.c
./configure
make -j6
sudo make install
make clean
cd ..

#
# OpenAL bereitstellen
#
# Eine Software-Implementierung der OpenAL-API und
# wird wie folgt bereitgestellt:
#

wget http://ftp.de.debian.org/debian/pool/main/o/openal-soft/openal-soft_1.14.orig.tar.bz2
tar xvf openal-soft_1.14.orig.tar.bz2
cd openal-soft-1.14
wget http://ftp.de.debian.org/debian/pool/main/o/openal-soft/openal-soft_1.14-4.debian.tar.gz
tar xvf openal-soft_1.14-4.debian.tar.gz
patch -p1 -i debian/patches/no-fpuextended.patch
cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr/local -DLIBTYPE=STATIC -DEXAMPLES=OFF
make -j6
sudo make install
cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr/local -DLIBTYPE=SHARED -DEXAMPLES=OFF
make -j6
sudo make install
make clean
cd ..

#
# VA-API bereitstellen
#
# Das Video Acceleration API (VA) für Linux
# wird wie folgt bereitgestellt:
#

wget http://ftp.de.debian.org/debian/pool/main/libv/libva/libva_1.2.1.orig.tar.bz2
tar xvf libva_1.2.1.orig.tar.bz2
cd libva-1.2.1
./configure --enable-static --enable-shared
make -j6
sudo make install
make clean
cd ..

