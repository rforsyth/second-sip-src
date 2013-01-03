class Tagged < ActiveRecord::Base
	self.table_name = "tagged"
	belongs_to :owner, :class_name => "Taster"
	belongs_to :tag
	belongs_to :taggable, :polymorphic => true
end
