Feature: user maintains friendships
  As a user
  I want maintain my friends
  so that I can work with them on startwork

  Scenario: user adds a friend
    Given an active, logged-in user with name "Ben", email "ben@example.com" and password "secret"
    And the user with name "Steffi", email "steffi@example.com" and password "secret"
    When the user goes to "friendships"
    And the user presses "Add as friend"
    Then the user sees "Remove as friend"

  Scenario: user removes a friend
    Given an active, logged-in user with name "Ben", email "ben@example.com" and password "secret"
    And the user with name "Steffi", email "steffi@example.com" and password "secret"
    When the user goes to "friendships"
    And the user presses "Add as friend"
    And the user presses "Remove as friend"
    Then the user does not sees "Remove as friend"
