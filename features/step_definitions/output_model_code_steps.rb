Then /^within "([^\"]*)" I should see:$/ do |within, table|
  puts combined_output
  output = combined_output.scan(/#{within}:\<\<(.*)\>\>/m).to_s
  table.hashes.each do |row|
    output.should =~ /#{row["line"]}/
  end
end