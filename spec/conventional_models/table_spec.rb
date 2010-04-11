require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module ConventionalModels
  describe Table do
    before(:each) do
      @columns = [mock(Column, :name => "test")]
      @conventions = Conventions.new
    end
    
    describe ".new" do
      it "sets the name" do
        Table.new("test", @columns, @conventions).name.should == "test"
      end
      
      it "sets the columns" do
        Table.new("test", @columns, @conventions).columns.should == @columns
      end
    end
    
    describe "#==" do
      it "is true for tables with the same name" do
        Table.new("Page", @columns, @conventions).should == Table.new("Page", @columns, @conventions)
      end
      
      it "is false for tables with different names" do
        Table.new("Page", @columns, @conventions).should_not == Table.new("Bar", @columns, @conventions)
      end
    end
    
    describe "#apply_conventions" do
      it "sets the primary key" do
        @conventions = Conventions.new do
          primary_key_name "ID"
        end
        @table = Table.new("Page", @columns, @conventions)
        @table.lines[0].should == "set_primary_key \"ID\""
      end
      
      it "sets the class name" do
        @conventions = Conventions.new do
          class_name do |table|
            "BOO"
          end
        end
        @table = Table.new("Page", @columns, @conventions)
        @table.class_name.should == "BOO"
      end
      
      it "sets belongs to columns" do
        @conventions = Conventions.new
        @columns = [Column.new("Site_id", nil, "integer")]
        @table = Table.new("Page", @columns, @conventions)
        @table.lines[2].should == "belongs_to :site, :class_name => 'Site'"
        @table.belongs_to_names.first.name.should == "Site_id"
      end
      
    end
    
    describe "#code" do
      before(:each) do
        @table = Table.new("pages", @columns, @conventions)
      end
      
      it "returns an activerecord class" do
        @model_code = @table.code
        @model_code.starts_with?(%Q{class ::Page < ::ActiveRecord::Base}).should be_true
      end
      
      it "returns lines in the model definition" do
        @table.lines << "test"
        @model_code = @table.code
        @model_code.split("\n")[3].should == "  test"
      end
    end
  end
end