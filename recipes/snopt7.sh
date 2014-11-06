#!/bin/bash
sudo apt-get install -y libblas-dev liblapack-dev gfortran
mypwd=`pwd`
pushd restricted && tar -xvf snopt7.tar.gz && cd snopt7 && ./configure --prefix "$pwd/snopt7-install" && make && make install && popd && tar -zcvf snopt7-install.tar.gz -C snopt7-install .

export PYTHONPATH="$PYTHONPATH:$mypwd/helpers" && python -c "from restricted import *; upload('snopt7.tar.gz')"
