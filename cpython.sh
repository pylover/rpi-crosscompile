#! /usr/bin/env bash

set -e
if [ -z "$1" ]
  then
    echo "No argument supplied, please provide the python version"
    echo "Example: ./cpython.sh 3.8"
fi

PYVER=$1

mkdir -p build/cpython
cd build/cpython
INSTALL=$(readlink -f install)
mkdir -p $INSTALL

if [ ! -d cpython ]; then
  git clone git@github.com:python/cpython.git -b$PYVER --depth=1
fi

export CC=$ARCH-gcc 
export CXX=$ARCH-g++
export AR=$ARCH-ar
export RANLIB=$ARCH-ranlib \

cd cpython
./configure \
  --host=$ARCH \
  --target=$ARCH \
  --build=x86_64-linux-gnu \
  --prefix=$INSTALL \
  --disable-ipv6 \
  --enable-shared \
  ac_cv_file__dev_ptmx=no \
  ac_cv_file__dev_ptc=no \
  ac_cv_have_long_long_format=yes


make \
    BLDSHARED="$ARCH-gcc -shared" \
    CROSS-COMPILE="$ARCH-" \
    CROSS_COMPILE_TARGET=yes \
    HOSTARCH=arm-linux \
    BUILDARCH=$ARCH \
    -j8


make altinstall \
    BLDSHARED="$ARCH-gcc -shared" \
    CROSS-COMPILE="$ARCH-" \
    CROSS_COMPILE_TARGET=yes \
    HOSTARCH=arm-linux \
    BUILDARCH=$ARCH \
    prefix=$INSTALL
