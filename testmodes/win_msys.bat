@echo on
mkdir my_build_msys
cd my_build_msys
cmake "-GMSYS Makefiles" ..
make
make install install_python
python -c "from casadi.tools import *;loadAllCompiledPlugins()"
cd ../test; make unittests_py examples_code_py; cd ../build
