#!/bin/bash

export SUFFIX=trusty
export SUFFIXFILE=_$SUFFIX
export FLAGS="coin_skip_warn_cxxflags=yes"
source recipes/bonmin_common.sh
