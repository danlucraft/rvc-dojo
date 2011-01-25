When /^I run rvc checkout$/ do
  @output = `./bin/rvc-checkout`
  raise "ouch" unless $? == 0
end

Then /^there should be a directory "([^"]*)"$/ do |arg1|
  `ls workspace`.should include("bin")
end

Then /^the directory "([^"]*)" should contain something like "([^"]*)"$/ do |arg1, arg2|
  `ls workspace/bin`.should include("rvc")
  `rm -rf workspace/*`
end

