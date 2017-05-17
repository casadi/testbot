#!/bin/bash
set -e

export SUFFIX=trusty

if [ -z "$SETUP" ]; then
  export SUFFIXFILE=_$SUFFIX
  mypwd=`pwd`
  hg clone http://hg.octave.org/mxe-octave/
  cd mxe-octave
  autoconf
  if [[ $BITNESS == 64 ]]
  then
    ./configure --enable-system-gcc --enable-windows-64
  else
    ./configure --enable-system-gcc --disable-windows-64
  fi
  (while true ; do sleep 60 ; echo "ping" ; done ) &
  make mingw-w64
  ls -al
  echo "tar -zcvf mingw_octave$BITNESS$SUFFIXFILE.tar.gz -C $mypwd usr /dev/null"
  tar -zcvf mingw_octave$BITNESS$SUFFIXFILE.tar.gz usr >/dev/null
  slurp_put mingw_octave$BITNESS$SUFFIXFILE
else
  echo "mingw_octave_start :$BAKEVERSION:"
  pushd $HOME/build
  fetch_tar mingw_octave$BITNESS trusty
  popd
  echo "mingw_octave_end :$BAKEVERSION:"
  export MINGW_ROOT=$HOME/build/mingw_octave$BITNESS/usr
  export PATH=$HOME/build/mingw_octave$BITNESS/usr/bin:$HOME/build/mingw_octave$BITNESS/usr/bin/$compilerprefix:$PATH
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/build/mingw_octave$BITNESS/usr/x86_64-unknown-linux-gnu/$compilerprefix/lib/
  mkdir -p /home/travis/build/casadi/testbot/
  # For .la files
  ln -s $HOME/build/mingw_octave$BITNESS /home/travis/build/casadi/testbot/mxe-octave
fi
