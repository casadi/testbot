#!/bin/bash
#set -e

if [ -z "$SETUP" ]; then
  echo "No setup needed"
else
  fetch_tar knitro10.1 trusty
  export KNITRO=$HOME/build/knitro10.1
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$KNITRO/lib
  export casadi_build_flags="$casadi_build_flags -DWITH_KNITRO=ON"  
fi
