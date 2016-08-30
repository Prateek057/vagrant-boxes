#!/bin/bash -eux

# Variables
composedir=/opt/containers
jenkins_home=/opt/jenkins_home

# Make & Change Directories
mkdir -p $jenkins_home && chown -R vagrant:vagrant $jenkins_home
mkdir -p $composedir && chown -R vagrant:vagrant $composedir
cd $composedir

# Clone Compose Repos
git clone https://github.com/volcomism/symfony_example.git symfony_example
git clone https://github.com/volcomism/elkstack-docker.git elk
git clone https://github.com/volcomism/rabbitmq.git rabbitmq
git clone https://github.com/volcomism/jenkins.git jenkins

