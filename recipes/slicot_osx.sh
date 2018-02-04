#!/bin/bash

#set -e

if [ -z "$SETUP" ]; then
  mypwd=`pwd`

  export SLURP_GCC=4.9
  export SLURP_OS=osx

  pushd $HOME/build
  slurp lapack
  popd

  git clone https://anonscm.debian.org/git/debian-science/packages/slicot.git

  cd slicot

  TAB="$(printf '\t')"
  
cat <<EOF >makefile
F77=gfortran-4.9
LDFLAGS += -Wl,--as-needed

SLICOT_SRC=\$(sort \$(shell echo src/*.f))
SLICOT_OBJ=\$(SLICOT_SRC:.f=.o)

src/%.o : src/%.f
$TAB\$(F77) \$(FFLAGS) -fPIC -c \$< -o \$@

libslicot.dll: \$(SLICOT_OBJ)
$TAB\$(F77) \$(LDFLAGS) -shared -Wl,-soname=libslicot.dylib -o \$@ \$^ -L$LIB -llapack -lblas -llapack
EOF

  make
  zip -j -r slicot_osx.zip libslicot.dylib
  slurp_put slicot_osx

else
  fetch_zip slicot osx
  export SLICOT_LIBRARY_DIR=$HOME/build/slicot
  export CASADI_ALLOW_GPL=ON
  export casadi_build_flags="$casadi_build_flags -DWITH_SLICOT=ON"
fi
