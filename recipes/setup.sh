#!/bin/bash
set -e

ssh-keyscan github.com >> ~/.ssh/known_hosts

sudo pip install requests==2.6.0
sudo pip install psutil
openssl aes-256-cbc -k "$keypass" -in id_rsa_travis.enc -out id_rsa_travis -d
openssl aes-256-cbc -k "$keypass" -in testbotcredentials.py.enc -out testbotcredentials.py -d
sudo chmod 600 id_rsa_travis
ssh-agent bash -c 'ssh-add id_rsa_travis; git clone git@github.com:jgillis/restricted.git'
git config --global user.email "testbot@casadidev.org"
git config --global user.name "casaditestbot"
