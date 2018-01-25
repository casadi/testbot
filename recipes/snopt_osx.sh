#!/bin/bash
export SUFFIX=osx
source $RECIPES_FOLDER/snopt_common.sh
export DYLD_LIBRARY_PATH=$SNOPT:$DYLD_LIBRARY_PATH
