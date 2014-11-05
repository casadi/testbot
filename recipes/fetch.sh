#!/bin/bash
mypwd=`pwd`
export PYTHONPATH="$PYTHONPATH:$mypwd/testbot/helpers:$mypwd/testbot" && python -c "from restricted import *; download('$1')"

