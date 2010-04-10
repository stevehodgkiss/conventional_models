require 'rubygems'
require 'active_record'
require 'active_support'
require 'conventional_models/version'
require 'conventional_models/conventions'
require 'conventional_models/database'
require 'conventional_models/table'
require 'conventional_models/column'
require 'conventional_models/active_record_base_model_for'

module ConventionalModels
  def self.configure(&block)
    @@conventions = Conventions.new(&block)
    @@database = Database.new(::ActiveRecord::Base.connection)
    @@database.apply_conventions(@@conventions)
    run_code @@database.code
  end
  
  def self.run_code(code)
    eval code
  end
  
  def self.model_code
    @@database.code
  end
  
  def self.model_code_for(table)
    @@database.code_for(table)
  end
end