#!/bin/bash
set -e

export SUFFIX=mingw${BITNESS}_trusty

if [ -z "$SETUP" ]; then
  mypwd=`pwd`
  mingw_setup
  export SUFFIXFILE=_$SUFFIX
  
  export SLURP_OS=trusty
  export SLURP_CROSS=mingw
  pushd $HOME/build
  slurp ipopt
  popd
  pushd restricted
  wget http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/OLD/metis-4.0.3.tar.gz
  tar -xvf coinhsl.tar.gz && cd coinhsl-2014.01.10 && tar -xvf ../metis-4.0.3.tar.gz
  ./configure --disable-static --enable-shared --host $compilerprefix --prefix=$mypwd/coinhsl-install LIBS="-L/home/travis/ipopt-install/lib" --with-blas="-lcoinblas -lcoinlapack -lcoinblas" CXXFLAGS="" FCFLAGS="-O2" CFLAGS="-O2" || cat config.log
  sed -i "s/deplibs_check_method=.*/deplibs_check_method=\"pass_all\"/" libtool
  make
  make install

  mkdir $mypwd/pack
  cd $mypwd/coinhsl-install/bin
  cp libcoinhsl-0.dll $mypwd/pack/libhsl.dll

  cp /usr/lib/gcc/$compilerprefix/4.9-posix/*.dll $mypwd/pack
  cp /usr/$compilerprefix/lib/*.dll $mypwd/pack
  zip -r hsl$SUFFIXFILE $mypwd/pack/*.dll
  
  slurp_put hsl$SUFFIXFILE
else
  fetch_zip hsl $SUFFIX
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/build/hsl
  export HSL=$HOME/build/hsl
fi

