Feature: user defines time in calendar
  As a user
  I want to define the working time
  so that I can join a work group at this time

  #@javascript
  Scenario: user defines time in calendar
    Given the user "Ben"
    And a work group
    When he signs in
    And he visits the calendar
    And he selects the day "tomorrow"
    And he selects the hour "10"
    Then this definition is saved successfully