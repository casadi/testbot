#!/bin/bash
sudo apt-get install git
git config --global user.name "casadibot"
git config --global user.email casaditestbot@gmail.com
ssh-keygen -t rsa
cat .ssh/id_rsa.pub
pause
git clone git@github.com:casadi/testbot.git
sudo apt-get install alien build-essential buildbot-slave cmake fakeroot gfortran libblas-dev libblas3gf openssh-server python-dev python-matplotlib python-numpy python-scipy 
echo -n "Enter name of slave: [-bot]"
read SLAVENAME
echo -n "Enter password of slave: "
read SLAVEPASS
mkdir -p slaves
buildslave create-slave --keepalive=30 --maxdelay=30 --umask=022 slaves/$SLAVENAME 10.0.2.2 $SLAVENAME $SLAVEPASS

sudo cat <<-EOF >> /etc/default/buildslave
SLAVE_ENABLED[1]=1                     # 1-enabled, 0-disabled
SLAVE_NAME[1]="$SLAVENAME"         # short name printed on start/stop
SLAVE_USER[1]="casadibot"              # user to run slave as
SLAVE_BASEDIR[1]="/home/casadibot/slaves/$SLAVENAME"                   # basedir to slave (absolute p
SLAVE_OPTIONS[1]=""                   # buildbot options
SLAVE_PREFIXCMD[1]=""                 # prefix command, i.e. nice, linux32, dchroot
EOF

