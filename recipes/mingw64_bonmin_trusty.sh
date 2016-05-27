#!/bin/bash
set -e

mypwd=`pwd`

sudo apt-get update -qq
sudo apt-get remove -qq -y mingw32
cat <<EOF | sudo tee --append  /etc/apt/sources.list
deb-src http://archive.ubuntu.com/ubuntu vivid main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu vivid main restricted universe multiverse
EOF
cat <<EOF | sudo tee /etc/apt/preferences.d/mytest
Package: *
Pin: release n=trusty
Pin-priority: 700

Package: *
Pin: release n=vivid
Pin-priority: 600
EOF
sudo apt-get update -qq
sudo apt-get install -q -y -t vivid mingw-w64
sudo apt-get install -q -y -t vivid mingw-w64 g++-mingw-w64 gcc-mingw-w64 gfortran-mingw-w64

VERSION=1.8.4

wget http://www.coin-or.org/Tarballs/Bonmin/Bonmin-$VERSION.tgz
tar -xvf Bonmin-$VERSION.tgz
pushd Bonmin-$VERSION
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
../configure --host x86_64-w64-mingw32 --enable-dependency-linking --build mingw32 --prefix=/home/travis/bonmin-install --disable-shared ADD_FFLAGS=-fPIC ADD_CFLAGS=-fPIC ADD_CXXFLAGS=-fPIC --with-blas=BUILD --with-lapack=BUILD --with-mumps=BUILD --with-metis=BUILD --without-hsl --without-asl
make
make install
popd && popd
tar -zcvf bonmin_mingw64_trusty.tar.gz -C /home/travis/bonmin-install .
export PYTHONPATH="$PYTHONPATH:$mypwd/helpers" && python -c "from restricted import *; upload('bonmin_mingw64_trusty.tar.gz')"


