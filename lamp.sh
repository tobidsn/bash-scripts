#!/bin/bash

# Color Reset
Color_Off='\033[0m'       # Reset

# Regular Colors
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan

# GENERATE PASSOWRDS
# sudo apt -qy install openssl # openssl used for generating a truly random password
PASS_MYSQL_ROOT=`openssl rand -base64 12` # this you need to save
PASS_PHPMYADMIN_APP=`openssl rand -base64 12` # can be random, won't be used again
PASS_PHPMYADMIN_ROOT="${PASS_MYSQL_ROOT}" # Your MySQL root pass

update() {
    # Update system repos
    echo -e "\n ${Cyan} Updating package repositories.. ${Color_Off}"
    sudo apt -qq update
}

installApache() {
    # Apache
    echo -e "\n ${Cyan} Installing Apache.. ${Color_Off}"
    sudo apt -qy install apache2 apache2-doc libexpat1 ssl-cert
    # check Apache configuration: apachectl configtest
}

installLetsEncryptCertbot() {
    # Let's Encrypt SSL
    echo -e "\n ${Cyan} Installing Let's Encrypt SSL.. ${Color_Off}"

    sudo apt update # update repo sources
    sudo apt install -y software-properties-common # required in order to add a repo
    sudo add-apt-repository ppa:certbot/certbot -y # add Certbot repo
    sudo apt update # update repo sources
    sudo apt install -y python-certbot-apache # install Certbot
}


installPHP() {
    # PHP and Modules
    echo -e "\n ${Cyan} Installing PHP and common Modules.. ${Color_Off}"


    # PHP7 (latest)
    sudo apt -qy install php php-common libapache2-mod-php php-curl php-cli php-dev php-gd php-gettext php-imagick php-intl php-mbstring php-mysql php-pear php-pspell php-recode php-xml php-zip
}

installPHP71() {
    # PHP and Modules
    echo -e "\n ${Cyan} Installing PHP 7.1 and common Modules.. ${Color_Off}"

    # PHP7.1
    sudo apt install software-properties-common
    sudo add-apt-repository ppa:ondrej/php
    sudo apt update
    sudo apt install php7.1 php7.1-common php7.1-opcache php7.1-cli php7.1-gd php7.1-curl php7.1-mysql php7.1-dev php7.1-gettext php7.1-mbstring php7.1-xml php7.1-zip
}

installPHP73() {
    # PHP and Modules
    echo -e "\n ${Cyan} Installing PHP 7.3 and common Modules.. ${Color_Off}"

    # PHP7.1
    sudo apt install software-properties-common
    sudo add-apt-repository ppa:ondrej/php
    sudo apt update
    sudo apt install php7.3 php7.3-common php7.3-opcache php7.3-cli php7.3-gd php7.3-curl php7.3-mysql php7.3-dev php7.3-gettext php7.3-mbstring php7.3-xml php7.3-zip
}

installMySQL() {
    # MySQL
    echo -e "\n ${Cyan} Installing MySQL.. ${Color_Off}"

    # set password with `debconf-set-selections` so you don't have to enter it in prompt and the script continues
    sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password ${PASS_MYSQL_ROOT}" # new password for the MySQL root user
    sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password ${PASS_MYSQL_ROOT}" # repeat password for the MySQL root user

    # DEBIAN_FRONTEND=noninteractive # by setting this to non-interactive, no questions will be asked
    DEBIAN_FRONTEND=noninteractive sudo apt -qy install mysql-server
}

secureMySQL() {
    # secure MySQL install
    echo -e "\n ${Cyan} Securing MySQL.. ${Color_Off}"

    mysql --user=root --password=${PASS_MYSQL_ROOT} << EOFMYSQLSECURE
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.db WHERE Db='test' OR Db='test_%';
FLUSH PRIVILEGES;
EOFMYSQLSECURE

# NOTE: Skipped validate_password because it'll cause issues with the generated password in this script
}

installPHPMyAdmin() {
    # PHPMyAdmin
    echo -e "\n ${Cyan} Installing PHPMyAdmin.. ${Color_Off}"

    # set answers with `debconf-set-selections` so you don't have to enter it in prompt and the script continues
    sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" # Select Web Server
    sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true" # Configure database for phpmyadmin with dbconfig-common
    sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password ${PASS_PHPMYADMIN_APP}" # Set MySQL application password for phpmyadmin
    sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password ${PASS_PHPMYADMIN_APP}" # Confirm application password
    sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password ${PASS_MYSQL_ROOT}" # MySQL Root Password
    sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/internal/skip-preseed boolean true"

    DEBIAN_FRONTEND=noninteractive sudo apt -qy install phpmyadmin
}

enableMods() {
    # Enable mod_rewrite, required for WordPress permalinks and .htaccess files
    echo -e "\n ${Cyan} Enabling Modules.. ${Color_Off}"

    sudo a2enmod rewrite
    # php5enmod mcrypt # PHP5 on Ubuntu 14.04 LTS
    # phpenmod -v 5.6 mcrypt mbstring # PHP5 on Ubuntu 17.04
    sudo phpenmod mbstring # PHP7
}

setPermissions() {
    # Permissions
    echo -e "\n ${Cyan} Setting Ownership for /var/www.. ${Color_Off}"
    sudo chown -R www-data:www-data /var/www
    sudo chmod -R 0755 /var/www
}

restartApache() {
    # Restart Apache
    echo -e "\n ${Cyan} Restarting Apache.. ${Color_Off}"
    sudo service apache2 restart
}

# RUN
update
installApache
installLetsEncryptCertbot
installPHP
installMySQL
secureMySQL
installPHPMyAdmin
enableMods
setPermissions
restartApache

echo -e "\n${Green} SUCCESS! MySQL password is: ${PASS_MYSQL_ROOT} ${Color_Off}"