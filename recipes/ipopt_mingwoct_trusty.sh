#!/bin/bash

export SUFFIX=mingwoct${BITNESS}_trusty

if [ -z "$SETUP" ]; then
  export SLURP_OS=trusty
  echo "ipopt_mingw_start:$BAKEVERSION:"
  pushd $HOME/build
  slurp mingw_octave
  popd
  echo "ipopt_mingw_end:$BAKEVERSION:"
  export SUFFIXFILE=_$SUFFIX
  # build must contain mingw, in order for the hsl loader to look for .dll as opposed to .so
  i686-w64-mingw32-gcc --version
  export FLAGS="--host $compilerprefix --enable-dependency-linking --build mingw32 coin_skip_warn_cxxflags=yes"
fi

source $RECIPES_FOLDER/ipopt_common.sh

