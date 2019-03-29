# PostgreSQL role for Ansible
## Background
This module install and configure postgres [https://www.postgresql.org/] through Ansible [https://www.ansible.com/]. 
It can also configure a database with configured user and name. 

## Getting started
If you don't set any `vars`, **postgres** will be installed but with only default account. In order to deploy your website, you may configure `vars` to match your env 

##Variables
| Variable | Default | Description
| --- | --- | --- |
db_name | <none> | Database name
db_user | <none> | SGBD user, granted on db_name 
db_pass | <none> | Auto-encyrpted password for db_user

## License
MIT License