#!/bin/bash
set -e

if [ -z "$SETUP" ]; then
  echo "noop"
else
  if [ "${BITNESS}" = "32" ]; then
    try_fetch_7z libworhp_mingw-w64_i686_1.7-dd7abd3 worhp
  fi
  if [ "${BITNESS}" = "64" ]; then
    try_fetch_7z libworhp_mingw-w64_x86_64_1.7-dd7abd3 worhp
  fi
  echo "bitness: ${BITNESS}"
  ls $HOME/build/worhp
  export WORHP=$HOME/build/worhp/
  cp $WORHP/bin/* $WORHP/lib
  export WORHP_LICENSE_FILE=$HOME/build/testbot/restricted/worhp/unlocked.lic
fi
