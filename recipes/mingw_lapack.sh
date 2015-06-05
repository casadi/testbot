#!/bin/bash
set -e

mypwd=`pwd`

compilerprefix=i686-w64-mingw32

sudo apt-get update -qq
sudo apt-get remove -qq -y mingw32
sudo apt-get install -q -y mingw-w64
sudo apt-get install -q -y mingw-w64 g++-mingw-w64 gcc-mingw-w64 gfortran-mingw-w64

ls ${compilerprefix}-ar

VERSION=3.4.2

wget http://www.coin-or.org/BuildTools/Lapack/lapack-$VERSION.tgz
tar -xvf lapack-$VERSION.tgz
pushd lapack-$VERSION
mkdir build
pushd build

cat <<EOF >toolchain.cmake
# this one is important
SET(CMAKE_SYSTEM_NAME Windows)
#this one not so much
SET(CMAKE_SYSTEM_VERSION 1)
# specify the cross compiler
set(COMPILER_PREFIX "$compilerprefix")

SET(CMAKE_C_COMPILER $compilerprefix-gcc)
SET(CMAKE_CXX_COMPILER $compilerprefix-g++)
SET(CMAKE_Fortran_COMPILER $compilerprefix-gfortran)
set(CMAKE_RC_COMPILER $compilerprefix-windres)
set(CMAKE_RANLIB $compilerprefix-ranlib)
set(CMAKE_AR $compilerprefix-ar)
# where is the target environment
SET(CMAKE_FIND_ROOT_PATH /usr/$compilerprefix)
# search for programs in the build host directories
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# for libraries and headers in the target directories
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY NEVER)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE NEVER)
EOF

cmake -DCMAKE_TOOLCHAIN_FILE=toolchain.cmake ..
make lapack -j2 VERBOSE=1
pushd lib && tar -cvf $mypwd/lapack_mingw.tar.gz . && popd
popd && popd
export PYTHONPATH="$PYTHONPATH:$mypwd/helpers" && python -c "from restricted import *; upload('lapack_mingw.tar.gz')"

