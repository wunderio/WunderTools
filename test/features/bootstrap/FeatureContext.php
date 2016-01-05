<?php
use Behat\Behat\Hook\Scope\AfterStepScope;
use Behat\Mink\Driver\Selenium2Driver;
/**
 * Defines application features from the specific context.
 */
class FeatureContext extends Behat\MinkExtension\Context\MinkContext {
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

}
