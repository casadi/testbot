#!/bin/bash
#set -e

export SUFFIX=trusty

if [ -z "$SETUP" ]; then
  export SUFFIXFILE=_$SUFFIX
  mypwd=`pwd`
  hg clone http://hg.octave.org/mxe-octave/
  cd mxe-octave
  hg update d88f6ada9d07
  autoconf
  if [[ $BITNESS == 64 ]]
  then
    ./configure --enable-windows-64 --enable-fortran-int64
  else
    ./configure --disable-windows-64 --disable-fortran-int64
  fi
  (while true ; do sleep 60 ; echo "ping" ; done ) &
  make build-gcc -j2
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
  export MINGW_LIB=$MINGW_ROOT/$compilerprefix/lib
  export PATH=$MINGW_ROOT/bin:$MINGW_ROOT/bin/$compilerprefix:$PATH
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$MINGW_ROOT/x86_64-unknown-linux-gnu/$compilerprefix/lib/:$MINGW_LIB
  echo $MINGW_LIB
  mkdir -p /home/travis/build/casadi/testbot/
  # For .la files
  ln -s $HOME/build/mingw_octave$BITNESS /home/travis/build/casadi/testbot/mxe-octave
fi
