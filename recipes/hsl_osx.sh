#!/bin/bash
#set -e


if [ -z "$SETUP" ]; then
  export SLURP_OS=osx
  export SLURP_GCC=7
  pushd $HOME/build && slurp ipopt && popd
  
  mypwd=`pwd`
  pushd restricted
  wget http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/OLD/metis-4.0.3.tar.gz
  tar -xvf coinhsl.tar.gz
  cd coinhsl-2014.01.10
  sed -i '.original' 's/SHLIBEXT "so"/SHLIBEXT "dylib"/' loadmetis/loadmetis.c
  tar -xvf ../metis-4.0.3.tar.gz
  osx_rpath_restore
  ./configure --prefix=$mypwd/coinhsl-install LIBS="-L$HOME/build/ipopt-install/lib" --with-blas="-lcoinblas -lcoinlapack -lcoinblas -lgfortran" CXXFLAGS="-O2" FCFLAGS="-O2"
  osx_rpath
  make
  make install
  cd $mypwd/coinhsl-install/lib
  ls
  mv libcoinhsl.0.dylib libhsl.dylib
  rm libcoinhsl.dylib
  sudo install_name_tool -change $GCC_FULL_ALT "@rpath/libgcc_s.1.dylib" libhsl.dylib
  sudo install_name_tool -id "@rpath/libhsl.dylib" libhsl.dylib
  otool -l libhsl.dylib
  popd
  tar -zcvf hsl_osx.tar.gz -C $mypwd/coinhsl-install/lib . 

  slurp_put hsl_osx
else
  fetch_tar hsl osx
  rm hsl/*.a # Dangerous to have static libs lying around
  export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:$HOME/build/hsl
  export MY_LIBRARY_PATH=$MY_LIBRARY_PATH:$HOME/build/hsl
  ls $HOME/build/hsl
  export HSL=$HOME/build/hsl
  export casadi_build_flags="$casadi_build_flags -DWITH_HSL=ON"  
fi
