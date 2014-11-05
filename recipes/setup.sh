#!/bin/bash
openssl aes-256-cbc -k "$keypass" -in id_rsa_travis.enc -out id_rsa_travis -d
sudo chmod 600 id_rsa_travis
ssh-agent bash -c 'ssh-add id_rsa_travis; git clone git@github.com:jgillis/restricted.git'

