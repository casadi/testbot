#!/bin/bash

export SUFFIX=trusty
source $RECIPES_FOLDER/knitro_common.sh
export LD_LIBRARY_PATH=$KNITRO:$LD_LIBRARY_PATH
