
class ReferenceProduct < ActiveRecord::Base
  
	belongs_to :creator, :class_name => "Taster"
	belongs_to :updater, :class_name => "Taster"
	belongs_to :reference_producer
	
	has_many :reference_looked, :as => :reference_lookable
	has_one :region, :source => :reference_lookup, :as => :reference_lookable, :through => :reference_looked
	has_one :style, :source => :reference_lookup, :as => :reference_lookable, :through => :reference_looked
	has_many :vineyards, :source => :reference_lookup, :as => :reference_lookable, :through => :reference_looked
	has_many :varietals, :source => :reference_lookup, :as => :reference_lookable, :through => :reference_looked
	
	validates_presence_of :reference_producer, :name
  before_save :set_canonical_fields
  
  def set_canonical_fields
    self.canonical_name = "#{self.reference_producer.canonical_name}-#{self.name.canonicalize}"
  end
  
  def to_param
    self.canonical_name
  end

end

class ReferenceBeer < ReferenceProduct
end

class ReferenceWine < ReferenceProduct
end

class ReferenceSpirit < ReferenceProduct
end
