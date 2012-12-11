
module Data::Taggable
  
  def update_tags(updated_tag_names, owner = nil)
    return if !updated_tag_names.present?
    
    tagified_tag_names = updated_tag_names.collect{|original_name| original_name.tagify}
    
    # first remove any tags that are not in the updated list
    tags_to_remove = []
    self.tagged.each do |tagged|
      tags_to_remove << tagged.tag.name if !tagified_tag_names.include?(tagged.tag.name)
    end
    tags_to_remove.each {|tag_to_remove| self.remove_tag(tag_to_remove)}
    
    # now add any new tags - depending on add_tag to detect existing tags
    tagified_tag_names.each {|tag_to_add| self.add_tag(tag_to_add)}
  end
  
  def add_tag(tag_name, owner = nil)
    return if tag_name.strip.empty?
    tagified_name = tag_name.tagify
    #self.tagged.each { |tagged| return self.tags if tagged.tag.name == tagified_name }
    return self.tags if self.contains_tag(tagified_name)
    tag = Tag.find_or_create_by_name_and_type(tagified_name, self.type)
    new_tagged = Tagged.new(:tag => tag, :owner => (owner || self.owner))
    self.tagged << new_tagged
    self.tags
  end
  
  def remove_tag(tag_name)
    tagified_name = tag_name.tagify
    self.tagged.each do |tagged|
      tagged.delete if tagged.tag.name == tagified_name
    end
    self.tags
  end
  
  def contains_tag(tag_name)
    self.tagged.each { |tagged| return true if tagged.tag.name == tag_name }
    return false
  end
  
  def self.included(base)
    base.class_eval do
    	has_many :tagged, :as => :taggable
    	has_many :tags, :as => :taggable, :through => :tagged
    end
  end

end
