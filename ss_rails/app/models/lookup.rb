require 'data/string'
require 'data/admin_taggable'

class Lookup < ActiveRecord::Base
  include Data::AdminTaggable
  
	belongs_to :creator, :class_name => "Taster"
	belongs_to :updater, :class_name => "Taster"
	belongs_to :owner, :class_name => "Taster"
	has_many :lookeds
	
	before_validation :canonicalize_names
	
  def canonicalize_names
		self.canonical_name = self.name.canonicalize
	end
  
  def self.find_or_create_by_name_and_type(name, entity_type, lookup_type)
    lookup = self.find_by_canonical_name(name.canonicalize,
                  :conditions => {:entity_type => entity_type, :lookup_type => lookup_type})
    return lookup if lookup.present?
    self.create(:name => name, :entity_type => entity_type, :lookup_type => lookup_type)
  end
	
end


