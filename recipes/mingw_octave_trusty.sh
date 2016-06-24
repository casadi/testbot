#!/bin/bash
set -e

if [ -z "$SETUP" ]; then
  mypwd=`pwd`
  hg clone http://hg.octave.org/mxe-octave/
  cd mxe-octave
  autoconf
  ./configure
  (while true ; do sleep 60 ; echo "ping" ; done ) &
  make mingw-w64
  tar -zcvf mingw_octave$SUFFIXFILE.tar.gz -C $mypwd usr >dev/null
  slurp_put mingw_octave$SUFFIXFILE
else
  fetch_tar mingw_octave $SUFFIX
  export PATH=$HOME/build/mingw_octave/usr/bin:$PATH
fi
