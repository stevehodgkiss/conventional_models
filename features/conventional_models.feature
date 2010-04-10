Feature: ConventionalModels
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
      require 'conventional_models'
      ConventionalModels.configure
      puts "Number of records: #{<model_name>.count}"
      """
    When I run "ruby my_script.rb"
    Then I should see "Number of records: 0"
    
    Examples:
      | table_name    | model_name  |
      | pages         | Page        |
      | content_items | ContentItem |
  
  Scenario Outline: One table, no rows, legacy database
    Given a table "<table_name>"
    And a file named "my_script.rb" with:
      """
      $:.unshift("../../lib")
      require 'rubygems'
      require 'active_record'
      ActiveRecord::Base.establish_connection(:database => '../test.sqlite', :adapter => 'sqlite3')
      require 'conventional_models'
      ConventionalModels.configure do
        table_name do |table|
          table
        end
      end
      puts "Number of records: #{<model_name>.count}"
      """
    When I run "ruby my_script.rb"
    Then I should see "Number of records: 0"

    Examples:
      | table_name    | model_name  |
      | Page          | Page        |
      | ContentItem   | ContentItem |
  
  Scenario: Two tables with belongs_to and has_many relationship
    Given a table "Page" with the following columns
      | name    | type    |
      | Id      | integer |
      | Name    | string  |
    And a table "ContentItems" with the following columns
      | name    | type                                       |
      | Id      | INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL |
      | Name    | string                                     |
      | Page_id | integer                                    |

    And a file named "my_script.rb" with:
      """
      $:.unshift("../../lib")
      require 'rubygems'
      require 'active_record'
      ActiveRecord::Base.establish_connection(:database => '../test.sqlite', :adapter => 'sqlite3')
      require 'conventional_models'
      ConventionalModels.configure do
        primary_key_name "Id"
        table_name do |table|
          table
        end
      end
      page = Page.create :Name => 'test'
      page.content_items.create :Name => 'content1'
      puts "My page's content item name: #{page.content_items.first.Name}"
      """
    When I run "ruby my_script.rb"
    Then I should see "My page's content item name: content1"
  
  