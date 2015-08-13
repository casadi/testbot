#!/bin/bash
set -e

compilerprefix=i686-w64-mingw32

sudo apt-get update -qq
sudo apt-get remove -qq -y mingw32
sudo apt-get install -q -y mingw-w64
sudo apt-get install -q -y mingw-w64 g++-mingw-w64 gcc-mingw-w64 gfortran-mingw-w64

sudo add-apt-repository -y ppa:pipelight/daily
sudo apt-get -qy update
sudo apt-get install -y wine-staging winbind

export PATH="/opt/wine-staging/bin:$PATH"

WINEARCH=wineboot

wget http://winetricks.org/winetricks
chmod +x winetricks
./winetricks nocrashdialog

ls -al /home/travis/.wine/drive_c/

svn co http://llvm.org/svn/llvm-project/llvm/tags/RELEASE_342/final/ llvm
cd llvm/tools
svn co http://llvm.org/svn/llvm-project/cfe/tags/RELEASE_342/final/ clang
cd ../..

git clone https://github.com/casadi/casadi.git
cd casadi
mkdir build
cd build

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
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=toolchain.cmake ..
make -j2

pushd lib && tar -cvf $mypwd/clang_mingw32.tar.gz . && popd
popd && popd
export PYTHONPATH="$PYTHONPATH:$mypwd/helpers" && python -c "from restricted import *; upload('clang_mingw32.tar.gz')"
