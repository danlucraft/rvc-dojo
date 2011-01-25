When /^I run rvc show$/ do
  @output = `./bin/rvc-show`
  raise "ouch" unless $? == 0
end

Then /^I want to see "([^"]*)"$/ do |expected|
  @output.should include(expected)
end
