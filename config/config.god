God::Contacts::Email.defaults do |d|
  d.from_email = 'god@photostre.am'
  d.from_name = 'God'
  d.delivery_method = :sendmail
end

God.contact(:email) do |c|
  c.name = 'tomk32'
  c.group = 'developers'
  c.to_email = 'tomk32@gmx.de'
end

God.load(File.dirname(__FILE__) + "/god/*.god")
