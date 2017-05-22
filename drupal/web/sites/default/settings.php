<?php

/**
 * General settings.php for all environments.
 * You could use this to add general settings to be used for all environments.
 */

/**
 * Database settings (overridden per environment)
 */
$databases = array();
$databases['default']['default'] = array (
  'database' => 'drupal',
  'username' => getenv('DB_USER_DRUPAL'),
  'password' => getenv('DB_PASS_DRUPAL'),
  'prefix' => '',
  'host' => 'localhost',
  'port' => '3306',
  'namespace' => 'Drupal\\Core\\Database\\Driver\\mysql',
  'driver' => 'mysql',
);

// CHANGE THIS.
$settings['hash_salt'] = 'some-hash-salt-please-change-this';

if ( (isset($_SERVER["HTTPS"]) && strtolower($_SERVER["HTTPS"]) == "on")
  || (isset($_SERVER["HTTP_X_FORWARDED_PROTO"]) && $_SERVER["HTTP_X_FORWARDED_PROTO"] == "https")
  || (isset($_SERVER["HTTP_HTTPS"]) && $_SERVER["HTTP_HTTPS"] == "on")
) {
  $_SERVER["HTTPS"] = "on";

  // Tell Drupal we're using HTTPS (url() for one depends on this).
  $settings['https'] = TRUE;
}

if (isset($_SERVER['REMOTE_ADDR'])) {
  $settings['reverse_proxy'] = TRUE;
  $settings['reverse_proxy_addresses'] = array($_SERVER['REMOTE_ADDR']);
}

if(!empty($_SERVER['SERVER_ADDR'])){
  // This should return last section of IP, such as "198". (dont want/need to expose more info).
  //drupal_add_http_header('X-Webserver', end(explode('.', $_SERVER['SERVER_ADDR'])));
  $pcs = explode('.', $_SERVER['SERVER_ADDR']);
  header('X-Webserver: '. end($pcs));
}

$env = getenv('WKV_SITE_ENV');
switch ($env) {
  case 'production':
		$settings['simple_environment_indicator'] = '#d4000f Production';
	break;
  case 'dev':
    $settings['simple_environment_indicator'] = '#004984 Development';
	break;
  case 'stage':
		$settings['simple_environment_indicator'] = '#e56716 Stage';
	break;
  case 'local':
		$settings['simple_environment_indicator'] = '#88b700 Local';
	break;
}
/**
 * Location of the site configuration files.
 */
$config_directories = array(
  CONFIG_SYNC_DIRECTORY => '../sync',
);

/**
 * Access control for update.php script.
 */
$settings['update_free_access'] = FALSE;

/**
 * Load services definition file.
 */
$settings['container_yamls'][] = __DIR__ . '/services.yml';

/**
 * Environment specific override configuration, if available.
 */
if (file_exists(__DIR__ . '/settings.local.php')) {
   include __DIR__ . '/settings.local.php';
}
