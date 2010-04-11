require 'optparse'
require 'rdoc/usage'
require 'ostruct'
require 'date'

module ConventionalModels
  class OptionParser
  
    attr_reader :options

    def initialize(arguments)
      @arguments = arguments
      
      @options = Options.new

      @parsed_options = true
      parse
    end
  
    def parsed_options?
      @parsed_options
    end
    
    def parse
      opts = ::OptionParser.new
      opts.on('-v', '--version')    { @options.output_version = true }
      opts.on('-h', '--help')       { @options.output_help = true }
      opts.on('-s', '--skip-configure')    { @options.skip_configure = true }  
      opts.on('-c', '--config FILE')      { |file| @options.config = file }
      opts.on('-e', '--environment ENV')      { |env| @options.environment = env }
      opts.on('-V', '--verbose')      { |env| @options.verbose = true }
      
      opts.parse!(@arguments) rescue @parsed_options = false
    end
      
    protected
      def output_help
        output_version
        RDoc::usage()
      end
    
      def output_usage
        RDoc::usage('usage')
      end
    
      def output_version
        puts "ConventionalModels version #{ConventionalModels::VERSION}"
      end
  end
end