#!/bin/bash
set -e

mypwd=`pwd`

sudo apt-get update -qq
sudo apt-get remove -qq -y mingw32
sudo apt-get install -q -y mingw-w64
sudo apt-get install -q -y mingw-w64 g++-mingw-w64 gcc-mingw-w64 gfortran-mingw-w64

pwd
ls

recipes/fetch.sh matlab$MATLABRELEASE.tar.gz

export PYTHONPATH="$PYTHONPATH:$mypwd/helpers" && python -c "from restricted import *; download('ipopt_mingw64.tar.gz')"
mkdir ipopt && tar -xf ipopt_mingw64.tar.gz -C ipopt
pushd /home/travis/ && ln -s $mypwd/ipopt ipopt-install  && popd

pushd restricted
wget http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/OLD/metis-4.0.3.tar.gz
tar -xvf coinhsl.tar.gz && cd coinhsl-2014.01.10 && tar -xvf ../metis-4.0.3.tar.gz

./configure --host x86_64-w64-mingw32 --prefix=$mypwd/coinhsl-install LIBS="-L/home/travis/ipopt-install/lib" --with-blas="-lcoinblas -lcoinlapack -lcoinblas" CXXFLAGS="-fopenmp" FCFLAGS="-O2 -fopenmp" CFLAGS="-O2 -fopenmp"
sed -i "s/deplibs_check_method=.*/deplibs_check_method=\"pass_all\"/" libtool
make
make install

cd $mypwd/coinhsl-install/lib && cp libcoinhsl-0.dll libcoinhsl.dll && cp libcoinhsl-0.dll libcoinhsl.so
cp /usr/lib/gcc/x86_64-w64-mingw32/4.9-posix/libgfortran-3.dll .
cp /usr/lib/gcc/x86_64-w64-mingw32/4.9-posix/libgomp-1.dll .
cp /usr/x86_64-w64-mingw32/lib/libwinpthread-1.dll .
cp /usr/lib/gcc/x86_64-w64-mingw32/4.9-posix/libgcc_s_seh-1.dll .
zip -r libhsl_mingw64.zip *.dll *.so

export PYTHONPATH="$PYTHONPATH:$mypwd/helpers" && python -c "from restricted import *; upload('libhsl_mingw64.zip')"

