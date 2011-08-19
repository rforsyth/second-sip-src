
require 'data/string'

class Lookup < ActiveRecord::Base
	belongs_to :creator, :class_name => "Taster"
	belongs_to :updater, :class_name => "Taster"
	belongs_to :owner, :class_name => "Taster"
	
	before_validation :canonicalize_names
	
  def canonicalize_names
		self.canonical_name = self.name.canonicalize
	end
	
end


