#!/bin/bash

mkdir build
pushd build
cmake -DWITH_WORHP=ON -DWITH_SLICOT=ON -DWITH_OOQP=ON -DWITH_PROFILING=ON -DWITH_DOC=ON -DWITH_EXAMPLES=ON -DWITH_COVERAGE=ON -DWITH_EXTRA_WARNINGS=ON .. 
make -j2
sudo make -j2 install
popd

git clone https://github.com/jgillis/pyreport.git
pushd pyreport && sudo python setup.py install && popd
sudo apt-get install python-lxml python-docutils texlive-science valgrind texlive-font-utils -y

pushd docs/api && make full && popd

if [[ $TRAVIS_BRANCH == 'develop' ]]; then
    pushd docs/api && python /home/travis/build/testbot/helpers/publish_doc.py && popd
    git pull
    sh /home/travis/build/testbot/helpers/acommit.sh "automatic documentation update"
    python /home/travis/build/testbot/helpers/publish_builds.py
fi


