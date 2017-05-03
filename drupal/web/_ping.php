<?php

//FOR DRUPAL 8 ONLY!
//FILE IS SUPPOSED TO BE IN DRUPAL ROOT DIRECTORY (NEXT TO INDEX.PHP)!!

// Register our shutdown function so that no other shutdown functions run before this one.
// This shutdown function calls exit(), immediately short-circuiting any other shutdown functions,
// such as those registered by the devel.module for statistics.
register_shutdown_function('status_shutdown');
function status_shutdown() {
  exit();
}

// We want to ignore _ping.php from New Relic statistics,
// because with 180rpm and less than 10s avg response times,
// _ping.php skews the overall statistics significantly.
if (extension_loaded('newrelic')) {
  newrelic_ignore_transaction();
}

header("HTTP/1.0 503 Service Unavailable");

// Drupal bootstrap.
use Drupal\Core\DrupalKernel;
use Drupal\Core\Site\Settings;
use Symfony\Component\HttpFoundation\Request;

$autoloader = require_once 'autoload.php';
$request = Request::createFromGlobals();
$kernel = DrupalKernel::createFromRequest($request, $autoloader, 'prod');
$kernel->boot();

// Define DRUPAL_ROOT if it's not yet defined by bootstrap.
defined('DRUPAL_ROOT') or define('DRUPAL_ROOT', getcwd());

// Get current settings.
$settings = Settings::getAll();

// Build up our list of errors.
$errors = array();

// Check that the main database is active.
$result = \Drupal\Core\Database\Database::getConnection()
  ->query('SELECT * FROM {users} WHERE uid = 1')
  ->fetchAllKeyed();

if (!count($result)) {
  $errors[] = 'Master database not responding.';
}

// Check that all memcache instances are running on this server.
if (isset($settings['memcache']['servers'])) {
  foreach ($settings['memcache']['servers'] as $address => $bin) {
    list($ip, $port) = explode(':', $address);
    if (!memcache_connect($ip, $port)) {
      $fails[] = 'Memcache bin <em>' . $bin . '</em> at address ' . $address . ' is not available.';
    }
    if(count($fails) >= count($settings['memcache']['servers'])) {
      $errors += $fails;
    }
  }
}

// Check that Redis instace is running correctly using PhpRedis
// TCP/IP connection
if (isset($conf['redis_client_host']) && isset($conf['redis_client_port'])) {
  $redis = new Redis();
  if (!$redis->connect($conf['redis_client_host'], $conf['redis_client_port'])) {
    $errors[] = 'Redis at ' . $conf['redis_client_host'] . ':' . $conf['redis_client_port'] . ' is not available.';
  }
}

// Define file_uri_scheme if it does not exist, it's required by realpath().
// The function file_uri_scheme is deprecated and will be removed in 9.0.0.
if (!function_exists('file_uri_scheme')) {
  function file_uri_scheme($uri) {
    return \Drupal::service('file_system')->uriScheme($uri);
  }
}

// Get current defined scheme.
$scheme = \Drupal::config('system.file')->get('default_scheme');

// Get the real path of the files uri.
$files_path = \Drupal::service('file_system')->realpath($scheme . '://');

// Check that the files directory is operating properly.
if ($test = tempnam($files_path, 'status_check_')) {
  if (!unlink($test)) {
    $errors[] = 'Could not delete newly create files in the files directory.';
  }
}
else {
  $errors[] = 'Could not create temporary file in the files directory.';
}

// UNIX socket connection
if (isset($settings['redis.connection']['host'])) {
  // @Todo, use Redis client interface.
  $redis = new \Redis();
  if (isset($settings['redis.connection']['port'])) {
    if (!$redis->connect($settings['redis.connection']['host'], $settings['redis.connection']['port'])) {
      $errors[] = 'Redis at ' . $settings['redis.connection']['host'] . ':' . $settings['redis.connection']['port'] . ' is not available.';
    }
  } else {
    if (!$redis->connect($settings['redis.connection']['host'])) {
      $errors[] = 'Redis at ' . $settings['redis.connection']['host'] . ' is not available.';
    }
  }
}

// Print all errors.
if ($errors) {
  $errors[] = 'Errors on this server will cause it to be removed from the load balancer.';
  header('HTTP/1.1 500 Internal Server Error');
  print implode("<br />\n", $errors);
}
else {
// Split up this message, to prevent the remote chance of monitoring software
// reading the source code if mod_php fails and then matching the string.
  header("HTTP/1.0 200 OK");
  print 'CONGRATULATIONS' . ' 200';
}


// Exit immediately, note the shutdown function registered at the top of the file.
exit();
