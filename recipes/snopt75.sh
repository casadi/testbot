#!/bin/bash
set -e

sudo apt-get install -y libblas-dev liblapack-dev gfortran
wget http://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz
tar -xvf autoconf-2.69.tar.gz
pushd autoconf-2.69 && ./configure && make && sudo make install && popd
mypwd=`pwd`
mkdir "$mypwd/snopt7-install"
export PYTHONPATH="$PYTHONPATH:$mypwd/helpers" && python -c "from restricted import *; download('snopt75-src.tar.gz')"
tar -xvf snopt75-src.tar.gz && pushd snopt7 && ./configure --prefix "$mypwd/snopt7-install" --with-cpp  --with-64 && make && make install && popd
tar -zcvf snopt75.tar.gz -C snopt7-install .
export PYTHONPATH="$PYTHONPATH:$mypwd/helpers" && python -c "from restricted import *; upload('snopt75.tar.gz')"
