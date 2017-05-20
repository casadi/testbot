#!/bin/bash
set -e

if [ -z "$SETUP" ]; then
  echo "noop"
else
  #try_fetch_7z libworhp_ubuntu14.04_amd64_1.9-1_16_10 worhp
  try_fetch_zip worhp_1.10_linux worhp
  export WORHP=$HOME/build/worhp
  export WORHP_LICENSE_FILE=$HOME/build/testbot/restricted/worhp/unlocked.lic
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$WORHP/lib
  export casadi_build_flags="$casadi_build_flags -DWITH_WORHP=ON"  
fi
