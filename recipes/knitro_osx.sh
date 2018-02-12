#!/bin/bash
export SUFFIX=osx
source $RECIPES_FOLDER/knitro_common.sh
mv knitro/knitro-10.3.1-z-MacOS-64/* knitro
export MY_LIBRARY_PATH=$KNITRO/lib:$MY_LIBRARY_PATH
