Given /^a table "([^\"]*)" in "([^\"]*)"$/ do |name, connection|
  ActiveRecord::Base.establish_connection(connection)
  ActiveRecord::Base.connection.execute "CREATE TABLE \"#{name}\" (\"id\" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL)"
end