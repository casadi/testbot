#!/bin/bash

#set -e
export SUFFIX=manylinux${BITNESS}_dockcross
export SUFFIXFILE=_$SUFFIX

if [ -z "$SETUP" ]; then


  mypwd=`pwd`

  export BUILD_ENV=dockcross
  dockcross_setup_start
  dockcross_setup_finish
  
  VERSION=3.4.2

  wget http://www.coin-or.org/BuildTools/Lapack/lapack-$VERSION.tgz
  tar -xvf lapack-$VERSION.tgz
  pushd lapack-$VERSION
  mkdir build
  pushd build

  build_env "cmake -DCMAKE_Fortran_FLAGS=-fPIC .. && make lapack -j2 VERBOSE=1"
  pushd lib && tar -cvf $mypwd/lapack$SUFFIXFILE.tar.gz . && popd
  popd && popd
  slurp_put lapack$SUFFIXFILE

else
  fetch_tar lapack $SUFFIX
  export LIB=$HOME/build/lapack
  export casadi_build_flags="$casadi_build_flags -DWITH_LAPACK=ON"  
fi

