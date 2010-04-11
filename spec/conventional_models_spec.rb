require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module ConventionalModels
  describe ConventionalModels do
    before(:each) do
      @conventions = mock(Conventions)
      Conventions.stub(:new => @conventions)
      
      ConventionalModels.stub(:run_code)
      
      @generated_code = mock(String)
      @database = mock(Database, :code => @generated_code)
      @database.stub(:apply_conventions).with(@conventions)
      Database.stub(:new => @database)

      ConventionalModels.stub(:remove)
    end
    
    describe ".configure" do
      describe "with no args" do
        it "creates a database object with the conventions" do
          Database.should_receive(:new).with(@conventions).and_return(@database)
          ConventionalModels.configure
        end
      
        it "run the generated code" do
          ConventionalModels.should_receive(:run_code).with(@generated_code)
          ConventionalModels.configure
        end
      end
      describe "second call" do
        it "should call remove if a database has already been configured" do
          ConventionalModels.should_receive(:remove).with(@database)
          ConventionalModels.configure
          ConventionalModels.configure
        end
      end
    end
    
    describe ".run_code" do
      it "evaluates the code (probably using Kernel#eval...)" do
        ConventionalModels.unstub!(:run_code)
        ConventionalModels.run_code("1 + 1").should == 2
        ConventionalModels.run_code("'banana'.reverse").should == "ananab"
      end
    end
    
    describe ".model_code" do
      it "returns the database code" do
        ConventionalModels.configure
        ConventionalModels.model_code.should == @generated_code
      end
    end
    
    describe ".model_code_for" do
      it "returns the model code for a specific model" do
        @database.should_receive(:code_for).with("Test").and_return("test")
        ConventionalModels.configure
        ConventionalModels.model_code_for("Test").should == "test"
      end
    end
    
    describe ".run_console!" do
      it "starts an IRB session" do
        IRB.should_receive(:start)
        ConventionalModels.should_receive(:configure_active_record)
        ConventionalModels.should_receive(:configure)
        ConventionalModels.run_console!
      end
    end
    
    describe ".remove" do
      before(:each) do
        ConventionalModels.unstub(:remove)
        table = mock(Table, :class_name => "TestTable")
        @database.should_receive(:tables).and_return([table])
        Object.should_receive(:send).with(:remove_const, :TestTable)
      end
      
      it "removes the table constants from the environment" do
        ConventionalModels.remove(@database)
      end
    end
  end  
end
