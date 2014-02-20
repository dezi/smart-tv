#!/bin/sh
# Rom Collections Browser patch
# By dezi

wget https://raw.github.com/dezi/smart-tv/master/part-03/patches/mame.xbmc.patch

unzip script.games.rom.collection.browser-2.0.10.zip

cd script.games.rom.collection.browser

cd resources

git apply ../../mame.xbmc.patch

cd ../..

zip -r script.games.rom.collection.browser-2.0.10-patched.zip script.games.rom.collection.browser

rm -f script.games.rom.collection.browser-2.0.10.zip

rm -rf script.games.rom.collection.browser

