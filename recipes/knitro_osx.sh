#!/bin/bash
export SUFFIX=osx
source $RECIPES_FOLDER/knitro_common.sh
export DYLD_LIBRARY_PATH=$KNITRO:$DYLD_LIBRARY_PATH
