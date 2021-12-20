#! /usr/bin/env bash

RPI=berry
XBUILD=$(readlink -f build/xbuild)
cd $XBUILD/armv8-rpi3-linux-gnueabihf/armv8-rpi3-linux-gnueabihf/sysroot

rsync -vrzLR --safe-links root@$RPI:/lib/ ./
rsync -vrzLR --safe-links root@$RPI:/usr/include/ ./
rsync -vrzLR --safe-links root@$RPI:/usr/lib/ ./
