class Producer < ActiveRecord::Base
	belongs_to :creator, :class_name => "User"
	belongs_to :updater, :class_name => "User"
	belongs_to :owner, :class_name => "User"
	has_many :products
	
end

class Brewery < Producer
end

class Winery < Producer
end

class Distillery < Producer
end
