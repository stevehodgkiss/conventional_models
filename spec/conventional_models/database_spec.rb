require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module ConventionalModels
  describe Database do
    before(:each) do
      @conventions = mock(Conventions)
      
      @connection = mock(::ActiveRecord::ConnectionAdapters::AbstractAdapter)
      @columns = [mock(Column)]
      
      @connection.stub(:tables).and_return(["Test"])
      @connection.stub(:columns).with("Test").and_return(@columns)
      
      @table = mock(Table)
      @table.stub(:apply_conventions)
      @table.stub(:belongs_to_names).and_return([])
      Table.stub(:new => @table)
    end
    
    describe "#apply_conventions" do
      before(:each) do
        @database = Database.new(@connection)
      end
      
      it "creates a table with the table name and the column definitions" do
        Table.should_receive(:new).with("Test", @columns).and_return(@table)
        @database.apply_conventions(@conventions)
        @database.tables.first.should == @table
      end
      
      it "applies conventions to each table" do
        @table.should_receive(:apply_conventions).with(@conventions)
        @database.apply_conventions(@conventions)
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
          @database.apply_conventions(Conventions.new)
          @database.tables.first.name.should == "sites"
          @database.tables.first.lines.last.should == "has_many :pages, :class_name => 'Page', :primary_key => 'id', :foreign_key => 'site_id'"
        end
      end
    end
    
    describe "#code" do
      it "should return the code for each table" do
        @table.should_receive(:code).and_return("test")
        @database = Database.new(@connection)
        @database.apply_conventions(@conventions)
        @database.code.should == "test"
      end
    end
  end
end