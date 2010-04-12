# Taken from has_permalink plugin by Nando Vieira released under the MIT license
class String
  def to_permalink
    str = ActiveSupport::Multibyte::Chars.new(self)
    str = str.normalize(:kd).gsub(/[^\x00-\x7F]/,'').to_s
    str.gsub!(/[^-\w\d]+/sim, "-")
    str.gsub!(/-+/sm, "-")
    str.gsub!(/^-?(.*?)-?$/, '\1')
    str.downcase!
    str
  end
end
