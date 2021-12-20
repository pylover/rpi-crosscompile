#! /usr/bin/env bash

RPI=berry


# Fetch some packages version from rpi
BINUTILS_VER=$(ssh $RPI ld --version | head -n1 | grep -Po '\d+\.\d+(\.\d+)?')
GCC_VER=$(ssh $RPI gcc --version | head -n1 | grep -Po '(?<=\s)\d+\.\d+(\.\d+)?' | head -n1)
LDD_VER=$(ssh $RPI ldd --version | head -n1 | grep -Po '(?<=\s)\d+\.\d+(\.\d+)?' | head -n1)

# BINUTILS_VER=2.35.2
# GCC_VER=10.2.1
# LDD_VER=2.31

echo "rpi's binutils version: $BINUTILS_VER"
echo "rpi's gcc version:      $GCC_VER"
echo "rpi's ldd version:      $LDD_VER"

# Create a directory for build
mkdir -p build
cd build

sudo apt install -y gcc g++ gperf bison flex texinfo help2man make \
  libncurses5-dev python3-dev autoconf automake libtool libtool-bin \
  gawk wget bzip2 xz-utils unzip patch libstdc++6 rsync git


# Install crosstool-ng
XTOOL=$(readlink -f xtool)
mkdir -p $XTOOL
git clone git@github.com:crosstool-ng/crosstool-ng.git crosstool-ng-src
cd crosstool-ng-src

./bootstrap
./configure --prefix=$XTOOL
make -j8
make install
cd ..

# Create dir for crosstool-ng build 
CTBUILD=$(readlink -f xbuild)
mkdir -p $CTBUILD/src
cd $CTBUILD

# Binutils patch
mkdir -p patches/binutils/$BINUTILS_VER
scp $RPI:/usr/src/binutils/patches/129_multiarch_libpath.patch \
  patches/binutils/$BINUTILS_VER
#$XTOOL/bin/ct-ng armv8-rpi3-linux-gnueabihf
#$XTOOL/bin/ct-ng menuconfig
cp ../../rpi3-config .config

export PATH="$XTOOL/bin:$PATH"
export DEB_TARGET_MULTIARCH=arm-linux-gnueabihf
$XTOOL/bin/ct-ng build -j8
