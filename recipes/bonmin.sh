#!/bin/bash
set -e

VERSION=1.8.4

mypwd=`pwd`

wget http://www.coin-or.org/Tarballs/Bonmin/Bonmin-$VERSION.tgz
tar -xvf Bonmin-$VERSION.tgz
pushd Bonmin-$VERSION
pushd ThirdParty
pushd Blas && ./get.Blas && popd 
pushd Lapack && ./get.Lapack && popd 
pushd Metis && ./get.Metis && popd 
pushd Mumps && ./get.Mumps && popd
popd
mkdir build
pushd build
../configure --prefix=/home/travis/bonmin-install --disable-shared ADD_FFLAGS=-fPIC ADD_CFLAGS=-fPIC ADD_CXXFLAGS=-fPIC --with-blas=BUILD --with-lapack=BUILD --with-mumps=BUILD --with-metis=BUILD --without-hsl --with-asl=BUILD
make
make install
popd && popd
tar -zcvf bonmin.tar.gz -C /home/travis/bonmin-install .
export PYTHONPATH="$PYTHONPATH:$mypwd/helpers" && python -c "from restricted import *; upload('bonmin.tar.gz')"



