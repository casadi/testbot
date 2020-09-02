#!/bin/bash

(while true ; do sleep 60 ; echo "ping" ; done ) &
shell_session_update() { :; } # Workaround for travis-ci/travis-ci#6522
pushd casadi && export COMMIT=`git rev-parse --short=7 HEAD` && popd
echo $?
echo "COMMIT: $COMMIT"
pushd ../../ && git clone https://github.com/casadi/testbot.git
echo $?
pushd testbot && source recipes/setup.sh
echo $?
echo "popd"
popd
echo "before_install return"
echo $?

for i in {1..30}; do echo "foobar"; done

ssh-keyscan web.sourceforge.net >> ~/.ssh/known_hosts 
echo $?

echo "before_install.sh finish"
pwd
echo $?
