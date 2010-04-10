module ConventionalModels
  class Database
    attr_accessor :tables
    
    def initialize(conventions, connection)
      @conventions = conventions
      @connection = connection
      @tables = []
      connection.tables.each do |table|
        @tables << Table.new(table, connection.columns(table))
      end
      @tables.each{|table| table.apply_conventions(@conventions)}
    end
    
    def code
      @tables.map{|t| t.code}.join("\n")
    end
  end
end
