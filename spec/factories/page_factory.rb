Factory.define :page do |page|
  page.title {'My page ' + Page.count.to_s}
  page.status 'published'
  page.body 'Welcome to my page'
  page.user_id { (User.first || Factory(:user)).id }
end