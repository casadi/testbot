#!/bin/bash

export SUFFIX=osx
  
if [ -z "$SETUP" ]; then
  export FLAGS=""
  export SUFFIXFILE=_$SUFFIX
fi

source $RECIPES_FOLDER/ecos_common.sh
