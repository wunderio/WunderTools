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
$kernel = new DrupalKernel('prod', $autoloader);

$request = Request::createFromGlobals();
$response = $kernel->handle($request);

define('DRUPAL_ROOT', getcwd());

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
if (isset($conf['memcache_servers'])) {
  foreach ($conf['memcache_servers'] as $address => $bin) {
    list($ip, $port) = explode(':', $address);
    if (!memcache_connect($ip, $port)) {
      $errors[] = 'Memcache bin <em>' . $bin . '</em> at address ' . $address . ' is not available.';
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

$files_path = \Drupal::service('file_system')->realpath(file_default_scheme() . "://");

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
if (isset($conf['redis_cache_socket'])) {
  $redis = new Redis();
  if (!$redis->connect($conf['redis_cache_socket'])) {
    $errors[] = 'Redis at ' . $conf['redis_cache_socket'] . ' is not available.';
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
