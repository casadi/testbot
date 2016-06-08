#!/bin/bash

set -e

if [ -z "$SETUP" ]; then

  mypwd=`pwd`

  mingw_setup

  VERSION=1.8.4

  wget http://www.coin-or.org/Tarballs/Bonmin/Bonmin-$VERSION.tgz
  tar -xvf Bonmin-$VERSION.tgz
  pushd Bonmin-$VERSION
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
  ../configure --host x86_64-w64-mingw32 --enable-dependency-linking --build mingw32 --prefix=/home/travis/bonmin-install --disable-shared ADD_FFLAGS=-fPIC ADD_CFLAGS=-fPIC ADD_CXXFLAGS=-fPIC --with-blas=BUILD --with-lapack=BUILD --with-mumps=BUILD --with-metis=BUILD --without-hsl --without-asl
  make
  make install
  popd && popd
  tar -zcvf bonmin_mingw64_trusty.tar.gz -C /home/travis/bonmin-install .
  export PYTHONPATH="$PYTHONPATH:$mypwd/helpers" && python -c "from restricted import *; upload('bonmin_mingw64_trusty.tar.gz')"

else
  fetch_tar bonmin mingw64_trusty
  
  export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/home/travis/bonmin-install/lib/pkgconfig
  pushd /home/travis/ && ln -s  /home/travis/build/ipopt ipopt-install && popd
fi

