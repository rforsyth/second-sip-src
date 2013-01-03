class AdminTagged < ActiveRecord::Base
	self.table_name = "admin_tagged"
	belongs_to :admin_tag
	belongs_to :admin_taggable, :polymorphic => true
end
