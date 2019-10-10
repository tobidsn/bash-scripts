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

installNginx() {
    # Nginx
    echo -e "\n ${Cyan} Installing Nginx.. ${Color_Off}"
    sudo apt -qy install nginx
    sudo ufw allow 'Nginx HTTP'
    systemctl start nginx
    systemctl enable nginx
}

installCurl() {
    sudo apt install curl
}

installLetsEncryptCertbot() {
    # Let's Encrypt SSL
    echo -e "\n ${Cyan} Installing Let's Encrypt SSL.. ${Color_Off}"

    sudo apt update # update repo sources
    sudo apt install -y software-properties-common # required in order to add a repo
    sudo add-apt-repository ppa:certbot/certbot -y # add Certbot repo
    sudo apt update # update repo sources
    sudo apt install -y python-certbot-nginx # install Certbot
}

installPHP() {
    # PHP and Modules
    echo -e "\n ${Cyan} Installing PHP and Modules.. ${Color_Off}"

    # PHP7 (latest)
    sudo add-apt-repository universe
    sudo apt update
    sudo apt -qy install php php-fpm php-curl php-cli php-mcrypt php-gd php-gettext php-imagick php-intl php-mbstring php-mysql php-pear php-xml php-zip
    systemctl start php-fpm
    systemctl enable php-fpm
}

installMySQL() {
    # MySQL
    echo -e "\n ${Cyan} Installing MySQL.. ${Color_Off}"

    # set password with `debconf-set-selections` so you don't have to enter it in prompt and the script continues
    sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password ${PASS_MYSQL_ROOT}" # new password for the MySQL root user
    sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password ${PASS_MYSQL_ROOT}" # repeat password for the MySQL root user

    # DEBIAN_FRONTEND=noninteractive # by setting this to non-interactive, no questions will be asked
    DEBIAN_FRONTEND=noninteractive sudo apt -qy install mysql-server
    systemctl start mysql
    systemctl enable mysql
}

secureMySQL() {
    # secure MySQL install
    echo -e "\n ${Cyan} Securing MySQL.. ${Color_Off}"

    mysql --user=root --password=${PASS_MYSQL_ROOT} << EOFMYSQLSECURE
DELETE FROM mysql.user WHERE user='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DELETE FROM mysql.user WHERE user='';
DELETE FROM mysql.db WHERE Db='test' OR Db='test_%';
FLUSH PRIVILEGES;
EOFMYSQLSECURE

# NOTE: Skipped validate_password because it'll cause issues with the generated password in this script
}

setPermissions() {
    # Permissions
    echo -e "\n ${Cyan} Setting Ownership for /var/www.. ${Color_Off}"
    sudo chown -R "$USER":www-data /var/www
    sudo chmod -R 0755 /var/www
}

restartNginx() {
    # Restart Nginx
    echo -e "\n ${Cyan} Restarting Nginx.. ${Color_Off}"
    sudo systemctl reload nginx
    sudo systemctl reload mysql
    sudo systemctl reload php-fpm
}

# RUN
update
installNginx
installCurl
installLetsEncryptCertbot
installPHP
installMySQL
secureMySQL
setPermissions
restartNginx

echo -e "\n${Green} SUCCESS! MySQL password is: ${PASS_MYSQL_ROOT} ${Color_Off}"

# Source Fork = https://github.com/aamnah/bash-scripts/blob/master/install/amp_debian.sh