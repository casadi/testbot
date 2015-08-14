#!/bin/bash
set -e

mypwd=`pwd`

compilerprefix=i686-w64-mingw32

sudo add-apt-repository ppa:umn-claoit-rce/compute-packages -y
sudo add-apt-repository ppa:baltix-members/ppa -y # for libslicot-dev
sudo add-apt-repository ppa:tkelman/mingw-backport -y
sudo apt-get update -qq
sudo apt-get install -y binutils gcc g++ gfortran git cmake


sudo apt-get update -qq
sudo apt-get remove -qq -y mingw32
sudo apt-get install -q -y mingw-w64
sudo apt-get install -q -y mingw-w64 g++-mingw-w64 gcc-mingw-w64 gfortran-mingw-w64

svn co http://llvm.org/svn/llvm-project/llvm/tags/RELEASE_342/final/ llvm
cd llvm/tools
svn co http://llvm.org/svn/llvm-project/cfe/tags/RELEASE_342/final/ clang
cd ../..

mkdir build
cd build

cat <<EOF >toolchain.cmake
# this one is important
SET(CMAKE_SYSTEM_NAME Windows)
#this one not so much
SET(CMAKE_SYSTEM_VERSION 1)
# specify the cross compiler

SET(COMPILER_PREFIX "$compilerprefix")

SET(CMAKE_C_COMPILER $compilerprefix-gcc)
SET(CMAKE_CXX_COMPILER $compilerprefix-g++)
SET(CMAKE_Fortran_COMPILER $compilerprefix-gfortran)
SET(CMAKE_RC_COMPILER $compilerprefix-windres)


# where is the target environment
SET(CMAKE_FIND_ROOT_PATH /usr/$compilerprefix)
# search for programs in the build host directories
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# for libraries and headers in the target directories
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY NEVER)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE NEVER)
EOF


cmake -DCMAKE_BUILD_TYPE=Release  -DCMAKE_TOOLCHAIN_FILE=toolchain.cmake -DCMAKE_INSTALL_PREFIX="$mypwd/install"  -DCLANG_ENABLE_ARCMT=OFF -DCLANG_ENABLE_REWRITER=OFF -DCLANG_ENABLE_STATIC_ANALYZER=OFF  ../llvm
make install

pushd ../install && tar -cvf $mypwd/clang_minwg32.tar.gz . && popd

cd $mypwd
export PYTHONPATH="$PYTHONPATH:$mypwd/helpers" && python -c "from restricted import *; upload('clang_minwg32.tar.gz')"
