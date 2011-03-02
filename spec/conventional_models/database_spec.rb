require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module ConventionalModels
  describe Database do
    let(:table) { mock(Table, :apply_conventions => nil, :belongs_to_names => [], :name => "Test") }
    let(:config) { mock(Config, :ignored_tables => [], :connection => nil, :module_name => nil) }
    let(:connection) do
      mock(::ActiveRecord::ConnectionAdapters::AbstractAdapter, :tables => ["Test"], :columns => columns)
    end
    let(:columns) { [mock(Column)] }
    
    before do
      ::ActiveRecord::Base.stub(:connection => connection)
      Table.stub(:new => table)
    end
    
    describe ".new" do
      it "creates a table with the table name, column definitions and config" do
        Table.should_receive(:new).with("Test", columns, config).and_return(table)
        Database.new(config).tables.first.should == table
      end
      
      context "has many relationships" do
        
        context "conventional" do
          before(:each) do
            connection.stub(:tables).and_return(["sites", "pages"])

            Table.unstub!(:new)
            @site_columns = [Column.new("name", nil, "string")]
            @pages_columns = [Column.new("site_id", nil, "integer")]
            connection.stub(:columns).with("sites").and_return(@site_columns)
            connection.stub(:columns).with("pages").and_return(@pages_columns)
            @database = Database.new(Config.new)
          end

          it "sets the table name" do
            @database.tables.first.name.should == "sites"
          end
          
          it "sets site to have many pages" do
            @database.tables.first.lines.last.should == "has_many :pages"
            # , :class_name => 'Page', :primary_key => 'id', :foreign_key => 'site_id'
          end
        end

        context "unconventional" do
          before(:each) do
            connection.stub(:tables).and_return(["Site", "Page"])
            Table.unstub!(:new)
            @site_columns = [Column.new("Name", nil, "string")]
            @pages_columns = [Column.new("Site_id", nil, "integer")]
            connection.stub(:columns).with("Site").and_return(@site_columns)
            connection.stub(:columns).with("Page").and_return(@pages_columns)
            @database = Database.new(Config.new{ primary_key_name "ID" })
          end

          it "sets the table name" do
            @database.tables.first.name.should == "Site"
          end
          
          it "sets site to have many pages" do
            @database.tables.first.lines.last.should == "has_many :pages, :class_name => 'Page', :foreign_key => 'Site_id', :primary_key => 'ID'"
          end
        end
        
      end
      
      it "ignores tables" do
        config = Config.new do
          ignore_tables "Test"
        end
        table.should_not_receive(:apply_conventions)
        @database = Database.new(config)
      end
    end

    describe "code outputting" do
      before(:each) do
        table.stub(:name).and_return("Test")
      end
      describe "#code" do
        it "should return the code for each table" do
          table.should_receive(:code).and_return("test")
          @database = Database.new(config)
          @database.code.should == "test"
        end
      end
    
      describe "#code_for" do
        it "should return the model code for a specific table" do
          table.should_receive(:code).and_return("test")
          @database = Database.new(config)
          @database.code_for("Test").should == "test"
        end
        it "should return not found for unknown tables" do
        @database = Database.new(config)
          @database.code_for("SomeTable").should == "SomeTable not found"
        end
      end
    end
  end
end