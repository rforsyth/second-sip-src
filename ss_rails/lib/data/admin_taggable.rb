
module Data::AdminTaggable
  
  def add_admin_tag(tag_name)
    tagified_name = tag_name.tagify
    self.admin_tagged.each { |tagged| return self.admin_tags if tagged.admin_tag.name == tagified_name }
    tag = AdminTag.find_or_create_by_name_and_type(tagified_name, self.class.name)
    
    self.admin_tagged << AdminTagged.new(:admin_tag => tag)
    self.admin_tags
  end
  
  def remove_admin_tag(tag_name)
    self.admin_tagged.each do |tagged|
      tagged.delete if tagged.admin_tag.name == tag_name
    end
    self.admin_tags
  end
  
  def self.included(base)
    base.class_eval do
    	has_many :admin_tagged, :as => :admin_taggable
    	has_many :admin_tags, :as => :admin_taggable, :through => :admin_tagged
    end
  end

end
