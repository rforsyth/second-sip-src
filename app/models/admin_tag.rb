class AdminTag < ActiveRecord::Base
  nilify_blanks
	belongs_to :creator, :class_name => "Taster"
	belongs_to :updater, :class_name => "Taster"
	has_many :admin_taggeds, :dependent => :destroy
	
  before_validation :tagify_name
  
	validates_presence_of :name, :entity_type, :creator, :updater
  validates_uniqueness_of :name, :scope => :entity_type
  
  def tagify_name
    self.name = self.name.tagify if self.name.present?
  end
	
  def to_param
    self.name
  end
  
  def self.find_or_create_by_name_and_type(name, entity_type)
    tag = self.find_by_name(name.tagify, :conditions => {:entity_type => entity_type})
    return tag if tag.present?
    self.create(:name => name, :entity_type => entity_type)
  end
  
end
