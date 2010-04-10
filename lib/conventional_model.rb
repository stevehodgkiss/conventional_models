require 'rubygems'
require 'active_support'
require 'active_record'
require 'conventional_model/version'
require 'conventional_model/conventions'
require 'conventional_model/database'
require 'conventional_model/table'

module ConventionalModel
  def self.configure(&block)
    @database = Database.new(Conventions.new(&block), ::ActiveRecord::Base.connection)
    run_code @database.code
  end
  
  def self.run_code(code)
    puts code
    eval code
  end
end