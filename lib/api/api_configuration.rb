
module Api
	
  class ApiConfiguration
    attr_reader :supports_ssl
    attr_accessor :message_title, :message_detail, :allow_access
    
    def initialize(supports_ssl)
      @supports_ssl = supports_ssl
      @allow_access = 1
    end
  end
	
end