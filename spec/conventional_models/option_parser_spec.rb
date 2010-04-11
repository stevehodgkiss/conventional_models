require 'spec_helper'

module ConventionalModels
  describe OptionParser do
    def options_for(args)
      @option_parser = OptionParser.new(args)
      @option_parser.options
    end
    
    describe "parsing" do
      it "accepts a database config file" do
        options_for(["-c", "config/db.yml"]).config.should == "config/db.yml"
        options_for(["--config", "config/db.yml"]).config.should == "config/db.yml"
      end
      
      it "accepts an environment flag" do
        options_for(["-e", "production"]).environment.should == "production"
        options_for(["--environment", "production"]).environment.should == "production"
      end
      
      it "accepts a skip configure flag" do
        options_for(["-s"]).skip_configure.should == true
        options_for(["--skip-configure"]).skip_configure.should == true
      end
      
      it "accepts an output version flag" do
        options_for(["-v"]).output_version.should == true
        options_for(["--version"]).output_version.should == true
      end
      
      it "accepts an output help flag" do
        options_for(["-h"]).output_help.should == true
        options_for(["--help"]).output_help.should == true
      end
    end
    
    describe "invalid arguments" do
      it "should set parsed_options? to false" do
        options_for(["--boobs"])
        @option_parser.parsed_options?.should == false
      end
    end
  end
end
