Feature: Stuff
  So things
  
  Scenario: dsfsd
    When I run rvc checkout
    Then there should be a directory "bin"
    Then the directory "bin" should contain something like "rvc"
