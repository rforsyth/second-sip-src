require 'data/string'
require 'data/admin_taggable'

class Lookup < ActiveRecord::Base
  include Data::AdminTaggable
  nilify_blanks
  
	belongs_to :creator, :class_name => "Taster"
	belongs_to :updater, :class_name => "Taster"
	belongs_to :owner, :class_name => "Taster"
	has_many :lookeds
	
	before_validation :canonicalize_names
  #before_create :add_unreviewed_tag
	validates_presence_of :name, :lookup_type, :entity_type, :creator, :updater
  validates_uniqueness_of :canonical_name, :scope => [:lookup_type, :entity_type],
                          :message => "is already being used."
	
  def canonicalize_names
		self.canonical_name = self.name.canonicalize if self.name.present?
	end
  
  def self.find_or_create_by_name_and_type(name, entity_type, lookup_type)
    lookup = self.find_by_canonical_name(name.canonicalize,
                  :conditions => {:entity_type => entity_type, :lookup_type => lookup_type})
    return lookup if lookup.present?
    self.create(:name => name, :entity_type => entity_type, :lookup_type => lookup_type)
  end
	
end


