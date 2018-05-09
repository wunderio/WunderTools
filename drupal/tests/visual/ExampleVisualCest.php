<?php

class ExampleVisualCest {

  /**
   * @param \VisualTester $I
   */
  public function headerTest(VisualTester $I) {
    $I->amOnPage('/');
    $I->dontSeeVisualChanges('Header', '#header', ['#block-bartik-branding > div.site-branding__text > div > a']);
  }
}
