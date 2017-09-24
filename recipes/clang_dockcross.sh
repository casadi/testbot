#!/bin/bash
#set -e

export SUFFIX=manylinux${BITNESS}_dockcross
export SUFFIXFILE=_$SUFFIX

if [ -z "$SETUP" ]; then
  source recipes/clang_common.sh
  export BUILD_ENV=dockcross
  dockcross_setup_start
  dockcross_setup_finish
  mypwd=`pwd`

  #sudo apt-get install libc6-dev

  svn co http://llvm.org/svn/llvm-project/llvm/tags/RELEASE_$VERSION/final/ llvm >/dev/null
  cd llvm/tools
  svn co http://llvm.org/svn/llvm-project/cfe/tags/RELEASE_$VERSION/final/ clang >/dev/null
  cd ../projects
  svn co http://llvm.org/svn/llvm-project/libcxx/tags/RELEASE_$VERSION/final/ libcxx >/dev/null
  cd libcxx && patch -p0 -i $mypwd/recipes/libcxx.patch && cd ..
  cd ../..
  mkdir build
  cd build
  
  echo -e "[WandiscoSVN]\nname=Wandisco SVN Repo\nbaseurl=http://opensource.wandisco.com/centos/5/svn-1.8/RPMS/\$basearch/\nenabled=1\ngpgcheck=1" > subversion.repo
  
  wget http://opensource.wandisco.com/RPM-GPG-KEY-WANdisco
  gpg --quiet --with-fingerprint ./RPM-GPG-KEY-WANdisco

  echo 'export PATH=/opt/python/cp27-cp27m/bin:$PATH' >> $HOME/dockcross_at_start
  build_env "sudo rpm --import ./RPM-GPG-KEY-WANdisco;sudo cp subversion.repo /etc/yum.repos.d/wandisco-svn.repo;sudo yum clean all;sudo yum install -y epel-release;sudo yum install -y subversion;sudo yum install -y libxml2-devel;cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=\"$mypwd/install\" ../llvm;make clang-tblgen install -j2 || make clang-tblgen install"
  cp bin/clang-tblgen "$mypwd/install/bin"

  pushd ../install && tar -cvf $mypwd/clang$SUFFIXFILE.tar.gz . && popd

  cd $mypwd
  slurp_put clang$SUFFIXFILE


else
  fetch_tar clang $SUFFIX
  export CLANG=$HOME/build/clang
  export casadi_build_flags="$casadi_build_flags -DWITH_CLANG=ON -DOLD_LLVM=ON"
fi
