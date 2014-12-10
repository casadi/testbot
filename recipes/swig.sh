#!/bin/bash
set -e
sudo apt-get install -y libpcre3-dev
mypwd=`pwd`
pushd restricted && wget http://sourceforge.net/projects/swig/files/swig/swig-2.0.11/swig-2.0.11.tar.gz && tar -xvf swig-2.0.11.tar.gz >/dev/null
pushd swig-2.0.11 && ./configure --prefix=$mypwd/swig-install && make && make install
popd && popd
tar -zcvf swig.tar.gz -C swig-install .
export PYTHONPATH="$PYTHONPATH:$mypwd/helpers" && python -c "from restricted import *; upload('swig.tar.gz')"
