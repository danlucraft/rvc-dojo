Feature: Show the current HEAD commit
  So I know what the fuck James is coding up here
  
  Scenario: lalala
    When I run rvc log
    Then I want to see "Message: Add .rvc to gitignore"
    And I want to see "Message: Turn zlibbing on"

  Scenario: Display author (aka lalalalal 2)
    When I run rvc log
    Then I want to see "Author: dan"
