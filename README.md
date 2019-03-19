# Ansible Vagrant profile for a LEMP server

## Background

Vagrant and VirtualBox (or some other VM provider) can be used to quickly build or rebuild virtual servers.

Those scripts use Vagrant profile to deploy a new server and install Nginx, MySQL and PHP (the 'EMP' part of 'LEMP') using the [Ansible](http://www.ansible.com/) provisioner.

## Getting Started

This README file is inside a folder that contains a `Vagrantfile` (hereafter this folder shall be called the [vagrant_root]), which tells Vagrant how to set up your virtual machine in VirtualBox.

To use the vagrant file, you will need to have done the following:

  1. Download and Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
  2. Download and Install [Vagrant](https://www.vagrantup.com/downloads.html)
  3. Install [Ansible](http://docs.ansible.com/ansible/latest/intro_installation.html)
  4. Run the following command to install the necessary Ansible roles for this profile: `$ ansible-galaxy install -r requirements.yml`
  
Run `./install.sh --name=... --ip=... [--cpu=[1-8] --ram=512(or more)]` in order to directly install the vbox 

### Setting up your hosts file

You need to modify your host machine's hosts file to add the new hosts, in order to use ssh. 
Run `sudo hosts-update.sh` to do that

After that is configured, you could visit http://{server name}/ in a browser, and you'll see the Nginx 'Welcome to nginx!' page, or your can use run 
`ssh vargant@server` with password `vargant`

If you'd like additional assistance editing your hosts file, or do that manually, please read [How do I modify my hosts file?](http://www.rackspace.com/knowledge_center/article/how-do-i-modify-my-hosts-file) from Rackspace.

## Licence
MIT license

## Author Information

Based on (https://github.com/geerlingguy/ansible-vagrant-examples) by [Jeff Geerling](https://www.jeffgeerling.com/), author of [Ansible for DevOps](https://www.ansiblefordevops.com/).
