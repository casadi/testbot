#!/bin/bash
set -e

source shellhelpers

ssh-keyscan github.com >> ~/.ssh/known_hosts
ssh-keyscan web.sourceforge.net >> ~/.ssh/known_hosts
ssh-keyscan shell.sourceforge.net >> ~/.ssh/known_hosts


export PATH=$HOME/.local/bin:$PATH
pip install --user requests==2.6.0
pip install --user psutil
pip install --user pyaml
openssl aes-256-cbc -k "$keypass" -in id_rsa_travis.enc -out id_rsa_travis -d
openssl aes-256-cbc -k "$keypass" -in testbotcredentials.py.enc -out testbotcredentials.py -d
openssl aes-256-cbc -k "$keypass" -in env.sh.enc -out env.sh -d
chmod 600 id_rsa_travis

cat <<EOF >> ~/.ssh/config
Host github.com
        Hostname github.com
        User git
        IdentityFile $(pwd)/id_rsa_travis
EOF

git clone git@github.com:jgillis/restricted.git
git config --global user.email "testbot@casadidev.org"
git config --global user.name "casaditestbot"

function fetch_tar() {
  export SUFFIX=""
  if [ -z "$SLURP_GCC" ];
  then
    SUFFIX="$SUFFIX_gcc${SLURP_GCC}"
  fi
  travis_retry $HOME/build/testbot/recipes/fetch.sh $1_$2$SUFFIX.tar.gz && mkdir $1 && tar -xf $1_$2$SUFFIX.tar.gz -C $1 && rm $1_$2$SUFFIX.tar.gz
}

function fetch_zip() {
  travis_retry $HOME/build/testbot/recipes/fetch.sh $1_$2.zip && mkdir $1 && unzip $1_$2.tar.gz -d $1 && rm $1_$2.tar.gz
}
  
function slurp() {
  if [ -f $HOME/build/testbot/recipes/$1_${SLURP_CROSS}${BITNESS}_${SLURP_OS}.sh ];
  then
    SETUP=1 source $HOME/build/testbot/recipes/$1_${SLURP_CROSS}${BITNESS}_${SLURP_OS}.sh
  elif [ -f $HOME/build/testbot/recipes/$1_${SLURP_CROSS}_${SLURP_OS}.sh ];
  then
    SETUP=1 source $HOME/build/testbot/recipes/$1_${SLURP_CROSS}_${SLURP_OS}.sh
  elif [ -f $HOME/build/testbot/recipes/$1_${SLURP_OS}.sh ];
  then
    SETUP=1 source $HOME/build/testbot/recipes/$1_${SLURP_OS}.sh
  else
    SETUP=1 source $HOME/build/testbot/recipes/$1.sh
  fi
}

function slurp_put() {
  SUFFIX=""
  if [ -z "$GCCVERSION" ];
  then
    SUFFIX="$SUFFIX_gcc${GCCVERSION}"
  fi

  export PYTHONPATH="$PYTHONPATH:$HOME/build/casadi/testbot/helpers"
  python -c "from restricted import *; upload('$1.tar.gz','$1$SUFFIX.tar.gz')"
}

export RECIPES_FOLDER="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
