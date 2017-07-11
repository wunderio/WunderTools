Provisioning Servers
====================

This project uses UpCloud server provisioning with ansible. The servers are deployed using the central or personal UpCloud account. This account needs to have the api-connections enabled in UpCloud dashboard.

In order to use it you need to export username and password for ansible as `UPCLOUD_API_USER` and `UPCLOUD_API_PASSWD`.

This is easiest to do with `lpass` lastpass cli helper. You can install it from https://github.com/lastpass/lastpass-cli.

Setup credentials with lastpass cli
-----------------------------------
**bash/zsh shell**
```bash
# Remember to use your credentials
$ lpass login first.last@wunder.io
# Use lpass to export the USER and PASSWORD
$ export UPCLOUD_API_USER=$(lpass show "replace/this/with/path/to/the/upcloud/credentials" --username)
$ export UPCLOUD_API_PASSWD=$(lpass show "replace/this/with/path/to/the/upcloud/credentials" --password)
```

**fish shell**
```bash
# Remember to use your credentials
$ lpass login first.last@wunder.io
# Use lpass to export the USER and PASSWORD
$ set -x UPCLOUD_API_USER=(lpass show "replace/this/with/path/to/the/upcloud/credentials" --username)
$ set -x UPCLOUD_API_PASSWD=(lpass show "replace/this/with/path/to/the/upcloud/credentials" --password)
```

Deploy servers to Upcloud
-------------------------

Deployment uses `upcloud_server_spec_list` list from `conf/variables.yml` to deploy and update servers.

You can deploy or update the running servers according to the spec by running:
```
$ ./provision.sh upcloud
```
