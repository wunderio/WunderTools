<?php

/**
 * General settings.php for all environments.
 * You could use this to add general settings to be used for all environments.
 */

/**
 * Database settings (overridden per environment)
 */
$databases = array();

/**
 * Location of the site configuration files.
 */
$config_directories = array(
  CONFIG_SYNC_DIRECTORY => '../sync',
);

/**
 * Salt for one-time login links, cancel links, form tokens, etc.
 *
 * Add the hash salt in local.settings.php
 */
# $settings['hash_salt'] = 'x5cXoUOZwUyDLneh2LM2K4HIdhTILlQslBTGXZP5pMx5bCuOoGiGP-zgk5BnY0EcS_vnHYmwCA';

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
