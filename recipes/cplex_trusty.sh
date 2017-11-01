#!/bin/bash
set -e

if [ -z "$SETUP" ]; then
  echo "noop"
else
  echo "nothing to do"
  try_fetch_tar cplex_linux1263 cplex
  export ILOG_LICENSE_FILE=$ILOG_LICENSE_FILE=$HOME/build/testbot/restricted/cplex/access.ilm
  export CPLEX=$HOME/build/cplex/
  ls $CPLEX
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CPLEX/bin/x86-64_linux
  export casadi_build_flags="$casadi_build_flags -DWITH_CPLEX=ON -DWITH_CPLEX_SHARED=ON -DCPLEX_VERSION=1263"  
fi
