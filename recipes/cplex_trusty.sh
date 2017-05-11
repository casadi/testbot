#!/bin/bash
set -e

if [ -z "$SETUP" ]; then
  echo "noop"
else
  try_fetch_tar cplex12.4 cplex
  try_fetch_tar cplex12.4-concert concert
  export CMAKE_INCLUDE_PATH=$CMAKE_INCLUDE_PATH:$HOME/build/testbot/restricted/cplex/cplex/include:$HOME/build/testbot/restricted/cplex/concert/include
  export CMAKE_LIBRARY_PATH=$CMAKE_LIBRARY_PATH:$HOME/build/testbot/restricted/cplex/cplex/lib/x86-64_sles10_4.1/static_pic/:$HOME/build/testbot/restricted/cplex/concert/lib/x86-64_sles10_4.1/static_pic/
  export ILOG_LICENSE_FILE=$ILOG_LICENSE_FILE=$HOME/build/testbot/restricted/cplex/access.ilm
  export casadi_build_flags="$casadi_build_flags -DWITH_CPLEX=ON"  
fi
