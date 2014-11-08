#!/bin/bash

mkdir build
pushd build
cmake -DWITH_WORHP=ON -DWITH_SLICOT=ON -DWITH_OOQP=ON -DWITH_PROFILING=ON -DWITH_DOC=ON -DWITH_EXAMPLES=ON -DWITH_COVERAGE=ON -DWITH_EXTRA_WARNINGS=ON .. 
make -j2
sudo make -j2 install
popd

sudo apt-get install valgrind -y

python -c "from casadi.tools import *;loadAllCompiledPlugins()"
pushd test && make unittests_py_valgrind && popd


