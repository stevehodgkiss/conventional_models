require 'optparse'
require 'rdoc/usage'
require 'ostruct'
require 'date'

module ConventionalModels
  class CLI
    attr_reader :options

    def initialize(arguments)
      @arguments = arguments
      @option_parser = OptionParser.new(arguments)
      @options = @option_parser.options
    end
    
    def run
      if @option_parser.parsed_options?
        return output_help if @options.output_help
        return output_version if @options.output_version
        output_options if @options.verbose
        run_console
      else
        output_usage
      end
    end
    
    protected
      
      def run_console
        ConventionalModels.configure_active_record(@options.config, @options.environment)
        ConventionalModels.configure unless @options.skip_configure
        puts ConventionalModels.model_code
        IRB.start
      end
      
      def output_options
        puts "Options:\n"
      
        @options.marshal_dump.each do |name, val|
          puts "  #{name} = #{val}"
        end
      end
    
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