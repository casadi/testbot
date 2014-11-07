#!/bin/bash
sudo apt-get install python-lxml -y
git clone https://github.com/jgillis/pyreport.git
nm $SNOPT/lib/libsnopt7.so | grep snlog2_
pushd pyreport && sudo python setup.py install && popd
python -c "from casadi.tools import *;loadAllCompiledPlugins()"
pushd test & make trunktesterbot MEMCHECK=-memcheck & popd
pushd build && make json && popd
pushd docs/api && make full && popd

if [[ $TRAVIS_BRANCH == 'develop' ]]; then
    pushd docs/api && python /home/travis/build/testbot/helpers/publish_doc.py && popd
    git pull
    sh /home/travis/build/testbot/helpers/acommit.sh "automatic documentation update"
    python /home/travis/build/testbot/helpers/publish_builds.py
fi


