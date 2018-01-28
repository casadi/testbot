#!/bin/bash

export SUFFIX=mingw${BITNESS}_trusty
source $RECIPES_FOLDER/snopt_common.sh
# we need the import library
rm $HOME/build/snopt/*dll
