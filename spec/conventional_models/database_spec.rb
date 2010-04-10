require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module ConventionalModels
  describe Database do
    before(:each) do
      @conventions = mock(Conventions)
      
      @connection = mock(::ActiveRecord::ConnectionAdapters::AbstractAdapter)
      @columns = [mock(Column)]
      
      @connection.stub(:tables).and_return(["Test"])
      @connection.should_receive(:columns).with("Test").and_return(@columns)
      
      @table = mock(Table)
      @table.stub(:apply_conventions)
      Table.stub(:new => @table)
    end
    
    describe ".new" do
      it "creates a table with the table name and the column definitions" do
        Table.should_receive(:new).with("Test", @columns).and_return(@table)
        @database = Database.new(@conventions, @connection)
        @database.tables.first.should == @table
      end
      
      it "applies conventions to each table" do
        @table.should_receive(:apply_conventions).with(@conventions)
        @database = Database.new(@conventions, @connection)
      end
    end
    
    describe "#code" do
      it "should return the code for each table" do
        @table.should_receive(:code).and_return("test")
        @database = Database.new(@conventions, @connection)
        @database.code.should == "test"
      end
    end
  end
end