#!/bin/bash
#set -e

export SUFFIX=mingwoct${BITNESS}_trusty

if [ -z "$SETUP" ]; then
  mypwd=`pwd`
  export SUFFIXFILE=_$SUFFIX
  export SLURP_OS=trusty
  slurp mingw_octave
  export SLURP_CROSS=mingwoct
fi

source $RECIPES_DIR/hsl_mingw_common.sh