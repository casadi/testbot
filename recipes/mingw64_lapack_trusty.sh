#!/bin/bash
set -e

mypwd=`pwd`

compilerprefix=x86_64-w64-mingw32

sudo apt-get update -qq
sudo apt-get remove -qq -y mingw32
cat <<EOF | sudo tee --append  /etc/apt/sources.list
deb-src http://archive.ubuntu.com/ubuntu vivid main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu vivid main restricted universe multiverse
EOF
cat <<EOF | sudo tee /etc/apt/preferences.d/mytest
Package: *
Pin: release n=trusty
Pin-priority: 700

Package: *
Pin: release n=vivid
Pin-priority: 600
EOF
sudo apt-get update -qq
sudo apt-get install -q -y -t vivid mingw-w64
sudo apt-get install -q -y -t vivid mingw-w64 g++-mingw-w64 gcc-mingw-w64 gfortran-mingw-w64

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
make lapack -j2
pushd lib && tar -cvf $mypwd/lapack_mingw64_trusty.tar.gz . && popd
popd && popd
export PYTHONPATH="$PYTHONPATH:$mypwd/helpers" && python -c "from restricted import *; upload('lapack_mingw64_trusty.tar.gz')"

