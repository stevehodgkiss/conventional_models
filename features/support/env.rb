$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')
require 'conventional_models'

require 'spec/expectations'

require 'aruba'
require 'active_record'

Before do
  config = {
    "development" => {
      "database" => 'tmp/aruba/test.sqlite',
      "adapter" => 'sqlite3'
    }
  }
  
  ActiveRecord::Base.configurations = config
  
  system "mkdir -p tmp"
  system "mkdir -p tmp/aruba"
  system 'rm -f tmp/aruba/test.sqlite'
  ActiveRecord::Base.establish_connection(config["development"])
end