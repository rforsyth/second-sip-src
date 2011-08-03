class Tag < ActiveRecord::Base
	belongs_to :creator, :class_name => "Taster"
	belongs_to :updater, :class_name => "Taster"
	
end

class AdminTag < Tag
end

class CategoryTag < Tag
end
