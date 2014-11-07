#!/bin/bash
mkdir build
pushd build
cmake -DWITH_WORHP=ON -DWITH_SLICOT=ON ..
make
sudo make install
popd
python -c "from casadi.tools import *;loadAllCompiledPlugins()"
pushd test && make unittests_py examples_code_py && popd
