#!/bin/bash

## Script de mise en place de l'application GSB ##
## Author : RADJAH Sofiane ##

## Installation des différents outils nécessaires à l'application web (APACHE, MARIADB, PHP, Mysql) ##
apt-get update
apt-get dist-upgrade
apt-get install apache2 mariadb-server php libapache2-mod-php php-mysql -y
mysql -u root -e "
use mysql;
update user set plugin='' where User='root';
flush privileges;"
systemctl restart mariadb.service
chown -R www-data:www-data /var/www
sed -i 's/.*AllowOverride None.*/AllowOverride All/' /etc/php/*/apache2/php.ini
systemctl reload apache2

## Mise en place de l'application GSB ##
apt-get update
apt-get upgrade -y
apt-get install apt-transport-https lsb-release ca-certificates -y
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
touch php.list
echo "deb https://packages.sury.org/php/ $(lsb_release sc) main" > php.list
mv php.list /etc/apt/sources.list.d
apt-get update
apt-get upgrade -y
wget http://gil83.fr/si7/GSB_Appli.zip
wget http://gil83.fr/si7/gsb_restore.sql
mysql_secure_installation -e -y < "root"
mariadb -u root -p < gsb_restore.sql < "root"
rm /var/www/html/index.html
cp GSB_Appli.zip /var/www/html
apt-get install unzip
unzip /var/www/html/GSB_Appli.zip