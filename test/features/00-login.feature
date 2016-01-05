Feature: Javascript-enabled test

  @javascript
  Scenario: Login with a Javascript browser
    Given I go to "user"
    Given I fill in "name" with "admin"
    And   I fill in "pass" with "admin"
    And   I press "edit-submit"
    Then  I should not see "Sorry, unrecognized username or password. Have you forgotten your password?"
    And  I should see "admin"
