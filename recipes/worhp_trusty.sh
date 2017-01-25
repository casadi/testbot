#!/bin/bash
set -e

if [ -z "$SETUP" ]; then
  
else
  try_fetch_7z libworhp_debian7_amd64_gcc47_1.7-12970f3 worhp
  export WORHP=$HOME/build/worhp
  export WORHP_LICENSE_FILE=$HOME/build/testbot/restricted/worhp/unlocked.lic
fi
