#!/bin/bash

if [ -z "$SETUP" ]; then
  mypwd=`pwd`

  git clone https://github.com/jgillis/ecos.git && pushd ecos && make $FLAGS && tar -cvf $mypwd/ecos$SUFFIXFILE.tar.gz . && popd

  cd $mypwd
  slurp_put ecos$SUFFIXFILE

else
  echo "SUFFIX" $SUFFIX
  fetch_tar ecos $SUFFIX
  export ECOS=$HOME/build/ecos
  export casadi_build_flags="$casadi_build_flags -DWITH_ECOS=ON"  
fi

