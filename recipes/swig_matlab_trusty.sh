#!/bin/bash
set -e

if [ -z "$SETUP" ]; then
  sudo apt-get install -y libpcre3-dev automake yodl
  mypwd=`pwd`
  pushd restricted && git clone https://github.com/jaeandersson/swig.git
  pushd swig && git checkout $BAKEVERSION && ./autogen.sh && ./configure --prefix=$mypwd/swig-matlab-install && make && make install
  popd && popd
  tar -zcvf swig_matlab_trusty.tar.gz -C swig-matlab-install .
  slurp_put swig_matlab_trusty
else
  fetch_tar swig_matlab trusty
  mkdir -p  $HOME/build/casadi/testbot
  pushd $HOME/build/casadi/testbot && ln -s  $HOME/build/swig_matlab  swig-matlab-install  && popd
  export PATH=$HOME/build/swig_matlab/bin:$HOME/build/swig_matlab/share:$PATH
fi
