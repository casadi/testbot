#!/bin/bash
sudo apt-get install -y libblas-dev liblapack-dev
pushd restricted && wget http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/OLD/metis-4.0.3.tar.gz && tar -xvf coinhsl.tar.gz && cd coinhsl-2014.01.10 && tar -xvf ../metis-4.0.3.tar.gz && ./configure --prefix=/home/travis/casadi/casadi/coinhsl-install LIBS="-llapack" --with-blas="-L/usr/lib -lblas" CXXFLAGS="-g -O2 -fopenmp" FCFLAGS="-g -O2 -fopenmp" && make && make install && cd /home/travis/casadi/casadi/coinhsl-install/lib && ln -s libcoinhsl.so libhsl.so && popd && cp /home/travis/casadi/casadi/coinhsl-install/lib/libhsl.so .

export PYTHONPATH="$PYTHONPATH:helpers" && python -c "from restricted import *; upload('libhsl.so')"

