#!/bin/bash
set -e

svn co http://llvm.org/svn/llvm-project/llvm/trunk llvm
cd llvm/tools
svn co http://llvm.org/svn/llvm-project/cfe/trunk clang
cd ../..
mkdir build
cd build

cmake -DCMAKE_BUILD_TYPE=Release ../llvm
make -j2

pushd lib && tar -cvf $mypwd/clang.tar.gz . && popd
popd && popd
export PYTHONPATH="$PYTHONPATH:$mypwd/helpers" && python -c "from restricted import *; upload('clang.tar.gz')"
