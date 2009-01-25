Feature: Registration
  In order to register
  As a unregistered user
  I want to type in my OpenID
  
  Scenario: Login with OpenID
    Given I am on the new session page
    When I fill in "openid_identifier" with "http://tomk32.openid.com"
    And I press "Sign in"
    Then I should be redirected to http://tomk32.openid.com
