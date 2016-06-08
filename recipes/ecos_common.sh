#!/bin/bash

set -e

if [ -z "$SETUP" ]; then
  mypwd=`pwd`

  git clone https://github.com/jgillis/ecos.git && pushd ecos && make $FLAGS && tar -cvf $mypwd/ecos_$SUFFIXFILE.tar.gz . && popd

  cd $mypwd
  slurp_put ecos_$SUFFIXFILE.tar.gz

else
  fetch_tar ecos $SUFFIX
  export ECOS=/home/travis/build/ecos
fi

