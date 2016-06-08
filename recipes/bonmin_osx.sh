#!/bin/bash

if [ -z "$SETUP" ]; then
  export SUFFIX=osx
  export SUFFIXFILE=_$SUFFIX
  export FLAGS=""
fi

source $RECIPES_FOLDER/bonmin_common.sh
