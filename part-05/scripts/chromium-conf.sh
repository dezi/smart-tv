#!/bin/sh
# Chromiunm Configuration
# By debian/dezi

# Disable SSE2
GYP_DEFINES="disable_sse2=1"

# Enable all codecs for HTML5 in chromium, depending on which ffmpeg sumo lib
# is installed, the set of usable codecs (at runtime) will still vary
GYP_DEFINES="$GYP_DEFINES proprietary_codecs=1"

# enable compile-time dependency on gnome-keyring
GYP_DEFINES="$GYP_DEFINES use_gnome_keyring=1 linux_link_gnome_keyring=1"

# controlling the use of GConf (the classic GNOME configuration
# and GIO, which contains GSettings (the new GNOME config system)
GYP_DEFINES="$GYP_DEFINES use_gconf=1 use_gio=1"

# disable native client (nacl)
GYP_DEFINES="$GYP_DEFINES disable_nacl=1"

#Debian Chromium Api Key
GYP_DEFINES += google_api_key='AIzaSyCkfPOPZXDKNn8hhgu3JrA62wIgC93d44k'
GYP_DEFINES += google_default_client_id='811574891467.apps.googleusercontent.com'
GYP_DEFINES += google_default_client_secret='kdloedMFGdGla2P1zacGjAQh'

# do not use embedded third_party/gold as the linker.
# GYP_DEFINES="$GYP_DEFINES linux_use_gold_binary=0 linux_use_gold_flags=0"

# disable tcmalloc
GYP_DEFINES="$GYP_DEFINES linux_use_tcmalloc=0"

# Use explicit library dependencies instead of dlopen.
# This makes breakages easier to detect by revdep-rebuild.
GYP_DEFINES="$GYP_DEFINES linux_link_gsettings=1"

# Use ARM architecture
GYP_DEFINES="$GYP_DEFINES target_arch=arm"
GYP_DEFINES="$GYP_DEFINES v8_use_arm_eabi_hardfloat=true"
GYP_DEFINES="$GYP_DEFINES arm_fpu=neon"
GYP_DEFINES="$GYP_DEFINES arm_float_abi=hard"
GYP_DEFINES="$GYP_DEFINES arm_thumb=1"
GYP_DEFINES="$GYP_DEFINES armv7=1"
GYP_DEFINES="$GYP_DEFINES arm_neon=1"
GYP_DEFINES="$GYP_DEFINES -DUSE_EABI_HARDFLOAT=1"

export GYP_DEFINES

