Factory.define :website do |website|
  website.title 'my portfolio'
  website.domains {['example%i.com' % Website.count ]}
  website.status 'active'
  website.user_ids {[Factory(:user).id]}
end
Factory.define :website_system, :parent => :website do |website|
  website.title 'photostre.am'
  website.domains ['photostre.am']
  website.status 'system'
end

Factory.define :website_with_photos, :parent => :website do |website|
  website.related_photos { (0..20).collect{ Factory.build(:related_photo) } }
end
