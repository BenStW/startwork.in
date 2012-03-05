Feature: User signs in
  As a user
  I want to sign in
  so that I can use my protected profile

  #@javascript
  Scenario: User signs in
    Given the user "Ben"
    When he signs in
    Then he can see his personalized homepage

