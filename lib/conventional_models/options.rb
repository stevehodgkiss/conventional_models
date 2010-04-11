module ConventionalModels
  class Options
    attr_accessor :skip_configure, :config, :environment, :verbose, :output_version, :output_help
    
    def initialize
      @skip_configure = false
      @config = "config/database.yml"
      @environment = "development"
      @verbose = false
      @output_version = false
      @output_help = false
    end
    
    
  end
end