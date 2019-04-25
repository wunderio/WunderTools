<?php

/*
 * Load database credentials from Lando.
 */
$lando_info = json_decode(getenv('LANDO_INFO'), TRUE);
$databases['default']['default'] = [
  'driver' => 'mysql',
  'database' => $lando_info['database']['creds']['database'],
  'username' => $lando_info['database']['creds']['user'],
  'password' => $lando_info['database']['creds']['password'],
  'host' => $lando_info['database']['internal_connection']['host'],
  'port' => $lando_info['database']['internal_connection']['port'],
];

/**
 * Generate the hash_salt from LANDO_HOST_IP.
 */
$settings['hash_salt'] = md5(getenv('LANDO_HOST_IP'));

/**
 * Skip file system permissions hardening.
 */
$settings['skip_permissions_hardening'] = TRUE;

/**
 * Skip trusted host pattern.
 */
$settings['trusted_host_patterns'] = ['.*'];

/**
 * Base URL.
 */
$base_url = "https://wundertools.lndo.site";

/**
 * Simple Environment Indicator testing mode on.
 */
$conf['simple_environment_indicator'] = 'DarkGreen Lando';

/**
 * Stage File Proxy setup.
 */
$conf['stage_file_proxy_origin'] = '';
$conf['stage_file_proxy_hotlink'] = TRUE;

/**
 * Imagemagick GD binary setup.
 */
// $conf['imagemagick_gm'] = 0;
// $conf['imagemagick_convert'] = '/usr/bin/convert';

/**
 * SOLR setup.
 */
// $conf['search_api_solr_overrides'] = array(
//   'solr' => array(
//     'name' => 'Solr Server (Overridden)',
//     'options' => array(
//       'host' => 'localhost',
//       'port' => 8983,
//       'path' => '/solr',
//     ),
//   ),
// );
