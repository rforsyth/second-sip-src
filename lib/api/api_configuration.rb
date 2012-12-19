
module Api
	
  class ApiConfiguration
    attr_reader :protocol
    attr_accessor :message_title, :message_detail, :allow_access
    
    def initialize(protocol)
      @protocol = protocol
      @allow_access = 1
    end
  end
	
end