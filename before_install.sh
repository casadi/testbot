#!/bin/bash

(while true ; do sleep 60 ; echo "ping" ; done ) &
shell_session_update() { :; } # Workaround for travis-ci/travis-ci#6522
pushd casadi && export COMMIT=`git rev-parse --short=7 HEAD` && popd
echo $?
echo "COMMIT: $COMMIT"
pushd ../../ && git clone https://github.com/casadi/testbot.git
echo $?
pushd testbot && source recipes/setup.sh && popd
echo $?

ssh-keyscan web.sourceforge.net >> ~/.ssh/known_hosts 
echo $?

echo "before_install.sh finish"
pwd
echo $?
