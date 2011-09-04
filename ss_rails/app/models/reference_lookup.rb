require 'data/admin_taggable'

class ReferenceLookup < ActiveRecord::Base
  include Data::AdminTaggable
  
	belongs_to :creator, :class_name => "Taster"
	belongs_to :updater, :class_name => "Taster"
	belongs_to :parent_lookup, :class_name => "Lookup"
	has_many :child_lookups, :class_name => "Lookup", :foreign_key => 'parent_lookup_id'
	before_validation :build_full_name
	before_validation :canonicalize_names

	private
	
  def build_full_name
		name_array = [self.name]
		build_full_name_helper(self.parent_lookup, name_array)
		self.full_name = name_array.join(' > ')
	end
	
	def build_full_name_helper(parent_lookup, name_array)
		if !parent_lookup.nil?
			name_array.insert(0, parent_lookup.name)
			build_full_name_helper(parent_lookup.parent_lookup, name_array)
		end
	end
	
  def canonicalize_names
		self.canonical_name = self.name.canonicalize
		self.canonical_full_name = self.full_name.canonicalize
	end
  
  def self.find_or_create_by_name_and_type(name, entity_type, lookup_type)
    lookup = self.find_by_canonical_name(name.canonicalize,
                  :conditions => {:entity_type => entity_type, :lookup_type => lookup_type})
    return lookup if lookup.present?
    self.create(:name => name, :entity_type => entity_type, :lookup_type => lookup_type)
  end
  
end
