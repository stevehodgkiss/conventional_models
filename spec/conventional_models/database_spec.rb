require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module ConventionalModels
  describe Database do
    before(:each) do
      @conventions = mock(Conventions)
      @conventions.stub(:ignored_tables).and_return([])
      
      @connection = mock(::ActiveRecord::ConnectionAdapters::AbstractAdapter)
      @columns = [mock(Column)]
      
      ::ActiveRecord::Base.stub(:connection).and_return(@connection)
      
      @connection.stub(:tables).and_return(["Test"])
      @connection.stub(:columns).with("Test").and_return(@columns)
      
      @table = mock(Table)
      @table.stub(:apply_conventions)
      @table.stub(:belongs_to_names).and_return([])
      @table.stub(:name).and_return("Test")
      Table.stub(:new => @table)
    end
    
    describe ".new" do
      it "creates a table with the table name, column definitions and conventions" do
        Table.should_receive(:new).with("Test", @columns, @conventions).and_return(@table)
        @database = Database.new(@conventions)
        @database.tables.first.should == @table
      end
      
      describe "has many relationships" do
        before(:each) do
          @connection.stub(:tables).and_return(["sites", "pages"])
          
          Table.unstub!(:new)
          @site_columns = [Column.new("name", nil, "string")]
          @pages_columns = [Column.new("site_id", nil, "integer")]
          
          @connection.stub(:columns).with("sites").and_return(@site_columns)
          @connection.stub(:columns).with("pages").and_return(@pages_columns)
        end
        
        it "sets site to have many pages" do
          @database = Database.new(Conventions.new)
          @database.tables.first.name.should == "sites"
          @database.tables.first.lines.last.should == "has_many :pages, :class_name => 'Page', :primary_key => 'id', :foreign_key => 'site_id'"
        end
      end
      
      it "ignores tables" do
        @conventions = Conventions.new do
          ignore_tables "Test"
        end
        @table.should_not_receive(:apply_conventions)
        @database = Database.new(@conventions)
      end
    end

    describe "code outputting" do
      before(:each) do
        @table.stub(:name).and_return("Test")
      end
      describe "#code" do
        it "should return the code for each table" do
          @table.should_receive(:code).and_return("test")
          @database = Database.new(@conventions)
          @database.code.should == "test"
        end
      end
    
      describe "#code_for" do
        it "should return the model code for a specific table" do
          @table.should_receive(:code).and_return("test")
          @database = Database.new(@conventions)
          @database.code_for("Test").should == "test"
        end
        it "should return not found for unknown tables" do
        @database = Database.new(@conventions)
          @database.code_for("SomeTable").should == "SomeTable not found"
        end
      end
    end
  end
end