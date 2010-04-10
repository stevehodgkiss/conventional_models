require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module ConventionalModels 
  describe Conventions do
    it "should set ignored tables" do
      config = Conventions.new do
        ignore_tables "slc", "abc"
      end
      config.ignored_tables.should == ["slc", "abc"]
    end
  
    it "should set primary key name" do
      config = Conventions.new do
        primary_key_name "Id"
      end
      config.primary_key_name.should == "Id"
    end
  
    it "should set table name" do
      config = Conventions.new do
        table_name do |table_name|
          table_name
        end
      end
      config.table_name.call("test").should == "test"
    end
  
    it "should set belongs to matcher" do
      config = Conventions.new do
        belongs_to_matcher do |column|
          true
        end
      end
      config.belongs_to_matcher.call("test_id").should be_true
    end
  
    it "should set belongs to name" do
      config = Conventions.new do
        belongs_to_name do |column|
          column
        end
      end
      config.belongs_to_name.call("test").should == "test"
    end
  
    it "should have default settings" do
      @site_id_column = Column.new("site_id", nil, "integer")
      
      config = Conventions.new
      config.belongs_to_name.call(@site_id_column).should == "site"
      config.belongs_to_matcher.call(@site_id_column).should be_true
      config.primary_key_name.should == "id"
      config.table_name.call("pages").should == "pages"
    end
  end
end