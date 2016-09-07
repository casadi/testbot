#!/bin/bash
set -e

if [ -z "$SETUP" ]; then
  echo "No setup needed"
else
  fetch_tar knitro10.1 trusty
  export KNITRO=$HOME/build/knitro10.1
fi
