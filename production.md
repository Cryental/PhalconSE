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

sudo apt install php7.4-{cgi,fpm,json,zip,gd,curl,bcmath,xml,bz2,bcmath,intl,gd,mbstring,mysql,zip,common,imagick,imap,dev}
sudo apt install imagemagick
sudo apt install php-pear
sudo apt install php7.4-psr
sudo apt install php-dev
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
sudo nano /etc/php/7.4/cgi/php.ini
```

Add this line on the second line of php.ini:

```
zend_extension = /usr/lib/php/20190902/ioncube_loader_lin_7.4.so
```

Modify following lines to these values:

```
expose_php = Off
max_execution_time = 360
max_input_time = 180
memory_limit = 1024M
post_max_size = 32M
upload_max_filesize = 1024M
user_agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.141 Safari/537.36"
default_socket_timeout = 180
opcache.enable=1
opcache.enable_cli=1
opcache.memory_consumption=256
opcache.interned_strings_buffer=16
opcache.max_accelerated_files=12000
opcache.max_wasted_percentage=10
opcache.validate_timestamps=1
opcache.revalidate_freq=5
```

Save and exit the editor.

Now apply the config to all:

```
sudo rm /etc/php/7.4/fpm/php.ini
sudo rm /etc/php/7.4/cli/php.ini

sudo cp /etc/php/7.4/cgi/php.ini /etc/php/7.4/fpm/php.ini
sudo cp /etc/php/7.4/cgi/php.ini /etc/php/7.4/cli/php.ini
```

### Setup Lighttpd

```
cd /etc/lighttpd/conf-available
sudo rm 15-fastcgi-php.conf
sudo nano 15-fastcgi-php.conf
```

Paste whole lines to there:

```
# -*- depends: fastcgi -*-
# /usr/share/doc/lighttpd/fastcgi.txt.gz
# http://redmine.lighttpd.net/projects/lighttpd/wiki/Docs:ConfigurationOptions#mod_fastcgi-fastcgi

## Start an FastCGI server for php (needs the php5-cgi package)
fastcgi.server += ( ".php" =>
        ((
                "bin-path" => "/usr/bin/php-cgi7.4",
                "socket" => "/var/run/php/php7.4-fpm.sock",
                "max-procs" => 1,
                "bin-environment" => (
                        "PHP_FCGI_CHILDREN" => "4",
                        "PHP_FCGI_MAX_REQUESTS" => "10000"
                ),
                "bin-copy-environment" => (
                        "PATH", "SHELL", "USER"
                ),
                "broken-scriptfilename" => "enable"
        ))
)
```

Save and exit the editor.

Run following commands:

```
sudo lighttpd-enable-mod fastcgi
sudo lighttpd-enable-mod fastcgi-php

sudo nano /etc/lighttpd/lighttpd.conf
```

Add this line at the end of a conf file:

```
url.rewrite-once = ( "^(/(?!(favicon.ico$|css/|js/|img/)).*)" => "/index.php?_url=$1" )
```

Add following modules to server.modules:

- mod_rewrite

Save and exit the editor.

Restart all services to apply changes:

```
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
