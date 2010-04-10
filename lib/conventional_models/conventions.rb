module ConventionalModels
  class Conventions
    def initialize(&block)
      builder = Builder.new(self)
      builder.instance_eval(&block) if block
    end
    
    attr_accessor :ignored_tables, :primary_key_name, :class_name,
                  :belongs_to_matcher, :belongs_to_name
    
    class Builder
      def initialize(config)
        @config = config
        belongs_to_matcher {|column| column.name.end_with? "_id"}
        belongs_to_name {|column| column.name.gsub(/_id$/, "")}
        primary_key_name "id"
        table_name {|table_name| table_name.pluralize}
        class_name {|table_name| table_name.singularize.camelize}
        ignore_tables "schema_migrations", "sqlite_sequence", "sysdiagrams"
      end
      
      def ignore_tables(*tables)
        @config.ignored_tables = tables.map{|t|t.to_s}
      end
      
      def primary_key_name(name)
        @config.primary_key_name = name
      end
      
      def belongs_to_matcher(&block)
        @config.belongs_to_matcher = block
      end
      
      def belongs_to_name(&block)
        @config.belongs_to_name = block
      end
      
      def class_name(&block)
        @config.class_name = block
      end
    end
  end
  
end