#!/bin/bash
sudo apt-get install -y libblas-dev liblapack-dev gfortran
mypwd=`pwd`
mkdir "$mypwd/snopt7-install"
pushd restricted && tar -xvf snopt7.tar.gz && cd snopt7 && ./configure --prefix "$mypwd/snopt7-install" --with-api && make && make install && popd && tar -zcvf snopt7.tar.gz -C snopt7-install .

pwd
ls
export PYTHONPATH="$PYTHONPATH:$mypwd/helpers" && python -c "from restricted import *; upload('snopt7.tar.gz')"
