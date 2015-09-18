#!/bin/bash
set -e

VERSION=342

mypwd=`pwd`

sudo apt-get install libc6-dev

svn co http://llvm.org/svn/llvm-project/llvm/tags/RELEASE_$VERSION/final/ llvm
cd llvm/tools
svn co http://llvm.org/svn/llvm-project/cfe/tags/RELEASE_$VERSION/final/ clang
cd ../projects
svn co http://llvm.org/svn/llvm-project/libcxx/tags/RELEASE_$VERSION/final/ libcxx
cd libcxx && patch -p0 -i ../libcxx.patch && cd ..
cd ../..
mkdir build
cd build

cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$mypwd/install" ../llvm
make clang-tblgen install -j2
cp bin/clang-tblgen "$mypwd/install/bin"

pushd ../install && tar -cvf $mypwd/clang.tar.gz . && popd

cd $mypwd
export PYTHONPATH="$PYTHONPATH:$mypwd/helpers" && python -c "from restricted import *; upload('clang.tar.gz')"
