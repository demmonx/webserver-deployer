# Nginx role for Ansible
## Background
This module install and configure nginx [https://www.nginx.com/] through Ansible [https://www.ansible.com/], woring with php-fpm.

## Getting started
If you don't set any `vars`, nginx will be installed but without any specific settings. In order to deploy your website, you may configure `vars` to match your env 

##Variables
| Variable | Default | Description
| --- | --- | --- |
web_folder | /var/www/html | HTML root folder
webserver_user | www-data | Webserver daemon user 
nginx_workers_con | 2048 | Number of simultaneous connexions
nginx_workers_nb | 4 | Number of running threads

## License
MIT License