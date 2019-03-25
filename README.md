# Auto-deploy script  for a LEMP server (Ansible / Vagrant profile)

## Background

Vagrant and VirtualBox (or some other VM provider) can be used to quickly build or rebuild virtual servers.

Those scripts use Vagrant profile to deploy a new server and install Nginx, MySQL and PHP (the 'EMP' part of 'LEMP') using the [Ansible](http://www.ansible.com/) provisioner.

## Getting Started

This README file is inside a folder that contains a `Vagrantfile` (hereafter this folder shall be called the [vagrant_root]), which tells Vagrant how to set up your virtual machine in VirtualBox.

To use the vagrant file, you will need to have done the following:

  1. Download and Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
  2. Download and Install [Vagrant](https://www.vagrantup.com/downloads.html)
  3. Install [Ansible](http://docs.ansible.com/ansible/latest/intro_installation.html)
  4. Run the following command to install the necessary Ansible roles for this profile: `$ ansible-galaxy install -r src/ansible/requirements.yml`
  5. Run `./install.sh` ti install `lemp-manager`, files are placed into `$HOME/.lemp-manager.d/`

## CLI interface

You can run directly `lemp-manager` or use modules `lemp-manager-<module>`, tape `lemp-manager help` to show availables commands.

| Command | Description |
| --- | --- |
| `lemp-manager deploy <file1> [<file2> ...]` | Deploy new VMs |
| `lemp-manager stop <name1> [<name2> ...]` | Halt VMs |
| `lemp-manager start <name1> [<name2> ...]` | Start VMs |
| `lemp-manager update` | Update installed VMs |
| `lemp-manager list` | List installed VMs |
| `lemp-manager update-hosts` | Update /etc/hosts (as root) |
| `lemp-manager remove <name1> [<name2> ...]` | Delete VMs |
| `lemp-manager help` | Show available commands |

### Deploy new VMs
VM config **must be described in a yml file**. As least IP and name should be set, others fields are optionnals. 

Next run : `lemp-manager deploy <file1> [<file2> ...]`

### Update hosts file (root only)
Update /etc/hosts to match existing VM and delete old VMs, in order to access them by using http://{server name}/ instead of http://{ip}/, same for SSH (password = `vargant`)
You need to be root in order to run this command : 
`lemp-manager update-hosts`

### Delete VMs 
You could delete on or more VMs using : 
`lemp-manager-delete <name1> [<name2> ...]`
The VMs are stopped (if they are running) and next deleted from disk. They are removed from list of active VM (cannot update after delete) and added to list of removed host (they should be remove on `/etc/hosts` after next `lemp-manager update-hosts`)

## Examples
See `examples` folder to see all
### Machine configuration
```
machine:
  name: toto
  ram: [your-pass]
  cpu: 2 
  ip: 192.168.2.3

smtp:
  host: stmp.gmail.com
  user: [your-username]
  pass: [your-pass]

git:
  repo: [some git repo]

mysql:
  root:
    passwd: [your-pass]
  db: [db name]
  user: [db user name, granted on db]
  passwd: [db user password]
```

## Licence
MIT license

## Author Information

Based on (https://github.com/geerlingguy/ansible-vagrant-examples) by [Jeff Geerling](https://www.jeffgeerling.com/), author of [Ansible for DevOps](https://www.ansiblefordevops.com/).
