#!/bin/bash

set -e

if [ -z "$SETUP" ]; then
  mypwd=`pwd`

  mingw_setup

  export SLURP_CROSS=mingw
  export SLURP_OS=trusty

  pushd $HOME/build
  slurp lapack
  popd

  git clone https://anonscm.debian.org/git/debian-science/packages/slicot.git

  cd slicot

  TAB="$(printf '\t')"
  
cat <<EOF >makefile
F77=$compilerprefix-gfortran
LDFLAGS += -Wl,--as-needed

SLICOT_SRC=\$(sort \$(shell echo src/*.f))
SLICOT_OBJ=\$(SLICOT_SRC:.f=.o)

src/%.o : src/%.f
$TAB\$(F77) \$(FFLAGS) -fPIC -c \$< -o \$@

libslicot.dll: \$(SLICOT_OBJ)
$TAB\$(F77) \$(LDFLAGS) -shared -Wl,-soname=libslicot.dll -o \$@ \$^ -L$LIB -llapack -lblas -llapack
EOF

  make
  zip -j -r f slicot_mingw${BITNESS}_trusty.zip libslicot.dll
  slurp_put slicot_mingw${BITNESS}_trusty

else
  fetch_zip slicot mingw${BITNESS}_trusty
  export SLICOT_LIBRARY_DIR=$HOME/build/slicot
  export CASADI_ALLOW_GPL=ON
fi
