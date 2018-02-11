#!/bin/bash
#set -e

export SUFFIX=mingw${BITNESS}_trusty

if [ -z "$SETUP" ]; then
  mypwd=`pwd`
  mingw_setup
  export SUFFIXFILE=_$SUFFIX
  
  export SLURP_OS=trusty
  export SLURP_CROSS=mingw
fi

source $RECIPES_DIR/hsl_mingw_common.sh