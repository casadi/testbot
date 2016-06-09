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
  pushd $HOME/build/casadi/testbot && ln -s  $HOME/build/swig  swig-install  && popd
  export PATH=$HOME/build/swig/bin:$PATH
fi
