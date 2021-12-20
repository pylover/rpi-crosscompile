#! /usr/bin/env bash

if [ -z "$1" ]
  then
    echo "No argument supplied, please provide the raspberrypi's hostname"
    echo "Example: ./fsroot.sh myrpi"
fi

RPI=berry
XBUILD=$(readlink -f build/xbuild)
cd $XBUILD/armv8-rpi3-linux-gnueabihf/armv8-rpi3-linux-gnueabihf/sysroot

rsync -vrzLR --safe-links root@$RPI:/lib/ ./
rsync -vrzLR --safe-links root@$RPI:/usr/include/ ./
rsync -vrzLR --safe-links root@$RPI:/usr/lib/ ./
