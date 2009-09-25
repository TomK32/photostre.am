Factory.define :album do |page|
  page.title {'My album ' + Page.count.to_s}
  page.state 'published'
  page.body 'These are photos from my trip to Helsinki'
  page.website { Website.first || Factory(:website) }
end