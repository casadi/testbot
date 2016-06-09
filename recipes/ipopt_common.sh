#!/bin/bash

if [ -z "$SETUP" ]; then

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
  ../configure $FLAGS --prefix=$HOME/ipopt-install --disable-shared ADD_FFLAGS=-fPIC ADD_CFLAGS=-fPIC ADD_CXXFLAGS=-fPIC --with-blas=BUILD --with-lapack=BUILD --with-mumps=BUILD --with-metis=BUILD --without-hsl --without-asl
  make
  make install
  popd && popd
  tar -zcvf ipopt$SUFFIXFILE.tar.gz -C $HOME/ipopt-install .
  slurp_put ipopt$SUFFIXFILE.tar.gz

else
  fetch_tar ipopt $SUFFIX
  
  export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$HOME/ipopt-install/lib/pkgconfig
  pushd $HOME && ln -s  $HOME/build/ipopt ipopt-install && popd
fi

