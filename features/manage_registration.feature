Feature: Registration
  In order to register
  As a unregistered user
  I want to type in my OpenID
  
  Scenario: Login with OpenID
    Given I am on the new session page
    When I fill in "openid_identifier" with "http://tomk32.myopenid.com"
    And I press "Sign in"
    Then I should be redirected to "http://www.myopenid.com/server"

  Scenario: Login with a bad OpenID
    Given I am on the new session page
    When I fill in "openid_identifier" with "http://badopenid.host"
    And I press "Sign in"
    Then the flash "error" should be "Sorry, the OpenID server couldn't be found"
    Then I should see template "sessions/new"

  Scenario: Valid OpenID missing user data
    Given that I have an incomplete OpenID
    Then I should see template "users/new"
    When I fill in "user_login" with "TomK32"
    And I fill in "user_name" with "Thomas R. Koll"
    And I fill in "user_email" with "tomk32@gmx.de"
    And I press "Create account"
    Then I should see template "photos/index"
    And I should have a user account
    And I should have a identity

  Scenario: Valid OpenID with all required user data
    Given that I have a complete OpenID as user "TomK33"
    Then I should see template "photos/index"
    And I should have a user account
    And I should have a identity