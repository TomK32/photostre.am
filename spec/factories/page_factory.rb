Factory.define :page do |page|
  page.title {'My page ' + Page.count.to_s}
  page.state 'published'
  page.body 'Welcome to my page'
  page.website_id { (Website.first || Factory(:website)).id }
  page.user_id { (User.first || Factory(:user)).id }
end