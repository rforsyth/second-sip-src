class AdminTag < ActiveRecord::Base
	belongs_to :creator, :class_name => "Taster"
	belongs_to :updater, :class_name => "Taster"
	has_many :admin_taggeds
	
  before_validation :tagify_name
  
  validates_uniqueness_of :name
  
  def tagify_name
    self.name = self.name.tagify
  end
	
  def to_param
    self.name
  end
  
  def self.find_or_create(name)
    tag = self.find_by_name(name)
    return tag if tag.present?
    self.create(:name => name)
  end
  
end
