#!/bin/bash

export SUFFIX=dockcross_manylinux${BITNESS}

if [ -z "$SETUP" ]; then
  export BUILD_ENV=dockcross
  dockcross_setup_start
  dockcross_setup_finish
  export SUFFIXFILE=_$SUFFIX
  export FLAGS="coin_skip_warn_cxxflags=yes"
fi

source $RECIPES_FOLDER/ipopt_common.sh
