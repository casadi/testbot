#!/bin/bash
set -e

mypwd=`pwd`

export compilerprefix=i686-w64-mingw32

sudo add-apt-repository ppa:umn-claoit-rce/compute-packages -y
sudo add-apt-repository ppa:baltix-members/ppa -y # for libslicot-dev
sudo add-apt-repository ppa:tkelman/mingw-backport -y
sudo apt-get update -qq
sudo apt-get install -y binutils gcc g++ gfortran git cmake


sudo apt-get update -qq
sudo apt-get remove -qq -y mingw32
sudo apt-get install -q -y mingw-w64
sudo apt-get install -q -y mingw-w64 g++-mingw-w64 gcc-mingw-w64 gfortran-mingw-w64


git clone https://github.com/embotech/ecos.git && pushd ecos && make ISWINDOWS=1 CC=$compilerprefix-gcc AR=$compilerprefix-ar RANLIB=$compilerprefix-ranlib && tar -cvf $mypwd/ecos_mingw.tar.gz . && popd

cd $mypwd
export PYTHONPATH="$PYTHONPATH:$mypwd/helpers" && python -c "from restricted import *; upload('ecos_mingw.tar.gz')"
