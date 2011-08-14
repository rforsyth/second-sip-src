require 'data/enums'

class Producer < ActiveRecord::Base
  
	belongs_to :creator, :class_name => "Taster"
	belongs_to :updater, :class_name => "Taster"
	belongs_to :owner, :class_name => "Taster"
	has_many :products
	
	has_many :tagged, :as => :taggable
	has_many :tags, :as => :taggable, :through => :tagged

  after_initialize :set_default_values
  before_save :set_canonical_fields
  
  def set_default_values
    self.visibility ||= Enums::Visibility::PUBLIC
  end	
  
  def set_canonical_fields
    self.canonical_name = self.name.canonicalize
  end
  
  def to_param
    self.canonical_name
  end
end

class Brewery < Producer
end

class Winery < Producer
end

class Distillery < Producer
end
