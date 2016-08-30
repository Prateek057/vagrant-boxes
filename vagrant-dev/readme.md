# CHIP Vagrant-Dev
https://intranet.cxo.name/jira/browse/AI-381

Required Vagrant Plugins: 

* vagrant-vbguest (Syncs Virtualbox version with Guest Additions)
* vagrant-hostmanager (Syncs host files with host machine)

Optional Vagrant Plugins: 

* vagrant-winnfsd (Optional for Windows user mounts)

OS:

* Ubuntu 14.04 - x86_64

Services:

* nginx (1.4.6)
* php5-fpm (5.5.9)
* nodejs (4.2.2)
* compass (1.0.3)
* rabbitmq-server (3.2.4)
* memcached (2.1.0)
* mariadb (5.5.46)
* mongodb (2.4.9)
* elasticsearch (1.7.3)
* docker (1.9.0)
* docker-compose (1.5.0)
* logstash-forwarder (0.4.0)
* jenkins (1.625.1)


Debugging:

* xdebug (2.2.3)

### # Notes

* Packer Provisioning: This box is provisioned by shell scripts using ubuntu repository versions, unless otherwise stated. This should be migrated to a centralised puppet solution using the r10k development branch provided by Operations to keep dev in sync with stg/prod environments.

* ELK Container: I've configured all local services + symfony + docker container logs to ship all logs to the local ELK stack which you can run by simply commenting out 'ELK' in the containers portion of Vagrant.yaml



### # To-Do
* Modify hosts entries based on 'sites' in Vagrant.yaml
* Issues with 'grunt server' latency through Vagrant NFS.
* Docker command in Vagrant.yaml should pull from Dockerhub not hardcoded repos in git.
* Document!

### # Issues
* This .box is still ~850MB in size, so I'm working on ways to reduce this space.
    * Docker Images: phusion/base, java8jdk, ubuntu/trusty - increases this box to 1.2GB
* Ran into issues when upgrading VirtualBox to 5.0.3
* Windows issues with longpathnames reoccuring in Vagrant 1.7.4 
	* Fix: 
		* In File "C:\HashiCorp\Vagrant\embedded\gems\gems\vagrant-1.7.4\plugins\providers\virtualbox\driver"
		* Replace ```hostpath = folder[:hostpath]```
with
```hostpath = '\\\\?\\' + folder[:hostpath].gsub(/[\/\\]/,'\\')```
			
	* (https://harvsworld.com/2015/how-to-fix-npm-install-errors-on-vagrant-on-windows-because-the-paths-are-too-long/)
