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
  'site' => 'ansibleref',
  'env' => 'vagrant',
  'root' => '/vagrant/drupal/current',
  'remote-host' => 'local.wundertools.fi',
  'remote-user' => 'vagrant',
  'ssh-options' => '-i ' . $key,
);

$aliases['dev'] = array(
  'uri' => 'wundertools.dev.wunder.io',
  'root' => '/var/www/wundertools.dev.wunder.io/current/web',
  'remote-host' => 'wundertools.dev.wunder.io',
  'remote-user' => 'www-admin',
  'path-aliases' => array(
    '%dump-dir' => '/home/www-admin',
    '%drush' => '/usr/lib/composer/vendor/bin/drush',
    '%drush-script' => '/usr/lib/composer/vendor/bin/drush',
  ),
  'command-specific' => array(
    'sql-sync' => array(
      'no-cache' => true,
      'no-ordered-dump' => true,
      'structure-tables' => array(
        'custom' => array(
          'cache',
          'cache_filter',
          'cache_menu',
          'cache_page',
          'cache_views_data',
          'history',
          'sessions',
        ),
      ),
    ),
  ),
);

$aliases['stage'] = array(
  'uri' => 'wundertools.stage.wunder.io',
  'root' => '/var/www/wundertools.stage.wunder.io/current/web',
  'remote-host' => 'wundertools.stage.wunder.io',
  'remote-user' => 'www-admin',
  'path-aliases' => array(
    '%dump-dir' => '/home/www-admin',
    '%drush' => '/usr/lib/composer/vendor/bin/drush',
    '%drush-script' => '/usr/lib/composer/vendor/bin/drush',
  ),
  'command-specific' => array(
    'sql-sync' => array(
      'no-cache' => true,
      'no-ordered-dump' => true,
      'structure-tables' => array(
        'custom' => array(
          'cache',
          'cache_filter',
          'cache_menu',
          'cache_page',
          'cache_views_data',
          'history',
          'sessions',
        ),
      ),
    ),
  ),
);

$aliases['prod'] = array(
  'uri' => 'wundertools.prod.wunder.io',
  'root' => '/var/www/www.wundertools.fi/current/web',
  'remote-host' => 'prod-front-1.wundertools.hel.upc.wunder.io',
  'remote-user' => 'www-admin',
  'path-aliases' => array(
    '%dump-dir' => '/home/www-admin',
    '%drush' => '/usr/lib/composer/vendor/bin/drush',
    '%drush-script' => '/usr/lib/composer/vendor/bin/drush',
  ),
  'command-specific' => array(
    'sql-sync' => array(
      'no-cache' => true,
      'no-ordered-dump' => true,
      'structure-tables' => array(
        'custom' => array(
          'cache',
          'cache_filter',
          'cache_menu',
          'cache_page',
          'cache_views_data',
          'history',
          'sessions',
        ),
      ),
    ),
  ),
);
