#!/bin/bash

export SUFFIX=mingw${BITNESS}_trusty

if [ -z "$SETUP" ]; then
  mingw_setup
  export SUFFIXFILE=_$SUFFIX
  # build must contain mingw, in order for the hsl loader to look for .dll as opposed to .so
  export FLAGS="--host $compilerprefix --enable-dependency-linking --build mingw32"
fi
source $RECIPES_FOLDER/ipopt_common.sh

