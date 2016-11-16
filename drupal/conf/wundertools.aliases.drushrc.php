<?php
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

$aliases['local'] = array(
  'parent' => '@parent',
  'site' => 'wundertools',
  'env' => 'vagrant',
  'root' => '/vagrant/drupal/current',
  'remote-host' => 'local.wundertools.com',
  'remote-user' => 'vagrant',
  'ssh-options' => '-i ' . $key,
  'uri' => 'https://local.wundertools.com'
);
