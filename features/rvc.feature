#@announce-stdout @announce-stderr
Feature: Ruby Version Control

  Background:
    Given a directory named "test_repo"
    When I cd to "test_repo"

  Scenario: Log should fail if it isn't a repo
    When I run rvc log
    And the output should contain "Not an RVC repository."

  Scenario: Log should succeed but be empty if there are no commits
    When I run rvc init
    And I run rvc log
    And the output should contain "No commits."
    
  Scenario: Commit should print usage if the arguments are wrong
    Given a file named "test_repo/example.rb" with:
      """
      puts "hello world"
      """
    When I run rvc init
    And I run rvc commit "Hello world implemented."
    Then the output should contain exactly:
      """
      usage: rvc commit USERNAME MESSAGE
      
      """

  Scenario: Commit should create a commit in the log
    Given a file named "test_repo/example.rb" with:
      """
      puts "hello world"
      """
    When I run rvc init
    And I run rvc commit dan "Hello world implemented."
    And I run rvc log
    Then the output should contain:
      """
      Hello world implemented.
      """

  Scenario: Should be able to checkout old versions
    Given a file named "test_repo/example.rb" with:
      """
      puts "hello world"
      """
    When I run rvc init
    And I run rvc commit dan "Initial commit."
    Given a file named "test_repo/example.rb" with:
      """
      puts "hello world"
      YOYOYO
      """
    And I run rvc commit dan "Modified."
    And I run rvc checkout HEAD^
    And the file "test_repo/example.rb" should not contain "YOYOYO"

  Scenario: Should be able to restore newer versions
    Given a file named "test_repo/example.rb" with:
      """
      puts "hello world"
      """
    When I run rvc init
    And I run rvc commit dan "Initial commit."
    Given a file named "test_repo/example.rb" with:
      """
      puts "hello world"
      YOYOYO
      """
    And I run rvc commit dan "Modified."
    And I run rvc checkout HEAD^
    And the file "test_repo/example.rb" should not contain "YOYOYO"
    And I run rvc checkout HEAD
    And the file "test_repo/example.rb" should contain "YOYOYO"

  Scenario: Should be able to look at old versions
    Given a file named "test_repo/example.rb" with:
      """
      puts "hello world"
      """
    When I run rvc init
    And I run rvc commit dan "Initial commit."
    Given a file named "test_repo/example.rb" with:
      """
      puts "hello world"
      YOYOYO
      """
    And I run rvc commit dan "2nd commit."
    And I run rvc show HEAD^:test_repo/example.rb
    Then the output should contain exactly:
      """
      puts "hello world"
      
      """
    












