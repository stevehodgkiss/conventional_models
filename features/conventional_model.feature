Feature: ConventionalModel
  In order play with my database
  As a lazy fuck
  I want conventional ActiveRecord models for my database

  Scenario Outline: One table, no rows
    Given a table "<table_name>"
    And a file named "my_script.rb" with:
      """
      $:.unshift("../../lib")
      require 'rubygems'
      require 'active_record'
      ActiveRecord::Base.establish_connection(:database => '../test.sqlite', :adapter => 'sqlite3')
      require 'conventional_model'
      ConventionalModel.configure
      puts "Number of records: #{<model_name>.count}"
      """
    When I run "ruby my_script.rb"
    Then I should see "Number of records: 0"
    
    Examples:
      | table_name    | model_name  |
      | pages         | Page        |
      | content_items | ContentItem |
