#!/bin/sh

# Remove Apt Fluff
sudo apt-get clean -y  && sudo apt-get autoclean -y

# Wipe Zero Space
sudo dd if=/dev/zero of=wipefile bs=1024x1024; rm -f wipefile

# Remove BASH History
cat /dev/null > ~/.bash_history && history -c && exit