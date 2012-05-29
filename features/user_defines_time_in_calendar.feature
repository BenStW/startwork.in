Feature: user defines time in calendar
  As a user
  I want to define the working time
  so that I can join a work group at this time

  Scenario: users define calendar events, adds friends and gets work_sessions
    Given the following users with calendar events
      | name   | start_time | end_time |
      | Ben    | 10         | 12       |
      | Miro   | 11         | 13       |
      | Robert | 11         | 13       |

    When the user has following fb friends
     | user | friends      |
     | Ben  | Miro, Robert |
  
   Then the following work_sessions
     | start_time | users             |
     | 10         | Ben               |
     | 11         | Ben, Robert, Miro |
     | 12         | Miro              |
     | 12         | Robert            |


  
   Scenario: users adds friends, defines calendar events and gets work_sessions
     Given the user has following fb friends
      | user | friends |
      | Ben  | Miro    |
  
     When the following users with calendar events
      | name | start_time | end_time |
      | Ben  | 10         | 13       |
      | Miro | 11         | 12       |
  
     Then the following work_sessions
      | start_time | users     |
      | 10         | Ben       |
      | 11         | Ben, Miro |
      | 12         | Ben       |
  

  
  
