require 'data/enums'
require 'data/admin_taggable'

class ReferenceProducer < ActiveRecord::Base
  include PgSearch
  include Data::AdminTaggable
  
	belongs_to :creator, :class_name => "Taster"
	belongs_to :updater, :class_name => "Taster"
	has_many :reference_products
	
  before_save :set_canonical_fields
  
  pg_search_scope :search,
    :against => [:name, :description]
    #:ignoring => :accents
  
  def set_canonical_fields
    self.canonical_name = self.name.canonicalize
  end
  
  def to_param
    self.canonical_name
  end
  
  def self.find_or_create_by_name(name)
    reference_producer = self.find_by_canonical_name(name.canonicalize)
    return reference_producer if reference_producer.present?
    self.create(:name => name)
  end

end

class ReferenceBrewery < ReferenceProducer
end

class ReferenceWinery < ReferenceProducer
end

class ReferenceDistillery < ReferenceProducer
end




