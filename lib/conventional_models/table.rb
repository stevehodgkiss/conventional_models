module ConventionalModels
  class Table
    attr_accessor :name, :columns, :lines, :belongs_to_names, :class_name
    
    def initialize(name, columns)
      @name = name
      @columns = columns
      @lines = []
      @belongs_to_names = []
    end
    
    def ==(other)
      @name == other.name
    end
    
    def apply_conventions(conventions)
      @class_name = conventions.class_name.call(@name)
      
      @lines << "set_primary_key \"#{conventions.primary_key_name}\""
      
      table_name = conventions.table_name.call(name)
      @lines << "set_table_name \"#{table_name}\""
      
      @columns.each do |column|
        if conventions.belongs_to_matcher.call(column)
          name = conventions.belongs_to_name.call(column)
          @belongs_to_names << column
          @lines << "belongs_to :#{name.underscore}, :class_name => '#{conventions.class_name.call(name)}'"
        end
      end
    end
    
    def code
      "class ::#{@name.singularize.camelize} < ::ActiveRecord::Base\n#{@lines.map{|l| "  #{l}"}.join("\n")}\nend"
    end
  end
end