class Product < ActiveRecord::Base
	belongs_to :creator, :class_name => "User"
	belongs_to :updater, :class_name => "User"
	belongs_to :owner, :class_name => "User"
	belongs_to :region, :class_name => "Lookup", :foreign_key => 'region_lookup_id'
	belongs_to :style, :class_name => "Lookup", :foreign_key => 'style_lookup_id'
	belongs_to :producer
	has_many :notes
	
end

class Beer < Product
end

class Wine < Product
end

class Spirit < Product
end