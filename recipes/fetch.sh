#!/bin/bash
mypwd=`pwd`
export PYTHONPATH="$PYTHONPATH:$mypwd/testbot/helpers" && python -c "from restricted import *; download('$1')"

