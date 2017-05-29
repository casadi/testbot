#!/bin/bash

set -e

if [ -z "$SETUP" ]; then
  echo "noop"
else
  sudo apt-get install -y libslicot-dev
  export casadi_build_flags="$casadi_build_flags -DWITH_SLICOT=ON"
fi
