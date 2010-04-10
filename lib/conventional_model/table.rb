module ConventionalModel
  class Table
    attr_accessor :name, :columns, :lines
    
    def initialize(name, columns)
      @name = name
      @columns = columns
      @lines = []
    end
    
    def ==(other)
      @name == other.name
    end
    
    def apply_conventions(conventions)
      table_name = conventions.table_name.call(name)
      @lines << "set_table_name \"#{table_name}\""
    end
    
    def code
      "class ::#{@name.singularize.camelize} < ::ActiveRecord::Base\n#{@lines.join('\n')}\nend"
    end
  end
end