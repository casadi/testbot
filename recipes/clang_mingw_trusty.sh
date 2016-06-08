#!/bin/bash

set -e

if [ -z "$SETUP" ]; then


  mypwd=`pwd`

  export PYTHONPATH="$PYTHONPATH:$mypwd/helpers" && python -c "from restricted import *; download('clang.tar.gz')"

  mkdir clang && tar -xvf clang.tar.gz -C clang

  sudo apt-get update -qq

  sudo apt-get install libc6-dev -y
  sudo apt-get install -y binutils gcc g++ gfortran git cmake

  mingw_setup

  VERSION=342

  svn co http://llvm.org/svn/llvm-project/llvm/tags/RELEASE_$VERSION/final/ llvm
  cd llvm/tools
  svn co http://llvm.org/svn/llvm-project/cfe/tags/RELEASE_$VERSION/final/ clang
  cd ../..
  mkdir build
  cd build

  ls /usr/bin/
  cmake --version

  cat <<EOF >toolchain.cmake
  # this one is important
  SET(CMAKE_SYSTEM_NAME Windows)
  #this one not so much
  SET(CMAKE_SYSTEM_VERSION 1)

  # x86_${BITNESS} # i686
  SET(PREFIX "$compilerprefix")

  # specify the cross compiler
  SET(CMAKE_C_COMPILER   $compilerprefix-gcc)
  SET(CMAKE_CXX_COMPILER $compilerprefix-g++)
  SET(CMAKE_Fortran_COMPILER $compilerprefix-gfortran)
  SET(CMAKE_RC_COMPILER $compilerprefix-windres)

  # where is the target environment 
  SET(CMAKE_FIND_ROOT_PATH  /usr/$compilerprefix)

  # search for programs in the build host directories
  SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
  # for libraries and headers in the target directories
  SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY NEVER)
  SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE NEVER)
  EOF

  cmake -DCMAKE_BUILD_TYPE=Release -DCLANG_TABLEGEN=$mypwd/clang/bin/clang-tblgen -DLLVM_TABLEGEN=$mypwd/clang/bin/llvm-tblgen  -DCMAKE_TOOLCHAIN_FILE=toolchain.cmake -DCMAKE_INSTALL_PREFIX="$mypwd/install"  -DCLANG_ENABLE_ARCMT=OFF -DCLANG_ENABLE_REWRITER=OFF -DCLANG_ENABLE_STATIC_ANALYZER=OFF  ../llvm
  make install -j2

  svn export http://llvm.org/svn/llvm-project/libcxx/tags/RELEASE_$VERSION/final/include $mypwd/install/include/c++/v1/

  pushd ../install && tar -cvf $mypwd/clang_mingw${BITNESS}_trusty.tar.gz . && popd

  cd $mypwd
  export PYTHONPATH="$PYTHONPATH:$mypwd/helpers" && python -c "from restricted import *; upload('clang_mingw${BITNESS}_trusty.tar.gz')"

else
  fetch_tar clang mingw${BITNESS}_trusty
  
  export CLANG=/home/travis/build/clang
fi

