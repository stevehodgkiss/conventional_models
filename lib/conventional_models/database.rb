require 'active_support/core_ext/string/inflections'

module ConventionalModels
  class Database
    attr_accessor :tables
    
    def initialize(conventions)
      @connection = ::ActiveRecord::Base.connection
      @conventions = conventions
      @tables = []
      apply_conventions
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
    
    protected
      def apply_conventions
        @connection.tables.select{|table| !@conventions.ignored_tables.include? table}.each do |table|
          @tables << Table.new(table, @connection.columns(table), @conventions)
        end

        @tables.each do |table|
          table.belongs_to_names.each do |belongs_to|
            name = @conventions.belongs_to_name.call(belongs_to)
            has_many_table = @tables.select{|t| t.class_name == @conventions.class_name.call(name)}.first
            if has_many_table
              unconventions = []
              unless table.conventional_name?
                unconventions << ":class_name => '#{table.class_name}'"
                unconventions << ":foreign_key => '#{belongs_to.name}'"
              end
              unless @conventions.primary_key_name == "id"
                unconventions << ":primary_key => '#{@conventions.primary_key_name}'"
              end
              
              has_many_table.lines << ["has_many :#{table.name.tableize}", "#{unconventions.join(", ")}"].select do |convention|
                !convention.empty?
              end.join(", ")
            end
          end
        end
      end
  end
end
