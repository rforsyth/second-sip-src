
module Api
	
  class ApiConfiguration
    attr_reader :protocol, :supports_ssl
    attr_accessor :message_title, :message_detail, :allow_access
    
    def initialize(protocol, supports_ssl)
      @protocol = protocol
      @supports_ssl = supports_ssl
      @allow_access = 1
    end
  end
	
end