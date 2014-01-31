#!/bin/bash
# XBMC Updater and Installer Script
# By mdrjr.

XBMC_VERSION="LATEST"
TEMP="/tmp/xbmc-$XBMC_VERSION"
DATE=`date +%Y.%m.%d-%H.%M`

start_up() { 
	
	# attempt to clear old stuff
	echo "*** Cleaning Old Temp Files"
	rm -rf $TEMP
	
	# check if the board is supported!
	echo "*** Checking board support" 
	get_board
	
	# Create Temp folder
	echo "*** Creating Temp folder"
	mkdir -p $TEMP

	# check distro type to get the proper download url
	get_download_url

	# Try always to install needed packages to run XBMC! 
	try_apt_install_deps
	
	# Download XBMC
	xbmc_download
	
	# Install XBMC!
	install_xbmc
	
}

get_download_url() { 
	if [ -f /etc/hk-debian ]; then
		echo "*** Debian Found"
		export DISTRO="debian"
		XBMC_DL_URL="http://builder.mdrjr.net/xbmc12.2-debian/$XBMC_VERSION/xbmc12.2-debian.tar.xz"
	elif [ -f /etc/lsb-release ]; then
		echo "*** Ubuntu Found"
		export DISTRO="ubuntu"
		XBMC_DL_URL="http://builder.mdrjr.net/xbmc12.2/$XBMC_VERSION/xbmc12.2.tar.xz"
	fi
}



try_apt_install_deps() {
	echo "*** Calling APT to install dependencies needed"
	apt-get -y install libmicrohttpd10 libtinyxml2.6.2 libtinyxml2-0.0.0 libpcre3 libpcrecpp0 libpcre++0 libhal1 libhal-storage1 axel
}
	

install_xbmc() {
	echo "**** Unpacking XBMC 12.2"
	(cd / && tar -Jxf $TEMP/xbmc12.2.tar.xz)
	echo "*** Fix for Keyb/Mouse" 
	rm -rf /lib/udev/rules.d/50-udev-default.rules
	axel -o /lib/udev/rules.d/50-udev-default.rules -a http://builder.mdrjr.net/tools/udev_default_xubuntu_update
	chmod 4777 /usr/local/lib/xbmc/xbmc.bin
	echo "*** All done"
	sync
	echo "*** Please reboot to get a XBMC Experience"
}

xbmc_download() {
	# Downloads XBMC! 
	echo "*** Downloading XBMC"
	(cd $TEMP && axel -o xbmc12.2.tar.xz -n 5 -a $XBMC_DL_URL)
}

get_board() {
	B=`cat /proc/cpuinfo  | grep -i odroid | awk {'print $3'}`
	case "$B" in
		"ODROIDXU")
			export BOARD="odroidxu"
			echo "*** Found board ODROID-XU"
			echo "*** ODROID-XU Isn't Currently Supported!"
			exit 1
			;;
		"ODROIDX")
			export BOARD="odroidx"
			echo "*** Found board ODROID-X"
			;;
		"ODROIDX2")
			export BOARD="odroidx2"
			echo "*** Found board ODROID-X2"
			;;
		"ODROIDU2")
			export BOARD="odroidu2"
			echo "*** Found board ODROID-U2"
			;;
		*)
			echo "*** Couldn't find board! Aborting"
			exit 0
			;;
	esac
}

start_up
