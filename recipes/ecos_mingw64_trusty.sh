#!/bin/bash

set -e

if [ -z "$SETUP" ]; then
  mypwd=`pwd`

  export compilerprefix=x86_64-w64-mingw32

  mingw_setup
  
  git clone https://github.com/jgillis/ecos.git && pushd ecos && make ISWINDOWS=1 CC=$compilerprefix-gcc AR=$compilerprefix-ar RANLIB=$compilerprefix-ranlib && tar -cvf $mypwd/ecos_mingw64_trusty.tar.gz . && popd

  cd $mypwd
  export PYTHONPATH="$PYTHONPATH:$mypwd/helpers" && python -c "from restricted import *; upload('ecos_mingw64_trusty.tar.gz')"

else
  fetch_tar ecos mingw64_trusty
  export ECOS=/home/travis/build/ecos
fi

