require 'data/admin_taggable'

class ReferenceProduct < ActiveRecord::Base
  include PgSearch
  include Data::AdminTaggable
  nilify_blanks
  
	belongs_to :creator, :class_name => "Taster"
	belongs_to :updater, :class_name => "Taster"
	belongs_to :reference_producer
	
	has_many :reference_looked, :as => :reference_lookable
	has_one :region, :source => :reference_lookup, :as => :reference_lookable, :through => :reference_looked,
	                 :conditions => {:lookup_type => Enums::LookupType::REGION}
	has_one :style, :source => :reference_lookup, :as => :reference_lookable, :through => :reference_looked,
	                :conditions => {:lookup_type => Enums::LookupType::STYLE}
	has_many :vineyards, :source => :reference_lookup, :as => :reference_lookable, :through => :reference_looked,
	                     :conditions => {:lookup_type => Enums::LookupType::VINEYARD}
	has_many :varietals, :source => :reference_lookup, :as => :reference_lookable, :through => :reference_looked,
	                     :conditions => {:lookup_type => Enums::LookupType::VARIETAL}
	
	validates_presence_of :reference_producer, :name
  validates_associated :reference_producer, :reference_looked
  before_validation :set_canonical_fields
  before_save :set_searchable_metadata
  
  pg_search_scope :search,
    :against => [:name, :searchable_metadata, :description]
    #:ignoring => :accents
  
  def set_canonical_fields
    self.canonical_name = self.name.canonicalize if self.name.present?
    self.reference_producer_canonical_name = self.reference_producer_name.canonicalize if self.reference_producer_name.present?
  end
  
  def to_param
    "#{self.reference_producer_canonical_name}-#{self.canonical_name}"
  end
  
  def set_searchable_metadata
    metadata = self.reference_producer.name.remove_accents
    self.reference_looked.each {|looked| metadata << " #{looked.reference_lookup.name.remove_accents}"}
    self.searchable_metadata = metadata
  end
  
  def set_lookup_properties(params, reference_producer_class)
    if params[:reference_producer_name].present?
      self.reference_producer = 
        reference_producer_class.find_or_create_by_name(params[:reference_producer_name])
      self.reference_producer_name = self.reference_producer.name
    end
    set_style(params[:style_name]) if params[:style_name].present?
    set_region(params[:region_name]) if params[:region_name].present?
    set_lookups(params[:varietal_names], Enums::LookupType::VARIETAL) if params[:varietal_names].present?
    set_lookups(params[:vineyard_names], Enums::LookupType::VINEYARD) if params[:vineyard_names].present?
  end
  
  def set_lookups(lookup_names, lookup_type)
    lookup_canonical_names = lookup_names.collect { |lookup_name| lookup_name.canonicalize }
    current_canonical_names = []
    # first, delete any lookups that got removed
    self.reference_looked.each do |reference_looked|
      if reference_looked.reference_lookup.lookup_type == lookup_type
        if lookup_canonical_names.include?(reference_looked.reference_lookup.name.canonicalize)
          current_canonical_names << reference_looked.reference_lookup.name.canonicalize
        else
          reference_looked.delete
        end
      end
    end
    # now add any new lookups
    lookup_names.each do |lookup_name|
      if !current_canonical_names.include?(lookup_name.canonicalize)
        lookup = ReferenceLookup.find_or_create_by_name_and_type(lookup_name,
                        self.class.name, lookup_type)
        self.reference_looked << ReferenceLooked.new(:reference_lookup => lookup)
      end
    end
  end
  
  def set_style(name)
    return if self.style.try(:canonical_name) == name.canonicalize
    self.reference_looked.each do |reference_looked|
      reference_looked.delete if reference_looked.reference_lookup.lookup_type == Enums::LookupType::STYLE
    end
    lookup = ReferenceLookup.find_or_create_by_name_and_type(name,
                    self.class.name, Enums::LookupType::STYLE)
    self.reference_looked << ReferenceLooked.new(:reference_lookup => lookup)
  end
  
  def set_region(name)
    return if self.region.try(:canonical_name) == name.canonicalize
    self.reference_looked.each do |reference_looked|
      reference_looked.delete if reference_looked.reference_lookup.lookup_type == Enums::LookupType::REGION
    end
    lookup = ReferenceLookup.find_or_create_by_name_and_type(name,
                    self.class.name, Enums::LookupType::REGION)
    self.reference_looked << ReferenceLooked.new(:reference_lookup => lookup)
  end

end

class ReferenceBeer < ReferenceProduct
end

class ReferenceWine < ReferenceProduct
end

class ReferenceSpirit < ReferenceProduct
end
