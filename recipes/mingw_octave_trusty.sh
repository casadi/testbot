#!/bin/bash
set -e

export SUFFIX=trusty

if [ -z "$SETUP" ]; then
  export SUFFIXFILE=_$SUFFIX
  mypwd=`pwd`
  hg clone http://hg.octave.org/mxe-octave/
  cd mxe-octave
  autoconf
  ./configure
  (while true ; do sleep 60 ; echo "ping" ; done ) &
  make mingw-w64
  ls -al
  echo "tar -zcvf mingw_octave$SUFFIXFILE.tar.gz -C $mypwd usr /dev/null"
  tar -zcvf mingw_octave$SUFFIXFILE.tar.gz usr >/dev/null
  slurp_put mingw_octave$SUFFIXFILE
else
  fetch_tar mingw_octave trusty
  export PATH=$HOME/build/mingw_octave/usr/bin:$PATH
fi
