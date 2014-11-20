#!/bin/bash
set -e

sudo add-apt-repository ppa:webupd8team/java -y
sudo apt-get update -q
sudo echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
sudo apt-get install python-pyparsing libhunspell-dev oracle-java7-installer -y
sudo pip install hunspell
wget https://www.languagetool.org/download/LanguageTool-2.7.zip
unzip LanguageTool-2.7.zip
mypwd=`pwd`
export languagetool="$mypwd/LanguageTool-2.7"

pushd build && make lint && popd
pushd build && export languagetool="$mypwd/LanguageTool-2.7" make spell && popd
pushd misc && python autogencode.py && popd
sh /home/travis/build/testbot/helpers/acommit.sh "automatic code generation"
git pull
git config --global push.default simple
git remote set-url origin git@github.com:casadi/casadi.git
ssh-agent bash -c 'ssh-add /home/travis/build/testbot/id_rsa_travis; git push origin HEAD:$TRAVIS_BRANCH'
