#!/bin/bash

fetch_tar knitro $SUFFIX
export KNITRO=$HOME/build/knitro
export casadi_build_flags="$casadi_build_flags -DWITH_KNITRO=ON"

