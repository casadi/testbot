#!/bin/bash
set -e

ssh-keyscan github.com >> ~/.ssh/known_hosts
ssh-keyscan web.sourceforge.net >> ~/.ssh/known_hosts
ssh-keyscan shell.sourceforge.net >> ~/.ssh/known_hosts



sudo pip install requests==2.6.0
sudo pip install psutil
openssl aes-256-cbc -k "$keypass" -in id_rsa_travis.enc -out id_rsa_travis -d
openssl aes-256-cbc -k "$keypass" -in testbotcredentials.py.enc -out testbotcredentials.py -d
sudo chmod 600 id_rsa_travis

cat <<EOF >> ~/.ssh/config
Host github.com
        Hostname github.com
        User git
        IdentityFile $(pwd)/id_rsa_travis
EOF

git clone git@github.com:jgillis/restricted.git
git config --global user.email "testbot@casadidev.org"
git config --global user.name "casaditestbot"
