#!/bin/bash

export SUFFIX=osx
  
if [ -z "$SETUP" ]; then
  export SUFFIXFILE=_$SUFFIX
  export FLAGS=""
fi

source $RECIPES_FOLDER/openblas_common.sh
