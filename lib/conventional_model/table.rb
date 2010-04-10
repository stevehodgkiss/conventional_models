module ConventionalModel
  class Table
    attr_accessor :name, :columns
    
    def initialize(name, columns)
      @name = name
      @columns = columns
    end
    
    def ==(other)
      @name == other.name
    end
    
    def code
      "class ::#{@name.singularize.camelize} < ::ActiveRecord::Base\nend"
    end
  end
end