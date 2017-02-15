#!/bin/bash
set -x
set -euo pipefail

# set the fastest ubuntu mirror
if [ ! -f /etc/apt/sources.list.orig ] ; then
    sudo mv /etc/apt/sources.list /etc/apt/sources.list.orig
    sudo echo "deb mirror://mirrors.ubuntu.com/mirrors.txt trusty main restricted universe multiverse" >> /etc/apt/sources.list
    sudo echo "deb mirror://mirrors.ubuntu.com/mirrors.txt trusty-updates main restricted universe multiverse" >> /etc/apt/sources.list
    sudo echo "deb mirror://mirrors.ubuntu.com/mirrors.txt trusty-backports main restricted universe multiverse" >> /etc/apt/sources.list
    sudo echo "deb mirror://mirrors.ubuntu.com/mirrors.txt trusty-security main restricted universe multiverse" >> /etc/apt/sources.list
    sudo cat /etc/apt/sources.list.orig >> /etc/apt/sources.list
fi

# copy .dot files over
cp dot.emacs /home/vagrant/.emacs
cp dot.screenrc /home/vagrant/.screenrc
sudo cp dot.emacs /root/.emacs
sudo cp dot.screenrc /root/.screenrc

# add a few utils
sudo apt-get update
sudo apt-get install -y openssh-server mysql-client unzip dc
sudo apt-get install -y git bridge-utils traceroute nmap dhcpdump wget curl
sudo apt-get install -y emacs24-nox screen tree git
sudo apt-get install -y python-pip
sudo apt-get install -y apache2-utils # for htpasswd

# install docker
if ! which docker; then
    sudo wget -qO- https://get.docker.com/ | sudo sh
    sudo usermod -aG docker root
    sudo usermod -aG docker vagrant
fi

# install docker-compose
sudo pip install -U docker-compose

# Install NFS automount and configure it to automount from the file share
sudo apt-get install -y autofs smbclient cifs-utils
if ! cat /etc/auto.master |grep auto.autofs; then
    echo "/autofs      /etc/auto.autofs" >> /etc/auto.master
    echo "media        -fstype=cifs,username=media,password=media! ://192.168.3.10/movies" > /etc/auto.autofs
    sudo mkdir -p /autofs
    sudo service autofs restart
fi

sudo pip install --upgrade pip
sudo apt-get autoremove -y
