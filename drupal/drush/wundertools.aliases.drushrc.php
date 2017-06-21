<?php
// If the .vagrant folder exists find the ssh key for the virtual machine
if (getenv('WKV_SITE_ENV' == 'local')) {
  $home = drush_server_home();
  // Solve the key file to use
  $path = explode('/', dirname(__FILE__));
  array_pop($path);
  array_pop($path);
  $path[] = '.vagrant';
  $path = implode('/', $path);
  $key = shell_exec('find ' . $path . ' -iname private_key');
  if (!$key) {
    $key = $home . '/.vagrant.d/insecure_private_key';
  }
  $key = rtrim($key);

} else {
  // .vagrant directory doesn't exist, just use empty key
  $key = "";
}

$aliases['local'] = array(
  'parent' => '@parent',
  'site' => 'wundertools',
  'env' => 'vagrant',
  'root' => '/vagrant/drupal/web',
  'remote-host' => 'local.wundertools.com',
  'remote-user' => 'vagrant',
  'ssh-options' => '-i ' . $key,
  'path-aliases' => array(
    '%files' => '/vagrant/drupal/files',
    '%dump-dir' => '/home/vagrant',
  ),
);

$aliases['dev'] = array(
  'uri' => 'https://dev.wundertools.com',
  'remote-user' => 'www-admin',
  'remote-host' => 'dev.wundertools.com',
  'root' => '/var/www/dev.wundertools.com/web',
  'path-aliases' => array(
    '%dump-dir' => '/home/www-admin',
  ),
  'command-specific' => array(
    'sql-sync' => array(
      'no-cache' => TRUE,
    ),
  ),
);

$aliases['stage'] = array(
  'uri' => 'https://stage.wundertools.com',
  'remote-user' => 'www-admin',
  'remote-host' => 'stage.wundertools.com',
  'root' => '/var/www/stage.wundertools.com/web',
  'path-aliases' => array(
    '%dump-dir' => '/home/www-admin',
  ),
  'command-specific' => array(
    'sql-sync' => array(
      'no-cache' => TRUE,
    ),
  ),
);

$aliases['prod'] = array(
  'uri' => 'https://wundertools.com',
  'remote-user' => 'www-admin',
  'remote-host' => 'wundertools.com',
  'root' => '/var/www/wundertools.com/web',
  'path-aliases' => array(
    '%dump-dir' => '/home/www-admin',
  ),
  'command-specific' => array(
    'sql-sync' => array(
      'no-cache' => TRUE,
    ),
  ),
);
