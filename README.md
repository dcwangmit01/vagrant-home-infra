## What this is

This Vagrant machine runs my entire self-hosted network from my home.

Upon "vagrant up":

* The Vagrant machine named "docker" is created with an independent IP
  address bridged through the host.
* The provisioning script under ./conf/setup.sh installs a few utilites:
  * Docker
  * Docker-compose
  * Mysql

* The docker-compose.yaml file is executed with "docker-compose up -d"
  which starts the following containers:
  * Nginx as an SSL reverse proxy for traffic to Wordpress
  * Wordpress serving my personal site using MariaDB (ex. Mysql) as a backend
  * Mysql running Independently
  * A Route53-DynamicDNS daemon to always keep my dynamic IP
    updated as an A-Record for my website.



## How it works

This Vagrantfile will create a VM with an independent IP address from
the Vagrant host, whose networking is bridged.  The Vagrant machine is
booted, provisioned, and my

  The Vagrant machine is
booted, the setup scripts under ./conf/setup

## Setup

Edit the "Custom Configuration" within the Vagrantfile, setting the
following variables:

* $address = "192.168.3.12"
  * The Desired IP of the Vagrant Machine
* $gateway = "192.168.3.1"
  * The Desired Gateway of the Vagrant Machine
* $bridge = "en0: Ethernet"
  * The Desired Host Interface to Bridge the Vagrant Machine
