#!/bin/bash
##set -e

if [ -z "$SETUP" ]; then
  echo "No setup needed"
else
  fetch_zip gurobi650 mingw${BITNESS}_trusty
  export GUROBI_HOME=$HOME/build/gurobi650
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$GUROBI_HOME/lib
  export casadi_build_flags="$casadi_build_flags -DWITH_GUROBI=ON"  
fi
