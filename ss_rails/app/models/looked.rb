class Looked < ActiveRecord::Base
	set_table_name "looked"
	belongs_to :lookup
	belongs_to :lookable, :polymorphic => true
end
