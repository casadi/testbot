#!/bin/bash
#set -e

if [ -z "$SETUP" ]; then
  echo "noop"
else
  echo "nothing to do"
  #try_fetch_7z libworhp_macosx10.9_gcc49_1.8-3cdb565 worhp
  #try_fetch_7z libworhp_macosx10.9_gcc48_1.8-3cdb565 worhp
  #export WORHP=$HOME/build/worhp
  #export WORHP_LICENSE_FILE=$HOME/build/testbot/restricted/worhp/unlocked.lic
  #export MY_LIBRARY_PATH=$MY_LIBRARY_PATH:$WORHP/lib
  
  #sudo install_name_tool -change /opt/local/lib/libgcc/libgfortran.3.dylib "@rpath/libgfortran.3.dylib" $WORHP/lib/libworhp.dylib
  #sudo install_name_tool -change /opt/local/lib/libgcc/libgcc_s.1.dylib "@rpath/libgcc_s.1.dylib" $WORHP/lib/libworhp.dylib
  #sudo install_name_tool -change /opt/local/lib/libgcc/libstdc++.6.dylib "@rpath/libstdc++.6.dylib" $WORHP/lib/libworhp.dylib
  
  #sudo install_name_tool -change /opt/local/lib/libgcc/libgcc_s.1.dylib "@rpath/libgfortran.3.dylib" $WORHP/lib/libworhp.dylib
  #sudo install_name_tool -change /opt/local/lib/libgcc/libstdc++.6.dylib "@rpath/libgfortran.3.dylib" $WORHP/lib/libworhp.dylib
  #export casadi_build_flags="$casadi_build_flags -DWITH_WORHP=ON"
fi
