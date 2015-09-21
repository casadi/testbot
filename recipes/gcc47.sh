#!/bin/bash
set -e

mypwd=`pwd`

sudo apt-get install libc6-dev libc6-dev-i386
sudo apt-get install libmpfr-dev libmpc-dev flex bison

svn co -q svn://gcc.gnu.org/svn/gcc/tags/gcc_4_7_4_release/ gcc-4.7
cd gcc-4.7

mkdir build
cd build
../configure --prefix="$mypwd/install" --disable-nls --enable-languages=c,c++,fortran
make -j2
make install


pushd ../install && tar -cvf $mypwd/gcc47.tar.gz . && popd

cd $mypwd
export PYTHONPATH="$PYTHONPATH:$mypwd/helpers" && python -c "from restricted import *; upload('gcc47.tar.gz')"
