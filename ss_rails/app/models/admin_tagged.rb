class AdminTagged < ActiveRecord::Base
	set_table_name "admin_tagged"
	belongs_to :admin_tag
	belongs_to :admin_taggable, :polymorphic => true
end
