<?php
use Behat\Behat\Tester\Exception\PendingException;
use Behat\Behat\Hook\Scope\AfterStepScope;
use Behat\Mink\Driver\Selenium2Driver;
use Behat\Behat\Context\SnippetAcceptingContext;

/**
 * Defines application features from the specific context.
 */
class FeatureContext extends Behat\MinkExtension\Context\MinkContext implements SnippetAcceptingContext{
    /**
   * Initializes context.
   *
   * Every scenario gets its own context instance.
   * You can also pass arbitrary arguments to the
   * context constructor through behat.yml.
   */
  public function __construct()
  {
    $this->debugger = new Debugger($this);
  }

  /**
   * Take a screenshot and save html when step fails. Works only with Selenium2Driver.
   *
   * @AfterStep
   * @param AfterStepScope $scope
   */
  public function takeScreenshotAfterFailedStep(Behat\Behat\Hook\Scope\AfterStepScope $scope)
  {
    if (99 === $scope->getTestResult()->getResultCode()) {
      $this->debugger->getScreenshot($scope);
      $this->debugger->saveHtml($scope);
    }
  }

  /**
  * CUSTOM IMPLEMENTATIONS
  */
  /**
   * @Then I should find :arg1
   */
  public function iShouldFind($arg1)
  {
      return $this->getSession()->getPage()->find('css',$arg1);
  }
}
