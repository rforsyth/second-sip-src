
class Note < ActiveRecord::Base
  
	belongs_to :creator, :class_name => "Taster"
	belongs_to :updater, :class_name => "Taster"
	belongs_to :owner, :class_name => "Taster"
	belongs_to :product
	
	has_many :tagged, :as => :taggable
	has_many :tags, :as => :taggable, :through => :tagged
	
	validates_presence_of :product
  validates_associated :product, :tagged

  after_initialize :set_default_values
  
  def set_default_values
    self.visibility ||= Enums::Visibility::PUBLIC
    self.tasted_at ||= DateTime.now
  end	
  
  def to_param
    "#{self.id}-#{self.product.canonical_name}"
  end
	
end

class BeerNote < Note
end

class WineNote < Note
end

class SpiritNote < Note
end
