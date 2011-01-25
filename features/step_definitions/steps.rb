When /^I run rvc log$/ do
  @output = `./bin/rvc-log`
  raise "ouch" unless $? == 0
end

Then /^I want to see "([^"]*)"$/ do |expected|
  @output.should include(expected)
end
