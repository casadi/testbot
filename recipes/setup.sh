#!/bin/bash
set -e -E

source shellhelpers

ssh-keyscan github.com >> ~/.ssh/known_hosts
ssh-keyscan web.sourceforge.net >> ~/.ssh/known_hosts
ssh-keyscan shell.sourceforge.net >> ~/.ssh/known_hosts


export PATH=$HOME/.local/bin:$PATH
pip install --user requests==2.6.0
set -e -E
pip install --user psutil
echo $?
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


function try_fetch_tar () {
  echo "Fetching $1 -> $2"
  travis_retry $HOME/build/testbot/recipes/fetch.sh $1 && mkdir  -p $2 && tar -xf $1 -C $2 && rm $1
}

function fetch_tar() {
  export GCCSUFFIX=""
  if [ -n "$SLURP_GCC" ];
  then
    GCCSUFFIX="gcc${SLURP_GCC}"
  fi
  export BAKESUFFIX=""
  if [ -f $HOME/build/testbot/recipes/$1.yaml ];
  then
    if [ -d $HOME/build/casadi/binaries/casadi ];
    then
      export BAKEVERSION=`python $HOME/build/testbot/helpers/gitmatch.py $HOME/build/testbot/recipes/$1.yaml $HOME/build/casadi/binaries/casadi`
    else
      export BAKEVERSION=`python $HOME/build/testbot/helpers/gitmatch.py $HOME/build/testbot/recipes/$1.yaml $HOME/build/casadi/casadi`
    fi
    echo "For $1, choosing bake version $BAKEVERSION" 
    BAKESUFFIX="bake${BAKEVERSION}"
  fi
  try_fetch_tar $1_$2_${GCCSUFFIX}_${BAKESUFFIX}.tar.gz $1 || try_fetch_tar $1_$2_${BAKESUFFIX}.tar.gz $1
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
  VERSIONSUFFIX=""
  if [ -n "$GCCVERSION" ];
  then
    VERSIONSUFFIX="${VERSIONSUFFIX}_gcc${GCCVERSION}"
  fi
  if [ -n ${BAKEVERSION} ];
  then
    VERSIONSUFFIX="${VERSIONSUFFIX}_bake${BAKEVERSION}"
  fi
  export PYTHONPATH="$PYTHONPATH:$HOME/build/casadi/testbot/helpers"
  python -c "from restricted import *; upload('$1.tar.gz','$1$VERSIONSUFFIX.tar.gz')"
}

export RECIPES_FOLDER="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function matlabtunnel() {
  source $HOME/build/testbot/restricted/env.sh
  sudo bash -c "echo '127.0.0.1	$FLEX_SERVER' >> /etc/hosts;echo '127.0.0.1	$FLEX_HOSTNAME' >> /etc/hosts"
  sudo hostname $FLEX_HOSTNAME
  mkdir -p ~/.matlab/${MATLABRELEASE}_licenses/
  echo -e "SERVER $FLEX_SERVER ANY 1715\nUSE_SERVER" > ~/.matlab/${MATLABRELEASE}_licenses/license.lic
  ssh-keyscan $GATE_SERVER >> ~/.ssh/known_hosts
  ssh -i $HOME/build/testbot/id_rsa_travis $USER_GATE@$GATE_SERVER -L 1701:$FLEX_SERVER:1701 -L 1719:$FLEX_SERVER:1719 -L 1718:$FLEX_SERVER:1718 -L 2015:$FLEX_SERVER:2015 -L 1815:$FLEX_SERVER:1815 -L 1715:$FLEX_SERVER:1715 -N &
  sleep 3
}
