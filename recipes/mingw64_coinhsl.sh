#!/bin/bash
set -e

mypwd=`pwd`

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
mkdir ipopt && tar -xf ipopt_mingw64.tar.gz -C ipopt
pushd /home/travis/ && ln -s $mypwd/ipopt ipopt-install  && popd

ls /home/travis/ipopt-install/lib

pushd restricted
wget http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/OLD/metis-4.0.3.tar.gz
tar -xvf coinhsl.tar.gz && cd coinhsl-2014.01.10 && tar -xvf ../metis-4.0.3.tar.gz

./configure --host x86_64-w64-mingw32 --prefix=$mypwd/coinhsl-install LIBS="-L/home/travis/ipopt-install/lib" --with-blas="-lcoinblas -lcoinlapack -lcoinblas" CXXFLAGS="" FCFLAGS="-O2" CFLAGS="-O2" || cat config.log
sed -i "s/deplibs_check_method=.*/deplibs_check_method=\"pass_all\"/" libtool
make
make install

mkdir $mypwd/pack
cd $mypwd/coinhsl-install/lib
ls
cp libcoinhsl-0.dll $mypwd/pack/libhsl.dll && cp libcoinhsl-0.dll $mypwd/pack/libhsl.so

cp /usr/lib/gcc/x86_64-w64-mingw32/4.9-posix/libgfortran-3.dll $mypwd/pack
cp /usr/lib/gcc/x86_64-w64-mingw32/4.9-posix/libgomp-1.dll $mypwd/pack
cp /usr/x86_64-w64-mingw32/lib/libwinpthread-1.dll $mypwd/pack
cp /usr/lib/gcc/x86_64-w64-mingw32/4.9-posix/libgcc_s_seh-1.dll $mypwd/pack
zip -r libhsl_mingw64.zip $mypwd/pack/*.dll $mypwd/pack/*.so

export PYTHONPATH="$PYTHONPATH:$mypwd/helpers" && python -c "from restricted import *; upload('libhsl_mingw64.zip')"

