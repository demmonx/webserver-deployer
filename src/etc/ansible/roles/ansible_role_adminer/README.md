# Adminer role for Ansible
## Background
This module install and configure Adminer [https://www.adminer.org/] through Ansible [https://www.ansible.com/]. It's working with Nginx [https://www.nginx.com/] server.

## Getting started
Be sure `ansible_role_nginx` is also installed, then **Adminer** is installed inside **nginx** html root repository   

## Variables
| Variable | Default | Description
| --- | --- | --- |
webserver_user | www-data | Webserver daemon user
webserver_folder | /var/www/html | HTML root repository 


## License
MIT License