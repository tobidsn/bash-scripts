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

update() {
    # Update system repos
    echo -e "\n ${Cyan} Updating package repositories.. ${Color_Off}"
    sudo apt -qq update
}

installNginx() {
    # Nginx
    echo -e "\n ${Cyan} Installing Nginx.. ${Color_Off}"
    sudo apt -qy install nginx
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
    sudo apt -qy install php php-fpm php-curl php-cli php-dev php-gd php-gettext php-imagick php-intl php-mbstring php-mysql php-pear php-xml php-zip
}

installMySQL() {
    # MySQL
    echo -e "\n ${Cyan} Installing MySQL.. ${Color_Off}"
    # DEBIAN_FRONTEND=noninteractive # by setting this to non-interactive, no questions will be asked
    DEBIAN_FRONTEND=noninteractive sudo apt -qy install mysql-server
}

secureMySQL() {
    # secure MySQL install
    echo -e "\n ${Cyan} For Securing MySQL please read tutorial: https://medium.com/@tobidsn/secure-mysql-installation-b30b8531a5d ${Color_Off}"
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
    systemctl enable nginx
    sudo systemctl reload mysql
    systemctl enable mysql
    sudo systemctl reload php-fpm
    systemctl enable php-fpm
}

# RUN
update
installNginx
installLetsEncryptCertbot
installPHP
installMySQL
setPermissions
restartNginx
secureMySQL

echo -e "\n${Green} Sample secure MySQL password is: ${PASS_MYSQL_ROOT} ${Color_Off}"


IP_ADDRESS=$(dig +short myip.opendns.com @resolver1.opendns.com)
echo -e $"Complete! \nYou now can test new host is: http://${IP_ADDRESS}"