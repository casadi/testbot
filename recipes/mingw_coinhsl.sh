#!/bin/bash
set -e

mypwd=`pwd`

compilerprefix=i686-w64-mingw32

export PYTHONPATH="$PYTHONPATH:$mypwd/helpers"

sudo apt-get update -qq
sudo apt-get remove -qq -y mingw32
sudo apt-get install -q -y mingw-w64
sudo apt-get install -q -y mingw-w64 g++-mingw-w64 gcc-mingw-w64 gfortran-mingw-w64

pwd
ls

sudo apt-get install locate
sudo updatedb

locate libgomp.spec
locate libgfortran

recipes/fetch.sh matlab$MATLABRELEASE.tar.gz

export PYTHONPATH="$PYTHONPATH:$mypwd/helpers" && python -c "from restricted import *; download('ipopt_mingw64.tar.gz')"
mkdir ipopt && tar -xf ipopt_mingw.tar.gz -C ipopt
pushd /home/travis/ && ln -s $mypwd/ipopt ipopt-install  && popd

ls /home/travis/ipopt-install/lib

pushd restricted
wget http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/OLD/metis-4.0.3.tar.gz
tar -xvf coinhsl.tar.gz && cd coinhsl-2014.01.10 && tar -xvf ../metis-4.0.3.tar.gz

./configure --host $compilerprefix --prefix=$mypwd/coinhsl-install LIBS="-L/home/travis/ipopt-install/lib" --with-blas="-lcoinblas -lcoinlapack -lcoinblas" CXXFLAGS="" FCFLAGS="-O2" CFLAGS="-O2" || cat config.log
sed -i "s/deplibs_check_method=.*/deplibs_check_method=\"pass_all\"/" libtool
make
make install

mkdir $mypwd/pack
cd $mypwd/coinhsl-install/lib
ls
cp $mypwd/coinhsl-install/bin/libcoinhsl-0.dll $mypwd/pack/libhsl.dll

cp /usr/lib/gcc/$compilerprefix/4.9-posix/*.dll $mypwd/pack
cp /usr/$compilerprefix/lib/libwinpthread-1.dll $mypwd/pack
zip -j libhsl_mingw.zip $mypwd/pack/*.dll

python -c "from restricted import *; upload('libhsl_mingw.zip')"

