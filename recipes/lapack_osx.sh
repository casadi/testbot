#!/bin/bash

#set -e
export SUFFIX=osx
export SUFFIXFILE=_$SUFFIX

if [ -z "$SETUP" ]; then

  mypwd=`pwd`
  
  VERSION=3.4.2

  wget http://www.coin-or.org/BuildTools/Lapack/lapack-$VERSION.tgz
  tar -xvf lapack-$VERSION.tgz
  pushd lapack-$VERSION
  mkdir build
  pushd build

  cmake -DCMAKE_Fortran_FLAGS=-fPIC .. && make lapack -j2 VERBOSE=1
  pushd lib && tar -cvf $mypwd/lapack$SUFFIXFILE.tar.gz . && popd
  popd && popd
  slurp_put lapack$SUFFIXFILE

else
  fetch_tar lapack $SUFFIX
  export LIB=$HOME/build/lapack
  export DYLD_LIBRARY_PATH=$LIB:$DYLD_LIBRARY_PATH
  cp lapack/libblas.a lapack/libblas.lib
  cp lapack/liblapack.a lapack/liblapack.lib
  echo "lapack"
  pwd
  ls
  ls $LIB
  export casadi_build_flags="$casadi_build_flags -DWITH_LAPACK=ON -DBLA_VENDOR=Generic -DBLA_STATIC=ON"  
fi
