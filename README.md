# Bash Scripts

Misc. bash scripts that i write with ❤️ for my work.


```
.
├── README.md
└── lamp.sh

```

## lamp.sh

Install Apache, Curl, LetsEncrypt Certbot, MySQL, Secure MySQL, PHP, phpMyAdmin, enable Mods and set Permissions

- requires no user input
- sets a MySQL password and shows in console
- does not overwrite the MySQL password if it is already set
- select php version

```bash
curl https://raw.githubusercontent.com/tobidsn/bash-scripts/master/lamp.sh | bash
chmod -x ./lamp.sh
bash ./lamp.sh
``