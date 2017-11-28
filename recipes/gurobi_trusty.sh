#!/bin/bash
set -e

if [ -z "$SETUP" ]; then
  echo "No setup needed"
else
  fetch_tar gurobi650 trusty
  export GUROBI_HOME=/home/travis/build/gurobi650
  export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:$GUROBI_HOME/lib
  export casadi_build_flags="$casadi_build_flags -DWITH_GUROBI=ON"  
fi
