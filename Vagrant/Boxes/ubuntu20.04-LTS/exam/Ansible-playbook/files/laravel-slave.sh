#!/bin/bash

##################################
#updating & upgrading the server
sudo apt update && sudo apt upgrade -y < /dev/null
####################################



#############################
#installation of lamp stack
sudo apt-get install apache2 -y < /dev/null

sudo apt-get install mysql-server -y < /dev/null

sudo add-apt-repository -y ppa:ondrej/php < /dev/null

sudo apt-gt update < /dev/null

sudo apt-get install libapache2-mod-php php php-common php-xml php-mysql php-gd php-mbstring php-tokenizer php-json php-bcmath php-curl php-zip unzip -y

sudo sed -i 's/cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php8.2/apache2/php.ini

sudo systemctl restart apache2 < /dev/null
#################################################


########################
#install a composer
####################

sudo apt install curl -y

sudo curl -sS https://getcomposer.org/installer | php

sudo mv composer.phar usr/local/bin/composer

composer --version < /dev/null

###########################

#############################
#configuration of apache2
cat << EOF > /etc/apache2/sites-available/laravel.conf
<VirtualHost *:80>
    ServerAdmin admin@example.com
    ServerName 192.168.20.11
    DocumentRoot /var/www/html/laravel/public

    <Directory /var/www/html/laravel>
    Options Indexes Multiviews Followsymlinks
    AllowOverride All
    Required all granted
    </Directory>

    Errorlog ${APACHE_LOG_DIR}/error.log
    Customlog  ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

sudo a2enmod rewrite

sudo a2ensite laravel.conf

sudo systemctl restart apache2

#####################################

#################################


# clone laravel application and dependencies 

cd /var/www/html && git clone https://github.com/laravel/laravel.git

sudo apt install curl -y

sudo curl -sS https://getcomposer.org/installer | php

sudo mv composer.phar usr/local/bin/composer

composer --version < /dev/null

cd /var/www/html/laravel && cp .env.example.env

sudo sed -i 's/DB_DATABASE=laravel/DB_DATABASE=bolupizule/' /var/www/html/laravel.env

sudo sed -i 's/DB_USERNAME=root/DB_USERNAME=bolupizule/' /var/www/html/laravel.env

sudo sed -i 's/DB_PASSWORD=/DB_PASSWORD=bolupizule2004/' /var/www/html/laravel.env

sudo chown -R 775 /var/www/html/laravel

sudo chmod -R 775 /var/www/html/laravel/storage

sudo chmod -R 775 /var/www/html/laravel/bootstrap/cache

cd /var/www/html/laravel && cp .env.example.env

###########################
#configuration mysql: creating user and password

echo "Creating MySQL user and database"
PASS=$2
if [ -z "$2" ]; then
  PASS=`openssl rand -base64 8`
fi


mysql -u root <<MYSQL_SCRIPT
CREATE DATABASE $1;
CREATE USER '$1'@'localhost' IDENTIFIED BY '$PASS';
GRANT ALL PRIVILEGES ON $1.* TO '$1'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

echo "MySQL user and database created."
echo "Username: $1"
echo "Database: $1"
echo "Password: $PASS"
#############################################

##########################################
# execute key generate and migrate command for php
########################################
sudo sed -i 's/DB_DATABASE=laravel/DB_DATABASE=bolupizule/' /var/www/html/laravel.env

sudo sed -i 's/DB_USERNAME=root/DB_USERNAME=bolupizule/' /var/www/html/laravel.env

sudo sed -i 's/DB_PASSWORD=/DB_PASSWORD=bolupizule2004/' /var/www/html/laravel.env

php artisan config:cache

cd /var/www/html/laravel && cp artisan migrate
##################################################


