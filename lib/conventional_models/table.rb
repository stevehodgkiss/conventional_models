module ConventionalModels
  class Table
    attr_accessor :name, :columns, :lines, :belongs_to_names, :class_name
    
    def initialize(name, columns, conventions)
      @name = name
      @columns = columns
      @lines = []
      @belongs_to_names = []
      @config = conventions
      
      apply_conventions
    end
    
    def ==(other)
      @name == other.name
    end
    
    def code
      "class ::#{@name.singularize.camelize} < ::ActiveRecord::Base\n#{@lines.map{|l| "  #{l}"}.join("\n")}\nend"
    end
    
    def conventional_name?
      @name.tableize == @name
    end
    
    protected
    
      def apply_conventions
        @class_name = @config.class_name.call(@name)
      
        @lines << "set_primary_key \"#{@config.primary_key_name}\"" unless @config.primary_key_name == "id"
      
        @lines << "set_table_name \"#{@name}\"" unless @name.tableize == @name
      
        @columns.each do |column|
          if @config.belongs_to_matcher.call(column)
            name = @config.belongs_to_name.call(column)
            @belongs_to_names << column
            @lines << "belongs_to :#{name.underscore}, :class_name => '#{@config.class_name.call(name)}'"
          end
        end
      end
  end
end