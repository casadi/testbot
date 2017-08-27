#!/bin/bash

if [ -z "$SETUP" ]; then

  VERSION=3.12.3

  wget http://www.coin-or.org/download/source/Ipopt/Ipopt-$VERSION.tgz
  tar -xvf Ipopt-$VERSION.tgz
  pushd Ipopt-$VERSION
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
  buildenv echo 123
  dockcross echo 123
  dockcross ../configure $FLAGS --prefix=$HOME/ipopt-install --disable-shared ADD_FFLAGS=-fPIC ADD_CFLAGS=-fPIC ADD_CXXFLAGS=-fPIC --with-blas=BUILD --with-lapack=BUILD --with-mumps=BUILD --with-metis=BUILD --without-hsl --without-asl  
  buildenv ../configure $FLAGS --prefix=$HOME/ipopt-install --disable-shared ADD_FFLAGS=-fPIC ADD_CFLAGS=-fPIC ADD_CXXFLAGS=-fPIC --with-blas=BUILD --with-lapack=BUILD --with-mumps=BUILD --with-metis=BUILD --without-hsl --without-asl
  buildenv make
  buildenv make install
  popd && popd
  tar -zcvf ipopt$SUFFIXFILE.tar.gz -C $HOME/ipopt-install .
  slurp_put ipopt$SUFFIXFILE

else
  fetch_tar ipopt $SUFFIX
  
  export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$HOME/ipopt-install/lib/pkgconfig
  pushd $HOME && ln -s  $HOME/build/ipopt ipopt-install && popd
  export casadi_build_flags="$casadi_build_flags -DWITH_IPOPT=ON"  
fi

