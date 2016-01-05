Feature: Javascript-enabled test

  @javascript
  Scenario: Login with a Javascript browser
    Given I go to "user"
    Given I fill in "name" with "admin"
    And   I fill in "pass" with "admin"
    And   I press "edit-submit"
    Then  I should not see "Sorry, unrecognized username or password. Have you forgotten your password?"
    And   I should see "admin"

  Scenario: Logout
    Given I go to "user/logout"
    Then  I should find "body.not-logged-in"

  Scenario: The login fails with a sensible message with wrong username
    Given I go to "user"
    Given I fill in "name" with "1234"
    And   I fill in "pass" with "admin"
    And   I press "edit-submit"
    Then  I should see "Sorry, unrecognized username or password. Have you forgotten your password?"
