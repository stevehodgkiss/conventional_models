require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module ConventionalModels
  describe CLI do
    before(:each) do
      @args = []
      @options = Options.new
      @option_parser = mock(OptionParser, :options => @options)
      OptionParser.stub(:new).and_return(@option_parser)
    end
    
    it "should create a new option parser with args" do
      OptionParser.should_receive(:new).with(@args)
      CLI.new(@args)
    end
    
    describe "run" do
      before(:each) do
        @stdout_orig = $stdout
        $stdout = StringIO.new
      end
      after(:each) do
        $stdout = @stdout_orig
      end
      
      def run
        @cli = CLI.new(@args)
        @cli.run
      end
      
      describe "with parsed options" do
        before(:each) do
          @option_parser.stub(:parsed_options?).and_return(true)
          ConventionalModels.stub(:configure)
          ConventionalModels.stub(:model_code)
          ConventionalModels.stub(:configure_active_record)
          IRB.stub(:start)
        end
        
        it "configures activerecord with config and environment options" do
          ConventionalModels.should_receive(:configure_active_record).with(@options.config, @options.environment)
          run
        end
        
        it "calls configure" do
          ConventionalModels.should_receive(:configure)
          run
        end
        
        it "puts the model code" do
          ConventionalModels.should_receive(:model_code).and_return("TEST")
          run
          $stdout.string.should == "TEST\n"
        end
        
        it "start IRB" do
          IRB.should_receive(:start)
          run
        end
        
        describe "with skip-configure option" do
          it "does not call configure" do
            @options.skip_configure = true
            ConventionalModels.should_not_receive(:configure)
            run
          end
        end
        
        describe "with help option" do
          it "outputs help" do
            RDoc.should_receive(:usage)
            @options.output_help = true
            ConventionalModels.should_not_receive(:configure_active_record)
            run
          end
        end
        
        describe "with output version option" do
          it "outputs the version" do
            @options.output_version = true
            ConventionalModels.should_not_receive(:configure_active_record)
            run
            $stdout.string.should =~ /#{VERSION}/
          end
        end
      end
      
      describe "with invalid options" do
        it "prints usage" do
          RDoc.should_receive(:usage).with('usage')
          @option_parser.stub(:parsed_options?).and_return(false)
          run
        end
      end
    end
  end
end