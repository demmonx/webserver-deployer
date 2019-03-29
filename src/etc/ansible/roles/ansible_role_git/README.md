# Git Deployer role for Ansible
## Background
This module install and configure git [https://git-scm.com/] through Ansible [https://www.ansible.com/]. 
It auto-deploy a repo inside the webserver root repository

## Getting started
Be sure dependencies are installed : 
```
  - ansible_role_nginx
  - ansible_role_php
  - ansible_role_composer
  - ansible_role_postgres
  - ansible_role_postfix
```
Then `git` is installed

##Variables
| Variable | Default | Description
| --- | --- | --- |
webserver_user | www-data | Webserver daemon user
webserver_folder | /var/www/html | HTML root repository 
git_repo | <none> | The repo to deploy

## License
MIT License