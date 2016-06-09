Feature: Content types testing

  @javascript

  Scenario: admins can create basic pages
    Given I am logged in as "admin"
    And   I go to "node/add/basic_page"
    When  I fill in "title" with "Example page"
    And   I fill in "Body" with "Example text"
    #And   I submit the form "basic-page-node-form"
    And   I press "edit-submit"
    Then  I should read "Basic page Example page has been created. YO"
