#!/bin/bash

fetch knitro $SUFFIX
export KNITRO=$HOME/build/knitro
pushd $KNITRO
find . -name "*.a" | xargs rm
popd
export casadi_build_flags="$casadi_build_flags -DWITH_KNITRO=ON"

