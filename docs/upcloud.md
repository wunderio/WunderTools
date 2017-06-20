# Upcloud provisioning

[Wundermachina](https://github.com/wunderkraut/wundermachina) contains a ansible role for provisioning UpCloud servers.

## Requirements
* UpCloud account or subaccount
* Upcloud account needs to have API-access enabled

## Configuration

You need to set unique project name for upcloud:
```
upcloud_project_name: Example-Client
```

It should use initial root user ssh keys automatically from the key server but you can override that by providing your own:
```
upcloud_server_admin_ssh_keys:
  - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAA...
  - ssh-rsa AAAAB3NzaC1yc2EAAAADAQAB...
```

You can edit the upcloud server specifications in `conf/variables.yml`:
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

## How to provision servers
```
# Setup upcloud enviromental variables
$ export UPCLOUD_API_USER=first.last@example.com UPCLOUD_API_PASSWD=XXXXXXXXXX

# Provision the servers
$ ./provision.sh upcloud
```