Then /^within "([^\"]*)" I should see:$/ do |within, table|
  output = all_output.match(/#{within}:\<\<(.*)\>\>/m)[0]
  table.hashes.each do |row|
    output.should =~ /#{row["line"]}/
  end
end