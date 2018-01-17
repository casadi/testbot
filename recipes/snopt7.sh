#!/bin/bash
#set -e

sudo apt-get install -y libblas-dev liblapack-dev gfortran
wget http://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz
tar -xvf autoconf-2.69.tar.gz
pushd autoconf-2.69 && ./configure && make && sudo make install && popd
mypwd=`pwd`
#sudo mv /usr/lib/libf2c.so /usr/lib/libf2c.so_backup
#sudo ln -s /usr/lib/libf2c.a /usr/lib/libf2c.so
mkdir "$mypwd/snopt7-install"
pushd restricted && tar -xvf snopt7.tar.gz && cd snopt7 && ./configure --with-c-cpp=yes --prefix "$mypwd/snopt7-install" && make && make install && popd
ls -al "$mypwd/snopt7-install/lib"
git clone https://github.com/jgillis/snopt-interface.git
pushd snopt-interface && ./autogen.sh && ./configure --with-snopt="$mypwd/snopt7-install/lib" --prefix="$mypwd/snopt7-install" && make lib && make install && popd
tar -zcvf snopt7.tar.gz -C snopt7-install .
export PYTHONPATH="$PYTHONPATH:$mypwd/helpers" && python -c "from restricted import *; upload('snopt7.tar.gz')"
