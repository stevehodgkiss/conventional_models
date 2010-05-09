require 'spec_helper'

module ConventionalModels
  describe Options do
    before do
      @options = Options.new
    end
    
    context "default options" do
      it "should use rails location for default database.yml" do
        @options.config.should == "config/database.yml"
      end

      it "should configure" do
        @options.skip_configure.should be_false
      end
      
      it "should default to development environment" do
        @options.environment.should == "development"
      end
      
      it "should not be verbose" do
        @options.verbose.should be_false
      end
      
      it "should not output version" do
        @options.output_version.should be_false
      end
      
      it "should not output help" do
        @options.output_help.should be_false
      end
    end
  end
end