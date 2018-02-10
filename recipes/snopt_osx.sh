#!/bin/bash
export SUFFIX=osx
source $RECIPES_FOLDER/snopt_common.sh
export MY_LIBRARY_PATH=$SNOPT:$MY_LIBRARY_PATH
sudo install_name_tool -change /opt/local/lib/libgcc/libgfortran.3.dylib "@rpath/libgfortran.3.dylib" $SNOPT/libsnopt7.dylib
sudo install_name_tool -change /opt/local/lib/libgcc/libgcc_s.1.dylib "@rpath/libgcc_s.1.dylib" $SNOPT/libsnopt7.dylib
sudo install_name_tool -change /opt/local/lib/libgcc/libquadmath.0.dylib "@rpath/libquadmath.0.dylib" $SNOPT/libsnopt7.dylib
