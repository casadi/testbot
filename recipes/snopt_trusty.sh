#!/bin/bash

#!/bin/bash
export SUFFIX=trusty
source $RECIPES_FOLDER/snopt_common.sh
export LD_LIBRARY_PATH=$SNOPT:$LD_LIBRARY_PATH
