require 'rubygems'
require 'active_record'
require 'active_support'
require 'conventional_models/version'
require 'conventional_models/config'
require 'conventional_models/database'
require 'conventional_models/table'
require 'conventional_models/column'
require 'conventional_models/active_record_base_model_for'
require 'conventional_models/options'
require 'conventional_models/option_parser'
require 'conventional_models/cli'
require 'irb';
require 'irb/completion'

module ConventionalModels
  @@database = nil
  
  def self.configure(&block)
    @@config = Config.new(&block)
    unless @@database.nil?
      remove(@@database)
    end
    @@database = Database.new(@@config)
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
  
  def self.run_console!
    configure_active_record
    configure
    IRB.start
  end
  
  def self.configure_active_record(config='config/database.yml', environment='development')
    config = YAML::load(IO.read(config))
    ActiveRecord::Base.configurations = config
    ActiveRecord::Base.establish_connection(config[environment])
  end
  
  def self.remove(database)
    database.tables.map{|t| t.class_name.to_sym}.each do |class_sym|
      Object.send(:remove_const, class_sym)
    end
  end
end