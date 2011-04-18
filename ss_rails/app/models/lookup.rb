class Lookup < ActiveRecord::Base
	belongs_to :creator, :class_name => "User"
	belongs_to :updater, :class_name => "User"
	
end
