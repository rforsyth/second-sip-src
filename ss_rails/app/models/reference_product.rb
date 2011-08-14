
class ReferenceProduct < ActiveRecord::Base
  
	belongs_to :creator, :class_name => "Taster"
	belongs_to :updater, :class_name => "Taster"
	belongs_to :region, :class_name => "Lookup", :foreign_key => 'region_lookup_id'
	belongs_to :style, :class_name => "Lookup", :foreign_key => 'style_lookup_id'
	belongs_to :reference_producer
	
	validates_presence_of :producer, :name
  before_save :set_canonical_fields
  
  def set_canonical_fields
    self.canonical_name = "#{self.producer.canonical_name}-#{self.name.canonicalize}"
  end
  
  def to_param
    self.canonical_name
  end
end