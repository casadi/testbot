#!/bin/bash
set -e

if [ -z "$SETUP" ]; then
  echo "noop"
else
  #try_fetch_7z libworhp_macosx10.9_gcc49_1.8-3cdb565 worhp
  try_fetch_7z libworhp_macosx10.9_gcc48_1.8-3cdb565 worhp
  export WORHP=$HOME/build/worhp
  export WORHP_LICENSE_FILE=$HOME/build/testbot/restricted/worhp/unlocked.lic
  export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:$WORHP/lib
fi
