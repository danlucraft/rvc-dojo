
require 'aruba/cucumber'
  
When /^I run rvc (.*)$/ do |args|
  When "I run \"ruby ../../../bin/rvc #{args}\""
end
