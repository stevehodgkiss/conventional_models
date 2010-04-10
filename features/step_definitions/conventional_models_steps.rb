Given /^a table "([^\"]*)"$/ do |name|
  ActiveRecord::Base.connection.execute "CREATE TABLE \"#{name}\" (\"id\" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL)"
end
