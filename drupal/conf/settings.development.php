<?php
/**
 * This file contains Drupal config
 */

/**
 * Set up our global environment constant
 */
putenv( 'WKV_SITE_ENV=development' );
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
	'database'  => env( 'DB_NAME_DEVELOPMENT' ),
	'username'  => env( 'DB_USER_DEVELOPMENT' ),
	'password'  => env( 'DB_PASS_DEVELOPMENT' ),
	'host'      => env( 'DB_HOST_DEVELOPMENT' ) ?: '127.0.0.1',
	'port'      => env( 'DB_PORT_DEVELOPMENT' )	?: 3306,
	'prefix'    => env( 'DB_PREFIX' )       	?: '',
	'driver'    => env( 'DB_DRIVER' )       	?: 'mysql',
	'namespace' => 'Drupal\\Core\\Database\\Driver\\mysql',
);

/**
 * Set salts, prefer salt for the environment but fallback to global salt
 */
$settings['hash_salt'] = env( 'DRUPAL_HASH_SALT_DEVELOPMENT' ) ?: env( 'DRUPAL_HASH_SALT' );
