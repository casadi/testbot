#!/bin/bash
set -e
sudo apt-get install -y libpcre3-dev
mypwd=`pwd`
pushd restricted && ssh-agent bash -c 'ssh-add id_rsa_travis; git clone git@github.com:jgillis/swig.git"
pushd swig && git checkout matlab && ./configure --prefix=$mypwd/swig-matlab-install && make && make install
popd && popd
tar -zcvf swig_matlab.tar.gz -C swig-matlab-install .
export PYTHONPATH="$PYTHONPATH:$mypwd/helpers" && python -c "from restricted import *; upload('swig_matlab.tar.gz')"
