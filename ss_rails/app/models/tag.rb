class Tag < ActiveRecord::Base
	belongs_to :creator, :class_name => "Taster"
	belongs_to :updater, :class_name => "Taster"
	
  before_validation :tagify_name
  
  validates_uniqueness_of :name
  
  def tagify_name
    self.name = self.name.tagify
  end
	
  def to_param
    self.name
  end
	
end
