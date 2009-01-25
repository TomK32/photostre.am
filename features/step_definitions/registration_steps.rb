
Given /I am on the new session page/ do
  visit "/sessions/new"
end

Then /^I should be redirected to \/(.*)\/$/ do |url|
  url = Regexp.new(url)
  assert @response.redirected_to.match(url)
end

Then /^the request should be a "(.*)"$/ do |status|
  assert_response status.to_sym
end