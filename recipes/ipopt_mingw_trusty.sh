#!/bin/bash

export SUFFIX=mingw${BITNESS}_trusty

if [ -z "$SETUP" ]; then
  mingw_setup
  export SUFFIXFILE=_$SUFFIX
  # build must contain mingw, in order for the hsl loader to look for .dll as opposed to .so
  export FLAGS="--host $compilerprefix --enable-dependency-linking --build mingw32"
else
  export PKG_CONFIG_LIBDIR=$PKG_CONFIG_LIBDIR:$HOME/ipopt-install/lib/pkgconfig
fi
source $RECIPES_FOLDER/ipopt_common.sh
remote_access

