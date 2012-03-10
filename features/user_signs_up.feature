Feature: User signs up
  As a user
  I want to signup
  so that I have an own protected profile

  Scenario: User signs up
    Given a new user "Ben"
    When the user populates his data on the sign up site
    And the user is activated
    Then he succussfully signs up
    And the user sees the work groups

  Scenario: Not activated User signs in
    Given a new user "Kai"
    When the user populates his data on the sign up site
    Then he succussfully signs up
    And he sees the not activated message

