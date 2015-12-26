#!/bin/bash
set -e

mypwd=`pwd`

export compilerprefix=x86_64-w64-mingw32

sudo apt-get update -qq
sudo apt-get install -y binutils gcc g++ gfortran git cmake

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

git clone https://github.com/jgillis/ecos.git && pushd ecos && make ISWINDOWS=1 CC=$compilerprefix-gcc AR=$compilerprefix-ar RANLIB=$compilerprefix-ranlib && tar -cvf $mypwd/ecos_mingw64_trusty.tar.gz . && popd

cd $mypwd
export PYTHONPATH="$PYTHONPATH:$mypwd/helpers" && python -c "from restricted import *; upload('ecos_mingw64_trusty.tar.gz')"
