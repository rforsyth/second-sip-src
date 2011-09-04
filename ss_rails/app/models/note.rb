require 'data/enums'
require 'data/taggable'
require 'data/admin_taggable'

class Note < ActiveRecord::Base
  include PgSearch
  include Data::Taggable
  include Data::AdminTaggable
  
	belongs_to :creator, :class_name => "Taster"
	belongs_to :updater, :class_name => "Taster"
	belongs_to :owner, :class_name => "Taster"
	belongs_to :product
	
	has_many :looked, :as => :lookable
	has_one :occasion, :source => :lookup, :as => :lookable, :through => :looked,
	                   :conditions => {:lookup_type => Enums::LookupType::OCCASION}
	
	validates_presence_of :product
  validates_associated :product, :tagged

  after_initialize :set_default_values
  before_save :set_searchable_metadata
  
  # include in metadata: vintage, producer name, product name, owner username,
  #                      style, region, occasion, vineyards, varietals
  pg_search_scope :search,
    :against => [:searchable_metadata, :description_overall, :description_appearance,
                 :description_aroma, :description_flavor, :description_mouthfeel]
    #:using => [:tsearch, :dmetaphone, :trigrams],
    #:ignoring => :accents
  
  def set_default_values
    self.visibility ||= Enums::Visibility::PUBLIC
    self.tasted_at ||= DateTime.now
  end	
  
  def to_param
    "#{self.id}-#{self.product.producer.canonical_name}-#{self.product.canonical_name}"
  end
  
  def set_searchable_metadata
    metadata = self.product.searchable_metadata.dup
    self.looked.each {|looked| metadata << " #{looked.lookup.name.remove_accents}"}
    self.searchable_metadata = metadata
  end
  
  def set_occasion(name, owner = nil)
    return if self.occasion.try(:canonical_name) == name.canonicalize
    self.looked.each { |looked| looked.delete if looked.lookup.lookup_type == Enums::LookupType::OCCASION }
    lookup = Lookup.find_or_create_by_name_and_type(name,
                    self.class.name, Enums::LookupType::OCCASION)
    self.looked << Looked.new(:lookup => lookup, :owner => (owner || self.owner))
  end
	
end

class BeerNote < Note
end

class WineNote < Note
end

class SpiritNote < Note
end
