#!/bin/bash
set -x
set -euo pipefail

# Ensure this script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
fi

CACHE_DIR=/vagrant/.cache
mkdir -p $CACHE_DIR

#####################################################################
# Persist the configuration directories for several tools
declare -A from_to_dirs
from_to_dirs=( \
    ["/vagrant/custom/dot.ssh"]="/home/vagrant/.ssh" \
    ["/vagrant/custom/dot.aws"]="/home/vagrant/.aws" \
    ["/vagrant/custom/dot.emacs.d"]="/home/vagrant/.emacs.d" \
    ["/vagrant/custom/dot.gnupg"]="/home/vagrant/.gnupg" \
    ["/vagrant/custom/dot.gcloud"]="/home/vagrant/.config/gcloud" \
    ["/vagrant/custom/dot.kube"]="/home/vagrant/.kube" )
for from_dir in "${!from_to_dirs[@]}"; do
    to_dir=${from_to_dirs[$from_dir]}
    # Ensure custom config directory exists
    if [ ! -d "${from_dir}" ]; then
        mkdir -p ${from_dir}
    fi
    # Set link to the custom config directory
    if [ ! -e $to_dir ]; then
        mkdir -p `dirname $to_dir`
        ln -s $from_dir $to_dir
    fi
done

# Persist the configuration files for several tools
declare -A from_to_files
from_to_files=( \
    ["/vagrant/custom/certbot.cron"]="/etc/cron.weekly/certbot" \
    ["/vagrant/custom/dot.gitconfig"]="/home/vagrant/.gitconfig" \
    ["/vagrant/custom/dot.emacs"]="/home/vagrant/.emacs" \
    ["/vagrant/custom/dot.vimrc"]="/home/vagrant/.vimrc" \
    ["/vagrant/custom/dot.screenrc"]="/home/vagrant/.screenrc" )
for from_file in "${!from_to_files[@]}"; do
    to_file=${from_to_files[$from_file]}
    # Ensure custom config file exists and is empty
    if [ ! -f ${from_file} ]; then
        mkdir -p `dirname $from_file`
        touch $from_file
    fi
    # Set link to the custom config file
    if [ ! -L $to_file ] || [ ! -e $to_file ]; then
        rm -f $to_file
        mkdir -p `dirname $to_file`
        ln -s $from_file $to_file
    fi
done


#####################################################################
# Setup Operating System and base utils from apt

# set the fastest ubuntu mirror
if [ ! -f /etc/apt/sources.list.orig ] ; then
    mv /etc/apt/sources.list /etc/apt/sources.list.orig
    echo "deb mirror://mirrors.ubuntu.com/mirrors.txt trusty main restricted universe multiverse" >> /etc/apt/sources.list
    echo "deb mirror://mirrors.ubuntu.com/mirrors.txt trusty-updates main restricted universe multiverse" >> /etc/apt/sources.list
    echo "deb mirror://mirrors.ubuntu.com/mirrors.txt trusty-backports main restricted universe multiverse" >> /etc/apt/sources.list
    echo "deb mirror://mirrors.ubuntu.com/mirrors.txt trusty-security main restricted universe multiverse" >> /etc/apt/sources.list
    cat /etc/apt/sources.list.orig >> /etc/apt/sources.list
fi

# Upgrade OS
apt-get update
apt-get -y autoremove

# Add common Utils
#
# moreutils: for sponge
# apache2-utils: for htpasswd
# xauth: to forward X11 programs to the host machine
apt-get -yq install mysql-client unzip dc gnupg moreutils \
	git bridge-utils traceroute nmap dhcpdump wget curl siege whois \
	emacs24-nox screen tree git jq \
	apache2-utils \
	python-pip python-dev \
	xauth

#####################################################################
# Configuration
#   Do this before tool installation to ensure symlinks can be created
#   before written to)

# Setup the .bashrc by appending the custom one
if [ -f /home/vagrant/.bashrc ] ; then
    # Truncates the Custom part of the config and below
    sed -n '/## Custom:/q;p' -i /home/vagrant/.bashrc
    # Appends custom bashrc
    cat /vagrant/custom/dot.bashrc >> /home/vagrant/.bashrc
fi

# Use user's point of view
source /vagrant/custom/dot.bashrc

#####################################################################
# Install Miscellaneous Tools

# Install docker
if ! which docker; then
    curl -fsSL https://get.docker.com/ | sh
    usermod -aG docker root
    usermod -aG docker vagrant
fi

# Install docker-compose
if ! which docker-compose; then
    pip install --upgrade pip
    pip install -U docker-compose
fi

# Install j2cli
if ! which j2; then
    pip install -U j2cli
fi

# Install NFS automount and configure it to automount from the file share
apt-get install -y autofs smbclient cifs-utils
if ! cat /etc/auto.master |grep auto.autofs; then
    echo "/autofs      /etc/auto.autofs" >> /etc/auto.master
    echo "media        -fstype=cifs,username=media,password=media! ://192.168.3.10/movies" > /etc/auto.autofs
    mkdir -p /autofs
    service autofs restart
fi

# Make the /docker directory and set up for new files/directories to
#   inherit parent permissions
if [ ! -d /docker ]; then
    mkdir /docker
    # ensure admin group (which includes vagrant user) has access
    chown -R root:adm /docker
    # ensure future files created inherit group permissions
    find /docker -type d -print0 | sudo xargs -0 chmod g+rws
fi
