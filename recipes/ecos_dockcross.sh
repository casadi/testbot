#!/bin/bash

export SUFFIX=manylinux${BITNESS}_dockcross

if [ -z "$SETUP" ]; then
  export BUILD_ENV=dockcross
  dockcross_setup_start
  dockcross_setup_finish
  export FLAGS=""
  export SUFFIXFILE=_$SUFFIX
fi

source $RECIPES_FOLDER/ecos_common.sh
