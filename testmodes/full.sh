#!/bin/bash
python -c "from casadi.tools import *;loadAllCompiledPlugins()"
pushd test & make trunktesterbot MEMCHECK=-memcheck & popd
pushd build && make json && popd
pushd docs/api && make full && popd

if [[ $TRAVIS_BRANCH == 'develop' ]]; then
    pushd docs/api && python /home/casadibot/testbot/helpers/publish_doc.py && popd
    git pull
    sh /home/travis/build/testbot/helpers/acommit.sh "automatic documentation update"
fi


