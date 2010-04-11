Feature: Output model code
  In order to see what model code has been generated
  As a lazy fuck
  I want to be able to output the evaluated model code

  Scenario: A page with many content items
    Given a table "Page" with the following columns
      | name    | type    |
      | Id      | integer |
      | Name    | string  |
    And a table "ContentItem" with the following columns
      | name    | type                                       |
      | Id      | INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL |
      | Name    | string                                     |
      | Page_id | integer                                    |
    And a file named "my_script.rb" with:
      """
      $:.unshift("../../lib")
      require 'rubygems'
      require 'active_record'
      ActiveRecord::Base.establish_connection(:database => 'test.sqlite', :adapter => 'sqlite3')
      require 'conventional_models'
      ConventionalModels.configure do
        primary_key_name "Id"
      end
      puts "ContentItem code:<<\n#{ContentItem.model_code}>>"
      puts "Page code:<<\n#{Page.model_code}>>"
      """
    When I run "ruby my_script.rb"
    And within "ContentItem code" I should see:
      | line                         |
      | set_table_name "ContentItem" |
      | set_primary_key "Id"         |
      | belongs_to :page             |
    Then within "Page code" I should see:
      | line                    |
      | set_table_name "Page"   |
      | set_primary_key "Id"    |
      | has_many :content_items |