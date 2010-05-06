require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module ConventionalModels 
  describe Config do
    it "should set ignored tables" do
      config = Config.new do
        ignore_tables "slc", "abc"
      end
      config.ignored_tables.should == ["slc", "abc"]
    end
  
    it "should set primary key name" do
      config = Config.new do
        primary_key_name "Id"
      end
      config.primary_key_name.should == "Id"
    end
  
    it "should set belongs to matcher" do
      config = Config.new do
        belongs_to_matcher do |column|
          true
        end
      end
      config.belongs_to_matcher.call("test_id").should be_true
    end
  
    it "should set belongs to name" do
      config = Config.new do
        belongs_to_name do |column|
          column
        end
      end
      config.belongs_to_name.call("test").should == "test"
    end
    
    it "should set class name" do
      config = Config.new do
        class_name do |column|
          "test"
        end
      end
      config.class_name.call("").should == "test"
    end
    
    it "should set connection" do
      config = Config.new do
        connection :adapter => 'sqlite3'
      end
      config.connection[:adapter].should == 'sqlite3'
    end
    
    it "should set module name" do
      config = Config.new do
        module_name "test"
      end
      config.module_name.should == "test"
    end
  
    it "should have default settings" do
      @site_id_column = Column.new("site_id", nil, "integer")
      
      config = Config.new
      config.belongs_to_name.call(@site_id_column).should == "site"
      config.belongs_to_matcher.call(@site_id_column).should be_true
      config.primary_key_name.should == "id"
      config.class_name.call("pages").should == "Page"
      config.class_name.call("page").should == "Page"
      config.ignored_tables.should == %w{schema_migrations sqlite_sequence sysdiagrams}
    end
  end
end