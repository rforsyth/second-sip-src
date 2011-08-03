class Note < ActiveRecord::Base
	belongs_to :creator, :class_name => "Taster"
	belongs_to :updater, :class_name => "Taster"
	belongs_to :owner, :class_name => "Taster"
	belongs_to :product
	
end

class BeerNote < Note
end

class WineNote < Note
end

class SpiritNote < Note
end
