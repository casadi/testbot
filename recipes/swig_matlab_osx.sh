#!/bin/bash
set -e

if [ -z "$SETUP" ]; then
  brew install pcre automake

  echo "touch \${@: -2}" > yodl2man && chmod +x yodl2man
  export PATH=$PATH:`pwd`

  mypwd=`pwd`
  pushd restricted && git clone https://github.com/jaeandersson/swig.git
  pushd swig && git checkout $BAKEVERSION && ./autogen.sh && ./configure --prefix=$mypwd/swig-matlab-install && make && make install
  popd && popd
  tar -zcvf swig_matlab_osx.tar.gz -C swig-matlab-install .
  slurp_put swig_matlab_osx
else
  fetch_tar swig_matlab osx
  mkdir -p  $HOME/build/casadi/testbot
  pushd $HOME/build/casadi/testbot && ln -s  $HOME/build/swig_matlab  swig-matlab-install  && popd
  export PATH=$HOME/build/swig_matlab/bin:$HOME/build/swig_matlab/share:$PATH
  
  ls $HOME/build/swig_matlab/bin
fi
