#!/bin/bash

if [ -z "$SETUP" ]; then

  VERSION=0.3.13
  (while true ; do sleep 60 ; echo "ping" ; done ) &
  wget https://github.com/xianyi/OpenBLAS/archive/v${VERSION}.zip -O openblas.zip
  unzip openblas.zip > /dev/null
  pushd OpenBLAS-$VERSION
  mkdir $HOME/openblas-install
  #build_env cmake -DDYNAMIC_ARCH=ON -DCMAKE_INSTALL_PREFIX=$HOME/openblas-install ..
  # DYNAMIC_OLDER=1 
  build_env make DYNAMIC_ARCH=1 NO_SHARED=0 USE_OPENMP=0 USE_THREAD=1 NUM_THREADS=32 > /dev/null
  build_env make PREFIX=$HOME/openblas-install install
  install_name_tool -id "@rpath/libopenblas.0.dylib" $HOME/openblas-install/lib/libopenblas.0.dylib
  popd
  tar -zcvf openblas$SUFFIXFILE.tar.gz -C $HOME/openblas-install .
  slurp_put openblas$SUFFIXFILE

else
  fetch_tar openblas $SUFFIX
  pwd
  export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$HOME/openblas-install/lib/pkgconfig
  pushd $HOME && ln -s  $HOME/build/openblas openblas-install && popd
  export LIB=$HOME/build/openblas/lib
  mkdir -p $HOME/extra_libs
  cp $LIB/libopenblas.0.dylib $HOME/extra_libs
  export DYLD_LIBRARY_PATH=$LIB:$DYLD_LIBRARY_PATH
  export BLAS_ROOT=$LIB
  export LAPACK_ROOT=$LIB # as of cmake 3.12
  export CMAKE_LIBRARY_PATH=$LIB:$CMAKE_LIBRARY_PATH
  echo "lapack"
  export casadi_build_flags="$casadi_build_flags -DCMAKE_POLICY_DEFAULT_CMP0074=NEW -DWITH_LAPACK=ON -DBLA_VENDOR=OpenBLAS -DBLA_STATIC=OFF"  
fi

