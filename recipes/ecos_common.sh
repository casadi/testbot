#!/bin/bash

set -e

if [ -z "$SETUP" ]; then
  mypwd=`pwd`

  git clone https://github.com/jgillis/ecos.git && pushd ecos && make $FLAGS && tar -cvf $mypwd/ecos_$SUFFIXFILE.tar.gz . && popd

  cd $mypwd
  export PYTHONPATH="$PYTHONPATH:$HOME/build/helpers" && python -c "from restricted import *; upload('ecos_$SUFFIXFILE.tar.gz')"

else
  fetch_tar ecos $SUFFIX
  export ECOS=/home/travis/build/ecos
fi

