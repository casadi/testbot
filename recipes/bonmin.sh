#!/bin/bash

if [ -z "$SETUP" ]; then
  export SUFFIX=trusty
  export SUFFIXFILE=_$SUFFIX
  export FLAGS="coin_skip_warn_cxxflags=yes"
fi

source $RECIPES_FOLDER/bonmin_common.sh
