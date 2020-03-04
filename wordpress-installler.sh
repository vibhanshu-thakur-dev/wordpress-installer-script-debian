echo " CUSTOM:: :: Updating apt"
sudo apt update

echo " CUSTOM:: :: Installing apache2"
sudo apt install apache2 -y

echo " CUSTOM:: :: Installing MariaDB"
sudo apt install mariadb-server -y

echo " CUSTOM:: :: Securing MariaDB installation - interactive mode"
sudo mysql_secure_installation

echo " CUSTOM:: :: CONFIGURING MARIA DB"
sudo mariadb << EOF
GRANT ALL ON *.* TO 'admin'@'localhost' IDENTIFIED BY 'password' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

mariadb -u admin -ppassword << EOF
CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
GRANT ALL ON wordpress.* TO 'wordpressuser'@'localhost' IDENTIFIED BY 'password';
FLUSH PRIVILEGES;
EOF

echo " CUSTOM:: :: End of Maria DB configuration"

echo " CUSTOM:: :: Installing PHP"
sudo apt install php libapache2-mod-php php-mysql -y

echo " CUSTOM:: :: Changing apache priority to display php first"
echo -e "<IfModule mod_dir.c> \n DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm \n </IfModule>" > /etc/apache2/mods-enabled/dir.conf

echo " CUSTOM:: :: Restart apache2 service"
sudo systemctl restart apache2

echo " CUSTOM:: :: Check Status of Apache "
sudo systemctl status apache2 | grep "active (running) since"
if [ $? -eq 0 ]
then
  echo " CUSTOM:: :: Apache running successfully"
else
  echo " CUSTOM:: :: Apache not running. Something went wrong" 
fi

echo " CUSTOM:: :: Creating test php file info.php to check php installation"
echo -e "<?php  phpinfo();  ?>" > /var/www/html/info.php

echo " CUSTOM:: :: Checking PHP installation "
curl http://localhost/info.php | grep "<title>phpinfo()</title>"
if [ $? -eq 0 ]
then
  echo " CUSTOM:: :: PHP installed successfully"
else
  echo " CUSTOM:: :: PHP installation failed"
fi

echo " CUSTOM:: :: Removing test php file"
sudo rm /var/www/html/info.php

echo " CUSTOM:: :: Adding additional php extensions"
sudo apt install php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip -y

echo " CUSTOM:: :: Restart apache"
sudo systemctl restart apache2

echo " CUSTOM:: :: Change root directory to wordpress in apache2 config"
sed -i 's/html/wordpress/g' /etc/apache2/sites-available/000-default.conf 

sudo a2enmod rewrite

echo " CUSTOM:: :: Checking apache config syntax"
sudo apache2ctl configtest 
if [ $? -eq 0 ]
then
  echo " CUSTOM:: :: Apache config syntax is OK"
else
  echo " CUSTOM:: :: Apache config syntex ERROR"
fi

echo " CUSTOM:: :: Restart Apache"
sudo systemctl restart apache2

echo " CUSTOM:: :: Downloading wordpress"
cd /tmp
curl -O https://wordpress.org/latest.tar.gz

echo " CUSTOM:: :: Extract wordpress"
tar xzvf latest.tar.gz

echo " CUSTOM:: :: Create .htaccess file"
touch /tmp/wordpress/.htaccess

echo " CUSTOM:: :: Creating wordpress config.php file"
cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php

echo " CUSTOM:: :: Creating wordpress upgrade folder"
mkdir /tmp/wordpress/wp-content/upgrade

echo " CUSTOM:: :: Copy all wordpress files to destination"
sudo cp -a /tmp/wordpress/. /var/www/wordpress

echo " CUSTOM:: :: Update wordpress file permissions"
sudo chown -R www-data:www-data /var/www/wordpress
sudo find /var/www/wordpress/ -type d -exec chmod 750 {} \;
sudo find /var/www/wordpress/ -type f -exec chmod 640 {} \;

echo " CUSTOM:: :: Configuring Wordpress"
sed -i 's/database_name_here/wordpress/g' /var/www/wordpress/wp-config.php
sed -i 's/username_here/wordpressuser/g' /var/www/wordpress/wp-config.php
sed -i 's/password_here/password/g' /var/www/wordpress/wp-config.php

sed -i "s/define( 'DB_COLLATE', '' );/define( 'DB_COLLATE', '' ); define('FS_METHOD', 'direct');/g" /var/www/wordpress/wp-config.php
