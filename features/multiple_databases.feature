Feature: Multiple database connection
  In order to transfer data between databases
  As a user
  I want to be able to connect and generate models for multiple databases

  Scenario: Connect to multiple database
    Given a table "pages" in "development"
    And a table "pages" in "test"
    And a file named "my_script.rb" with:
      """
      $:.unshift("../../lib")
      require 'rubygems'
      require 'active_record'
      require 'conventional_models'
      config = {
        "development" => {
          "database" => 'development.sqlite',
          "adapter" => 'sqlite3'
        },
        "test" => {
          "database" => 'test.sqlite',
          "adapter" => 'sqlite3'
        }
      }
      ConventionalModels.configure do
        connection config["development"]
        module_name "Development"
      end
      ConventionalModels.configure do
        connection config["test"]
        module_name "Test"
      end
      puts ConventionalModels.model_code
      Development::Page.create!
      Development::Page.create!
      Test::Page.create!
      puts "Number of development records: #{Development::Page.count}"
      puts "Number of production records: #{Test::Page.count}"
      """
    When I run "ruby my_script.rb"
    Then the output should contain "Number of development records: 2"
    Then the output should contain "Number of production records: 1"