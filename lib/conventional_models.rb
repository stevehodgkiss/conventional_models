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
require 'irb'
require 'irb/completion'

module ConventionalModels
  @@database = nil
  @@model_code = []
  
  def self.configure(config=nil, &block)
    @@config = Config.new(&block)
    @@database = Database.new(@@config)
    code = @@database.code
    run_code code 
    @@model_code << code
  end
  
  def self.run_code(code)
    eval code
  end
  
  def self.model_code
    @@model_code.join("\n")
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
end