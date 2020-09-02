#!/bin/bash

(while true ; do sleep 60 ; echo "ping" ; done ) &
shell_session_update() { :; } # Workaround for travis-ci/travis-ci#6522
pushd casadi && export COMMIT=`git rev-parse --short=7 HEAD` && popd
pushd ../../ && git clone https://github.com/casadi/testbot.git
pushd testbot && source recipes/setup.sh && popd

ssh-keyscan web.sourceforge.net >> ~/.ssh/known_hosts 

echo "before_install.sh finish"
pwd
