Feature: user defines time in calendar
  As a user
  I want to define the working time
  so that I can join a work group at this time

  #@javascript
  Scenario: user defines time in calendar
    Given an active, logged-in user "Benedikt"
    And the following users with work session times
    | name     | start_time | end_time |
    | Benedikt | 10         | 13       |
    | Robert   | 11         | 12       |
    | Miro     | 9          | 11       |

    And the following friendships
    | user1    | user2  |
    | Benedikt | Robert |
    | Benedikt | Miro   |
    And the user presses "My calendar"

