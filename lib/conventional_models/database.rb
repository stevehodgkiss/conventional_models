require 'active_support/core_ext/string/inflections'

module ConventionalModels
  class Database
    attr_accessor :tables
    
    def initialize(connection)
      @connection = connection
      @tables = []
    end
    
    def apply_conventions(conventions)
      @connection.tables.select{|table| !conventions.ignored_tables.include? table}.each do |table|
        @tables << Table.new(table, @connection.columns(table))
      end
      
      @tables.each{|table| table.apply_conventions(conventions)}
      
      @tables.each do |table|
        table.belongs_to_names.each do |belongs_to|
          name = conventions.belongs_to_name.call(belongs_to)
          has_many_table = @tables.select{|t| t.class_name == conventions.class_name.call(name)}.first
          if has_many_table
            has_many_table.lines << "has_many :#{table.name.tableize}, :class_name => '#{table.class_name}', :primary_key => '#{conventions.primary_key_name}', :foreign_key => '#{belongs_to.name}'"
          end
        end
      end
    end
    
    def code
      @tables.map{|t| t.code}.join("\n")
    end
    
    def code_for(table_name)
      table = @tables.select{|t| t.name == table_name}.first
      if table
        table.code
      else
        "#{table_name} not found"
      end
    end
  end
end
