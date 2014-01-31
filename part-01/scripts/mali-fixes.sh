#!/bin/bash
# Fixes for Mali libraries.
# By dezi

cd /usr/lib/arm-linux-gnueabihf

sudo apt-get install libgles2-mesa-dev

sudo ln -sf libMali.so libEGL.so
sudo ln -sf libMali.so libEGL.so.1
sudo ln -sf libMali.so libEGL.so.1.0.0
sudo ln -sf libMali.so libEGL.so.1.4

sudo ln -sf libMali.so libGLESv1_CM.so
sudo ln -sf libMali.so libGLESv1_CM.so.1
sudo ln -sf libMali.so libGLESv1_CM.so.1.1
sudo ln -sf libMali.so libGLESv2.so
sudo ln -sf libMali.so libGLESv2.so.2
sudo ln -sf libMali.so libGLESv2.so.2.0
sudo ln -sf libMali.so libGLESv2.so.2.0.0

sudo chmod g-w,o-w libMali.so libUMP.so

ls -al libEGL*
ls -al libGLES*
ls -al libMali.so libUMP.so

