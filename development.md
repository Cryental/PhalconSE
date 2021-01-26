# Environment Guides

## Requirements
1. Ubuntu 20.04
2. 2GB+ RAM

## Software to Install
1. PHP 7.4
2. Phalcon Framework
3. Imagick
4. MariaDB 10.5
5. Lighttpd

## Installations

### Run Updates

```
sudo apt update
sudo apt upgrade
sudo apt autoremove
```

### Add PHP Repository

```
sudo add-apt-repository ppa:ondrej/php
sudo apt update
sudo apt upgrade
```

### Install Lighttpd

```
sudo apt install lighttpd
sudo apt install lighttpd-mod-geoip lighttpd-mod-maxminddb lighttpd-mod-vhostdb-dbi lighttpd-mod-vhostdb-pgsql lighttpd-modules-mysql
sudo service lighttpd start
sudo update-rc.d lighttpd defaults
sudo update-rc.d lighttpd enable
```

### Install PHP 7.4 and Extensions

```
sudo apt install php7.4

sudo service apache2 stop
sudo apt-get purge apache2 apache2-utils apache2-bin
sudo apt autoremove

sudo apt install php7.4-{cgi,fpm,json,zip,gd,curl,bcmath,xml,bz2,bcmath,intl,gd,mbstring,mysql,zip,common,imagick,imap,dev,psr}
sudo apt install imagemagick
sudo apt install php-pear
sudo apt install libgeoip-dev
sudo pecl install geoip-beta
sudo pecl install phalcon

cd /tmp
sudo wget https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz
sudo tar -zxvf ioncube_loaders_lin_x86*
cd ioncube/
sudo cp /tmp/ioncube/ioncube_loader_lin_7.4.so /usr/lib/php/20190902

sudo bash -c "echo extension=geoip.so > /etc/php/7.4/cgi/conf.d/geoip.ini"
sudo bash -c "echo extension=phalcon.so > /etc/php/7.4/cgi/conf.d/phalcon.ini"

sudo bash -c "echo extension=geoip.so > /etc/php/7.4/fpm/conf.d/geoip.ini"
sudo bash -c "echo extension=phalcon.so > /etc/php/7.4/fpm/conf.d/phalcon.ini"

sudo bash -c "echo extension=geoip.so > /etc/php/7.4/cli/conf.d/geoip.ini"
sudo bash -c "echo extension=phalcon.so > /etc/php/7.4/cli/conf.d/phalcon.ini"
```

### Setup PHP 7.4

```
wget https://raw.githubusercontent.com/Cryental/PhalconSE/main/php.ini
sudo rm /etc/php/7.4/fpm/php.ini
sudo rm /etc/php/7.4/cli/php.ini
sudo rm /etc/php/7.4/cgi/php.ini

sudo cp php.ini /etc/php/7.4/fpm/php.ini
sudo cp php.ini /etc/php/7.4/cli/php.ini
sudo cp php.ini /etc/php/7.4/cgi/php.ini
sudo rm php.ini
```

### Setup Lighttpd

```
cd /tmp
wget https://raw.githubusercontent.com/Cryental/PhalconSE/main/lighttpd.conf
wget https://raw.githubusercontent.com/Cryental/PhalconSE/main/15-fastcgi-php.conf

sudo rm /etc/lighttpd/lighttpd.conf
sudo rm /etc/lighttpd/conf-available/15-fastcgi-php.conf

sudo mv lighttpd.conf /etc/lighttpd/lighttpd.conf
sudo mv 15-fastcgi-php.conf /etc/lighttpd/conf-available/15-fastcgi-php.conf

sudo lighttpd-enable-mod fastcgi
sudo lighttpd-enable-mod fastcgi-php

sudo service php7.4-fpm restart
sudo service lighttpd restart
```

### Install Composer 2.0

```
cd /tmp
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
sudo php composer-setup.php --install-dir=/usr/bin --filename=composer
php -r "unlink('composer-setup.php');"
composer self-update
```

### Install Phalcon Devtools

```
composer global require phalcon/devtools
```

### Install MariaDB

```
sudo apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'
sudo add-apt-repository 'deb [arch=amd64,arm64,ppc64el] http://nyc2.mirrors.digitalocean.com/mariadb/repo/10.5/ubuntu focal main'
sudo apt update
sudo apt upgrade
sudo apt install mariadb-server

mysql_secure_installation
```

### Install Let’s Encrypt

```
sudo apt install certbot
```
