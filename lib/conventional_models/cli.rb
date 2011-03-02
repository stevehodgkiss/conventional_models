require 'optparse'
require 'ostruct'
require 'date'

module ConventionalModels
  class CLI
    attr_reader :options

    def run(args)
      opts = OptionParser.new
      @options = Options.new
      opts.on('-v', '--version')    { @options.output_version = true }
      opts.on('-h', '--help')       { @options.output_help = opts }
      opts.on('-s', '--skip-configure')    { @options.skip_configure = true }  
      opts.on('-c', '--config FILE')      { |file| @options.config = file }
      opts.on('-e', '--environment ENV')      { |env| @options.environment = env }
      opts.on('-V', '--verbose')      { |env| @options.verbose = true }
      
      begin
        opts.parse!(args)
        return output_version if @options.output_version
        return output_help(@options.output_help) if @options.output_help
        output_options if @options.verbose
        run_console
      rescue
        puts opts
      end
    end
    
    protected
      
      def run_console
        unless File.exists?(@options.config)
          puts "Config #{@options.config} doesn't exist!"
          return
        end
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

      def output_version
        puts "ConventionalModels version #{ConventionalModels::VERSION::STRING}"
      end
      
      def output_help(options)
        puts options
      end
  end
end