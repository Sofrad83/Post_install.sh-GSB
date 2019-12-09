apt-get update
apt-get dist-upgrade
apt-get install apache2 -y
apt-get install php -y
apt-get install mariadb-server -y
mysql -u root -e "
use mysql;
update user set plugin='' where User='root';
flush privileges;"
systemctl restart mariadb.service
apt-get install php-mysql -y
chown -R www-data:www-data /var/www
sed -i 's/.*AllowOverride None.*/AllowOverride All/' /etc/php/*/apache2/php.ini
systemctl reload apache2
