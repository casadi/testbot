#!/bin/bash
python -c "from casadi.tools import *;loadAllCompiledPlugins()"
pushd test & make trunktesterbot MEMCHECK=-memcheck & popd
pushd build && make json && popd
