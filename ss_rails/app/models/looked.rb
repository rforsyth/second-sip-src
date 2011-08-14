class Looked < ActiveRecord::Base
	set_table_name "looked"
	belongs_to :lookable, :polymorphic => true
	belongs_to :lookup
end
