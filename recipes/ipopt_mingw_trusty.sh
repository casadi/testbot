#!/bin/bash

set -e

if [ -z "$SETUP" ]; then


  mypwd=`pwd`
  mingw_setup

  VERSION=3.12.3

  wget http://www.coin-or.org/download/source/Ipopt/Ipopt-$VERSION.tgz
  tar -xvf Ipopt-$VERSION.tgz
  pushd Ipopt-$VERSION
  pushd ThirdParty
  #pushd ASL && ./get.ASL && popd
  pushd Blas && ./get.Blas && popd 
  pushd Lapack && ./get.Lapack && popd 
  pushd Metis && ./get.Metis && popd 
  pushd Mumps && ./get.Mumps && popd
  popd
  mkdir build
  pushd build
  # build must contain mingw, in order for the hsl loader to look for .dll as opposed to .so
  ../configure --host $compilerprefix --enable-dependency-linking --build mingw32 --prefix=/home/travis/ipopt-install --disable-shared ADD_FFLAGS=-fPIC ADD_CFLAGS=-fPIC ADD_CXXFLAGS=-fPIC --with-blas=BUILD --with-lapack=BUILD --with-mumps=BUILD --with-metis=BUILD --without-hsl --without-asl
  make
  make install
  popd && popd
  tar -zcvf ipopt_mingw${BITNESS}_trusty.tar.gz -C /home/travis/ipopt-install .
  export PYTHONPATH="$PYTHONPATH:$mypwd/helpers" && python -c "from restricted import *; upload('ipopt_mingw${BITNESS}_trusty.tar.gz')"

else
  fetch_tar ipopt mingw${BITNESS}_trusty
  
  export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/home/travis/ipopt-install/lib/pkgconfig
  pushd /home/travis/ && ln -s  /home/travis/build/ipopt ipopt-install && popd
fi

