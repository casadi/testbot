#!/bin/bash
#set -e

if [ -z "$SETUP" ]; then
  echo "No setup needed"
else
  fetch_zip gurobi650 osx
  export GUROBI_HOME=/Users/travis/build/gurobi650
  sudo install_name_tool -id "@rpath/libgurobi65.so" $GUROBI_HOME/lib/libgurobi65.so
  export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:$GUROBI_HOME/lib
  export casadi_build_flags="$casadi_build_flags -DWITH_GUROBI=ON"  
fi
