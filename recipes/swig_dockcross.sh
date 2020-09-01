#!/bin/bash
#set -e

export SUFFIX=manylinux${BITNESS}_dockcross

if [ -z "$SETUP" ]; then
  dockcross_setup_start
  dockcross_setup_finish
  export SUFFIXFILE=_$SUFFIX
  mypwd=`pwd`
  pushd restricted && git clone https://github.com/jaeandersson/swig.git
  pushd swig && git checkout $BAKEVERSION
  dockcross "sudo yum -y install pcre-devel; ./autogen.sh ; ./configure --prefix=$mypwd/swig-matlab-install; make ; make install"
  popd && popd
  tar -zcvf swig$SUFFIXFILE.tar.gz -C swig-matlab-install .
  slurp_put swig$SUFFIXFILE
else
  fetch_tar swig $SUFFIX
  mkdir -p  $HOME/build/casadi/testbot
  pushd $HOME/build/casadi/testbot && ln -s  $HOME/build/swig_matlab  swig-matlab-install  && popd
  export SWIG_HOME=/host/$HOME/build/swig_matlab
  export PATH=$SWIG_HOME/bin:$SWIG_HOME/share:$PATH
  ls $HOME/build/swig_matlab
  function swig_patch_pyobject() {
    sed -i -e 's/\"SwigPyObject\"/\"SwigPyCasadiObject\"/g' $SWIG_HOME/share/swig/3.0.11/python/pyrun.swg
  }
fi
