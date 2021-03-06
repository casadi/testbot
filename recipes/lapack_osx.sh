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
  export BLAS_ROOT=$LIB
  export LAPACK_ROOT=$LIB # as of cmake 3.12
  export CMAKE_LIBRARY_PATH=$LIB:$CMAKE_LIBRARY_PATH
  echo "lapack"
  pwd
  ls
  ls $LIB
  cp lapack/libblas.a lapack/libblas.lib
  cp lapack/liblapack.a lapack/liblapack.lib
  export casadi_build_flags="$casadi_build_flags -DCMAKE_POLICY_DEFAULT_CMP0074=NEW -DWITH_LAPACK=ON -DBLA_VENDOR=Generic -DBLA_STATIC=ON"  
fi
