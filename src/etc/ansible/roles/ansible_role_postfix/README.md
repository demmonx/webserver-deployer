# Postfix role for Ansible
## Background
This module install and configure postfix [http://www.postfix.org/] through Ansible [https://www.ansible.com/]. 
It can also configure **postfix** as smtp relay using TLS, working with Gmail accounts. 

## Getting started
If you don't set any `vars`, postfix will be installed but without any specific settings. In order to deploy your website, you may configure `vars` to match your env 

##Variables
| Variable | Default | Description
| --- | --- | --- |
smtp_host | <none> | IP or server name, should use TLS
smtp_user | <none> | Smtp host user account 
smtp_pass | <none> | Auto-encyrpted password for smtp_user

## License
MIT License