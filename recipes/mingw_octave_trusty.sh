#!/bin/bash
set -e

if [ -z "$SETUP" ]; then
  mypwd=`pwd`
  hg clone http://hg.octave.org/mxe-octave/
  cd mxe-octave
  autoconf
  ./configure
  make mingw-w64
  tar -zcvf mingw_octave_trusty.tar.gz -C $mypwd .
else
  export PATH=$HOME/build/mingw_octave:$PATH
fi
