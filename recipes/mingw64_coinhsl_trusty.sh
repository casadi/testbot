#!/bin/bash
set -e

mypwd=`pwd`
compilerprefix=x86_64-w64-mingw32

export PYTHONPATH="$PYTHONPATH:$mypwd/helpers"

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

pwd
ls

sudo apt-get install locate
sudo updatedb

locate libgomp.spec
locate libgfortran

recipes/fetch.sh matlab$MATLABRELEASE.tar.gz

export PYTHONPATH="$PYTHONPATH:$mypwd/helpers" && python -c "from restricted import *; download('ipopt_mingw64_trusty.tar.gz')"
mkdir ipopt && tar -xf ipopt_mingw64_trusty.tar.gz -C ipopt
pushd /home/travis/ && ln -s $mypwd/ipopt ipopt-install  && popd

ls /home/travis/ipopt-install/lib

pushd restricted
wget http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/OLD/metis-4.0.3.tar.gz
tar -xvf coinhsl.tar.gz && cd coinhsl-2014.01.10 && tar -xvf ../metis-4.0.3.tar.gz

./configure --host $compilerprefix --prefix=$mypwd/coinhsl-install LIBS="-L/home/travis/ipopt-install/lib" --with-blas="-lcoinblas -lcoinlapack -lcoinblas" CXXFLAGS="-fopenmp" FCFLAGS="-O2 -fopenmp" CFLAGS="-O2 -fopenmp" || cat config.log
sed -i "s/deplibs_check_method=.*/deplibs_check_method=\"pass_all\"/" libtool
make
make install

mkdir $mypwd/pack

ls $mypwd/coinhsl-install/bin
cp $mypwd/coinhsl-install/bin/libcoinhsl-0.dll $mypwd/pack/libhsl.dll
cp $mypwd/coinhsl-install/bin/libmetis-0.dll $mypwd/pack/libmetis.dll
cp /usr/lib/gcc/$compilerprefix/4.9-win32/*.dll $mypwd/pack

zip -j libhsl_mingw64_trusty.zip $mypwd/pack/*.dll

python -c "from restricted import *; upload('libhsl_mingw64_trusty.zip')"

