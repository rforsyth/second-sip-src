require 'data/float'
require 'data/taggable'
require 'data/admin_taggable'

class Product < ActiveRecord::Base
  include PgSearch
  include Data::Taggable
  include Data::AdminTaggable
  
	belongs_to :creator, :class_name => "Taster"
	belongs_to :updater, :class_name => "Taster"
	belongs_to :owner, :class_name => "Taster"
	
	belongs_to :producer
	has_many :notes
	
	has_many :looked, :as => :lookable
	has_one :region, :source => :lookup, :as => :lookable, :through => :looked,
	                 :conditions => {:lookup_type => Enums::LookupType::REGION}
	has_one :style, :source => :lookup, :as => :lookable, :through => :looked,
	                :conditions => {:lookup_type => Enums::LookupType::STYLE}
	has_many :vineyards, :source => :lookup, :as => :lookable, :through => :looked,
	                     :conditions => {:lookup_type => Enums::LookupType::VINEYARD}
	has_many :varietals, :source => :lookup, :as => :lookable, :through => :looked,
	                     :conditions => {:lookup_type => Enums::LookupType::VARIETAL}
	
	validates_presence_of :producer, :name
  validates_associated :producer, :looked, :tagged

  after_initialize :set_default_values
  before_save :set_canonical_fields
  
  pg_search_scope :search,
    :against => [:name, :searchable_metadata, :description]
    #:ignoring => :accents
  
  def set_default_values
    self.visibility ||= Enums::Visibility::PUBLIC
  end	
  
  def set_canonical_fields
    self.canonical_name = self.name.canonicalize
  end
  
  def to_param
    "#{self.producer.canonical_name}-#{self.canonical_name}"
  end
  
  def set_lookup_properties(params, owner, producer_class)
    if params[:producer_name].present?
      self.producer = producer_class.find_or_create_by_owner_and_name(owner, params[:producer_name])
    end
    set_style(params[:style_name], owner) if params[:style_name].present?
    set_region(params[:region_name], owner) if params[:region_name].present?
    set_lookups(params[:varietal_names], Enums::LookupType::VARIETAL, owner) if params[:varietal_names].present?
    set_lookups(params[:vineyard_names], Enums::LookupType::VINEYARD, owner) if params[:vineyard_names].present?
  end
  
  def set_lookups(lookup_names, lookup_type, owner = nil)
    lookup_canonical_names = lookup_names.collect { |lookup_name| lookup_name.canonicalize }
    current_canonical_names = []
    # first, delete any lookups that got removed
    self.looked.each do |looked|
      if looked.lookup.lookup_type == lookup_type
        if lookup_canonical_names.include?(looked.lookup.name.canonicalize)
          current_canonical_names << looked.lookup.name.canonicalize
        else
          looked.delete
        end
      end
    end
    # now add any new lookups
    lookup_names.each do |lookup_name|
      if !current_canonical_names.include?(lookup_name.canonicalize)
        lookup = Lookup.find_or_create_by_name_and_type(lookup_name,
                        self.class.name, lookup_type)
        self.looked << Looked.new(:lookup => lookup, :owner => (owner || self.owner))
      end
    end
  end
  
  def set_style(name, owner = nil)
    return if self.style.try(:canonical_name) == name.canonicalize
    self.looked.each { |looked| looked.delete if looked.lookup.lookup_type == Enums::LookupType::STYLE }
    lookup = Lookup.find_or_create_by_name_and_type(name,
                    self.class.name, Enums::LookupType::STYLE)
    self.looked << Looked.new(:lookup => lookup, :owner => (owner || self.owner))
  end
  
  def set_region(name, owner = nil)
    return if self.region.try(:canonical_name) == name.canonicalize
    self.looked.each { |looked| looked.delete if looked.lookup.lookup_type == Enums::LookupType::REGION }
    lookup = Lookup.find_or_create_by_name_and_type(name,
                    self.class.name, Enums::LookupType::REGION)
    self.looked << Looked.new(:lookup => lookup, :owner => (owner || self.owner))
  end

end

class Beer < Product
end

class Wine < Product
end

class Spirit < Product
end