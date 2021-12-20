#! /usr/bin/env bash

set -e

cd build/xbuild
ct-ng build $@
