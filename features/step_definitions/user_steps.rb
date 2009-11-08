Given /I am logged in as "(.*)"/ do |login|
  Given "there is a User \"#{login}\""
  Given "that I have a complete OpenID as user \"#{login}\""
end

Given /there is a User "(.*)"/ do |login|
  @current_user = User.find_or_create_by_login(login)
end
