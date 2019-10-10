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

```bash
curl https://raw.githubusercontent.com/tobidsn/bash-scripts/master/lamp.sh | bash
chmod -x ./lamp.sh
bash ./lamp.sh
``

```
## lemp.sh

Install Nginx, Curl, LetsEncrypt Certbot, MySQL, Secure MySQL, Latest PHP and ser Permissions

- requires no user input
- sets a MySQL password and shows in console

```bash
curl https://raw.githubusercontent.com/tobidsn/bash-scripts/master/lemp.sh | bash
chmod -x ./lemp.sh
bash ./lemp.sh
``