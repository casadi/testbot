#!/bin/bash

set -e

mingw_setup
export FLAGS="ISWINDOWS=1 CC=$compilerprefix-gcc AR=$compilerprefix-ar RANLIB=$compilerprefix-ranlib"
export SUFFIX=mingw${BITNESS}_trusty
export SUFFIXFILE=_$SUFFIX
source recipes/ecos_common.sh