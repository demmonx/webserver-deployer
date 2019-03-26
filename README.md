# Auto-deploy manager for a LEMP server ( deployement with Ansible / Vagrant profile)

## Background

Vagrant and VirtualBox are used to quickly build or rebuild virtual servers.

Those scripts use Vagrant profile to deploy a new server and install Nginx, PostgreSQL, SMTP and PHP using the [Ansible](http://www.ansible.com/) provisioner.

## Getting Started

You will need to have done the following before using the app:

  1. Download and Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
  2. Download and Install [Vagrant](https://www.vagrantup.com/downloads.html)
  3. Install [Ansible](http://docs.ansible.com/ansible/latest/intro_installation.html)
  4. Install  `sshpass` by running  `apt-get install sshpass` or  `yum install sshpass`
  5. Run the following command to install the necessary Ansible roles for this profile: `$ ansible-galaxy install -r src/ansible/requirements.yml`
  6. Run `./install.sh` to install `lemp-manager`, files are placed into `$HOME/.lemp-manager.d/`
  7. Run `source $HOME/.bashrc` to make the commands available globally

## CLI interface

You can run directly `lemp-manager` or use modules `lemp-manager-<module>`, tape `lemp-manager help` to show availables commands.

| Command | Description | Status
| --- | --- | --- |
| `lemp-manager create` | Create a config file by asking the user | Working
| `lemp-manager deploy <file1> [<file2> ...]` | Deploy new VMs | VM deployed, package installed but not configured -> debug needed
| `lemp-manager stop <name1> [<name2> ...]` | Halt VMs | Working
| `lemp-manager start <name1> [<name2> ...]` | Start VMs | Working
| `lemp-manager update` | Update installed VMs | Working
| `lemp-manager list` | List installed VMs | Working
| `lemp-manager update-hosts` | Update /etc/hosts (as root) | Working
| `lemp-manager remove <name1> [<name2> ...]` | Delete VMs | Working
| `lemp-manager help` | Show available commands | Working

### Deploy new VMs
VM config **must be described in a yml file**. As least IP and name should be set, others fields are optionnals. 

Next run : `lemp-manager deploy <file1> [<file2> ...]`

### Update hosts file (root only)
Update `/etc/hosts` to match existing VM and delete old VMs, in order to access them by using `http://{server name}/` instead of `http://{ip}/`wl, same for SSH (password = `vargant`)
You need to be root in order to run this command : 
`lemp-manager update-hosts`

### Delete VMs 
You could delete on or more VMs using : 
`lemp-manager-delete <name1> [<name2> ...]`
The VMs are stopped (if they are running) and next deleted from disk. They are removed from list of active VM (cannot update after delete) and added to list of removed host (they should be remove on `/etc/hosts` after next `lemp-manager update-hosts`)

## Examples
See `example` folder to see all
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
