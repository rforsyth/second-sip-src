require 'data/enums'
require 'data/taggable'
require 'data/admin_taggable'
require 'data/validation_helper'

class Producer < ActiveRecord::Base
  include PgSearch
  include Data::Taggable
  include Data::AdminTaggable
  include Data::ValidationHelper
  nilify_blanks
  
	belongs_to :creator, :class_name => "Taster"
	belongs_to :updater, :class_name => "Taster"
	belongs_to :owner, :class_name => "Taster"
	has_many :products
	
  before_validation :set_canonical_fields
  before_validation :add_protocol_to_website_url
  before_create :add_unreviewed_tag
  after_save :update_products_and_notes_producer_name
  
	validates_presence_of :creator, :updater, :name, :visibility
  validates_uniqueness_of :canonical_name, :scope => :owner_id,
                          :message => "is already being used."
  validates_format_of :website_url, :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix
  
  pg_search_scope :search,
    :against => [:name, :description]
    #:ignoring => :accents
  
  def set_canonical_fields
    self.canonical_name = self.name.canonicalize if self.name.present?
  end
  
  def to_param
    self.canonical_name
  end
  
  def self.find_or_create_by_owner_and_name(owner, name, visibility)
    producer = self.find_by_canonical_name(name.canonicalize, :conditions => { :owner_id => owner.id })
    return producer if producer.present?
    self.create(:name => name, :owner => owner, :visibility => visibility)
  end
  
	def simple_copy
		copy = SimpleProducer.new
		copy.id = self.id
		copy.name = self.name
		copy.visibility = self.visibility
		return copy
	end
	
	def update_products_and_notes_producer_name
	  producer_name = ActiveRecord::Base.sanitize(self.name)
	  producer_canonical_name = ActiveRecord::Base.sanitize(self.name.canonicalize)
	  
	  ActiveRecord::Base.connection.execute("
	    UPDATE products 
	    SET producer_name = #{producer_name},
	      producer_canonical_name = #{producer_canonical_name}
	    WHERE products.producer_id = #{self.id}")
	  
	  ActiveRecord::Base.connection.execute("
	    UPDATE notes 
	    SET producer_name = #{producer_name},
	      producer_canonical_name = #{producer_canonical_name}
	    FROM products
	    WHERE products.producer_id = #{self.id}
	      AND notes.product_id = products.id")
  end
  
  
  
end

class SimpleProducer
	attr_accessor :id, :name, :visibility
end

class Brewery < Producer
end

class Winery < Producer
end

class Distillery < Producer
end
