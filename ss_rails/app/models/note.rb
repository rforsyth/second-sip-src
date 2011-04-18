class Note < ActiveRecord::Base
	belongs_to :creator, :class_name => "User"
	belongs_to :updater, :class_name => "User"
	belongs_to :owner, :class_name => "User"
	belongs_to :product
	
end

class BeerNote < Note
end

class WineNote < Note
end

class SpiritNote < Note
end
