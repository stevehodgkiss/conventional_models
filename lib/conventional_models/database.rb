module ConventionalModels
  class Database
    attr_accessor :tables
    
    def initialize(connection)
      @connection = connection
      @tables = []
    end
    
    def apply_conventions(conventions)
      @connection.tables.each do |table|
        @tables << Table.new(table, @connection.columns(table))
      end
      
      @tables.each{|table| table.apply_conventions(conventions)}
    end
    
    def code
      @tables.map{|t| t.code}.join("\n")
    end
  end
end
