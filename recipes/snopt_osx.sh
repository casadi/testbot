#!/bin/bash
export SUFFIX=osx
source $RECIPES_FOLDER/snopt_common.sh
export MY_LIBRARY_PATH=$SNOPT:$MY_LIBRARY_PATH
sudo install_name_tool -change /opt/local/lib/libgcc/libgfortran.3.dylib $FORTRAN_FULL $SNOPT/*.dylib
sudo install_name_tool -change /opt/local/lib/libgcc/libgcc_s.1.dylib $GCC_FULL $SNOPT/*.dylib
sudo install_name_tool -change /opt/local/lib/libgcc/libquadmath.0.dylib $QUADMATH_FULL $SNOPT/*.dylib
