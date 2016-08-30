#!/bin/bash -eux

# Install LEMP
debconf-set-selections <<< 'mariadb-server-5.5 mysql-server/root_password password root'
debconf-set-selections <<< 'mariadb-server-5.5 mysql-server/root_password_again password root'
apt-get install -y mariadb-server
apt-get install -y nginx
apt-get install -y php-apc php5-common php5-cli php5-json php5-intl php5-mysql php5-curl php5-fpm php5-memcached php5-mongo php5-xdebug

# Enable xdebug
echo "xdebug.remote_enable = 1
xdebug.remote_connect_back = 1
xdebug.remote_port = 9000
xdebug.scream=0
xdebug.cli_color=1
xdebug.show_local_vars=1" >> /etc/php5/fpm/conf.d/20-xdebug.ini

# Install Memcache
apt-get install -y memcached

# Install MongoDB
apt-get install -y mongodb-server

# Install Nodejs, Bower, Grunt for FEAs
curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
apt-get install -y nodejs
ln -s /usr/bin/nodejs /usr/bin/node
npm install -g bower grunt-cli

# Install Compass for FE
gem install compass

# Install Composer
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# Install Docker & Compose  // Might want to combine adding repos to a single update to shorten build time.
apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo deb https://apt.dockerproject.org/repo ubuntu-trusty main > /etc/apt/sources.list.d/docker.list
apt-get update -y
apt-get install -y docker-engine
usermod -aG docker vagrant
pip install docker-compose

# Pre-load docker base-images for shorter build time
docker pull phusion/baseimage
docker pull java:8-jdk
docker pull ubuntu:trusty

# Install Logstash-Forwarder
wget https://download.elastic.co/logstash-forwarder/binaries/logstash-forwarder_0.4.0_amd64.deb -P /opt/
dpkg -i /opt/logstash-forwarder_0.4.0_amd64.deb
rm /opt/logstash-forwarder_0.4.0_amd64.deb

cat > /etc/logstash-forwarder.conf <<"EOF"
{
  "network": {
    "servers": [ "localhost:5000" ],
    "timeout": 15,
    "ssl ca": "/etc/pki/tls/certs/logstash-forwarder.crt"
  },
  "files": [
    {
      "paths": [
        "/var/log/syslog",
        "/var/log/auth.log"
       ],
      "fields": { "type": "syslog" }
    },
    {
      "paths": [
        "/var/log/nginx/access.log"
       ],
      "fields": { "type": "nginx-access" }
    },
    {
      "paths": [
        "/var/log/nginx/error.log"
       ],
      "fields": { "type": "nginx-error" }
    },
    {
      "paths": [
        "/var/log/mysql/error.log"
       ],
      "fields": { "type": "mysql-error" }
    },
    {
      "paths": [
        "/var/log/mongodb/mongodb.log"
       ],
      "fields": { "type": "mongodb" }
    },
    {
      "paths": [
        "PROJECT_PATH../app/logs/prod.log"
       ],
      "fields": { "type": "symfony-app" }
    },
    {
      "paths": [
        "PROJECT_PATH../app/logs/dev.log"
       ],
      "fields": { "type": "symfony-app" }
    }
   ]
}
EOF

forwarder_cert="-----BEGIN CERTIFICATE-----
MIIC+zCCAeOgAwIBAgIJAOOotxUh3Y0nMA0GCSqGSIb3DQEBCwUAMBQxEjAQBgNV
BAMMCWxvY2FsaG9zdDAeFw0xNTExMDQxNDUwNTBaFw0xNTEyMDQxNDUwNTBaMBQx
EjAQBgNVBAMMCWxvY2FsaG9zdDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
ggEBAN7AZP0z7h4WSA/zmGbHpuGn3AV3kCUu/e4I5pxDKSEbbMy12B69k2Q0Rnxv
ybUpJGe4JdqLaNL/xlZXpQ90AHq04vVxkeBE3n0FjLDBls2TOl5gJcRvOCJpA8d1
njubF2CVs1bx+lLTDspMY8XvLL53gU7BgfdbZaDfVH6JOoLziabj65IbrcfgZOCQ
eScN27C3LAlHBHkwFHxZbobafOmK8G+9dNd4peSaXhsN47lNovwf8D+SzWOWCTCB
HEtEBqxY02HLGQ8tQ6Hn2/pCNfjbbfAm8H4AITo5+nDCB+5ZS/CUfYsZ0xzh3Wdp
saWlJhF+OYTOCG0IrsGANpZ4+qECAwEAAaNQME4wHQYDVR0OBBYEFBQj6RH9GfCi
X0JCacJYb7FCYPwmMB8GA1UdIwQYMBaAFBQj6RH9GfCiX0JCacJYb7FCYPwmMAwG
A1UdEwQFMAMBAf8wDQYJKoZIhvcNAQELBQADggEBAKe0b5w1mGB7YBNWjPlU3vHx
Xa1oRh6ec35V2sq26WqGJRg5wz9LvQO1IRtkpUwNPfdIRK0JXi65i6Zg4H0cQyYE
ISwLnvikEVneneK7JMz8NKx3+eY1XPN1FmIAAEJLNiiRzSknEoSkZkoktvGddcKi
3ibpDi/xKy7Zy5UxFsDv6hO5j4vPGnSEHg5ymDd1WlCJM1101TD3nhRh7CDcLAEM
TXzd4FMRlMM78D89DIibvLrJjr7dj/k7T0Ns1py1W624iPh0LpOmukSsZoqmlnH5
Q55PZF/Iny2vul5cSIsm5j71bvn/EJkObHH9ELUzHHtXbDaRT0TMGWvrbvWNuwQ=
-----END CERTIFICATE-----"
mkdir -p /etc/pki/tls/certs/
echo "$forwarder_cert" > "/etc/pki/tls/certs/logstash-forwarder.crt"
chmod 644 /etc/pki/tls/certs/logstash-forwarder.crt

