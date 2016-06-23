#!/bin/bash
set -e

if [ -z "$SETUP" ]; then
  hg clone http://hg.octave.org/mxe-octave/
  cd mxe-octave
  autoconf
  ./configure
  make -j2
  

else
fi
