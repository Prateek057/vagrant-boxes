#!/bin/bash
if [ ! -f "$2" ] ; then
    echo "Include file '$2' for nginx not found. Please create this file or remove the config option in the Vagrant.yaml file." 1>&2
    exit 1
fi
TF="/tmp/.nginxcfg_$1"
cat /etc/nginx/sites-enabled/$1 | sed "6i\    include \"$2\";" > $TF
mv $TF /etc/nginx/sites-enabled/$1