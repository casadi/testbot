#!/bin/bash
set -e

if [ -z "$SETUP" ]; then

  sudo apt-get install -y libpcre3-dev
  mypwd=`pwd`
  pushd restricted && wget http://sourceforge.net/projects/swig/files/swig/swig-2.0.12/swig-2.0.12.tar.gz && tar -xvf swig-2.0.12.tar.gz >/dev/null
  pushd swig-2.0.12 && ./configure --prefix=$mypwd/swig-install && make && make install
  popd && popd
  tar -zcvf swig_trusty.tar.gz -C swig-install .
  export PYTHONPATH="$PYTHONPATH:$mypwd/helpers" && python -c "from restricted import *; upload('swig_trusty.tar.gz')"

else
  fetch_tar swig trusty
  mkdir -p  $HOME/build/casadi/testbot
  pushd $HOME/build/casadi/testbot && ln -s  $HOME/build/swig  swig-install  && popd
  export PATH=$HOME/build/swig/bin:$PATH
fi
