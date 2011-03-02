require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module ConventionalModels
  describe CLI do
    before(:each) do
      @args = []
      @options = Options.new
      File.stub(:exists?).with(@options.config).and_return(true)
    end
    
    
    describe "run" do
      before(:each) do
        @stdout_orig = $stdout
        $stdout = StringIO.new
      end
      after(:each) do
        $stdout = @stdout_orig
      end
      
      def run(args = [])
        @cli = CLI.new(@args)
        @cli.run(Array.wrap(args))
      end
      
      context "with parsed options" do
        before(:each) do
          ConventionalModels.stub(:configure)
          ConventionalModels.stub(:model_code)
          ConventionalModels.stub(:configure_active_record)
          IRB.stub(:start)
        end
        
        it "configures activerecord with config and environment options" do
          ConventionalModels.should_receive(:configure_active_record).with(@options.config, @options.environment)
          run
        end
        
        context "when config doesnt exist" do
          before(:each) do
            File.stub(:exists?).with(@options.config).and_return(false)
          end
          
          it "complains" do
            run
            $stdout.string.should include("doesn't exist")
          end
          
          it "does not call configure_active_record" do
            run
            ConventionalModels.should_not_receive(:configure_active_record)
          end
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
        
        context "with skip-configure option" do
          it "does not call configure" do
            ConventionalModels.should_not_receive(:configure)
            run("-s")
          end
        end
        
        context "with help option" do
          it "outputs help" do
            ConventionalModels.should_not_receive(:configure_active_record)
            run("-h")
          end
        end
        
        context "with output version option" do
          it "outputs the version" do
            ConventionalModels.should_not_receive(:configure_active_record)
            run("-v")
            $stdout.string.should =~ /#{VERSION::STRING}/
          end
        end
      end
      
      context "with invalid options" do
        it "prints usage" do
          run("-d invalid")
          $stdout.string.should =~ /Usage:/
        end
      end
    end
  end
end