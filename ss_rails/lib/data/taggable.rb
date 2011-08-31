
module Data::Taggable
  
  def add_tag(tag_name, owner = nil)
    tagified_name = tag_name.tagify
    self.tagged.each { |tagged| return self.tags if tagged.tag.name == tagified_name }
    tag = Tag.find_or_create(tagified_name)
    self.tagged << Tagged.new(:tag => tag, :owner => (owner || self.owner))
    self.tags
  end
  
  def remove_tag(tag_name)
    tagified_name = tag_name.tagify
    self.tagged.each do |tagged|
      tagged.delete if tagged.tag.name == tagified_name
    end
    self.tags
  end
  
  def self.included(base)
    base.class_eval do
    	has_many :tagged, :as => :taggable
    	has_many :tags, :as => :taggable, :through => :tagged
    end
  end

end