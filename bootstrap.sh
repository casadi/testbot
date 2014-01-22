#!/bin/bash
sudo apt-get install git
git config --global user.name "casadibot"
git config --global user.email casaditestbot@gmail.com
ssh-keygen -t rsa
cat .ssh/id_rsa.pub
pause
git clone git@github.com:casadi/testbot.git
sudo apt-get install alien build-essential buildbot-slave cmake fakeroot gfortran libblas-dev libblas3gf openssh-server python-dev python-matplotlib python-numpy python-scipy 
echo -n "Enter name of slave: "
read SLAVENAME
echo -n "Enter password of slave: "
read SLAVEPASS
mkdir -p slaves
buildslave create-slave --keepalive=30 --maxdelay=30 --umask=022 slaves/$SLAVENAME 10.0.2.2 $SLAVENAME $SLAVEPASS
