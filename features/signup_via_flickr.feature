Feature: Register via Flickr
  In order to register via flickr.com
  As an unregistered user
  I want to login
  And have a user account created on the fly


  Scenario: Login with flickr username
    Given I go to the homepage
    When I fill in "source_username" with "TomK32"
    And I press "Login via flickr"
    Then I should be redirected to 