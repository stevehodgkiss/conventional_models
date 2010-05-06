require 'active_support/core_ext/string/inflections'

module ConventionalModels
  class Database
    attr_accessor :tables
    
    def initialize(config)
      if config.connection.nil?
        @connection = ::ActiveRecord::Base.connection
      else
        base_class_code = []
        base_class_code << "module ::#{config.module_name}"
        base_class_code << "  class Base < ActiveRecord::Base;"
        base_class_code << "  end;"
        base_class_code << "end"
        eval base_class_code.join
        @base_class = "::#{config.module_name}::Base".constantize
        @base_class.class_eval do
          establish_connection config.connection
        end
        @connection = @base_class.connection
      end
      @config = config
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
        @connection.tables.select{|table| !@config.ignored_tables.include? table}.each do |table|
          @tables << Table.new(table, @connection.columns(table), @config)
        end

        @tables.each do |table|
          table.belongs_to_names.each do |belongs_to|
            name = @config.belongs_to_name.call(belongs_to)
            has_many_table = @tables.select{|t| t.class_name == @config.class_name.call(name)}.first
            if has_many_table
              unconventions = []
              unless table.conventional_name?
                unconventions << ":class_name => '#{table.class_name}'"
                unconventions << ":foreign_key => '#{belongs_to.name}'"
              end
              unless @config.primary_key_name == "id"
                unconventions << ":primary_key => '#{@config.primary_key_name}'"
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
