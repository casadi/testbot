#!/bin/bash
set -e

if [ -z "$SETUP" ]; then
  sudo apt-get install -y libpcre3-dev automake yodl
  mypwd=`pwd`
  pushd restricted && git clone https://github.com/jaeandersson/swig.git
  pushd swig && git checkout matlab && ./autogen.sh && ./configure --prefix=$mypwd/swig-matlab-install && make && make install
  popd && popd
  tar -zcvf swig_matlab_trusty.tar.gz -C swig-matlab-install .
  export PYTHONPATH="$PYTHONPATH:$mypwd/helpers" && python -c "from restricted import *; upload('swig_matlab_trusty.tar.gz')"

else
  fetch_tar swig_matlab trusty
  pushd $HOME/build/casadi/testbot && ln -s  $HOME/build/swig_matlab  swig-matlab-install  && popd
  export PATH=$HOME/build/swig_matlab/bin:$HOME/build/swig_matlab/share:$PATH
fi
