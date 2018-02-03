#!/bin/bash
#set -e

export SUFFIX=mingwoct${BITNESS}_trusty

if [ -z "$SETUP" ]; then
  mypwd=`pwd`
  export SUFFIXFILE=_$SUFFIX
  
  export SLURP_OS=trusty
  slurp mingw_octave
  export SLURP_CROSS=mingwoct
  pushd $HOME/build
  slurp ipopt
  popd
  pushd restricted
  wget http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/OLD/metis-4.0.3.tar.gz
  tar -xvf coinhsl.tar.gz && cd coinhsl-2014.01.10 && tar -xvf ../metis-4.0.3.tar.gz
  ./configure --disable-static --enable-shared --host $compilerprefix --prefix=$mypwd/coinhsl-install LIBS="-L/home/travis/ipopt-install/lib" --with-blas="-lcoinblas -lcoinlapack -lcoinblas" CXXFLAGS="" FCFLAGS="-O2" CFLAGS="-O2" || cat config.log
  sed -i "s/deplibs_check_method=.*/deplibs_check_method=\"pass_all\"/" libtool
  sed -i "s/soname_spec=.*/soname_spec=\"libhsl.dll\"/" libtool
  make VERBOSE=1
  make install

  mkdir $mypwd/pack
  cd $mypwd/coinhsl-install/bin
  cp libhsl.dll $mypwd/pack/libhsl.dll
  pushd $mypwd/pack/
  sudo apt-get install -y mingw-w64-tools
  gendef libhsl.dll - | tee  libhsl.def
  which $compilerprefix-dlltool
  $compilerprefix-dlltool --dllname libhsl.dll -d libhsl.def  -l libhsl.lib
  popd
  zip -j -r hsl$SUFFIXFILE $mypwd/pack/*.dll hsl$SUFFIXFILE $mypwd/pack/*.lib hsl$SUFFIXFILE $mypwd/pack/*.a
  
  slurp_put hsl$SUFFIXFILE
else
  fetch_zip hsl $SUFFIX
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/build/hsl
  export HSL=$HOME/build/hsl
  export casadi_build_flags="$casadi_build_flags -DWITH_HSL=ON"  
fi

