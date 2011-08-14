
class Product < ActiveRecord::Base
  
	belongs_to :creator, :class_name => "Taster"
	belongs_to :updater, :class_name => "Taster"
	belongs_to :owner, :class_name => "Taster"
	
	belongs_to :producer
	has_many :notes
	
	has_many :tagged, :as => :taggable
	has_many :tags, :as => :taggable, :through => :tagged
	
	#belongs_to :region, :class_name => "Lookup", :foreign_key => 'region_lookup_id'
	#belongs_to :style, :class_name => "Lookup", :foreign_key => 'style_lookup_id'
	has_many :looked, :as => :lookable
	has_one :region, :source => :lookup, :as => :lookable, :through => :looked
	has_one :style, :source => :lookup, :as => :lookable, :through => :looked
	has_many :vineyards, :source => :lookup, :as => :lookable, :through => :looked
	has_many :varietals, :source => :lookup, :as => :lookable, :through => :looked
	
	validates_presence_of :producer, :name

  after_initialize :set_default_values
  before_save :set_canonical_fields
  
  def set_default_values
    self.visibility ||= Enums::Visibility::PUBLIC
  end	
  
  def set_canonical_fields
    self.canonical_name = "#{self.producer.canonical_name}-#{self.name.canonicalize}"
  end
  
  def to_param
    self.canonical_name
  end

end

class Beer < Product
end

class Wine < Product
end

class Spirit < Product
end