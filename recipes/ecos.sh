#!/bin/bash
set -e

mypwd=`pwd`

git clone https://github.com/jgillis/ecos.git && pushd ecos && make && tar -cvf $mypwd/ecos.tar.gz . && popd

cd $mypwd
export PYTHONPATH="$PYTHONPATH:$mypwd/helpers" && python -c "from restricted import *; upload('ecos.tar.gz')"
