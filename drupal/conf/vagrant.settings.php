<?php

// DATABASE

$databases = array (
  'default' => 
  array (
    'default' => 
    array (
      'database' => 'drupal',
      'username' => 'drupal',
      'password' => 'password',
      'host'     => 'localhost',
      'port'     => '',
      'driver'   => 'mysql',
      'prefix'   => '',
    ),
  ),
);

// CACHING
$conf['cache_backends'][] = 'sites/all/modules/contrib/redis/redis.autoload.inc';
$conf['cache_backends'][] = 'sites/all/modules/contrib/varnish/varnish.cache.inc';

$conf['cache_default_class']     = 'Redis_Cache';
//$conf['cache_class_cache_form']  = 'DrupalDatabaseCache';
$conf['cache_class_cache_page']  = 'VarnishCache';
$conf['redis_client_interface']  = 'PhpRedis';
$conf['redis_client_socket']     = '/tmp/redis.sock';
$conf['cache_prefix']            = 'wk';
$conf['page_cache_invoke_hooks'] = FALSE;

// Lock is disabled due to performance issues
// $conf['lock_inc']             = 'sites/all/modules/contrib/redis/redis.lock.inc';



