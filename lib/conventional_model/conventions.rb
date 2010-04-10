module ConventionalModel
  class Conventions
    def initialize(&block)
      builder = Builder.new(self)
      builder.instance_eval(&block) if block
    end
    
    attr_accessor :ignored_tables, :primary_key_name, 
                  :table_name, :belongs_to_matcher, :belongs_to_name
    
    class Builder
      def initialize(config)
        @config = config
        belongs_to_matcher {|column| column.end_with? "_id"}
        belongs_to_name {|column| column.gsub(/_id$/, "")}
        primary_key_name "id"
        table_name {|table_name| table_name}
      end
      
      def ignore_tables(*tables)
        @config.ignored_tables = tables.map{|t|t.to_s}
      end
      
      def primary_key_name(name)
        @config.primary_key_name = name
      end
      
      def table_name(&block)
        @config.table_name = block
      end
      
      def belongs_to_matcher(&block)
        @config.belongs_to_matcher = block
      end
      
      def belongs_to_name(&block)
        @config.belongs_to_name = block
      end
    end
  end
  
end