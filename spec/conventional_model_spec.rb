require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module ConventionalModel
  describe ConventionalModel do
    describe ".configure" do
      describe "with no args" do
        before(:each) do
          @conventions = mock(Conventions)
          Conventions.stub(:new => @conventions)
          
          ConventionalModel.stub(:run_code)
          
          @connection = mock(Column)
          ::ActiveRecord::Base.stub(:connection).and_return(@connection)
          
          @generated_code = mock(String)
          @database = mock(Database, :code => @generated_code)
          Database.stub(:new => @database)
        end
        
        it "creates a database object with the connection and conventions" do
          Database.should_receive(:new).with(@conventions, @connection).and_return(@database)
          ConventionalModel.configure
        end
      
        it "run the generated code" do
          ConventionalModel.should_receive(:run_code).with(@generated_code)
          ConventionalModel.configure
        end
        
        it "passes the block to conventions" do
          ConventionalModel.configure do
            
          end
        end
      end
    end
    
    describe ".run_code" do
      it "evaluates the code (probably using Kernel#eval...)" do
        ConventionalModel.run_code("1 + 1").should == 2
        ConventionalModel.run_code("'banana'.reverse").should == "ananab"
      end
    end
  end  
end
