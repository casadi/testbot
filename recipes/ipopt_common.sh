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
--- a/Ipopt/src/Algorithm/IpIpoptAlg.cpp	2013-10-19 20:18:04.000000000 +0200
+++ b/Ipopt/src/Algorithm/IpIpoptAlg.cpp	2019-10-17 13:12:55.000291572 +0200
@@ -262,7 +262,7 @@
     }
 
     if (!isResto) {
-      Jnlst().Printf(J_ITERSUMMARY, J_MAIN, "This is Ipopt version "IPOPT_VERSION", running with linear solver %s.\n", linear_solver_.c_str());
+      Jnlst().Printf(J_ITERSUMMARY, J_MAIN, "This is Ipopt version " IPOPT_VERSION ", running with linear solver %s.\n", linear_solver_.c_str());

 #ifndef IPOPT_NOMUMPSNOTE
       if( linear_solver_ == "mumps" )
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
  echo "foobar"
  if [ -n "$CROSS_TRIPLE" ]; then
    #FLAGS="--host=x86_64-pc-linux-gnu --build=\$CROSS_TRIPLE $FLAGS --enable-dependency-linking"
    echo " hey $FLAGS"
  fi
  #FLAGS="--host=x86_64-pc-linux-gnu --build=\$CROSS_TRIPLE $FLAGS --enable-dependency-linking"
  #FLAGS="--host=\$CROSS_TRIPLE $FLAGS --enable-dependency-linking"
  # Looking at ThirdParty/Blas/config.log, configure logic seems to generate FLIBS with "-lm'" in it
  #export FLIBS="-L/usr/xcc/aarch64-unknown-linux-gnueabi/lib/gcc/aarch64-unknown-linux-gnueabi/4.9.4 -L/usr/xcc/aarch64-unknown-linux-gnueabi/lib/gcc/aarch64-unknown-linux-gnueabi/4.9.4/../../../../aarch64-unknown-linux-gnueabi/lib/../lib64 -L/usr/xcc/aarch64-unknown-linux-gnueabi/aarch64-unknown-linux-gnueabi/sysroot/lib/../lib64 -L/usr/xcc/aarch64-unknown-linux-gnueabi/aarch64-unknown-linux-gnueabi/sysroot/usr/lib/../lib64 -L/usr/xcc/aarch64-unknown-linux-gnueabi/lib/gcc/aarch64-unknown-linux-gnueabi/4.9.4/../../../../aarch64-unknown-linux-gnueabi/lib -L/usr/xcc/aarch64-unknown-linux-gnueabi/aarch64-unknown-linux-gnueabi/sysroot/lib -L/usr/xcc/aarch64-unknown-linux-gnueabi/aarch64-unknown-linux-gnueabi/sysroot/usr/lib -lgfortran -lm -lgcc_s"
  #echo "$FLAGS"
  #echo $FLAGS
  #echo $CC
  build_env echo $FLAGS
  build_env echo \$CC
  build_env echo \$FC
  build_env echo \$F77
  build_env echo $CC
  build_env echo \${CROSS_ROOT}/bin/\${CROSS_TRIPLE}-gcc
  build_env ../configure $CROSS_CONFIGURE $FLAGS --prefix=$HOME/ipopt-install --disable-shared ADD_FFLAGS=-fPIC ADD_CFLAGS=-fPIC ADD_CXXFLAGS=-fPIC --with-blas=BUILD --with-lapack=BUILD --with-mumps=BUILD --with-metis=BUILD --without-hsl --without-asl \|\| cat ThirdParty/Blas/config.log
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

