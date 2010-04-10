require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module ConventionalModel
  describe Table do
    before(:each) do
      @columns = [mock(Column, :name => "test")]
    end
    
    describe ".new" do
      it "sets the name" do
        Table.new("test", @columns).name.should == "test"
      end
      
      it "sets the columns" do
        Table.new("test", @columns).columns.should == @columns
      end
    end
    
    describe "#==" do
      it "is true for tables with the same name" do
        Table.new("Page", @columns).should == Table.new("Page", @columns)
      end
      
      it "is false for tables with different names" do
        Table.new("Page", @columns).should_not == Table.new("Bar", @columns)
      end
    end
    
    describe "#apply_conventions" do
      describe "table_name" do
        it "sets the table name" do
          @conventions = Conventions.new do
            table_name do |table|
              "Test"
            end
          end
          @table = Table.new("Page", @columns)
          @table.apply_conventions(@conventions)
          @table.lines.first.should == "set_table_name \"Test\""
        end
      end
      
      it "sets belongs to columns" do
        @conventions = Conventions.new
        @columns = [Column.new("site_id", nil, "integer")]
        @table = Table.new("Page", @columns)
        @table.apply_conventions(@conventions)
        @table.lines[1].should == "belongs_to :site"
      end
    end
    
    describe "#code" do
      before(:each) do
        @table = Table.new("pages", @columns)
      end
      
      it "returns an empty activerecord class with no columns" do
        @model_code = @table.code
        @model_code.should == %Q{class ::Page < ::ActiveRecord::Base\n\nend}
      end
      
      it "returns lines in the model definition" do
        @table.lines << "test"
        @model_code = @table.code
        @model_code.split("\n")[1].should == "test"
      end
    end
  end
end