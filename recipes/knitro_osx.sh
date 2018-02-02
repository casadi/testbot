#!/bin/bash
export SUFFIX=osx
source $RECIPES_FOLDER/knitro_common.sh
mv knitro-10.3.1-z-MacOS-64/* .
export MY_LIBRARY_PATH=$KNITRO:$MY_LIBRARY_PATH
