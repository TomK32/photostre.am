Factory.define :page do |page|
  page.title {'My page ' + Page.count.to_s}
  page.state 'published'
  page.body 'Welcome to my page'
  page.website { Website.first || Factory(:website) }
  page.user { User.first || Factory(:user)}
end