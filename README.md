# Bash Scripts

Misc. bash scripts that i write with ❤️ for my work.


```
.
├── README.md
├── lamp.sh
└── lemp.sh

```

## lamp.sh

Install Apache, Curl, LetsEncrypt Certbot, MySQL, Secure MySQL, PHP, phpMyAdmin, enable Mods and set Permissions

- requires no user input
- sets a MySQL password and shows in console

Install with wget

```bash
wget https://raw.githubusercontent.com/tobidsn/bash-scripts/master/lamp.sh
chmod -x ./lamp.sh
bash ./lamp.sh
``

```
Install with curl

```bash
curl https://raw.githubusercontent.com/tobidsn/bash-scripts/master/lamp.sh | bash
``

```
## lemp.sh

Install Nginx, Curl, LetsEncrypt Certbot, MySQL, Secure MySQL, Latest PHP and ser Permissions

- requires no user input
- sets a MySQL password and shows in console

Install with wget

```bash
wget https://raw.githubusercontent.com/tobidsn/bash-scripts/master/lemp.sh
chmod -x ./lemp.sh
bash ./lemp.sh
``

```
Install with curl

```bash
curl https://raw.githubusercontent.com/tobidsn/bash-scripts/master/lemp.sh | bash
``