#!/bin/bash

echo 'Running Updates...'
echo ''
sudo apt -y update
sudo apt -y upgrade
sudo apt -y autoremove
echo ''

echo 'Adding PHP Repository...'
echo ''
sudo add-apt-repository ppa:ondrej/php -y
sudo apt -y update
sudo apt -y upgrade
echo ''

echo 'Installing Lighttpd...'
echo ''
sudo apt -y install lighttpd
sudo apt -y install lighttpd-mod-geoip lighttpd-mod-maxminddb lighttpd-mod-vhostdb-dbi lighttpd-mod-vhostdb-pgsql lighttpd-modules-mysql
sudo service lighttpd start
sudo update-rc.d lighttpd defaults
sudo update-rc.d lighttpd enable
echo ''

echo 'Installing PHP 7.4 and Extensions...'
echo ''

sudo apt -y install php7.4-{cgi,fpm,json,zip,gd,curl,bcmath,xml,bz2,bcmath,intl,gd,mbstring,mysql,zip,common,imagick,imap,dev,psr}
sudo apt -y install imagemagick
sudo apt -y install php-pear
sudo apt -y install libgeoip-dev
sudo pecl install geoip-beta


cd /tmp
sudo wget https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz
sudo tar -zxvf ioncube_loaders_lin_x86*
cd ioncube/
sudo cp /tmp/ioncube/ioncube_loader_lin_7.4.so /usr/lib/php/20190902

cd /tmp 
wget https://github.com/Cryental/PhalconSE/releases/download/1.0/phalcon.so
mv phalcon.so /usr/lib/php/20190902

sudo bash -c "echo extension=geoip.so > /etc/php/7.4/cgi/conf.d/geoip.ini"
sudo bash -c "echo extension=phalcon.so > /etc/php/7.4/cgi/conf.d/phalcon.ini"

sudo bash -c "echo extension=geoip.so > /etc/php/7.4/fpm/conf.d/geoip.ini"
sudo bash -c "echo extension=phalcon.so > /etc/php/7.4/fpm/conf.d/phalcon.ini"

sudo bash -c "echo extension=geoip.so > /etc/php/7.4/cli/conf.d/geoip.ini"
sudo bash -c "echo extension=phalcon.so > /etc/php/7.4/cli/conf.d/phalcon.ini"
echo ''

echo 'Auto Config For PHP 7.4...'
echo ''
wget https://raw.githubusercontent.com/Cryental/PhalconSE/main/php.ini
sudo rm /etc/php/7.4/fpm/php.ini
sudo rm /etc/php/7.4/cli/php.ini
sudo rm /etc/php/7.4/cgi/php.ini

sudo cp php.ini /etc/php/7.4/fpm/php.ini
sudo cp php.ini /etc/php/7.4/cli/php.ini
sudo cp php.ini /etc/php/7.4/cgi/php.ini
sudo rm php.ini
echo ''

echo 'Auto Config For Lighttpd...'
echo ''
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
echo ''

echo 'Installing Composer 2.0...'
echo ''
cd /tmp
export COMPOSER_ALLOW_SUPERUSER=1;
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
sudo php composer-setup.php --install-dir=/usr/bin --filename=composer
php -r "unlink('composer-setup.php');"
composer self-update
echo ''

echo 'Installing Phalcon Devtools...'
echo ''
composer global require phalcon/devtools
echo ''

echo 'Installing MariaDB...'
echo ''
sudo apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'
sudo add-apt-repository 'deb [arch=amd64,arm64,ppc64el] http://nyc2.mirrors.digitalocean.com/mariadb/repo/10.5/ubuntu focal main' -y
sudo apt -y update
sudo apt -y upgrade
sudo apt -y install mariadb-server

echo 'Finalizing Script...'
echo ''
sudo apt -y update
sudo apt -y upgrade
sudo apt -y autoremove
sudo rm -rf /etc/apache2
cd /tmp
sudo rm -rf .
cd ~
echo ''
echo ''

echo 'Installation Completed. Please run mysql_secure_installation!'
