# UpCloud provisioning

[Wundermachina](https://github.com/wunderkraut/wundermachina) contains a ansible roles for:
* Provisioning UpCloud servers using `upcloud-servers` role.
* Setupping disks and mounting them to machines with `upcloud-disks` role.
* Creating and Updating firewall rules using `upcloud-firewall` role.

## Requirements
* UpCloud account or subaccount
* Upcloud account needs to have API-access enabled

## Provisioning servers and disks to UpCloud with ansible

You need to set unique project name for UpCloud in `conf/variables.yml`:
```yml
upcloud_project_name: Example-Client
```

The role uses root user ssh keys automatically from the key server when WunderSecrets are used but you can override that by providing your own:
```yml
upcloud_server_admin_ssh_keys:
  - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAA...
  - ssh-rsa AAAAB3NzaC1yc2EAAAADAQAB...
```

You can edit the UpCloud server specifications in `conf/variables.yml`:
```yaml
# These are the specifications for servers in this project
upcloud_server_spec_list:
  - group: production
    members:
      - { name: web1, state: present }
    settings:
      plan: 6xCPU-8GB
      zone: de-fra1
      # Allows ansible to reboot the machine when making changes to the disks
      allow_reboot_on_resize: true
      storage_devices:
        - title: root
          os: CentOS 7.0
          size: 200
          backup_rule: { interval: daily, time: '0430', retention: 14 }
        - title: logs
          size: 10
          mount:
            path: /var/log
            fstype: ext4
            opts: defaults,noatime
        - title: database
          size: 30
          mount:
            path: /var/lib/mysql
            fstype: ext4
            # Options for mysql performance
            # These are the same as Mozilla is using for their mysql servers: https://bugzilla.mozilla.org/show_bug.cgi?id=874039
            opts: defaults,noatime,data=writeback,barrier=0,dioread_nolock
          backup_rule: { interval: daily, time: '0430', retention: 14 }
        # Swap is recommended for system stability and when it's a partition it can be excluded from backups
        # Upcloud minimum partition is 10gb
        - title: swap
          size: 10
          mount:
            path: none
            fstype: swap
            state: present
            opts: sw
  - group: stage
    members:
      - { name: web1, state: present }
    settings:
      plan: 2xCPU-2GB
      zone: de-fra1
      # Allows ansible to reboot the machine when making changes to the disks
      allow_reboot_on_resize: true
      storage_devices:
        - title: root
          size: 50
          os: CentOS 7.0
          backup_rule: { interval: daily, time: '0430', retention: 14 }
        - title: logs
          size: 10
          mount:
            path: /var/log
            fstype: ext4
            opts: noatime
```

### How to provision UpCloud servers
```bash
# Setup UpCloud credentials as envs
$ export UPCLOUD_API_USER=first.last@example.com UPCLOUD_API_PASSWD=XXXXXXXXXX

# Provision the servers
$ ./provision.sh upcloud
```

## Setupping the UpCloud firewall

You can also automatically setup [UpCloud provided firewall](https://www.upcloud.com/support/firewall/) by using WunderTools. This will work even if you didn't provision the servers with ansible.

### Firewall configuration

Default firewall rules are applied from [WunderSecrets](https://github.com/wunderio/wundersecrets). You can only see this repository if you have access to `wunderio` organization. The default rules will create list variable `firewall_ssh_allowed` which contains our prefered CI and office IP-addresses for administration. You shouldn't and can't override `firewall_ssh_allowed` variable.

Variables you can modify or add to your project are listed here:
```yml
# This rule set is used to allow additional servers to access ssh port
project_additional_ssh_firewall_rules:
  - comment: Admin machine
    ip: 10.0.0.1
  - comment: Test Machine
    ip: 127.0.0.1

# Because ansible is declarative it doesn't delete old records automatically
# You should move old non-used rules over here to ensure that they are deleted.
remove_ssh_firewall_rules:
  - comment: Admin machine
    ip: 10.0.0.1
  - comment: Test Machine
    ip: 127.0.0.1

# These are added after ssh rules
# It can be used to open ports for other services than ssh
# If you open up Remember to use encryption with those services!
project_additional_firewall_rules:
- direction: in
  family: IPv4
  protocol: tcp
  source_address_start: 127.0.0.1
  source_address_end: 127.0.0.255
  destination_port_start: 330
  destination_port_end: 22
  action: accept
```

### Deploy firewall settings to UpCloud

When you are ready you can provision firewall rules with `provision.sh`:
```bash

# Setup UpCloud credentials as envs
$ export UPCLOUD_API_USER=first.last@example.com UPCLOUD_API_PASSWD=XXXXXXXXXX

./provision.sh -t firewall upcloud
```