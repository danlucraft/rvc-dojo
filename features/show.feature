Feature: Show the current HEAD commit
  So I know what the fuck James is coding up here
  
  Scenario: lalala (aka display messaaage)
    When I run rvc log
    Then I want to see "Message: Add .rvc to gitignore"

  Scenario: Display author (aka lalalalal 2)
    When I run rvc log
    Then I want to see "Author: dan"
    
  Scenario: Now I know how many there are (hint: lalalalalalalalalalalalalalalalalalalalalalalalalala)
    When I run rvc log
    Then I want to see "Message" 26 times
