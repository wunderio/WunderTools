#!/bin/bash

echo export WKV_SITE_ENV="vagrant" > /etc/profile.d/wkv.sh
echo "export XDEBUG_CONFIG=\"remote_host=\${SSH_CLIENT%% *}\"" > /etc/profile.d/xdebug.sh