#!/bin/bash
set -e

export SUFFIX=manylinux${BITNESS}_dockcross
export SUFFIXFILE=_$SUFFIX

if [ -z "$SETUP" ]; then
  source recipes/clang_common.sh
  export BUILD_ENV=dockcross
  dockcross_setup_start
  dockcross_setup_finish
  mypwd=`pwd`

  #sudo apt-get install libc6-dev

  svn co http://llvm.org/svn/llvm-project/llvm/tags/RELEASE_$VERSION/final/ llvm >/dev/null
  cd llvm/tools
  svn co http://llvm.org/svn/llvm-project/cfe/tags/RELEASE_$VERSION/final/ clang >/dev/null
  cd ../projects
  svn co http://llvm.org/svn/llvm-project/libcxx/tags/RELEASE_$VERSION/final/ libcxx >/dev/null
  cd libcxx && patch -p0 -i $mypwd/recipes/libcxx.patch && cd ..
  cd ../..
  mkdir build
  cd build

  echo 'export PATH=/opt/python/cp27-cp27m/bin:$PATH' >> $HOME/path_appends.txt
  build_env cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$mypwd/install" ../llvm
  build_env make clang-tblgen install -j2
  cp bin/clang-tblgen "$mypwd/install/bin"

  pushd ../install && tar -cvf $mypwd/clang$SUFFIXFILE.tar.gz . && popd

  cd $mypwd
  slurp_put clang$SUFFIXFILE

else
  fetch_tar clang $SUFFIX
  export CLANG=$HOME/build/clang
  export casadi_build_flags="$casadi_build_flags -DWITH_CLANG=ON -DOLD_LLVM=ON"
fi
