#!/bin/bash
set -e

if [ -z "$SETUP" ]; then
  brew install pcre automake

  echo "touch \${@: -2}" > yodl2man && chmod +x yodl2man
  export PATH=$PATH:`pwd`

  mypwd=`pwd`
  pushd restricted && git clone https://github.com/jaeandersson/swig.git
  pushd swig && git checkout matlab && ./autogen.sh && ./configure --prefix=$mypwd/swig-matlab-install && make && make install
  popd && popd
  tar -zcvf swig_matlab_osx.tar.gz -C swig-matlab-install .
  slurp_put swig_matlab_osx
else
  fetch_tar swig matlab_osx
  mkdir -p  $HOME/build/casadi/testbot
  pushd $HOME/build/casadi/testbot && ln -s  $HOME/build/swig  swig-install  && popd
  export PATH=$HOME/build/swig/bin:$PATH
fi
