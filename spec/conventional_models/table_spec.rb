require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module ConventionalModels
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
      it "sets the primary key" do
        @conventions = Conventions.new do
          primary_key_name "ID"
        end
        @table = Table.new("Page", @columns)
        @table.apply_conventions(@conventions)
        @table.lines[0].should == "set_primary_key \"ID\""
      end
      
      it "sets the class name" do
        @conventions = Conventions.new do
          class_name do |table|
            "BOO"
          end
        end
        @table = Table.new("Page", @columns)
        @table.apply_conventions(@conventions)
        @table.class_name.should == "BOO"
      end
      
      it "sets belongs to columns" do
        @conventions = Conventions.new
        @columns = [Column.new("Site_id", nil, "integer")]
        @table = Table.new("Page", @columns)
        @table.apply_conventions(@conventions)
        @table.lines[2].should == "belongs_to :site, :class_name => 'Site'"
        @table.belongs_to_names.first.name.should == "Site_id"
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
        @model_code.split("\n")[1].should == "  test"
      end
    end
  end
end