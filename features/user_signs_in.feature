Feature: User signs in
  As a user
  I want to sign in
  so that I can use my protected profile

  #@javascript
  Scenario: User signs in
    Given the user "Ben"
    And the user is activated
    When he signs in
    Then the user sees the work groups

  Scenario: Not activated User signs in
    Given the user "Kai"
    When he signs in
    Then he sees the not activated message 

