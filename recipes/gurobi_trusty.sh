#!/bin/bash
#set -e

if [ -z "$SETUP" ]; then
  echo "No setup needed"
else
  fetch_tar gurobi650 trusty
  export GUROBI_HOME=/home/travis/build/gurobi650
  export GRB_LICENSE_FILE=$HOME/build/testbot/restricted/gurobi.lic
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$GUROBI_HOME/lib
  ls $GUROBI_HOME/lib
  echo $LD_LIBRARY_PATH
  export casadi_build_flags="$casadi_build_flags -DWITH_GUROBI=ON"  
fi
