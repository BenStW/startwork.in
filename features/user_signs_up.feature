Feature: User signs up
  As a user
  I want to signup
  so that I have an own protected profile

  Scenario: User signs up
    Given a new user "Ben"
    When Ben populates his data on the sign up site
    Then he succussfully signs up