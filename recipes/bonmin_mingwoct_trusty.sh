#!/bin/bash

export SUFFIX=mingwoct${BITNESS}_trusty

if [ -z "$SETUP" ]; then
  export SLURP_OS=trusty
  slurp mingw_octave
  export SUFFIXFILE=_$SUFFIX
  # build must contain mingw, in order for the hsl loader to look for .dll as opposed to .so
  export FLAGS="--host $compilerprefix --enable-dependency-linking --build mingw32 coin_skip_warn_cxxflags=yes --disable-pkg-config"
fi

source $RECIPES_FOLDER/bonmin_common.sh
