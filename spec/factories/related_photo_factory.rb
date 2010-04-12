Factory.define :related_photo do |related_photo|
  related_photo.photo_id { Factory(:photo).id}
end