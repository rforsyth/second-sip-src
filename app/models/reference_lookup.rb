require 'data/admin_taggable'

class ReferenceLookup < ActiveRecord::Base
  include Data::AdminTaggable
  nilify_blanks
  
	belongs_to :creator, :class_name => "Taster"
	belongs_to :updater, :class_name => "Taster"
	belongs_to :parent_reference_lookup, :class_name => "ReferenceLookup"
	has_many :child_reference_lookups, :class_name => "ReferenceLookup", :foreign_key => 'parent_reference_lookup_id'
	before_validation :build_full_name
	before_validation :canonicalize_names
	
	validates_presence_of :name, :full_name, :lookup_type, :entity_type, :creator, :updater
  validates_uniqueness_of :canonical_name, :scope => [:lookup_type, :entity_type],
                          :message => "is already being used."

	private
	
  def build_full_name
		name_array = [self.name]
		build_full_name_helper(self.parent_reference_lookup, name_array)
		self.full_name = name_array.join(' > ')
	end
	
	def build_full_name_helper(parent_reference_lookup, name_array)
		if !parent_reference_lookup.nil?
			name_array.insert(0, parent_reference_lookup.name)
			build_full_name_helper(parent_reference_lookup.parent_reference_lookup, name_array)
		end
	end
	
  def canonicalize_names
		self.canonical_name = self.name.canonicalize if self.name.present?
		self.canonical_full_name = self.full_name.canonicalize if self.full_name.present?
	end
  
  def self.find_or_create_by_name_and_type(name, entity_type, lookup_type)
    lookup = self.find_by_canonical_name(name.canonicalize,
                  :conditions => {:entity_type => entity_type, :lookup_type => lookup_type})
    return lookup if lookup.present?
    self.create(:name => name, :entity_type => entity_type, :lookup_type => lookup_type)
  end
  
end
