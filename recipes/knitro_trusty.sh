#!/bin/bash

export SUFFIX=trusty
source $RECIPES_FOLDER/knitro_common.sh
ls
ls knitro
mv knitro/knitro-10.3.0-z-Linux-64/* knitro
export LD_LIBRARY_PATH=$KNITRO:$LD_LIBRARY_PATH
