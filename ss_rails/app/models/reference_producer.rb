require 'data/enums'
require 'data/admin_taggable'

class ReferenceProducer < ActiveRecord::Base
  include PgSearch
  include Data::AdminTaggable
  
	belongs_to :creator, :class_name => "Taster"
	belongs_to :updater, :class_name => "Taster"
	has_many :reference_products
	
  before_validation :set_canonical_fields
  after_save :update_products_producer_name
  
  pg_search_scope :search,
    :against => [:name, :description]
    #:ignoring => :accents
  
  def set_canonical_fields
    self.canonical_name = self.name.canonicalize if self.name.present?
  end
  
  def to_param
    self.canonical_name
  end
  
  def self.find_or_create_by_name(name)
    reference_producer = self.find_by_canonical_name(name.canonicalize)
    return reference_producer if reference_producer.present?
    self.create(:name => name)
  end
	
	def update_products_producer_name
	  producer_name = ActiveRecord::Base.sanitize(self.name)
	  producer_canonical_name = ActiveRecord::Base.sanitize(self.name.canonicalize)
	  
	  ActiveRecord::Base.connection.execute("
	    UPDATE reference_products 
	    SET reference_producer_name = #{producer_name},
	      reference_producer_canonical_name = #{producer_canonical_name}
	    WHERE reference_products.reference_producer_id = #{self.id}")
  end

end

class ReferenceBrewery < ReferenceProducer
end

class ReferenceWinery < ReferenceProducer
end

class ReferenceDistillery < ReferenceProducer
end




