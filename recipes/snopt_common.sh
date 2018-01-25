#!/bin/bash

fetch_tar ipopt $SUFFIX
export SNOPT=$HOME/build/snopt
export casadi_build_flags="$casadi_build_flags -DWITH_SNOPT=ON"

export SNOPT_LICENSE=$HOME/build/testbot/restricted/snopt7.lic
