require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module ConventionalModels
  describe Table do
    let(:columns) { [mock(Column, :name => "test")] }
    let(:config) { Config.new }
    
    def has_item?(array, expected)
      @found = false
      array.each do |line|
        @found = true if line == expected
      end
      @found
    end
    
    describe ".new" do
      it "sets the name" do
        Table.new("test", columns, config).name.should == "test"
      end
      
      it "sets the columns" do
        Table.new("test", columns, config).columns.should == columns
      end
    end
    
    describe "#==" do
      it "is true for tables with the same name" do
        Table.new("Page", columns, config).should == Table.new("Page", columns, config)
      end
      
      it "is false for tables with different names" do
        Table.new("Page", columns, config).should_not == Table.new("Bar", columns, config)
      end
    end
    
    describe "#conventional_name?" do
      it "is true for tables that have a name that matches rails conventions" do
        Table.new("Page", columns, config).conventional_name?.should be_false
        Table.new("pages", columns, config).conventional_name?.should be_true
      end
    end
    
    describe ".new" do
      it "sets the primary key" do
        config = Config.new do
          primary_key_name "ID"
        end
        @table = Table.new("Page", columns, config)
        has_item?(@table.lines, "set_primary_key \"ID\"").should be_true
      end
      
      it "doesn't set the primary key when it is the rails default" do
        @table = Table.new("Page", columns, config)
        has_item?(@table.lines, "set_primary_key \"id\"").should_not == be_true
      end
      
      it "sets the table name" do
        @table = Table.new("Page", columns, config)
        has_item?(@table.lines, "set_table_name \"Page\"").should be_true
      end
      
      it "doesn't set the table name if it is the rails default" do
        @table = Table.new("pages", columns, config)
        has_item?(@table.lines, "set_table_name \"pages\"").should be_false
      end
      
      it "sets the class name" do
        config = Config.new do
          class_name do |table|
            "BOO"
          end
        end
        @table = Table.new("Page", columns, config)
        @table.class_name.should == "BOO"
      end
      
      it "sets belongs to columns" do
        config = Config.new
        columns = [Column.new("Site_id", nil, "integer")]
        @table = Table.new("Page", columns, config)
        has_item?(@table.lines, "belongs_to :site, :class_name => 'Site'").should be_true
        @table.belongs_to_names.first.name.should == "Site_id"
      end
      
    end
    
    describe "#code" do
      before(:each) do
        @table = Table.new("pages", columns, config)
      end
      
      it "returns an activerecord class" do
        @model_code = @table.code
        @model_code.starts_with?(%Q{class ::Page < ::ActiveRecord::Base}).should be_true
      end
      
      it "returns lines in the model definition" do
        @table.lines << "test"
        @model_code = @table.code
        has_item?(@model_code.split("\n"), "  test").should be_true
      end
    end
  end
end