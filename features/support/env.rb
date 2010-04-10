$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')
require 'conventional_model'

require 'spec/expectations'

require 'aruba'
require 'active_record'

Before do
  config = {
    :development => {
      :database => 'tmp/test.sqlite',
      :adapter => 'sqlite3'
    }
  }
  
  ActiveRecord::Base.configurations = config
  
  system "mkdir -p tmp"
  system 'rm -f tmp/test.sqlite'
  ActiveRecord::Base.establish_connection(config[:development])
end