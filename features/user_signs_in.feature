Feature: User signs in
  As a user
  I want to sign up and sign in
  so that I can use my protected profile

  Scenario: User signs up
    Given a new user
    When the user signs up with his name "Ben", email "ben@example.com" and password "secret"
    And the user "Ben" is activated
    Then the user sees "Maintain work sessions"

  Scenario: Not activated User signs up
    Given a new user
    When the user signs up with his name "Ben", email "ben@example.com" and password "secret"
    Then the user sees "Your account is not activated yet."

  #@javascript
  Scenario: User signs in
    Given the user with name "Ben", email "ben@example.com" and password "secret"
    And the user "Ben" is activated
    When the user signs in with his email "ben@example.com" and password "secret"
    Then the user sees "Maintain work sessions"

  Scenario: Not activated User signs in
    Given the user with name "Ben", email "ben@example.com" and password "secret"
    When the user signs in with his email "ben@example.com" and password "secret"
    Then the user sees "Your account is not activated yet."

