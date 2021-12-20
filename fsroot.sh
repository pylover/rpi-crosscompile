#! /usr/bin/env bash

set -e

if [ -z "$1" ]
  then
    echo "No argument supplied, please provide the raspberrypi's hostname"
    echo "Example: ./fsroot.sh myrpi"
    return 1
fi

RPI=$1
XBUILD=$(readlink -f build/xbuild)
cd $XBUILD/$ARCH/$ARCH/sysroot

rsync -vrzLR --safe-links root@$RPI:/lib/ ./
rsync -vrzLR --safe-links root@$RPI:/usr/include/ ./
rsync -vrzLR --safe-links root@$RPI:/usr/lib/ ./
