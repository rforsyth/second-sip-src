class ReferenceLooked < ActiveRecord::Base
	self.table_name = "reference_looked"
	belongs_to :reference_lookable, :polymorphic => true
	belongs_to :reference_lookup
end
