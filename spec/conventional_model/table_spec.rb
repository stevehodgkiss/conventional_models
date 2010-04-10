require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module ConventionalModel
  describe Table do
    before(:each) do
      @columns = [mock(::ActiveRecord::ConnectionAdapters::Column)]
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
      
    end
    
    describe "#code" do
      it "returns an empty activerecord class with no columns" do
        @model_code = Table.new("pages", []).code
        @model_code.should == %Q{class ::Page < ::ActiveRecord::Base\nend}
      end
    end
  end
end