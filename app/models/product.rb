require 'data/float'
require 'data/taggable'
require 'data/admin_taggable'
require 'data/cache_helper'

class Product < ActiveRecord::Base
  include PgSearch
  include Data::Taggable
  include Data::AdminTaggable
  include Data::CacheHelper
  nilify_blanks
  
	belongs_to :creator, :class_name => "Taster"
	belongs_to :updater, :class_name => "Taster"
	belongs_to :owner, :class_name => "Taster"
	
	belongs_to :producer
	has_many :notes, :dependent => :destroy
	
	has_many :looked, :as => :lookable, :dependent => :delete_all
  # has_one :region, :source => :lookup, :as => :lookable, :through => :looked,
  #                  :conditions => {:lookup_type => Enums::LookupType::REGION}
  # has_one :style, :source => :lookup, :as => :lookable, :through => :looked,
  #                 :conditions => {:lookup_type => Enums::LookupType::STYLE}
	has_many :vineyards, :source => :lookup, :as => :lookable, :through => :looked,
	                     :conditions => {:lookup_type => Enums::LookupType::VINEYARD}
	has_many :varietals, :source => :lookup, :as => :lookable, :through => :looked,
	                     :conditions => {:lookup_type => Enums::LookupType::VARIETAL}
	
	validates_presence_of :producer, :name, :visibility
  validates_associated :producer, :looked, :tagged
	validate :product_name_is_unique

  after_initialize :init
  before_validation :set_canonical_fields
  before_save :set_searchable_metadata
  #before_create :add_unreviewed_tag
  after_save :update_notes_product_name
  
  pg_search_scope :search,
    :against => [:name, :producer_name, :searchable_metadata, :description]
    #:ignoring => :accents
  
  def style  
    self.looked.each do |looked|
      return looked.lookup if looked.lookup.lookup_type == Enums::LookupType::STYLE
    end
    return nil
  end  
  
  def region  
    self.looked.each do |looked|
      return looked.lookup if looked.lookup.lookup_type == Enums::LookupType::REGION
    end
    return nil
  end
  
  def region_name
    self.region.try(:name)
  end
  
  def style_name
    self.style.try(:name)
  end
  
  def vineyard_names
    return nil if !self.vineyards.present?
    self.vineyards.collect {|vineyard| vineyard.name}
  end
  
  def varietal_names
    return nil if !self.varietals.present?
    self.varietals.collect {|varietal| varietal.name}
  end
  
  def set_canonical_fields
    self.canonical_name = self.name.canonicalize if self.name.present?
    self.producer_canonical_name = self.producer_name.canonicalize if self.producer_name.present?
  end
  
  def set_searchable_metadata
    metadata = "#{self.owner.username} #{self.producer.name} #{self.name}"
    self.looked.each {|looked| metadata << " #{looked.lookup.name}"}
    self.searchable_metadata = metadata.remove_accents[0..499]
  end
  
  def to_param
    "#{self.producer_canonical_name}-#{self.canonical_name}"
  end
  
  def set_lookup_properties(params, owner, producer_class)
    # save the current state of the lookup tag names for the auto-tag generation feature
    @original_lookup_tag_names = self.looked.collect {|looked| looked.lookup.name.tagify}
    if params[:producer_name].present?
      self.producer = producer_class.find_or_create_by_owner_and_name(
                        owner, params[:producer_name], self.visibility)
      self.producer_name = self.producer.name
    end
    set_style(params[:style_name], owner)
    set_region(params[:region_name], owner)
    set_lookups(params[:varietal_names], Enums::LookupType::VARIETAL, owner)
    set_lookups(params[:vineyard_names], Enums::LookupType::VINEYARD, owner)
  end
  
  def set_lookups(lookup_names, lookup_type, owner = nil)
    if lookup_names.present?
      lookup_canonical_names = lookup_names.collect { |lookup_name| lookup_name.canonicalize }
    else
      lookup_canonical_names = []
    end
    current_canonical_names = []
    # first, delete any lookups that got removed
    self.looked.each do |looked|
      if looked.lookup.lookup_type == lookup_type
        if lookup_canonical_names.include?(looked.lookup.name.canonicalize)
          current_canonical_names << looked.lookup.name.canonicalize
        else
          self.remove_tag(looked.lookup.name.tagify)
          looked.delete
        end
      end
    end
    return if !lookup_names.present?
    # now add any new lookups
    lookup_names.each do |lookup_name|
      if !current_canonical_names.include?(lookup_name.canonicalize)
        lookup = Lookup.find_or_create_by_name_and_type(lookup_name,
                        self.class.name, lookup_type)
        looked = Looked.new(:lookup => lookup, :owner => (owner || self.owner))
        self.add_tag(lookup_name.tagify, owner || self.owner)
        self.looked << looked
      end
    end
  end
  
  def set_style(name, owner = nil)
    return if name.present? && (self.style.try(:canonical_name) == name.canonicalize)
    self.looked.each do |looked|
      if looked.lookup.lookup_type == Enums::LookupType::STYLE
        self.remove_tag(looked.lookup.name.tagify)
        looked.delete
      end
    end
    return if !name.present?
    lookup = Lookup.find_or_create_by_name_and_type(name,
                    self.class.name, Enums::LookupType::STYLE)
    looked = Looked.new(:lookup => lookup, :owner => (owner || self.owner))
    self.add_tag(name.tagify, owner || self.owner)
    self.looked << looked
  end
  
  def set_region(name, owner = nil)
    return if name.present? && (self.region.try(:canonical_name) == name.canonicalize)
    self.looked.each do |looked|
      if looked.lookup.lookup_type == Enums::LookupType::REGION
        self.remove_tag(looked.lookup.name.tagify)
        looked.delete
      end
    end
    return if !name.present?
    lookup = Lookup.find_or_create_by_name_and_type(name,
                    self.class.name, Enums::LookupType::REGION)
    looked = Looked.new(:lookup => lookup, :owner => (owner || self.owner))
    self.add_tag(name.tagify, owner || self.owner)
    self.looked << looked
  end
  
	def simple_copy
		copy = SimpleProduct.new
		copy.id = self.id
		copy.name = self.name
		copy.visibility = self.visibility
		copy.producer_name = self.producer_name
		copy.price_paid = self.price_paid
		copy.price_type = self.price_type
		copy.region_name = self.region.try(:name)
		copy.style_name = self.style.try(:name)
		copy.varietal_names = self.varietals.collect{|varietal| varietal.name} if self.varietals.present?
		copy.vineyard_names = self.vineyards.collect{|vineyard| vineyard.name} if self.vineyards.present?
		return copy
	end
	
	def api_copy(include_description = true)
		copy = ApiProduct.new
		
	  copy.id = self.id
	  copy.owner_id = self.owner_id
	  copy.producer_id = self.producer_id
	  copy.type = self.type
	  copy.visibility = self.visibility
	  copy.name = self.name
	  copy.canonical_name = self.canonical_name
	  copy.created_at = self.created_at
		copy.producer_name = self.producer_name
		copy.producer_canonical_name = self.producer_canonical_name
	  if include_description
	    copy.description = self.description
	  end
	  
    owner = fetch_taster(self.owner_id)
    copy.owner_username = owner.username

		return copy
  end
	
	def update_notes_product_name
	  product_name = ActiveRecord::Base.sanitize(self.name)
	  product_canonical_name = ActiveRecord::Base.sanitize(self.name.canonicalize)
	  
	  ActiveRecord::Base.connection.execute("
	    UPDATE notes 
	    SET product_name = #{product_name}, product_canonical_name = #{product_canonical_name}
	    WHERE notes.product_id = #{self.id}")
  end
  
  def product_name_is_unique
    products = self.class.where("owner_id = ? AND producer_canonical_name = ? AND canonical_name = ?",
                               self.owner_id, self.producer_canonical_name, self.canonical_name)
    if products.count > 0
      if self.new_record?
        errors.add(:name, "already exists.")
      else
        products.each do |product|
          if product.id != self.id
            errors.add(:name, "is already being used.")
            return
          end
        end
      end
    end
  end
  

end
	
class SimpleProduct
	attr_accessor :id, :name, :producer_name, :visibility, :price_paid, :price_type,
	 							:region_name, :style_name, :varietal_names, :vineyard_names
end
	
class ApiProduct
	attr_accessor :id, :owner_id, :producer_id, :type, :visibility, :producer_name, :producer_canonical_name,
	              :name, :canonical_name, :description, :created_at
	# these are related properties that must be filled in
	attr_accessor :owner_username, :tags, :notes,
	              :region_name, :style_name, :varietal_names, 
	              :vineyard_names, :producer_description
end

class Beer < Product
  def init
    self.price_type  ||= Enums::BeerPriceType::SIX_PACK
  end
end

class Wine < Product
  def init
    self.price_type  ||= Enums::WinePriceType::BOTTLE
  end
end

class Spirit < Product
  def init
    self.price_type  ||= Enums::SpiritPriceType::FIFTH
  end
end