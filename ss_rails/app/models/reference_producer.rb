require 'data/enums'

class ReferenceProducer < ActiveRecord::Base
  
	belongs_to :creator, :class_name => "Taster"
	belongs_to :updater, :class_name => "Taster"
	has_many :products
	
  before_save :set_canonical_fields
  
  def set_canonical_fields
    self.canonical_name = self.name.canonicalize
  end
  
  def to_param
    self.canonical_name
  end
end

