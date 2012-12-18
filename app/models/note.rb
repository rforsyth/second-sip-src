require 'data/enums'
require 'data/taggable'
require 'data/admin_taggable'
require 'data/cache_helper'

class Note < ActiveRecord::Base
  include PgSearch
  include Data::Taggable
  include Data::AdminTaggable
  include Data::CacheHelper
  nilify_blanks
  
	belongs_to :creator, :class_name => "Taster"
	belongs_to :updater, :class_name => "Taster"
	belongs_to :owner, :class_name => "Taster"
	belongs_to :product
	
	has_many :looked, :as => :lookable
	has_one :occasion, :source => :lookup, :as => :lookable, :through => :looked,
	                   :conditions => {:lookup_type => Enums::LookupType::OCCASION}
	
	validates_presence_of :product, :visibility, :tasted_at
  validates_associated :product, :tagged
	validate :score_matches_score_type

  after_initialize :save_original_auto_tag_values
  before_validation :set_canonical_fields
  before_save :set_searchable_metadata, :add_auto_tags
  #before_create :add_unreviewed_tag
  
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
  
  def save_original_auto_tag_values
    @original_buy_when = self.buy_when if self.respond_to?(:buy_when)
    @original_vintage = self.vintage if self.respond_to?(:vintage)
  end
  
  def to_param
    "#{self.id}-#{self.producer_canonical_name}-#{self.product_canonical_name}"
  end
  
  def tasted_at=(value)
    if value.kind_of?(String)
      value = Date.strptime(value, '%m/%d/%Y') rescue nil
    end
    write_attribute(:tasted_at, value)
  end
  
  def set_searchable_metadata
    metadata = self.product.searchable_metadata.dup
    self.looked.each {|looked| metadata << " #{looked.lookup.name}"}
    self.searchable_metadata = metadata.remove_accents[0..499]
  end
  
  def set_occasion(name, owner = nil)
    return if name.present? && self.occasion.try(:canonical_name) == name.canonicalize
    self.looked.each do |looked|
      if looked.lookup.lookup_type == Enums::LookupType::OCCASION
        self.remove_tag(looked.lookup.name.tagify)
        looked.delete
      end
    end
    return if !name.present?
    lookup = Lookup.find_or_create_by_name_and_type(name,
                    self.class.name, Enums::LookupType::OCCASION)
    new_looked = Looked.new(:lookup => lookup, :owner => (owner || self.owner))
    self.add_tag(name.tagify, owner || self.owner)
    self.looked << new_looked
    
    puts self.tags.inspect
    puts self.looked.inspect
  end

	def api_copy(include_description = true)
		copy = ApiNote.new
	  copy.id = self.id
	  copy.owner_id = self.owner_id
	  copy.product_id = self.product_id
	  copy.type = self.type
	  copy.visibility = self.visibility
	  copy.created_at = self.created_at
	  copy.tasted_at = self.tasted_at
		copy.product_name = self.product_name
		copy.product_canonical_name = self.product_canonical_name
		copy.producer_name = self.producer_name
		copy.producer_canonical_name = self.producer_canonical_name
		if include_description
  		copy.description_overall = self.description_overall
  		copy.description_appearance = self.description_appearance
  		copy.description_aroma = self.description_aroma
  		copy.description_flavor = self.description_flavor
  		copy.description_mouthfeel = self.description_mouthfeel
  		copy.score_type = self.score_type
  		copy.score = self.score
  		copy.price_paid = self.price_paid
  		copy.price_type = self.price_type
  		copy.price = self.price
  		copy.buy_when = self.buy_when
  		copy.vintage = self.vintage
  	end
		
    owner = fetch_taster(self.owner_id)
    copy.owner_username = owner.username
		return copy
  end
  
  private
  
  def add_auto_tags
    if !(@original_buy_when == self.buy_when && !self.new_record?)
      self.remove_tag(Enums::BuyWhen.to_tag(@original_buy_when)) if @original_buy_when.present?
      self.add_tag(Enums::BuyWhen.to_tag(self.buy_when), self.owner) if self.buy_when.present?
    end
    # if !(@original_vintage == self.vintage && !self.new_record?)
    #   self.remove_tag(tagify_vintage(@original_vintage)) if @original_vintage.present?
    #   self.add_tag(tagify_vintage(self.vintage), self.owner) if self.vintage.present?
    # end
  end
  
  def tagify_vintage(vintage)
    "vintage-#{vintage}"
  end
  
  def score_matches_score_type
	  return if !score.present?
    if score < 0
      errors.add(:score, "must be greater than zero.") 
    end
    if score > score_type
      errors.add(:score, "must be less then your chosen score type.") 
    end
	end
	
end

class ApiNote
	attr_accessor :id, :owner_id, :producer_id, :product_id, :type, :visibility, :created_at, :tasted_at, 
	              :product_name, :product_canonical_name, :producer_name, :producer_canonical_name,
	              :description_overall, :description_appearance, :description_aroma,
	              :description_flavor, :description_mouthfeel, :score_type, :score,
	              :buy_when, :vintage, :price_paid, :price_type, :price,
	              :region_name, :style_name, :varietal_names, :vineyard_names
	# these are related properties that must be filled in
	attr_accessor :owner_username, :tags, :occasion, :product_description, :producer_description
end

class BeerNote < Note
end

class WineNote < Note
end

class SpiritNote < Note
end
