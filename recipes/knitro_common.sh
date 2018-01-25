#!/bin/bash

fetch_tar knitro $SUFFIX
export KNITRO=$HOME/build/knitro
pushd $KNITRO && find -name "*.a" | xargr rm && popd
export casadi_build_flags="$casadi_build_flags -DWITH_KNITRO=ON"

