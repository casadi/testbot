#!/bin/bash

if [ -z "$SETUP" ]; then

  VERSION=3.12.3

  wget https://github.com/dthierry/IpoptOld/archive/l1_sep_2020.zip
  unzip l1_sep_2020.zip
  wget http://www.coin-or.org/download/source/Ipopt/Ipopt-$VERSION.tgz
  tar -xvf Ipopt-$VERSION.tgz
  pushd IpoptOld-l1_sep_2020
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
  if [[ $compilerprefix == *w64* ]]
  then
      # required for modern x86_64-w64-mingw32-pkg-config
      find . -type f -name "*" -exec sed -i'' -e 's/PKG_CONFIG_PATH/PKG_CONFIG_LIBDIR/g' {} +
  fi
  mkdir build
  pushd build
  mkdir $HOME/ipopt-install
  build_env ../configure $FLAGS --prefix=$HOME/ipopt-install --disable-shared ADD_FFLAGS=-fPIC ADD_CFLAGS=-fPIC ADD_CXXFLAGS=-fPIC --with-blas=BUILD --with-lapack=BUILD --with-mumps=BUILD --with-metis=BUILD --without-hsl --without-asl
  build_env make
  build_env make install
  popd && popd
  tar -zcvf ipopt$SUFFIXFILE.tar.gz -C $HOME/ipopt-install .
  slurp_put ipopt$SUFFIXFILE

else
  fetch_tar ipopt $SUFFIX
  pwd
  ls $HOME/build/ipopt
  export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$HOME/ipopt-install/lib/pkgconfig
  pushd $HOME && ln -s  $HOME/build/ipopt ipopt-install && popd
  export casadi_build_flags="$casadi_build_flags -DWITH_IPOPT=ON"
  echo "Ipopt configured"
fi

