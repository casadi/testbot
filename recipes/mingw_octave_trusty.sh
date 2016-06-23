#!/bin/bash
set -e

if [ -z "$SETUP" ]; then
  mypwd=`pwd`
  sudo apt-get install -y automake
  hg clone http://hg.octave.org/mxe-octave/
  cd mxe-octave
  autoconf
  ./configure
  (while true ; do sleep 60 ; echo "ping" ; done ) &
  make -j2 mingw-w64
  tar -zcvf mingw_octave$SUFFIXFILE.tar.gz -C $mypwd .
  slurp_put mingw_octave$SUFFIXFILE
else
  fetch_tar mingw_octave $SUFFIX
  export PATH=$HOME/build/mingw_octave:$PATH
fi
