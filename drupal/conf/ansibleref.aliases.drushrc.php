<?php
$home = drush_server_home();
// Solve the key file to use
$path = explode('/', dirname(__FILE__));
array_pop($path);
$path[] = '/../.vagrant';
$path = implode('/', $path);
$key = shell_exec('find ' . $path . ' -iname private_key');
if (!$key) {
  $key = $home . '/.vagrant.d/insecure_private_key';
}
$key = rtrim($key);

$aliases['local'] = array(
  'uri' => 'https://local.ansibleref.com',
  'parent' => '@parent',
  'site' => 'ansibleref',
  'env' => 'vagrant',
  'root' => '/vagrant/drupal/current/web',
  'remote-host' => 'local.ansibleref.com',
  'remote-user' => 'vagrant',
  'ssh-options' => '-i ' . $key,
  'path-aliases' => array(
    '%files' => '/vagrant/drupal/files',
    '%dump-dir' => '/home/vagrant',
  ),
);

$aliases['dev'] = array(
  'uri' => 'https://dev.ansibleref.com',
  'remote-user' => 'www-admin',
  'remote-host' => 'dev.ansibleref.com',
  'root' => '/var/www/dev.ansibleref.com/current/web',
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
  'uri' => 'https://stage.ansibleref.com',
  'remote-user' => 'www-admin',
  'remote-host' => 'stage.ansibleref.com',
  'root' => '/var/www/stage.ansibleref.com/current/web',
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
  'uri' => 'https://ansibleref.com',
  'remote-user' => 'www-admin',
  'remote-host' => 'ansibleref.com',
  'root' => '/var/www/ansibleref.com/current/web',
  'path-aliases' => array(
    '%dump-dir' => '/home/www-admin',
  ),
  'command-specific' => array(
    'sql-sync' => array(
      'no-cache' => TRUE,
    ),
  ),
);
