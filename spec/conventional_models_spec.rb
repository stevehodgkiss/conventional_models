require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module ConventionalModels
  describe ConventionalModels do
    describe ".configure" do
      describe "with no args" do
        before(:each) do
          @conventions = mock(Conventions)
          Conventions.stub(:new => @conventions)
          
          ConventionalModels.stub(:run_code)
          
          @connection = mock(Column)
          ::ActiveRecord::Base.stub(:connection).and_return(@connection)
          
          @generated_code = mock(String)
          @database = mock(Database, :code => @generated_code)
          @database.stub(:apply_conventions).with(@conventions)
          Database.stub(:new => @database)
        end
        
        it "creates a database object with the connection and conventions" do
          Database.should_receive(:new).with(@connection).and_return(@database)
          ConventionalModels.configure
        end
        
        it "called apply_conventions on the database object" do
          @database.should_receive(:apply_conventions).with(@conventions)
          ConventionalModels.configure
        end
      
        it "run the generated code" do
          ConventionalModels.should_receive(:run_code).with(@generated_code)
          ConventionalModels.configure
        end
        
        it "passes the block to conventions" do
          ConventionalModels.configure do
            
          end
        end
      end
    end
    
    describe ".run_code" do
      it "evaluates the code (probably using Kernel#eval...)" do
        ConventionalModels.run_code("1 + 1").should == 2
        ConventionalModels.run_code("'banana'.reverse").should == "ananab"
      end
    end
  end  
end
