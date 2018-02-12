#!/bin/bash

export SUFFIX=trusty
source $RECIPES_FOLDER/knitro_common.sh
pushd $KNITRO
find . -name "*.a" | xargs rm
popd
mv knitro/knitro-10.3.0-z-Linux-64/* knitro
export LD_LIBRARY_PATH=$KNITRO/lib:$LD_LIBRARY_PATH
ldd $KNITRO/lib/libknitro.so
