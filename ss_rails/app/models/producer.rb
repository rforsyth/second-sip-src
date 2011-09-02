require 'data/enums'
require 'data/taggable'
require 'data/admin_taggable'

class Producer < ActiveRecord::Base
  include PgSearch
  include Data::Taggable
  include Data::AdminTaggable
  
	belongs_to :creator, :class_name => "Taster"
	belongs_to :updater, :class_name => "Taster"
	belongs_to :owner, :class_name => "Taster"
	has_many :products

  after_initialize :set_default_values
  before_save :set_canonical_fields
  
  pg_search_scope :search,
    :against => [:name, :description]
    #:ignoring => :accents
  
  def set_default_values
    self.visibility ||= Enums::Visibility::PUBLIC
  end	
  
  def set_canonical_fields
    self.canonical_name = self.name.canonicalize
  end
  
  def to_param
    self.canonical_name
  end
  
  def self.find_or_create_by_owner_and_name(owner, name)
    producer = self.find_by_canonical_name(name.canonicalize, :conditions => { :owner_id => owner.id })
    return producer if producer.present?
    self.create(:name => name, :owner => owner)
  end
  
  
end

class Brewery < Producer
end

class Winery < Producer
end

class Distillery < Producer
end
