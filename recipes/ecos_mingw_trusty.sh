#!/bin/bash

export SUFFIX=mingw${BITNESS}_trusty

if [ -z "$SETUP" ]; then
  mingw_setup
  export FLAGS="ISWINDOWS=1 CC=$compilerprefix-gcc AR=$compilerprefix-ar RANLIB=$compilerprefix-ranlib"
  export SUFFIXFILE=_$SUFFIX
fi

source $RECIPES_FOLDER/ecos_common.sh
