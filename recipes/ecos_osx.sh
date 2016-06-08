#!/bin/bash

set -e

if [ -z "$SETUP" ]; then
  export FLAGS=""
  export SUFFIX=osx
  export SUFFIXFILE=_$SUFFIX
fi

source $RECIPES_FOLDER/ecos_common.sh
