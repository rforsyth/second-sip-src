class Tagged < ActiveRecord::Base
	set_table_name "tagged"
	belongs_to :owner, :class_name => "Taster"
	belongs_to :tag
	belongs_to :taggable, :polymorphic => true
end
