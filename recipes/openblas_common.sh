#!/bin/bash

if [ -z "$SETUP" ]; then

  VERSION=0.3.13

  wget https://github.com/xianyi/OpenBLAS/archive/v${VERSION}.zip -O openblas.zip
  unzip openblas.zip
  pushd OpenBLAS-$VERSION
  mkdir build
  pushd build
  mkdir $HOME/openblas-install
  build_env cmake -DDYNAMIC_ARCH=ON -DCMAKE_INSTALL_PREFIX=$HOME/openblas-install ..
  build_env make
  build_env make install
  popd && popd
  tar -zcvf openblas$SUFFIXFILE.tar.gz -C $HOME/openblas-install .
  slurp_put openblas$SUFFIXFILE

else
  fetch_tar openblas $SUFFIX
  pwd
  export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$HOME/openblas-install/lib/pkgconfig
  pushd $HOME && ln -s  $HOME/build/openblas openblas-install && popd
  export LIB=$HOME/build/openblas
  export DYLD_LIBRARY_PATH=$LIB:$DYLD_LIBRARY_PATH
  export BLAS_ROOT=$LIB
  export LAPACK_ROOT=$LIB # as of cmake 3.12
  export CMAKE_LIBRARY_PATH=$LIB:$CMAKE_LIBRARY_PATH
  echo "lapack"
  export casadi_build_flags="$casadi_build_flags -DCMAKE_POLICY_DEFAULT_CMP0074=NEW -DWITH_LAPACK=ON -DBLA_VENDOR=OpenBLAS -DBLA_STATIC=OFF"  
fi

