#!/bin/bash
set -e

echo "|1|EfVEgM7YLBONFBmYXt+IznbkGhU=|C1RlstpJexqKpOMb3FBQgwVptO8= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==" >> ~/.ssh/known_hosts
sudo pip install requests
openssl aes-256-cbc -k "$keypass" -in id_rsa_travis.enc -out id_rsa_travis -d
openssl aes-256-cbc -k "$keypass" -in testbotcredentials.py.enc -out testbotcredentials.py -d
sudo chmod 600 id_rsa_travis
ssh-agent bash -c 'ssh-add id_rsa_travis; git clone git@github.com:jgillis/restricted.git'

