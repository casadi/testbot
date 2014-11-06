#!/bin/bash
sudo apt-get install -y libblas-dev liblapack-dev gfortran f2c
mypwd=`pwd`
mkdir "$mypwd/snopt7-install"
pushd restricted && tar -xvf snopt7.tar.gz && cd snopt7 && ./configure --prefix "$mypwd/snopt7-install" && make && make install && popd
git clone https://github.com/snopt/snopt-interface.git
pushd snopt-interface && ./autogen.sh && ./configure --with-snopt="$mypwd/snopt7-install/lib" --prefix="$mypwd/snopt7-install" && make && make install && popd
tar -zcvf snopt7.tar.gz -C snopt7-install .
export PYTHONPATH="$PYTHONPATH:$mypwd/helpers" && python -c "from restricted import *; upload('snopt7.tar.gz')"
