#!/bin/bash
#
## Setup the the box. This runs as root
apt-get install -y vim htop git git-flow zip unzip curl wget python-pip ruby-dev linux-image-generic-lts-trusty software-properties-common

# Set Timezone
sudo timedatectl set-timezone Europe/Berlin

# You can install anything you need here.
