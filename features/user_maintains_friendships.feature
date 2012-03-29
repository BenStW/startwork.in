Feature: user maintains friendships
  As a user
  I want maintain my friends
  so that I can work with them on startwork

  Scenario: user adds a friend
    Given an active, logged-in user "Ben"
    And the active user with name "Steffi"
    When the user goes to "friendships"
    And the user adds "Steffi" as a work-buddy
    Then the user "Steffi" is shown as work-buddy

  Scenario: user removes a friend
    Given an active, logged-in user "Ben"
    And the active user with name "Steffi"
    When the user goes to "friendships"
    And the user adds "Steffi" as a work-buddy
    And the user removes "Steffi" as a work-buddy
    Then the user "Steffi" is not shown as work-buddy
  