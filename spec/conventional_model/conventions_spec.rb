require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
 
describe ConventionalModel::Conventions do
  it "should set ignored tables" do
    config = ConventionalModel::Conventions.new do
      ignore_tables "slc", "abc"
    end
    config.ignored_tables.should == ["slc", "abc"]
  end
  
  it "should set primary key name" do
    config = ConventionalModel::Conventions.new do
      primary_key_name "Id"
    end
    config.primary_key_name.should == "Id"
  end
  
  it "should set table name" do
    config = ConventionalModel::Conventions.new do
      table_name do |table_name|
        table_name
      end
    end
    config.table_name.call("test").should == "test"
  end
  
  it "should set belongs to matcher" do
    config = ConventionalModel::Conventions.new do
      belongs_to_matcher do |column|
        column.end_with? "_id"
      end
    end
    config.belongs_to_matcher.call("test").should be_false
    config.belongs_to_matcher.call("test_id").should be_true
  end
  
  it "should set belongs to name" do
    config = ConventionalModel::Conventions.new do
      belongs_to_name do |column|
        column
      end
    end
    config.belongs_to_name.call("test").should == "test"
  end
  
  it "should have default settings" do
    config = ConventionalModel::Conventions.new
    config.belongs_to_name.call("Site_id").should == "Site"
    config.belongs_to_matcher.call("Site_id").should be_true
    config.primary_key_name.should == "Id"
  end
end