#!/bin/bash
set -e

if [ -z "$SETUP" ]; then
  source recipes/clang_common.sh

  mypwd=`pwd`

  svn co http://llvm.org/svn/llvm-project/llvm/tags/RELEASE_$VERSION/final/ llvm
  cd llvm/tools
  svn co http://llvm.org/svn/llvm-project/cfe/tags/RELEASE_$VERSION/final/ clang
  cd ../projects
  svn co http://llvm.org/svn/llvm-project/libcxx/tags/RELEASE_$VERSION/final/ libcxx
  cd libcxx && patch -p0 -i $mypwd/recipes/libcxx.patch && cd ..
  cd ../..
  mkdir build
  cd build

  cmake -DLLVM_ENABLE_TERMINFO=OFF -DLLVM_ENABLE_ZLIB=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$mypwd/install" ../llvm
  make clang-tblgen install -j2
  cp bin/clang-tblgen "$mypwd/install/bin"

  pushd ../install && tar -cvf $mypwd/clang_osx.tar.gz . && popd

  cd $mypwd
  slurp_put clang_osx.tar.gz

else
  fetch_tar clang osx
  export ECOS=$HOME/build/clang
fi
