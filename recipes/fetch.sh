#!/bin/bash
##set -e

mypwd=`pwd`
export PYTHONPATH="$PYTHONPATH:$TESTBOT_DIR/helpers:$TESTBOT_DIR" && python -c "from restricted import *; download('$1')"

