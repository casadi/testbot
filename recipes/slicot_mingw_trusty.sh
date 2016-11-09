#!/bin/bash

set -e

if [ -z "$SETUP" ]; then


  export SLURP_CROSS=mingw
  export SLURP_OS=trusty

  slurp lapack

  mypwd=`pwd`

  mingw_setup

  git clone https://anonscm.debian.org/git/debian-science/packages/slicot.git

  cd slicot

  cat <<EOF >makefile
  F77=$compilerprefix-gfortran
  LDFLAGS += -Wl,--as-needed

  SLICOT_SRC=$(sort $(shell echo src/*.f))
  SLICOT_OBJ=$(SLICOT_SRC:.f=.o)

  src/%.o : src/%.f
          $(F77) $(FFLAGS) -fPIC -c $< -o $@

  libslicot.dll: $(SLICOT_OBJ)
          $(F77) $(LDFLAGS) -shared -Wl,-soname=libslicot.dll -o $@ $^ -L$LIB -llapack -lblas -llapack
EOF

  make
  pushd lib && tar -cvf $mypwd/slicot${BITNESS}_trusty.tar.gz . && popd
  popd && popd
  slurp_put slicot${BITNESS}_trusty

else
  fetch_tar slicot${BITNESS}_trusty
  export SLICOT_LIBRARY_DIR=$HOME/build/slicot
fi
