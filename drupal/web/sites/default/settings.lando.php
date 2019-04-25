<?php

$base_url = "https://yrittajat.lndo.site";

// Imagemagick GD binary seems to be unavailable in Lando
$conf['imagemagick_gm'] = 0;
$conf['imagemagick_convert'] = '/usr/bin/convert';

// Set testing mode on locally
$conf['simple_environment_indicator'] = 'DarkGreen Lando';

$conf['stage_file_proxy_origin'] = 'https://www.yrittajat.fi';
$conf['stage_file_proxy_hotlink'] = TRUE;

// SOLR.
$conf['search_api_solr_overrides'] = array(
  'solr' => array(
    'name' => 'Solr Server (Overridden)',
    'options' => array(
      'host' => 'localhost',
      'port' => 8983,
      'path' => '/solr',
    ),
  ),
);

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

// CRM URL
$conf['sy_crm_url'] = 'https://yrittajat.crmserviceintegration.fi/Test/PublicServices/CompanyService.svc?wsdl';
