@wip
Feature: Cmconsole
  In order to play with models generated against other projects with ease
  As a user
  I want a cmconsole command to find my database config, configure activerecord and start an IRB session for me
  
  Scenario: Typing cmconsole when a valid config/database.yml exists
    Given a file named "config/database.yml" with:
      """
      development:
        adapter: sqlite3
        database: test.sqlite
        pool: 5
        timeout: 5000
        
      test:
        adapter: sqlite3
        database: test.sqlite
        pool: 5
        timeout: 5000
        
      production:
        adapter: sqlite3
        database: production.sqlite
        pool: 5
        timeout: 5000
      """
    And a table "pages"
    When I run "../../bin/cmconsole"
    Then I should see ">> "
  
  

  
