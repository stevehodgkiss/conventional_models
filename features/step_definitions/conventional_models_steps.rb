Given /^a table "([^\"]*)"$/ do |name|
  ActiveRecord::Base.connection.execute "CREATE TABLE \"#{name}\" (\"id\" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL)"
end

Given /^a table "([^\"]*)" with the following columns$/ do |name, table|
  columns = []
  table.hashes.each do |column|
    columns << "#{column["name"]} #{column["type"]}"
  end
  sql = "CREATE TABLE \"#{name}\" (#{columns.join(", ")})"
  ActiveRecord::Base.connection.execute sql
end