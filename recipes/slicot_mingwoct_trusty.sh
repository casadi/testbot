#!/bin/bash

#set -e

if [ -z "$SETUP" ]; then
  mypwd=`pwd`

  export SLURP_CROSS=mingwoct
  export SLURP_OS=trusty

  slurp mingw_octave

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
  zip -j -r slicot_mingwoct${BITNESS}_trusty.zip libslicot.dll
  slurp_put slicot_mingwoct${BITNESS}_trusty

else
  fetch_zip slicot mingwoct${BITNESS}_trusty
  export SLICOT_LIBRARY_DIR=$HOME/build/slicot
  export CASADI_ALLOW_GPL=ON
  export casadi_build_flags="$casadi_build_flags -DWITH_SLICOT=ON"
fi
