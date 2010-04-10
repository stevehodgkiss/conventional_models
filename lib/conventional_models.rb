require 'rubygems'
require 'active_record'
require 'active_support'
require 'conventional_models/version'
require 'conventional_models/conventions'
require 'conventional_models/database'
require 'conventional_models/table'
require 'conventional_models/column'

module ConventionalModels
  def self.configure(&block)
    @database = Database.new(Conventions.new(&block), ::ActiveRecord::Base.connection)
    run_code @database.code
  end
  
  def self.run_code(code)
    puts code
    eval code
  end
end