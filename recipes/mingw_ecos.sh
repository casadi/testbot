#!/bin/bash
set -e

mypwd=`pwd`

export compilerprefix=i686-w64-mingw32

git clone https://github.com/embotech/ecos.git && pushd ecos && make ISWINDOWS=1 CC=$compilerprefix-gcc AR=$compilerprefix-ar RANLIB=$compilerprefix-ranlib && tar -cvf $mypwd/ecos.tar.gz . && popd

cd $mypwd
export PYTHONPATH="$PYTHONPATH:$mypwd/helpers" && python -c "from restricted import *; upload('ecos_mingw.tar.gz')"
