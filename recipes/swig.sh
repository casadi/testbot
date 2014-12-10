#!/bin/bash
set -e
sudo apt-get install -y libpcre3-dev tree dh-make
mypwd=`pwd`
pushd restricted && wget http://sourceforge.net/projects/swig/files/swig/swig-2.0.11/swig-2.0.11.tar.gz && tar -xvf swig-2.0.11.tar.gz >/dev/null
pushd swig-2.0.11 && dh_make --s --copyright gpl -f ../swig-2.0.11.tar.gz && dpkg-buildpackage -rfakeroot
tree
#export PYTHONPATH="$PYTHONPATH:$mypwd/helpers" && python -c "from restricted import *; upload('libhsl.tar.gz')"
