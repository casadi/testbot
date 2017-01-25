#!/bin/bash
set -e

if [ -z "$SETUP" ]; then
  echo "noop"
else
  try_fetch_7z libworhp_vs2013_1.9-1_16_10 worhp
  echo "bitness: ${BITNESS}"
  ls $HOME/build/worhp
  export WORHP=$HOME/build/worhp/vs2013-Release/
  mv $WORHP/bin${BITNESS} $WORHP/lib
  export WORHP_LICENSE_FILE=$HOME/build/testbot/restricted/worhp/unlocked.lic
fi
