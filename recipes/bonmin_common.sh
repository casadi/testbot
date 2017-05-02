#!/bin/bash

if [ -z "$SETUP" ]; then

  mypwd=`pwd`

  VERSION=1.8.4

  wget http://www.coin-or.org/Tarballs/Bonmin/Bonmin-$VERSION.tgz
  tar -xvf Bonmin-$VERSION.tgz
  pushd Bonmin-$VERSION
  cat <<EOF > dlopen.patch
diff --git a/Ipopt/src/contrib/LinearSolverLoader/LibraryHandler.c b/Ipopt/src/contrib/LinearSolverLoader/LibraryHandler.c
index 2387f02..4e75c34 100644
--- a/Ipopt/src/contrib/LinearSolverLoader/LibraryHandler.c
+++ b/Ipopt/src/contrib/LinearSolverLoader/LibraryHandler.c
@@ -46,7 +46,11 @@ soHandle_t LSL_loadLib(const char *libName, char *msgBuf, int msgLen)
     mysnprintf(msgBuf, msgLen, "Windows error while loading dynamic library %s, error = %d.\n(see http://msdn.microsoft.com/en-us/library/ms681381%%28v=vs.85%%29.aspx)\n", libName, GetLastError());
   }
 # else
+#ifdef __APPLE__
   h = dlopen (libName, RTLD_NOW);
+#else
+  h = dlopen (libName, RTLD_NOW | RTLD_DEEPBIND);
+#endif
   if (NULL == h) {
     strncpy(msgBuf, dlerror(), msgLen);
     msgBuf[msgLen-1]=0;
EOF
  patch -p1 < dlopen.patch 
  pushd ThirdParty
  #pushd ASL && ./get.ASL && popd
  pushd Blas && ./get.Blas && popd 
  pushd Lapack && ./get.Lapack && popd 
  pushd Metis && ./get.Metis && popd 
  pushd Mumps && ./get.Mumps && popd
  popd
  mkdir build
  pushd build
  # build must contain mingw, in order for the hsl loader to look for .dll as opposed to .so
  ../configure $FLAGS --prefix=$HOME/bonmin-install --disable-shared ADD_FFLAGS=-fPIC ADD_CFLAGS=-fPIC ADD_CXXFLAGS=-fPIC --with-blas=BUILD --with-lapack=BUILD --with-mumps=BUILD --with-metis=BUILD --without-hsl --without-asl
  (while true ; do sleep 60 ; echo "ping" ; done ) &
  make 2> /dev/null
  make install
  popd && popd
  tar -zcvf bonmin$SUFFIXFILE.tar.gz -C $HOME/bonmin-install .
  slurp_put bonmin$SUFFIXFILE
else
  fetch_tar bonmin $SUFFIX
  export casadi_build_flags="$casadi_build_flags -DWITH_BONMIN=ON"
  
  export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$HOME/bonmin-install/lib/pkgconfig
  pushd $HOME/ && ln -s  $HOME/build/bonmin bonmin-install && popd
fi

