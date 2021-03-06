# In order to store the photos in their own collection and still have
# them with more than just an array of ids in the Website, Album and Page
# objects we have an extra class, rebuilding what in SQL would be a join table
class RelatedPhoto
  include Mongoid::Document

#  field :position, :type => Integer
  field :permalink, :type => String
  field :status, :type => String


  belongs_to_related :photo
  embedded_in :parent, :polymorphic => true, :inverse_of => :related_photos
  before_validation :set_permalink
  validates_presence_of :permalink

  def method_missing_with_photo(method, *args, &block)
    if self.attributes[method.to_s]
      return self.attributes[method.to_s]
    elsif method.to_s[/=$/]
      return self.attributes.merge!({method.to_s[0...-1] => args})
    elsif Photo.fields[method.to_s] || self.photo.respond_to?(method)
      return self.photo.send(method, *args, &block)
    else
      return method_missing_without_photo(method, *args, &block)
    end
  end
  alias_method_chain :method_missing, :photo
  def set_permalink(permalink = nil)
    title = self.title.strip.blank? ? 'image' : self.title
    if (title and self.permalink.blank?) || permalink
      permalink ||= title
      permalink = permalink.to_permalink.strip
      permalink_index = nil
      permalinks = parent.related_photos.only(:permalink).collect(&:permalink)
      while permalinks.include?([permalink, permalink_index].compact.join('-'))
        permalink_index ||= 0
        permalink_index += 1
      end
      self.permalink = [permalink, permalink_index].compact.join('-')
    end
  end
end