<?php

use Drupal\node\Entity\Node;
use Codeception\Util\Fixtures;

class NodeCest {

  public function NewNodesGetPublishedToFRontPageTest(FunctionalTester $I) {
    $body = 'Etiam porta sem malesuada magna mollis euismod.';
    $node = Node::create([
      'type'        => 'article',
      'title'       => 'Druplicon test',
      'body' => [
        'value' => $body,
        'format' => 'full_html',
      ],
    ]);
    $node->isPublished();
    $node->save();
    Fixtures::add('test_node', $node->id());

    $I->amOnPage('/');
    $I->see($body);
  }

  /**
   * @inheritdoc
   */
  public function _after() {
    $node = \Drupal::entityTypeManager()
      ->getStorage('node')
      ->load(Fixtures::get('test_node'));
    $node->delete();
  }

  /**
   * @inheritdoc
   */
  public function _failed() {
    $this->_failed();
  }

}
