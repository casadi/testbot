#!/bin/bash
set -e

if [ -z "$SETUP" ]; then
  sudo apt-get install -y libblas-dev liblapack-dev
  mypwd=`pwd`
  pushd restricted
  wget http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/OLD/metis-4.0.3.tar.gz
  tar -xvf coinhsl.tar.gz
  cd coinhsl-2014.01.10
  tar -xvf ../metis-4.0.3.tar.gz
  ./configure --prefix=$mypwd/coinhsl-install --disable-static --enable-shared LIBS="-llapack" --with-blas="-L/usr/lib -lblas" CXXFLAGS="-O2 -fPIC -ftls-model=local-dynamic" FCFLAGS="-O2 -fPIC -ftls-model=local-dynamic"
  make
  make install
  cd $mypwd/coinhsl-install/lib
  ln -s libcoinhsl.so libhsl.so
  popd
  tar -zcvf hsl_trusty.tar.gz -C $mypwd/coinhsl-install/lib . 

  #echo "test" > libhsl.tar.gz
  slurp_put hsl_trusty
else
  fetch_tar hsl trusty
  rm -f hsl/*.a
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/build/hsl
  export HSL=$HOME/build/hsl
  export casadi_build_flags="$casadi_build_flags -DWITH_HSL=ON"  
fi
