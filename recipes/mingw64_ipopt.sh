#!/bin/bash
set -e

mypwd=`pwd`

sudo apt-get update -qq
sudo apt-get remove -qq -y mingw32
sudo apt-get install -q -y mingw-w64
sudo apt-get install -q -y mingw-w64 g++-mingw-w64 gcc-mingw-w64 gfortran-mingw-w64

VERSION=3.12.3

wget http://www.coin-or.org/download/source/Ipopt/Ipopt-$VERSION.tgz
tar -xvf Ipopt-$VERSION.tgz
pushd Ipopt-$VERSION
pushd ThirdParty
#pushd ASL && ./get.ASL && popd
pushd Blas && ./get.Blas && popd 
pushd Lapack && ./get.Lapack && popd 
pushd Metis && ./get.Metis && popd 
pushd Mumps && ./get.Mumps && popd
popd
mkdir build
pushd build
# build must contain mingw, in order for the hsl loader to look for .dll as opposed to .so
../configure --host x86_64-w64-mingw32 --build mingw32 --prefix=/home/travis/ipopt-install --disable-static --enable-shared ADD_FFLAGS=-fPIC ADD_CFLAGS=-fPIC ADD_CXXFLAGS=-fPIC --with-blas=BUILD --with-lapack=BUILD --with-mumps=BUILD --with-metis=BUILD --without-hsl --without-asl
make
make install
popd && popd
tar -zcvf ipopt_mingw64.tar.gz -C /home/travis/ipopt-install .
export PYTHONPATH="$PYTHONPATH:$mypwd/helpers" && python -c "from restricted import *; upload('ipopt_mingw64_shared.tar.gz')"


