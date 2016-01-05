<?php
use Behat\Behat\Hook\Scope\AfterStepScope;

class Debugger {

  /** @var \FeatureContext */
  private $featureContext;
  private $screenshot_path = '/var/www/html/screenshots';
  private $screenshot_url = 'http://localhost/screenshots';
  private $html_dump_path = '/var/www/html/screenshots_html';
  private $html_dump_url = 'http://localhost/screenshots_html';

  public function __construct(\FeatureContext $featureContext) {
    $this->featureContext = $featureContext;
  }

  public function getScreenshot(Behat\Behat\Hook\Scope\AfterStepScope $scope) {
    if (!$scope->getTestResult()->isPassed()) {
      $driver = $this->featureContext->getSession()->getDriver();
      $filename = $this->buildScreenshotFilename($scope);
      $fileName = str_replace(array(' ', ','), '-', $scope->getName());
      $screenshot = $driver->getScreenshot();

      if (!file_exists($this->screenshot_path)){
          mkdir($this->screenshot_path);
      }

      $screenshot = $driver->getScreenshot();
      file_put_contents($filename, $screenshot);

      $message = "Screenshot saved to: " . $this->screenshot_path . "/". $fileName . ".png";
      $message .= "\nScreenshot available at: " . $this->screenshot_url . "/". $fileName . ".png";
      $message .= "\nCurrent URL: " . $this->featureContext->getSession()->getCurrentUrl();

      echo($message);
    }
  }
  public function saveHtml(Behat\Behat\Hook\Scope\AfterStepScope $scope) {
    if (!$scope->getTestResult()->isPassed()) {
      $session = $this->featureContext->getSession();
      $page = $session->getPage();
      $fileName = str_replace(array(' ', ','), '-', $scope->getName());

      if (!file_exists($this->html_dump_path)){
          mkdir($this->html_dump_path);
      }

      $date = date('Y-m-d H:i:s');
      $url = $session->getCurrentUrl();
      $html = $page->getContent();

      $html = "<!-- HTML dump from behat  \nDate: $date  \nUrl:  $url  -->\n " . $html;

      $htmlCapturePath = $this->html_dump_path . '/' . $fileName . '.html';
      file_put_contents($htmlCapturePath, $html);

      $message = "HTML saved to: " . $this->html_dump_path . "/". $fileName . ".html";
      $message .= "\nHTML available at: " . $this->html_dump_url . "/". $fileName . ".html";

      echo($message);
    }
  }

    private function buildScreenshotFilename(Behat\Behat\Hook\Scope\AfterStepScope $scope) {
      $scenarioTitle = str_replace(array(' ', ','), '-', $scope->getName());

      return $this->screenshot_path . '/' . $scenarioTitle . '.png';
    }
}
