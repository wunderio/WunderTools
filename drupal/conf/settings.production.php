<?php
/**
 * This file contains Drupal config
 */

/**
 * Set up our global environment constant
 */
putenv( 'WKV_SITE_ENV=production' );
define( 'WKV_SITE_ENV', getenv( 'WKV_SITE_ENV' ) );

/**
 * Keep this codebase DRY and include global settings from another file
 */
if ( file_exists( __DIR__ . '/settings.global.php' ) ) {
    include __DIR__ . '/settings.global.php';
}

/**
 * Database settings from env
 */
$databases['default']['default'] = array (
	'database'  => getenv( 'DB_NAME_PRODUCTION' ),
	'username'  => getenv( 'DB_USER_PRODUCTION' ),
	'password'  => getenv( 'DB_PASS_PRODUCTION' ),
	'host'      => getenv( 'DB_HOST_PRODUCTION' ) 	?: '127.0.0.1',
	'port'      => getenv( 'DB_PORT_PRODUCTION' )	?: 3306,
	'prefix'    => getenv( 'DB_PREFIX' )       	?: '',
	'driver'    => getenv( 'DB_DRIVER' )       	?: 'mysql',
	'namespace' => 'Drupal\\Core\\Database\\Driver\\mysql',
);

/**
 * Set salts, prefer salt for the environment but fallback to global salt
 */
$settings['hash_salt'] = getenv( 'DRUPAL_HASH_SALT_PRODUCTION' ) ?: getenv( 'DRUPAL_HASH_SALT' );
