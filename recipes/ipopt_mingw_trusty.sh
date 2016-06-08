#!/bin/bash

set -e

export SUFFIX=mingw${BITNESS}_trusty
export SUFFIXFILE=_$SUFFIX
# build must contain mingw, in order for the hsl loader to look for .dll as opposed to .so
export FLAGS="--host $compilerprefix --enable-dependency-linking --build mingw32"
source recipes/ipopt_common.sh
