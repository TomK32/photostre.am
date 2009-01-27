Then /^the flash "(.*)" should be "(.*)"$/ do |flash_type, message|
  assert_equal message, flash[flash_type.to_sym]
end

Then /^I should be redirected to "(.*)"$/ do |url|
  if @response.redirected_to
    assert @response.redirected_to.match(url)
  else
    assert_redirected_to url
  end
end

Then /^I should see template "(.*)"$/ do |template|
  assert_template template
end

Then /^the request should be a "(.*)"$/ do |status|
  assert_response status.to_sym
end

Given /I am on the (.*) page/ do |page|
  page = page.split(' ').flatten.reverse
  page[0] = page[0].pluralize if page.size > 1
  visit (page.join('/'))
end
