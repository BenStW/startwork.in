Feature: user joins work_session
  As a user
  I want to join a work_session
  so that I can work with my work_buddies

  @javascript
  Scenario: user joins work_session
     Given the following users with calendar events
      | name | start_time | end_time |
      | Ben  | 10         | 12       |    
     And a logged-in facebook user "Ben"
    # When the user hits ID "join_work_session"

   #  When the user hits ID "join_work_session"
