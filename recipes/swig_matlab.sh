#!/bin/bash
set -e

if [ -z "$SETUP" ]; then
  sudo apt-get install -y libpcre3-dev automake yodl
  mypwd=`pwd`
  pushd restricted && git clone https://github.com/jaeandersson/swig.git
  pushd swig && git checkout matlab && ./autogen.sh && ./configure --prefix=$mypwd/swig-matlab-install && make && make install
  popd && popd
  tar -zcvf swig_matlab.tar.gz -C swig-matlab-install .
  export PYTHONPATH="$PYTHONPATH:$mypwd/helpers" && python -c "from restricted import *; upload('swig_matlab.tar.gz')"

else
  fetch_tar swig matlab
  pushd /home/travis/build/casadi/testbot && ln -s  /home/travis/build/swig  swig-install  && popd
  export PATH=/home/travis/build/swig/bin:$PATH
fi
