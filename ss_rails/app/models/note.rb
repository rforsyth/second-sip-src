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
	
	validates_presence_of :product, :visibility
  validates_associated :product, :tagged

  after_initialize :save_original_buy_when
  before_validation :set_canonical_fields
  before_save :set_searchable_metadata, :add_buy_when_tag
  before_create :add_unreviewed_tag
  
  # include in metadata: vintage, owner username,
  #                      style, region, occasion, vineyards, varietals
  pg_search_scope :search,
    :against => [:producer_name, :product_name, :searchable_metadata,
                 :description_overall, :description_appearance,
                 :description_aroma, :description_flavor, :description_mouthfeel]
    #:using => [:tsearch, :dmetaphone, :trigrams],
    #:ignoring => :accents
  
  def set_canonical_fields
    self.product_canonical_name = self.product_name.canonicalize if self.product_name.present?
    self.producer_canonical_name = self.producer_name.canonicalize if self.producer_name.present?
  end
  
  def save_original_buy_when
    @original_buy_when = self.buy_when if self.respond_to?(:buy_when)
  end
  
  def to_param
    "#{self.id}-#{self.producer_canonical_name}-#{self.product_canonical_name}"
  end
  
  def set_searchable_metadata
    metadata = self.product.searchable_metadata.dup
    self.looked.each {|looked| metadata << " #{looked.lookup.name.remove_accents}"}
    self.searchable_metadata = metadata
  end
  
  def set_occasion(name, owner = nil)
    return if self.occasion.try(:canonical_name) == name.canonicalize
    self.looked.each do |looked|
      if looked.lookup.lookup_type == Enums::LookupType::OCCASION
        self.remove_tag(looked.lookup.name.tagify)
        looked.delete
      end
    end
    lookup = Lookup.find_or_create_by_name_and_type(name,
                    self.class.name, Enums::LookupType::OCCASION)
    looked = Looked.new(:lookup => lookup, :owner => (owner || self.owner))
    self.add_tag(name.tagify, owner || self.owner)
    self.looked << looked
  end
  
  def add_buy_when_tag
    return if @original_buy_when == self.buy_when
    self.remove_tag(Enums::BuyWhen.to_tag(@original_buy_when)) if @original_buy_when.present?
    self.add_tag(Enums::BuyWhen.to_tag(self.buy_when)) if self.buy_when.present?
  end
	
end

class BeerNote < Note
end

class WineNote < Note
end

class SpiritNote < Note
end
