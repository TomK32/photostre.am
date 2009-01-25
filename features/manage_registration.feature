Feature: Registration
  In order to register
  As a unregistered user
  I want to type in my OpenID
  
  Scenario: Login with OpenID
    Given I am on the new session page
    When I fill in "openid_identifier" with "http://tomk32.myopenid.com"
    And I press "Sign in"
    Then I should be redirected to /^http://www.myopenid.com/server/

  Scenario: Loging with a bad OpenID
    Given I am on the new session page
    When I fill in "openid_identifier" with "http://badopenid.host"
    And I press "Sign in"
    Then the request should be a "success"
