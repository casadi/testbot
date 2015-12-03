#!/bin/bash
set -e
brew install pcre automake

echo "touch \${@: -2}" > yodl2man && chmod +x yodl2man
export PATH=$PATH:`pwd`

mypwd=`pwd`
pushd restricted && git clone https://github.com/jaeandersson/swig.git
pushd swig && git checkout 82714bf35c33fe2 && ./autogen.sh && ./configure --prefix=$mypwd/swig-matlab-install && make && make install
popd && popd
tar -zcvf swig_matlab_fixed_osx.tar.gz -C swig-matlab-install .
export PYTHONPATH="$PYTHONPATH:$mypwd/helpers" && python -c "from restricted import *; upload('swig_matlab_fixed_osx.tar.gz')"
