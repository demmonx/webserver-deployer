# PHP role for Ansible
## Background
This module install and configure php [https://www.php.net/] through Ansible [https://www.ansible.com/]. 

## Getting started
Be sure `ansible_role_nginx` is installed before. 
If you don't set any `vars`, php will be installed but without any specific settings. In order to deploy your website, you may configure `vars` to match your env, such as extra packages 

##Variables
| Variable | Default | Description
| --- | --- | --- |
webserver_daemon | nginx | Webserver daemon
php_packages | <none> | PHP extra packages (gd, mbstring, etc) 

## License
MIT License