class Producer < ActiveRecord::Base
	belongs_to :creator, :class_name => "Taster"
	belongs_to :updater, :class_name => "Taster"
	belongs_to :owner, :class_name => "Taster"
	has_many :products
	
end

class Brewery < Producer
end

class Winery < Producer
end

class Distillery < Producer
end
