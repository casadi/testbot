#!/bin/bash

export SUFFIX=trusty

if [ -z "$SETUP" ]; then
  export FLAGS=""
  export SUFFIXFILE=_$SUFFIX
fi

source $RECIPES_FOLDER/ecos_common.sh
