#!/bin/bash
python -c "from casadi.tools import *;loadAllCompiledPlugins()"
pushd test && make unittests_py examples_code_py && popd
