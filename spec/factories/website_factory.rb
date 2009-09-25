Factory.define :website do |website|
  website.site_title 'my portfolio'
  website.domain {'example%i.com' % Website.count }
end