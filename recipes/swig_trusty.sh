#!/bin/bash
set -e

if [ -z "$SETUP" ]; then

  sudo apt-get install -y libpcre3-dev
  mypwd=`pwd`
  pushd restricted && wget http://sourceforge.net/projects/swig/files/swig/swig-2.0.12/swig-2.0.12.tar.gz && tar -xvf swig-2.0.12.tar.gz >/dev/null
  pushd swig-2.0.12 && ./configure --prefix=$mypwd/swig-install && make && make install
  popd && popd
  tar -zcvf swig_trusty.tar.gz -C swig-install .
  slurp_put swig_trusty

else
  fetch_tar swig_matlab trusty
  mkdir -p  $HOME/build/casadi/testbot
  pushd $HOME/build/casadi/testbot && ln -s  $HOME/build/swig_matlab  swig-matlab-install  && popd
  export PATH=$HOME/build/swig_matlab/bin:$HOME/build/swig_matlab/share:$PATH
  function swig_patch_pyobject() {
    #sed -i -e 's/\"SwigPyObject\"/\"SwigPyCasadiObject\"/g' $SWIG_HOME/share/swig/2.0.12/python/pyrun.swg
    sed -i -e 's/\"SwigPyObject\"/\"SwigPyCasadiObject\"/g' $SWIG_HOME/share/swig/*/python/pyrun.swg
  }
fi
