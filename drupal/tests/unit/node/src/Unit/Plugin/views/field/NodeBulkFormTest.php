<?php

namespace Drupal\Tests\node\Unit\Plugin\views\field;

use Drupal\Core\DependencyInjection\ContainerBuilder;
use Drupal\node\Plugin\views\field\NodeBulkForm;
use Drupal\Core\StringTranslation\TranslatableMarkup;
use Drupal\Core\StringTranslation\PluralTranslatableMarkup;

/**
 * @coversDefaultClass \Drupal\node\Plugin\views\field\NodeBulkForm
 * @group node
 */
class NodeBulkFormTest extends \PHPUnit_Framework_TestCase {

  /**
   * Tests the constructor assignment of actions.
   */
  public function testConstructor() {
    $actions = [];

    for ($i = 1; $i <= 2; $i++) {
      $action = $this->getMockBuilder('\Drupal\system\ActionConfigEntityInterface')->getMock();
      $action->expects($this->any())
        ->method('getType')
        ->will($this->returnValue('node'));
      $actions[$i] = $action;
    }

    $action = $this->getMockBuilder('\Drupal\system\ActionConfigEntityInterface')->getMock();
    $action->expects($this->any())
      ->method('getType')
      ->will($this->returnValue('user'));
    $actions[] = $action;

    $entity_storage = $this->getMockBuilder('Drupal\Core\Entity\EntityStorageInterface')->getMock();
    $entity_storage->expects($this->any())
      ->method('loadMultiple')
      ->will($this->returnValue($actions));

    $entity_manager = $this->getMockBuilder('Drupal\Core\Entity\EntityManagerInterface')->getMock();
    $entity_manager->expects($this->once())
      ->method('getStorage')
      ->with('action')
      ->will($this->returnValue($entity_storage));

    $language_manager = $this->getMockBuilder('Drupal\Core\Language\LanguageManagerInterface')->getMock();

    $views_data = $this->getMockBuilder('Drupal\views\ViewsData')
      ->disableOriginalConstructor()
      ->getMock();
    $views_data->expects($this->any())
      ->method('get')
      ->with('node')
      ->will($this->returnValue(['table' => ['entity type' => 'node']]));
    $container = new ContainerBuilder();
    $container->set('views.views_data', $views_data);
    $container->set('string_translation', $this->getStringTranslationStub());

    $storage = $this->getMockBuilder('Drupal\views\ViewEntityInterface')->getMock();
    $storage->expects($this->any())
      ->method('get')
      ->with('base_table')
      ->will($this->returnValue('node'));

    $executable = $this->getMockBuilder('Drupal\views\ViewExecutable')
      ->disableOriginalConstructor()
      ->getMock();
    $executable->storage = $storage;

    $display = $this->getMockBuilder('Drupal\views\Plugin\views\display\DisplayPluginBase')
      ->disableOriginalConstructor()
      ->getMock();

    $definition['title'] = '';
    $options = [];

    $node_bulk_form = new NodeBulkForm([], 'node_bulk_form', $definition, $entity_manager, $language_manager);
    $node_bulk_form->init($executable, $display, $options);

    $this->assertAttributeEquals(array_slice($actions, 0, -1, TRUE), 'actions', $node_bulk_form);
  }

  /**
   * Returns a stub translation manager that just returns the passed string.
   *
   * @return \PHPUnit_Framework_MockObject_MockObject|\Drupal\Core\StringTranslation\TranslationInterface
   *   A mock translation object.
   */
  private function getStringTranslationStub() {
    $translation = $this->getMockBuilder('Drupal\Core\StringTranslation\TranslationInterface')->getMock();
    $translation->expects($this->any())
      ->method('translate')
      ->willReturnCallback(function ($string, array $args = [], array $options = []) use ($translation) {
        return new TranslatableMarkup($string, $args, $options, $translation);
      });
    $translation->expects($this->any())
      ->method('translateString')
      ->willReturnCallback(function (TranslatableMarkup $wrapper) {
        return $wrapper->getUntranslatedString();
      });
    $translation->expects($this->any())
      ->method('formatPlural')
      ->willReturnCallback(function ($count, $singular, $plural, array $args = [], array $options = []) use ($translation) {
        $wrapper = new PluralTranslatableMarkup($count, $singular, $plural, $args, $options, $translation);
        return $wrapper;
      });
    return $translation;
  }

}
