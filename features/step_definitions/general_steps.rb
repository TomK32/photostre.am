Then /^the flash "(.*)" should be "(.*)"$/ do |flash_type, message|
  assert_equal message, flash[flash_type.to_sym]
end