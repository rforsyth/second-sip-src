
class ActionException < StandardError
	attr_reader :error_type, :details
	
	def initialize(error_type, details = nil)
		@error_type = error_type
		@details = details
	end
end