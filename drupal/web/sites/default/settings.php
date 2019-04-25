<?php

/**
 * General settings.php for all environments.
 * You could use this to add general settings to be used for all environments.
 */

/**
 * Database settings (overridden per environment)
 */
$databases = [];
$databases['default']['default'] = [
  'database' => getenv('DB_NAME_DRUPAL'),
  'username' => getenv('DB_USER_DRUPAL'),
  'password' => getenv('DB_PASS_DRUPAL'),
  'prefix' => '',
  'host' => getenv('DB_HOST_DRUPAL'),
  'port' => '3306',
  'namespace' => 'Drupal\\Core\\Database\\Driver\\mysql',
  'driver' => 'mysql',
];

// CHANGE THIS.
$settings['hash_salt'] = 'some-hash-salt-please-change-this';

if ((isset($_SERVER["HTTPS"]) && strtolower($_SERVER["HTTPS"]) == "on")
  || (isset($_SERVER["HTTP_X_FORWARDED_PROTO"]) && $_SERVER["HTTP_X_FORWARDED_PROTO"] == "https")
  || (isset($_SERVER["HTTP_HTTPS"]) && $_SERVER["HTTP_HTTPS"] == "on")
) {
  $_SERVER["HTTPS"] = "on";

  // Tell Drupal we're using HTTPS (url() for one depends on this).
  $settings['https'] = TRUE;
}

$env = getenv('WKV_SITE_ENV');
switch ($env) {
  case 'prod':
    $settings['simple_environment_indicator'] = '#d4000f Production';
    $settings['memcache']['servers'] = array(
      '[front1_internal_ip]:11211' => 'default',
      '[front2_internal_ip]:11211' => 'default'
    );
    break;

  case 'dev':
    $settings['simple_environment_indicator'] = '#004984 Development';
    break;

  case 'stage':
    $settings['simple_environment_indicator'] = '#e56716 Stage';
    break;

  case 'local':
  case 'lando':
    $settings['simple_environment_indicator'] = '#88b700 Local';
    break;
}

/**
 * Access control for update.php script.
 */
$settings['update_free_access'] = FALSE;

/**
 * Silta cluster configuration overrides.
 */
if (getenv('SILTA_CLUSTER') && file_exists($app_root . '/' . $site_path . '/settings.silta.php')) {
  include $app_root . '/' . $site_path . '/settings.silta.php';
}

/**
 * Local Lando configuration overrides.
 */
if (getenv('LANDO_INFO') && file_exists(__DIR__ . '/settings.lando.php')) {
  include __DIR__ . '/settings.lando.php';
}

/**
 * Environment specific override configuration, if available.
 */
if (file_exists(__DIR__ . '/settings.local.php')) {
  include __DIR__ . '/settings.local.php';
}
