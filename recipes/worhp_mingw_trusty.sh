#!/bin/bash
#set -e

if [ -z "$SETUP" ]; then
  echo "noop"
else
  #try_fetch_7z libworhp_vs2013_1.10-2 worhp
  #try_fetch_zip worhp_1.10_mingw worhp
  try_fetch_zip worhp_1.13-0_win${BITNESS} worhp
    echo "bitness: ${BITNESS}"
  ls $HOME/build/worhp
  export WORHP=$HOME/build/worhp
  mv $WORHP/bin/* $WORHP/lib
  rm $WORHP/lib/worhp.dll.a
  export WORHP_LICENSE_FILE=$HOME/build/testbot/restricted/worhp/unlocked.lic
  export casadi_build_flags="$casadi_build_flags -DWITH_WORHP=ON"
fi
