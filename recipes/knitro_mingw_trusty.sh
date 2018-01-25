#!/bin/bash

export SUFFIX=mingw${BITNESS}_trusty
source $RECIPES_FOLDER/knitro_common.sh
mv knitro-10.3.2-z-WinMSVC10-${BITNESS}/* .

