<?php
/**
 * @file
 * wk_basic_page_feature.features.inc
 */

/**
 * Implements hook_node_info().
 */
function wk_basic_page_feature_node_info() {
  $items = array(
    'basic_page' => array(
      'name' => t('Basic page'),
      'base' => 'node_content',
      'description' => t('Use <em>basic pages</em> for your static content, such as an \'About us\' page.'),
      'has_title' => '1',
      'title_label' => t('Title'),
      'help' => '',
    ),
  );
  return $items;
}
