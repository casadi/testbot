#!/bin/bash
##set -e

export SUFFIX=manylinux${BITNESS}_dockcross

if [ -z "$SETUP" ]; then
  dockcross_setup_start
  dockcross_setup_finish
  mypwd=`pwd`
  
  export SUFFIXFILE=_$SUFFIX
  export SLURP_OS=dockcross
  export SLURP_CROSS=manylinux
  pushd $HOME/build
  slurp ipopt
  popd
  pushd restricted
  wget http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/OLD/metis-4.0.3.tar.gz
  tar -xvf coinhsl.tar.gz
  cd coinhsl-2014.01.10
  tar -xvf ../metis-4.0.3.tar.gz
  dockcross ./configure --prefix=$mypwd/coinhsl-install --disable-static --enable-shared LIBS='-L/home/travis/ipopt-install/lib' --with-blas='-lcoinblas -lcoinlapack -lcoinblas' CXXFLAGS='-O2 -fPIC -ftls-model=local-dynamic' FCFLAGS='-O2 -fPIC -ftls-model=local-dynamic' || cat config.log
  sed -i "s/deplibs_check_method=.*/deplibs_check_method=\"pass_all\"/" libtool
  dockcross make
  dockcross make install  
  cd $mypwd/coinhsl-install/lib
  ln -s libcoinhsl.so libhsl.so
  popd
  tar -zcvf hsl$SUFFIXFILE.tar.gz -C $mypwd/coinhsl-install/lib . 

  #echo "test" > libhsl.tar.gz
  slurp_put hsl$SUFFIXFILE
else
  fetch_tar hsl $SUFFIX
  rm -f hsl/*.a
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/build/hsl
  export HSL=$HOME/build/hsl
  export casadi_build_flags="$casadi_build_flags -DWITH_HSL=ON"  
fi
