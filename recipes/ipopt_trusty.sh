#!/bin/bash

export SUFFIX=trusty

if [ -z "$SETUP" ]; then
  export SUFFIXFILE=_$SUFFIX
  export FLAGS="coin_skip_warn_cxxflags=yes"
fi

source $RECIPES_FOLDER/ipopt_common.sh
