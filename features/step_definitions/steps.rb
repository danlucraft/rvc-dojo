When /^I run rvc log$/ do
  @output = `./bin/rvc-log`
  raise "ouch" unless $? == 0
end

Then /^I want to see "([^"]*)"$/ do |expected|
  @output.should include(expected)
end

Then /^I want to see "([^"]*)" (\d+) times$/ do |expected, n|
  expectations = @output.scan(Regexp.new(Regexp.escape(expected)))
  expectations.should == [expected] * n.to_i
end
